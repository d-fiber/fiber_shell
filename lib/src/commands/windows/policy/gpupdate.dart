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

/// `gpupdate`, which refreshes Group Policy settings on the local machine.
/// Windows only.
///
/// ```dart
/// await Gpupdate.force().target('computer').wait('0').execute();
/// ```
///
/// Without [force], only settings that changed since the last refresh are
/// reapplied — [force] reapplies everything, which is slower but is what a
/// script wants after directly editing policy rather than waiting for the
/// normal change-driven refresh.
///
/// [wait] controls how long `gpupdate` blocks the calling process, not how
/// long policy processing itself takes: policy continues in the background
/// past the wait, and the default is 600 seconds. Pass `'0'` to return
/// immediately, or `'-1'` to block until processing genuinely finishes —
/// what a script that depends on the result should use instead of the
/// default.
///
/// [logoff] and [boot] each force a sign-out or a restart once the refresh
/// completes, for the client-side extensions (user-targeted software
/// install, folder redirection; computer-targeted software install) that
/// only apply at logon or startup rather than in the background. Neither
/// does anything if no such extension is in play, but on a machine where one
/// is, this signs the user out or restarts the machine out from under
/// whatever was running.
class GpupdateCmd extends CommandBuilder<GpupdateCmd> {
  @override
  final String executable = 'gpupdate';

  /// Limits the refresh to only `computer` or only `user` policy
  /// (`/target:{computer|user}`). Both are refreshed if this is omitted.
  GpupdateCmd target(String scope) => token('/target:$scope');

  /// Reapplies every policy setting, not just the ones that changed
  /// (`/force`).
  GpupdateCmd force() => token('/force');

  /// Seconds to wait for policy processing before returning to the caller;
  /// `'0'` returns immediately, `'-1'` waits indefinitely (`/wait:<value>`).
  GpupdateCmd wait(String seconds) => token('/wait:$seconds');

  /// Signs the user out once Group Policy has been updated, for extensions
  /// that only apply at logon (`/logoff`).
  GpupdateCmd logoff() => token('/logoff');

  /// Restarts the computer once Group Policy has been updated, for
  /// extensions that only apply at startup (`/boot`).
  GpupdateCmd boot() => token('/boot');

  /// Makes the next foreground policy application (at boot or logon)
  /// synchronous (`/sync`). Overrides [force] and [wait], which are ignored
  /// alongside it.
  GpupdateCmd sync() => token('/sync');

  /// Prints usage help (`/?`).
  GpupdateCmd help() => token('/?');
}

/// `gpupdate`, ready to take its first option.
// ignore: non_constant_identifier_names
GpupdateCmd get Gpupdate => GpupdateCmd();
