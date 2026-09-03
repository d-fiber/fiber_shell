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

import '../../../builder.dart';

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
