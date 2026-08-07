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

/// `pmset`, the power management tool. macOS only.
///
/// ```dart
/// final ShellResult settings = await Pmset.get().arg('custom').output();
/// await Pmset.allPowerSources().setting('sleep', '0').asRoot().execute();
/// ```
///
/// The interesting one for a machine that hosts anything is `sleep 0`: a Mac
/// that sleeps takes its containers, its tunnels and its cron jobs with it. On a
/// laptop that setting only applies to the power source you name, one of
/// [onCharger], [onBattery], [onUps] or [allPowerSources], and the default is
/// whichever source is in use, which is how a fix applied on mains power
/// evaporates on the train.
///
/// A process can override any of this with a power assertion, which is what
/// [CaffeinateCmd] does; `pmset -g assertions` lists who is currently doing so.
///
/// Reading is unprivileged; every setting wants `asRoot()`.
class PmsetCmd extends CommandBuilder<PmsetCmd> {
  @override
  final String executable = 'pmset';

  /// The settings that follow apply to every power source (`-a`).
  PmsetCmd allPowerSources() => token('-a');

  /// They apply on battery (`-b`).
  PmsetCmd onBattery() => token('-b');

  /// They apply on mains power (`-c`).
  PmsetCmd onCharger() => token('-c');

  /// They apply on a UPS (`-u`).
  PmsetCmd onUps() => token('-u');

  /// Reads the current values (`-g`).
  ///
  /// Takes a topic: `custom` for what was configured, `live` for what is in
  /// force, `assertions` for who is overriding it, `batt`, `sched`, `log`.
  PmsetCmd get() => token('-g');

  /// Schedules a wake, a sleep or a restart (`schedule`).
  PmsetCmd schedule() => token('schedule');

  /// Manages a repeating schedule (`repeat`).
  PmsetCmd repeat() => token('repeat');

  /// Schedules a wake or a power-on this many seconds from now (`relative`).
  PmsetCmd relative() => token('relative');

  /// Reapplies the settings without changing them (`touch`).
  PmsetCmd touch() => token('touch');

  /// Sleeps now (`sleepnow`).
  PmsetCmd sleepNow() => token('sleepnow');

  /// Turns the display off now (`displaysleepnow`).
  PmsetCmd displaySleepNow() => token('displaysleepnow');

  /// Reapplies the boot-time settings (`boot`).
  PmsetCmd boot() => token('boot');

  /// Sets one power management setting, `sleep 0` and the like.
  ///
  /// `0` means never for the timers: `sleep`, `displaysleep` and `disksleep`.
  PmsetCmd setting(String name, String value) => pair(name, value);

  /// Adds a bare argument: a topic for [get], a date for [schedule].
  PmsetCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
PmsetCmd get Pmset => PmsetCmd();
