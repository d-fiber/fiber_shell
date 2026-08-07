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

/// `kill`, the signal sender. On every Unix, absent from Windows. Dart can do
/// this itself with `Process.kill` when it started the process; this is for the
/// ones it did not.
///
/// ```dart
/// await Kill.signal('TERM').pid(pid).execute();
/// ```
///
/// The default signal is `TERM`, which asks a process to stop and lets it clean
/// up. `KILL` cannot be caught, so nothing is flushed and nothing is released:
/// it is the answer to a process that ignored `TERM`, not the first thing to
/// reach for.
///
/// Signalling a process you do not own needs `asRoot()`, and a `kill` that
/// matched nothing exits non-zero, which is a reasonable "was it there" test.
///
/// A negative pid signals the whole process group. Convenient, and the reason a
/// stray minus sign turns one dead process into a dead session.
class KillCmd extends CommandBuilder<KillCmd> {
  @override
  final String executable = 'kill';

  /// The signal to send, by name: `TERM`, `HUP`, `KILL` (`-s`).
  KillCmd signal(String name) => pair('-s', name);

  /// The signal by name, glued to the dash: `-TERM`.
  KillCmd signalNamed(String name) => token('-$name');

  /// The signal by number: `-15`.
  KillCmd signalNumber(String number) => token('-$number');

  /// Lists the signal names (`-l`).
  KillCmd listSignals() => token('-l');

  /// Adds a process id. Negative for a whole process group.
  KillCmd pid(String value) => token(value);
}

// ignore: non_constant_identifier_names
KillCmd get Kill => KillCmd();
