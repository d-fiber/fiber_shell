// Copyright (C) 2026 Fiber
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at https://mozilla.org/MPL/2.0/.
//
// What you may do:
// - Use this software for any purpose, including commercially, and build and
//   sell your own products on top of it.
// - Change it, and create new works based on it.
// - Distribute copies of it, with or without your changes.
// - Combine it with files under any other licence, proprietary ones included,
//   and licence that larger work on your own terms.
//
// What you must do in return:
// - Keep this notice on every file you received it on.
// - Publish, under these same terms, the source of every file covered by them
//   that you distribute, including the ones you changed, so that whoever
//   receives your version can obtain that source.
// - Leave Fiber out of it: the name "Fiber", its branding, its logos and its
//   trademarks may not be used to endorse or promote what you build, and this
//   licence grants no right to them.
//
// Disclaimer:
// AS FAR AS THE LAW ALLOWS, THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
// OR CONDITION OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
// NON-INFRINGEMENT. IN NO EVENT SHALL FIBER BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT
// LIMITED TO LOSS OF USE, DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT
// OF OR RELATED TO THESE TERMS OR THE USE OR NATURE OF THE SOFTWARE, UNDER ANY
// KIND OF LEGAL CLAIM.
//
// This header is a summary written for convenience. Where it differs from the
// LICENSE file, the LICENSE file governs.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'exception.dart';
import 'result.dart';

/// Runs [executable] with the parent's stdin, stdout and stderr.
///
/// Output shows up as the command produces it, which is what anything a human
/// watches needs: a test run, a build, an install.
///
/// {@template shell_process_cwd_env}
/// Pass [cwd] to run somewhere other than the current directory. Entries in
/// [env] are added to the environment the child inherits, replacing any that
/// clash.
/// {@endtemplate}
///
/// Throws [ShellException] if the command exits with a non-zero status.
Future<void> sh(String executable, List<String> args, {String? cwd, Map<String, String>? env}) async {
  final Process process = await Process.start(
    executable,
    args,
    workingDirectory: cwd,
    environment: env,
    mode: ProcessStartMode.inheritStdio,
  );
  final int code = await process.exitCode;
  if (code != 0) {
    throw ShellException('${[executable, ...args].join(' ')} exited with code $code');
  }
}

/// Runs [executable] and hands back the [ProcessResult] as `Process.run` built
/// it, with both streams decoded as strings.
///
/// {@macro shell_process_cwd_env}
///
/// A non-zero status is not an error here, it is a field to read. Prefer
/// [captureResult] in new code; this one stays for the callers that already
/// speak [ProcessResult].
Future<ProcessResult> capture(String executable, List<String> args, {String? cwd, Map<String, String>? env}) {
  return Process.run(executable, args, workingDirectory: cwd, environment: env);
}

/// Runs [executable], writes [input] to its stdin, then closes it.
///
/// {@macro shell_process_cwd_env}
///
/// Both streams are decoded as UTF-8, so this only suits commands that speak
/// text. For a secret handed over on stdin, see `CommandBuilder.output`.
///
/// A command that exits without reading all of [input] closes its end of the
/// pipe first, and the write fails with a broken-pipe error that is not this
/// call's to report: the exit code it returns already says what the process
/// made of its input.
Future<ProcessResult> captureWithStdin(
  String executable,
  List<String> args,
  String input, {
  String? cwd,
  Map<String, String>? env,
}) async {
  final Process process = await Process.start(executable, args, workingDirectory: cwd, environment: env);
  try {
    process.stdin.write(input);
    await process.stdin.close();
  } on Object {
    // Handled by the exit code the caller already reads below.
  }
  final String stdout = await process.stdout.transform(utf8.decoder).join();
  final String stderr = await process.stderr.transform(utf8.decoder).join();
  final int code = await process.exitCode;
  return ProcessResult(process.pid, code, stdout, stderr);
}

/// Runs [executable] and pipes its stdout into [dest], overwriting whatever was
/// there.
///
/// {@macro shell_process_cwd_env}
///
/// stderr is drained and dropped rather than left alone: an unread pipe fills
/// up, and the command stalls waiting for somebody to empty it.
///
/// Throws [ShellException] if the command exits with a non-zero status.
Future<void> shToFile(String executable, List<String> args, File dest, {String? cwd, Map<String, String>? env}) async {
  final Process process = await Process.start(executable, args, workingDirectory: cwd, environment: env);
  final Future<void> stderrDone = process.stderr.drain<void>();
  await process.stdout.pipe(dest.openWrite());
  await stderrDone;
  final int code = await process.exitCode;
  if (code != 0) {
    throw ShellException('${[executable, ...args].join(' ')} exited with code $code');
  }
}

/// Whether [name] resolves to something runnable on this machine.
///
/// Asks `where` on Windows and `which` everywhere else.
Future<bool> commandExists(String name) async {
  final String locator = Platform.isWindows ? 'where' : 'which';
  final ProcessResult result = await capture(locator, [name]);
  return result.exitCode == 0;
}

/// An executable and its arguments, kept apart so that one can be wrapped
/// around the other. [privileged] returns `sudo` holding the original pair.
///
/// The name shadows `dart:core`'s own `Invocation` for anyone importing this
/// library. That type only ever turns up in `noSuchMethod`, which none of this
/// code implements, so the clash has stayed harmless.
class Invocation {
  Invocation(this.executable, this.args);

  /// The program to run.
  final String executable;

  /// The arguments handed to [executable].
  final List<String> args;

  /// [executable] and [args] as one list, the shape `Process.start` wants.
  List<String> get argv => [executable, ...args];
}

/// Returns [executable] and [args] behind `sudo` on Linux, and untouched
/// everywhere else.
Invocation privileged(String executable, List<String> args) {
  if (Platform.isLinux) return Invocation('sudo', [executable, ...args]);
  return Invocation(executable, args);
}

/// Anything that can be turned into a command line.
///
/// `CommandBuilder` is the implementation every wrapper under `commands/` uses.
/// The interface exists so that the runners below never have to care where the
/// arguments came from.
abstract class ShellCommand {
  /// The program to run, looked up in `PATH` unless it is a path already.
  String get executable;

  /// The arguments passed to [executable], already split.
  List<String> get args;
}

/// Runs [command] with stdio inherited, through [sh].
///
/// {@macro shell_process_cwd_env}
Future<void> streamCommand(ShellCommand command, {String? cwd, Map<String, String>? env}) {
  return sh(command.executable, command.args, cwd: cwd, env: env);
}

/// Runs [command] and captures both streams, through [capture].
///
/// {@macro shell_process_cwd_env}
Future<ProcessResult> captureCommand(ShellCommand command, {String? cwd, Map<String, String>? env}) {
  return capture(command.executable, command.args, cwd: cwd, env: env);
}

/// Runs [command] with stdio inherited, elevated by [privileged].
///
/// {@macro shell_process_cwd_env}
Future<void> streamPrivilegedCommand(ShellCommand command, {String? cwd, Map<String, String>? env}) {
  final Invocation invocation = privileged(command.executable, command.args);
  return sh(invocation.executable, invocation.args, cwd: cwd, env: env);
}

/// Runs [command] and captures both streams, elevated by [privileged].
///
/// {@macro shell_process_cwd_env}
Future<ProcessResult> capturePrivilegedCommand(ShellCommand command, {String? cwd, Map<String, String>? env}) {
  final Invocation invocation = privileged(command.executable, command.args);
  return capture(invocation.executable, invocation.args, cwd: cwd, env: env);
}

/// Runs [command] and pipes its stdout into [dest], through [shToFile].
///
/// {@macro shell_process_cwd_env}
Future<void> streamCommandToFile(ShellCommand command, File dest, {String? cwd, Map<String, String>? env}) =>
    shToFile(command.executable, command.args, dest, cwd: cwd, env: env);

/// Runs [command] into [dest] the way [streamCommandToFile] does, elevated by
/// [privileged].
///
/// {@macro shell_process_cwd_env}
Future<void> streamPrivilegedCommandToFile(ShellCommand command, File dest, {String? cwd, Map<String, String>? env}) {
  final Invocation invocation = privileged(command.executable, command.args);
  return shToFile(invocation.executable, invocation.args, dest, cwd: cwd, env: env);
}

/// [command] flattened into an argv list, without running anything.
///
/// Set [asPrivileged] for the `sudo` form. Useful when one command has to be
/// passed as the arguments of another, the way `docker compose exec` takes the
/// command it should run inside the container.
List<String> commandArgv(ShellCommand command, {bool asPrivileged = false}) {
  if (asPrivileged) return privileged(command.executable, command.args).argv;
  return [command.executable, ...command.args];
}

/// [command] joined into one string, for logs and error messages.
///
/// Nothing is quoted, so an argument with a space in it comes out ambiguous.
/// The result is meant to be read, not pasted back into a shell.
String commandLine(ShellCommand command) => [command.executable, ...command.args].join(' ');

/// Runs [command] and collects everything it produced into a [ShellResult].
///
/// {@macro shell_process_cwd_env}
///
/// Pass [input] to write to the command's stdin before it is closed, and
/// [asPrivileged] to route through [privileged].
///
/// Both streams start draining before the exit code is awaited. Doing it the
/// other way round deadlocks the moment a command writes more than the pipe
/// buffer holds and then sits there waiting for somebody to read it.
///
/// A command that exits without reading all of [input] closes its end of the
/// pipe first, and the write then fails with a broken-pipe error. That is
/// answered by the exit code this returns as [ShellResult.exitCode], not by
/// throwing out of a call [ShellResult] promises never throws: the process
/// already said what it thought of its input, and this only stops that from
/// racing a low-level stream error.
Future<ShellResult> captureResult(
  ShellCommand command, {
  String? cwd,
  Map<String, String>? env,
  String? input,
  bool asPrivileged = false,
}) async {
  final List<String> argv = commandArgv(command, asPrivileged: asPrivileged);
  final Stopwatch watch = Stopwatch()..start();
  final Process process = await Process.start(argv.first, argv.sublist(1), workingDirectory: cwd, environment: env);
  final Future<List<int>> out = collectBytes(process.stdout);
  final Future<List<int>> err = collectBytes(process.stderr);
  try {
    if (input != null) process.stdin.write(input);
    await process.stdin.close();
  } on Object {
    // Handled by the exit code the caller already reads below.
  }
  final int code = await process.exitCode;
  return ShellResult(
    command: argv.join(' '),
    exitCode: code,
    bytes: await out,
    errorBytes: await err,
    duration: (watch..stop()).elapsed,
  );
}

/// Everything [stream] emits, concatenated, left undecoded.
///
/// Shared with the pipeline runner in `script.dart`, which needs the same
/// byte-for-byte collection over several processes at once.
Future<List<int>> collectBytes(Stream<List<int>> stream) async {
  final BytesBuilder builder = BytesBuilder();
  await for (final List<int> chunk in stream) {
    builder.add(chunk);
  }
  return builder.takeBytes();
}

/// Polls [cmd] every [interval] seconds until it exits zero, and returns whether
/// that happened within [timeout] seconds.
///
/// Nothing is logged and nothing is thrown: a timeout comes back as `false`, and
/// the caller decides whether that deserves a warning, an error, or another
/// round of waiting.
Future<bool> waitUntil(List<String> cmd, {int interval = 2, int timeout = 180}) async {
  int waited = 0;
  while (true) {
    final ProcessResult result = await capture(cmd.first, cmd.sublist(1));
    if (result.exitCode == 0) return true;
    if (waited >= timeout) return false;
    await Future.delayed(Duration(seconds: interval));
    waited += interval;
  }
}
