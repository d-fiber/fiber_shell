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

/// `shutdown`, the power and restart tool, and the closest thing Windows has
/// to `systemctl poweroff`. Windows only.
///
/// ```dart
/// await Shutdown.restart().force().timer('0').output();
/// ```
///
/// **[remoteShutdownDialog] opens the "Remote Shutdown" GUI box instead of
/// doing anything**, and per Microsoft's own syntax it must be the *only*
/// flag passed — every other option is ignored once it is there. A headless
/// script wants an explicit action instead: [powerOff], [restart], [logOff],
/// [hybridShutdown], [fullShutdownAndRestart], [signOnShutdown] or [abort].
///
/// [signOff] cannot be combined with any other flag either; passing more is
/// silently ignored, not rejected.
///
/// [abort] only works within the [timer] window of a pending shutdown or
/// restart; once it fires there is nothing left to abort. Combine with
/// [clearFirmwareBoot] to also cancel a pending [firmwareBoot].
///
/// [timer] defaults to 30 seconds and implies [force] once it is above zero;
/// [force] on its own closes running applications without warning, which can
/// **lose unsaved data**.
///
/// Every documented switch: `/i`, `/l`, `/s`, `/sg`, `/r`, `/g`, `/a`, `/p`,
/// `/h`, `/hybrid`, `/fw`, `/e`, `/o`, `/f`, `/m`, `/t`, `/d`, `/c`.
class ShutdownCmd extends CommandBuilder<ShutdownCmd> {
  @override
  final String executable = 'shutdown';

  /// Opens the Remote Shutdown dialog (`/i`). Must be the only flag, or every
  /// other one is ignored — not what a script wants.
  ShutdownCmd remoteShutdownDialog() => token('/i');

  /// Signs the current user out immediately, no time-out (`/l`). Cannot be
  /// combined with any other flag.
  ShutdownCmd signOff() => token('/l');

  /// Shuts the machine down (`/s`).
  ShutdownCmd powerOff() => token('/s');

  /// Shuts down; if Automatic Restart Sign-On is enabled, signs back in and
  /// restarts registered applications on the next boot (`/sg`).
  ShutdownCmd signOnShutdown() => token('/sg');

  /// Restarts the computer after shutdown (`/r`).
  ShutdownCmd restart() => token('/r');

  /// Fully shuts down and restarts; with Automatic Restart Sign-On, signs
  /// back in and restarts registered applications after (`/g`).
  ShutdownCmd fullShutdownAndRestart() => token('/g');

  /// Aborts a pending shutdown or restart, run as a separate command inside
  /// the [timer] window (`/a`). Combine with [clearFirmwareBoot] to also
  /// clear a pending firmware boot.
  ShutdownCmd abort() => token('/a');

  /// Turns off the local machine only, no time-out or warning, no remote
  /// target (`/p`). Only valid with [reason] or [force].
  ShutdownCmd powerOffImmediate() => token('/p');

  /// Hibernates the local machine, if hibernation is enabled (`/h`).
  /// Combinable with [force].
  ShutdownCmd hibernate() => token('/h');

  /// Shuts down and prepares the device for fast startup (`/hybrid`). Must be
  /// combined with [powerOff].
  ShutdownCmd hybridShutdown() => token('/hybrid');

  /// Makes the next restart go to the firmware user interface (`/fw`).
  /// Combine with a shutdown/restart flag, or with [abort] to clear it.
  ShutdownCmd firmwareBoot() => token('/fw');

  /// Alias documenting the [abort] + [firmwareBoot] pairing that clears a
  /// pending firmware boot; call both methods together.
  ShutdownCmd clearFirmwareBoot() => firmwareBoot();

  /// Lets you document the reason for an unexpected shutdown in the Shutdown
  /// Event Tracker (`/e`).
  ShutdownCmd documentUnexpected() => token('/e');

  /// Goes to the Advanced Boot Options menu and restarts (`/o`). Must be
  /// combined with [restart].
  ShutdownCmd bootOptions() => token('/o');

  /// Forces running applications to close without warning (`/f`). **Can lose
  /// unsaved data.** Implied once [timer] is above zero.
  ShutdownCmd force() => token('/f');

  /// The remote machine to target, `\\\\computername` (`/m`).
  ShutdownCmd server(String value) => pair('/m', value);

  /// The countdown in seconds before the action fires (`/t`). 0–315360000,
  /// default 30; anything above 0 implies [force].
  ShutdownCmd timer(String seconds) => pair('/t', seconds);

  /// The reason code logged in the Event Log, `[p|u:]xx:yy` — `p` planned,
  /// `u` user-defined, neither means unplanned; `xx` major, `yy` minor
  /// (`/d`).
  ShutdownCmd reason(String code) => pair('/d', code);

  /// The message shown in the countdown dialog, up to 512 characters (`/c`).
  /// Can be combined with [reason].
  ShutdownCmd comment(String text) => pair('/c', text);
}

/// `shutdown`, ready to take its first option.
// ignore: non_constant_identifier_names
ShutdownCmd get Shutdown => ShutdownCmd();
