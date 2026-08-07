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

import 'dart:io';

import 'process.dart';
import 'result.dart';
import 'script.dart';

/// Base class of the tool wrappers: an ordered list of argument tokens, plus the
/// handful of ways to run them.
///
/// Subclasses name themselves as their own type argument
/// (`class RmCmd extends CommandBuilder<RmCmd>`), so every option returns the
/// concrete wrapper and a chain stays typed end to end:
///
/// ```dart
/// await Rm.recursive().force().path('/some/dir').execute();
/// ```
///
/// One method adds one option. Reach for [token] on a bare flag, [pair] when the
/// value is its own argument, [joined] when the tool wants `--name=value`, and
/// [joinedAll] for the comma-separated lists Deno is fond of.
///
/// Being a [ShellScript], a wrapper composes with the others: see [asRoot] for
/// `sudo`, [PipeStage.|] for a pipe, and [ShellScript.and], [ShellScript.or] and
/// [ShellScript.then] for `&&`, `||` and `;`.
///
/// Mind the names when adding options. A method colliding with [execute],
/// [output], [writeTo], [line], [asRoot], [stages] or any of the token helpers
/// is an invalid override and will not compile; that is how curl's `-o` ended up
/// as `outputFile()`.
abstract class CommandBuilder<T extends CommandBuilder<T>> extends ShellScript with PipeStage implements ShellCommand {
  /// The arguments gathered so far, in the order they were added.
  final List<String> tokens = <String>[];

  @override
  List<String> get args => tokens;

  /// This builder, seen as the concrete wrapper.
  ///
  /// The cast is what keeps chains typed, and it holds as long as every subclass
  /// passes itself as `T`.
  T get self => this as T;

  /// Adds [value] as one argument, untouched.
  T token(String value) {
    tokens.add(value);
    return self;
  }

  /// Adds [name] and [value] as two separate arguments.
  T pair(String name, String value) {
    tokens
      ..add(name)
      ..add(value);
    return self;
  }

  /// Adds a single `name=value` argument.
  T joined(String name, String value) {
    tokens.add('$name=$value');
    return self;
  }

  /// Adds a single argument pinning [name] to a comma-separated [values].
  T joinedAll(String name, List<String> values) {
    tokens.add('$name=${values.join(',')}');
    return self;
  }

  /// This command on its own, as a pipeline stage.
  @override
  List<ShellCommand> get stages => <ShellCommand>[this];

  /// The command as it would read in a terminal, without running it.
  @override
  String get line => commandLine(this);

  /// This command behind `sudo`, on the platforms where [privileged] adds it.
  ///
  /// Elevation sits on the command rather than on the run, so it survives being
  /// piped or chained: `Cat.file(secret).asRoot() | Grep.pattern('root')`.
  ElevatedCommand asRoot() => ElevatedCommand(this);

  /// Runs the command with stdio inherited, so its output appears live.
  ///
  /// {@macro shell_process_cwd_env}
  ///
  /// Throws `ShellException` on a non-zero status. When a failure is one of the
  /// expected outcomes, use [output] and read the result instead.
  @override
  Future<void> execute({String? cwd, Map<String, String>? env}) => streamCommand(this, cwd: cwd, env: env);

  /// Runs the command, captures both streams, and returns how it went.
  ///
  /// {@macro shell_process_cwd_env}
  ///
  /// Never throws on a non-zero status: check [ShellResult.success]. Pass
  /// [input] to feed the command's stdin, the way `secret-tool store` insists on
  /// taking its secret.
  @override
  Future<ShellResult> output({String? cwd, Map<String, String>? env, String? input}) =>
      captureResult(this, cwd: cwd, env: env, input: input);

  /// Runs the command and pipes its stdout into [dest], overwriting it.
  ///
  /// {@macro shell_process_cwd_env}
  @override
  Future<void> writeTo(File dest, {String? cwd, Map<String, String>? env}) =>
      streamCommandToFile(this, dest, cwd: cwd, env: env);
}
