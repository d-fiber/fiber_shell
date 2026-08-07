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

import '../../builder.dart';

/// `taskkill`, which ends processes, the counterpart of `kill`. Windows only.
///
/// ```dart
/// await Taskkill.imageName('deno.exe').tree().force().execute();
/// ```
///
/// Without [force] taskkill asks the process to close, which only a program with
/// a window will hear; a console process ignores it. With [force] it is killed
/// outright, and nothing is flushed: the same trade as `SIGTERM` against
/// `SIGKILL`, except there is no polite signal a background process can catch.
///
/// [tree] takes the children with it, which is what you want for anything that
/// spawned workers and what you do not want if you got the pid wrong.
///
/// **A remote kill is always forced**, whatever the flags say. And killing
/// nothing exits non-zero, which makes a reasonable "was it running" test.
class TaskkillCmd extends CommandBuilder<TaskkillCmd> {
  @override
  final String executable = 'taskkill';

  /// The remote machine (`/s`).
  TaskkillCmd server(String value) => pair('/s', value);

  /// The account to act as, `DOMAIN\\user` (`/u`). Needs [server].
  TaskkillCmd user(String value) => pair('/u', value);

  /// Its password (`/p`).
  TaskkillCmd password(String value) => pair('/p', value);

  /// Adds a filter, `"USERNAME eq NT AUTHORITY\\SYSTEM"` (`/fi`). Repeatable.
  TaskkillCmd filter(String expression) => pair('/fi', expression);

  /// The process id to end (`/pid`). Repeatable.
  TaskkillCmd pid(String value) => pair('/pid', value);

  /// The image name to end, `deno.exe` (`/im`). `*` only alongside a filter.
  TaskkillCmd imageName(String value) => pair('/im', value);

  /// Ends the process outright rather than asking (`/f`).
  TaskkillCmd force() => token('/f');

  /// Ends the children too (`/t`).
  TaskkillCmd tree() => token('/t');

  /// Adds a bare argument.
  TaskkillCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
TaskkillCmd get Taskkill => TaskkillCmd();
