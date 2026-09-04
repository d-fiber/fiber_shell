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

/// `csrutil`, which reads and changes System Integrity Protection (SIP)
/// settings. macOS only.
///
/// ```dart
/// final ShellResult sip = await Csrutil.status().output();
/// if (sip.text.contains('enabled')) { /* SIP is on */ }
/// ```
///
/// [enable], [disable], and the `enable`/`disable` forms of
/// [allowResearchGuestsCommand] and [authenticatedRootCommand] all require
/// the machine to be booted into the Recovery OS — they cannot succeed from
/// a running copy of macOS, script or not. In practice that leaves
/// [status], [allowResearchGuestsCommand] and [authenticatedRootCommand]
/// (both with the `status` verb) as the only things a script running under
/// normal macOS can actually do with this tool; everything else is for a
/// startup-disk provisioning flow driven from Recovery.
class CsrutilCmd extends CommandBuilder<CsrutilCmd> {
  @override
  final String executable = 'csrutil';

  /// Clears the existing SIP configuration back to defaults (`clear`).
  CsrutilCmd clear() => token('clear');

  /// Disables SIP protection of the OS installation. Recovery OS only
  /// (`disable`).
  CsrutilCmd disable() => token('disable');

  /// Enables SIP protection of the OS installation. Recovery OS only
  /// (`enable`).
  CsrutilCmd enable() => token('enable');

  /// Shows the SIP configuration: per-installation in Recovery OS, or for
  /// the running OS otherwise (`status`).
  CsrutilCmd status() => token('status');

  /// The `allow-research-guests` sub-verb group, controlling whether
  /// research guest accounts are allowed (`allow-research-guests`). Chain
  /// [statusVerb], [enableVerb] or [disableVerb] next.
  CsrutilCmd allowResearchGuestsCommand() => token('allow-research-guests');

  /// The `authenticated-root` sub-verb group, controlling whether booting
  /// requires a sealed system snapshot (`authenticated-root`). Chain
  /// [statusVerb], [enableVerb] or [disableVerb] next.
  CsrutilCmd authenticatedRootCommand() => token('authenticated-root');

  /// Shows the current setting for the sub-verb group in effect (`status`).
  CsrutilCmd statusVerb() => token('status');

  /// Enables the setting for the sub-verb group in effect. Recovery OS only
  /// (`enable`).
  CsrutilCmd enableVerb() => token('enable');

  /// Disables the setting for the sub-verb group in effect. Recovery OS
  /// only (`disable`).
  CsrutilCmd disableVerb() => token('disable');
}

/// `csrutil`, ready to take its first command.
// ignore: non_constant_identifier_names
CsrutilCmd get Csrutil => CsrutilCmd();
