// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'dart:async';
import 'dart:io';

import 'exception.dart';
import 'process.dart';
import 'result.dart';

/// Something runnable: one command, a pipeline, or commands chained on each
/// other's outcome.
///
/// The shell operators live here because `Process.start` knows none of them:
/// it takes an executable and a list of arguments, and that is all. The
/// alternative would be handing a string to `sh -c`, which means quoting every
/// argument correctly and giving up Windows. So `|` wires the streams in Dart,
/// and `&&`, `||` and `;` become [and], [or] and [then].
///
/// ```dart
/// await AptGet.update().asRoot().and(AptGet.install().arg('curl').asRoot()).execute();
///
/// final ShellResult result = await (Curl.silent().url(url) | Grep.pattern('ok')).output();
/// ```
///
/// Dart cannot overload `&&` and `||`: they short-circuit, so they are syntax
/// rather than operators, and `&` already means "background" to anyone reading
/// a shell command, which is not what it would do here. Named methods beat a
/// symbol that lies.
abstract class ShellScript {
  const ShellScript();

  /// The script as it would read in a terminal, without running it.
  String get line;

  /// Runs the script with stdio inherited, so its output appears live.
  ///
  /// {@macro shell_process_cwd_env}
  ///
  /// Throws [ShellException] if the script ends on a non-zero status.
  Future<void> execute({String? cwd, Map<String, String>? env});

  /// Runs the script and returns how it went, capturing both streams.
  ///
  /// {@macro shell_process_cwd_env}
  ///
  /// Never throws on a non-zero status. [input] goes to the stdin of whatever
  /// runs first: the left side of a chain, the head of a pipeline.
  Future<ShellResult> output({String? cwd, Map<String, String>? env, String? input});

  /// Runs [next] only if this script succeeds, the way `&&` does.
  ShellScript and(ShellScript next) => _Sequence(this, next, _Join.onSuccess);

  /// Runs [next] only if this script fails, the way `||` does.
  ShellScript or(ShellScript next) => _Sequence(this, next, _Join.onFailure);

  /// Runs [next] whatever happens here, the way `;` does.
  ///
  /// The status of the pair is [next]'s; a failure on this side is swallowed.
  ShellScript then(ShellScript next) => _Sequence(this, next, _Join.always);
}

/// A script that is still a flat list of processes, so it can feed another one.
///
/// Mixed into the single commands and into [Pipeline] itself, which is what
/// makes `a | b | c` build up from the left. A chain built with
/// [ShellScript.and] and its siblings deliberately does not get this: a shell
/// needs a subshell to pipe out of one, and there is no reason to fake that.
mixin PipeStage on ShellScript {
  /// The processes this stage contributes, in order.
  List<ShellCommand> get stages;

  /// Sends this stage's stdout into [next]'s stdin.
  Pipeline operator |(ShellCommand next) => Pipeline(<ShellCommand>[...stages, next]);

  /// Runs the stage and writes its stdout into [dest], overwriting it.
  ///
  /// {@macro shell_process_cwd_env}
  Future<void> writeTo(File dest, {String? cwd, Map<String, String>? env});

  /// Starts the stage and comes back straight away, the way `&` does.
  ///
  /// {@macro shell_process_cwd_env}
  ///
  /// Both streams are collected in the background, so the job can be left alone
  /// and read later through [BackgroundJob.wait]. Nobody reaps it for you: a CLI
  /// that returns from `main` with a job still running leaves the child to the
  /// operating system.
  Future<BackgroundJob> background({String? cwd, Map<String, String>? env}) async {
    final Stopwatch watch = Stopwatch()..start();
    final List<Process> running = await _spawn(stages, cwd, env);
    final Future<List<int>> out = collectBytes(running.last.stdout);
    final List<Future<List<int>>> errors = running.map((Process process) => collectBytes(process.stderr)).toList();
    unawaited(running.first.stdin.close());
    return BackgroundJob(running, () async {
      final List<int> codes = await Future.wait(running.map((Process process) => process.exitCode));
      return ShellResult(
        command: line,
        exitCode: _pipefail(codes),
        bytes: await out,
        errorBytes: <int>[for (final Future<List<int>> chunk in errors) ...await chunk],
        duration: (watch..stop()).elapsed,
      );
    }());
  }
}

/// A stage started by [PipeStage.background] and still running.
///
/// ```dart
/// final BackgroundJob server = await Deno.run().file('server.ts').background();
/// await waitUntil(<String>['curl', '-fs', 'http://localhost:8000']);
/// server.kill();
/// ```
class BackgroundJob {
  BackgroundJob(this._running, this._result);

  final List<Process> _running;
  final Future<ShellResult> _result;

  /// The process id of the first stage, the one a shell would report.
  int get pid => _running.first.pid;

  /// Waits for the job to finish and returns how it went.
  ///
  /// Safe to call more than once, and safe to call after [kill]: a killed
  /// process still exits, with the status its signal produced.
  Future<ShellResult> wait() => _result;

  /// Signals every process in the job, and reports whether they all took it.
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) =>
      _running.map((Process process) => process.kill(signal)).every((bool sent) => sent);
}

/// A single command run through [privileged]: `sudo` on Linux, untouched
/// elsewhere.
///
/// Elevation belongs to a command rather than to the run, which is what a
/// pipeline needs: only the stage reading the protected file wants the rights.
///
/// ```dart
/// await (Cat.file('/etc/shadow').asRoot() | Grep.pattern('root')).output();
/// ```
class ElevatedCommand extends ShellScript with PipeStage implements ShellCommand {
  ElevatedCommand(this.command) : _invocation = privileged(command.executable, command.args);

  /// The command being elevated.
  final ShellCommand command;

  final Invocation _invocation;

  @override
  String get executable => _invocation.executable;

  @override
  List<String> get args => _invocation.args;

  @override
  List<ShellCommand> get stages => <ShellCommand>[this];

  @override
  String get line => commandLine(this);

  @override
  Future<void> execute({String? cwd, Map<String, String>? env}) => sh(executable, args, cwd: cwd, env: env);

  @override
  Future<ShellResult> output({String? cwd, Map<String, String>? env, String? input}) =>
      captureResult(this, cwd: cwd, env: env, input: input);

  @override
  Future<void> writeTo(File dest, {String? cwd, Map<String, String>? env}) =>
      shToFile(executable, args, dest, cwd: cwd, env: env);
}

/// Commands wired stdout to stdin, the way `|` does.
///
/// Built by [PipeStage.|] rather than by hand. Every stage starts at once, as a
/// shell starts them, so a slow producer and a slow consumer overlap instead of
/// queueing.
///
/// The status is the one `set -o pipefail` gives: the rightmost stage that
/// failed, or zero when they all succeeded. Plain shell semantics, where only
/// the last stage counts, hide a broken first command behind a `grep` that
/// happily matched nothing, which is rarely what a CLI wants.
///
/// [ShellResult.bytes] holds the last stage's stdout, [ShellResult.errorBytes]
/// every stage's stderr in order.
///
/// The usual pipefail catch applies: a consumer that walks away early, `head`
/// being the classic one, leaves the stage before it dying on a broken pipe, and
/// the pipeline reports that death. Reach for [output] and read the status
/// yourself when that is the shape of the command.
class Pipeline extends ShellScript with PipeStage {
  Pipeline(this.stages);

  @override
  final List<ShellCommand> stages;

  @override
  String get line => stages.map(commandLine).join(' | ');

  @override
  Future<void> execute({String? cwd, Map<String, String>? env}) async {
    final List<Process> running = await _spawn(stages, cwd, env);
    final List<Future<void>> forwarded = <Future<void>>[
      _forward(running.last.stdout, stdout),
      for (final Process process in running) _forward(process.stderr, stderr),
    ];
    await running.first.stdin.close();
    final List<int> codes = await Future.wait(running.map((Process process) => process.exitCode));
    await Future.wait(forwarded);
    _failOn(codes);
  }

  @override
  Future<ShellResult> output({String? cwd, Map<String, String>? env, String? input}) async {
    final Stopwatch watch = Stopwatch()..start();
    final List<Process> running = await _spawn(stages, cwd, env);
    final Future<List<int>> out = collectBytes(running.last.stdout);
    final List<Future<List<int>>> errors = running.map((Process process) => collectBytes(process.stderr)).toList();
    if (input != null) running.first.stdin.write(input);
    await running.first.stdin.close();
    final List<int> codes = await Future.wait(running.map((Process process) => process.exitCode));
    return ShellResult(
      command: line,
      exitCode: _pipefail(codes),
      bytes: await out,
      errorBytes: <int>[for (final Future<List<int>> chunk in errors) ...await chunk],
      duration: (watch..stop()).elapsed,
    );
  }

  @override
  Future<void> writeTo(File dest, {String? cwd, Map<String, String>? env}) async {
    final List<Process> running = await _spawn(stages, cwd, env);
    final List<Future<void>> forwarded = <Future<void>>[
      for (final Process process in running) _forward(process.stderr, stderr),
    ];
    await running.first.stdin.close();
    await running.last.stdout.pipe(dest.openWrite());
    final List<int> codes = await Future.wait(running.map((Process process) => process.exitCode));
    await Future.wait(forwarded);
    _failOn(codes);
  }

  void _failOn(List<int> codes) {
    final int status = _pipefail(codes);
    if (status != 0) throw ShellException('$line exited with code $status');
  }
}

/// Starts every stage at once and wires each stdout into the next stdin.
///
/// A stage giving up early leaves the one before it writing into a closed pipe;
/// that error is swallowed, which is the shell's SIGPIPE behaviour.
Future<List<Process>> _spawn(List<ShellCommand> stages, String? cwd, Map<String, String>? env) async {
  final List<Process> running = <Process>[];
  for (final ShellCommand stage in stages) {
    running.add(await Process.start(stage.executable, stage.args, workingDirectory: cwd, environment: env));
  }
  for (int i = 0; i < running.length - 1; i++) {
    unawaited(running[i].stdout.pipe(running[i + 1].stdin).catchError((Object _) {}));
  }
  return running;
}

/// The rightmost non-zero status in [codes], or zero when there is none.
int _pipefail(List<int> codes) => codes.lastWhere((int code) => code != 0, orElse: () => 0);

/// Copies [from] into [to] without closing it, completing when the source runs
/// dry.
///
/// `Stream.pipe` would close the sink, and closing the process's own stdout is
/// not something it recovers from. A broken pipe downstream ends the copy
/// quietly, the way a shell drops SIGPIPE on the floor.
Future<void> _forward(Stream<List<int>> from, IOSink to) {
  final Completer<void> done = Completer<void>();
  void finish([Object? _]) {
    if (!done.isCompleted) done.complete();
  }

  from.listen(to.add, onDone: finish, onError: finish, cancelOnError: true);
  return done.future;
}

enum _Join { onSuccess, onFailure, always }

/// Two scripts joined by an outcome: `&&`, `||` or `;`.
class _Sequence extends ShellScript {
  const _Sequence(this.left, this.right, this.join);

  final ShellScript left;
  final ShellScript right;
  final _Join join;

  String get _symbol => switch (join) {
    _Join.onSuccess => '&&',
    _Join.onFailure => '||',
    _Join.always => ';',
  };

  @override
  String get line => '${left.line} $_symbol ${right.line}';

  @override
  Future<void> execute({String? cwd, Map<String, String>? env}) async {
    if (join == _Join.onSuccess) {
      await left.execute(cwd: cwd, env: env);
      return right.execute(cwd: cwd, env: env);
    }
    bool failed = false;
    try {
      await left.execute(cwd: cwd, env: env);
    } on ShellException {
      failed = true;
    }
    if (join == _Join.onFailure && !failed) return;
    return right.execute(cwd: cwd, env: env);
  }

  @override
  Future<ShellResult> output({String? cwd, Map<String, String>? env, String? input}) async {
    final ShellResult first = await left.output(cwd: cwd, env: env, input: input);
    final bool carryOn = switch (join) {
      _Join.onSuccess => first.success,
      _Join.onFailure => first.failed,
      _Join.always => true,
    };
    if (!carryOn) {
      return ShellResult(
        command: line,
        exitCode: first.exitCode,
        bytes: first.bytes,
        errorBytes: first.errorBytes,
        duration: first.duration,
      );
    }
    final ShellResult second = await right.output(cwd: cwd, env: env);
    return ShellResult(
      command: line,
      exitCode: second.exitCode,
      bytes: <int>[...first.bytes, ...second.bytes],
      errorBytes: <int>[...first.errorBytes, ...second.errorBytes],
      duration: first.duration + second.duration,
    );
  }
}
