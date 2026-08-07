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

/// `caffeinate`, the sleep blocker. macOS only, and the polite counterpart of
/// [PmsetCmd]: it holds a power assertion for as long as it runs rather than
/// changing the machine's configuration, so nothing has to be put back
/// afterwards.
///
/// ```dart
/// await Caffeinate.preventIdleSleep().arg('make').arg('release').execute();
/// ```
///
/// Given a command it runs it and holds the assertion until it exits, which is
/// the shape to use, since there is nothing left behind if the process dies.
/// Given [timeout] and no command it simply waits. Given neither it holds the
/// assertion until it is killed, so pair that form with `background()` and keep
/// the handle.
///
/// [preventSystemSleep] only applies on mains power; a laptop on battery ignores
/// it. [preventIdleSleep] is the one that holds in both cases, and neither stops
/// a user closing the lid.
class CaffeinateCmd extends CommandBuilder<CaffeinateCmd> {
  @override
  final String executable = 'caffeinate';

  /// Keeps the display awake (`-d`).
  CaffeinateCmd preventDisplaySleep() => token('-d');

  /// Keeps the system from sleeping when idle (`-i`).
  CaffeinateCmd preventIdleSleep() => token('-i');

  /// Keeps the disk from sleeping when idle (`-m`).
  CaffeinateCmd preventDiskSleep() => token('-m');

  /// Keeps the system awake outright (`-s`). Mains power only.
  CaffeinateCmd preventSystemSleep() => token('-s');

  /// Declares the user active, waking the display if it was off (`-u`).
  CaffeinateCmd declareUserActive() => token('-u');

  /// How long the assertion lasts, in seconds (`-t`).
  CaffeinateCmd timeout(String seconds) => pair('-t', seconds);

  /// Holds the assertion until this process exits (`-w`).
  CaffeinateCmd waitForPid(String pid) => pair('-w', pid);

  /// The command to run, and its arguments.
  CaffeinateCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
CaffeinateCmd get Caffeinate => CaffeinateCmd();
