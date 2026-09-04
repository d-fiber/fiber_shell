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

/// `wusa`, the Windows Update Standalone Installer: installs, uninstalls and
/// extracts `.msu` update packages from the command line. Windows only.
///
/// ```dart
/// await Wusa.packageFile(r'C:\updates\windows10.0-kb5001330-x64.msu').quiet().norestart().asRoot().execute();
///
/// await Wusa.uninstall().kb('5001330').quiet().norestart().asRoot().execute();
/// ```
///
/// **[norestart] is silently ignored unless [quiet] is also set** — that is
/// documented behavior, not a bug to work around.
///
/// **Silent uninstall is blocked on Windows 10 and Windows Server 2016 and
/// later**: [uninstall] combined with [quiet] fails there (Setup event log,
/// event ID 8) because a quiet, background uninstall of a security update is
/// treated as a risk. DISM's `/Remove-Package` (see `Dism`) or PowerShell are
/// the supported silent-uninstall paths on those versions; `wusa /uninstall`
/// still works fine interactively, or against the original `.msu` rather than
/// a KB number.
///
/// [forceRestart] combined with [quiet] closes running applications without
/// asking before restarting — expected behavior for unattended patch
/// deployment, and exactly the kind of thing you don't want to trigger by
/// accident on an interactive machine.
class WusaCmd extends CommandBuilder<WusaCmd> {
  @override
  final String executable = 'wusa';

  /// The `.msu` package to install or, with [uninstall], the `.msu` to roll
  /// back. First positional argument.
  WusaCmd packageFile(String path) => token(path);

  /// Removes a previously installed update instead of installing one
  /// (`/uninstall`). Pair with [packageFile] or [kb].
  WusaCmd uninstall() => token('/uninstall');

  /// The KB number to uninstall, `/uninstall` only, in place of naming the
  /// original `.msu` again (`/kb:<number>`).
  WusaCmd kb(String number) => token('/kb:$number');

  /// Runs without any user interaction (`/quiet`). Required for [norestart]
  /// to have any effect.
  WusaCmd quiet() => token('/quiet');

  /// Suppresses the automatic restart after install/uninstall (`/norestart`).
  /// Has no effect unless [quiet] is also set.
  WusaCmd norestart() => token('/norestart');

  /// With [quiet], prompts before restarting instead of restarting outright
  /// (`/warnrestart:<seconds>`).
  WusaCmd warnRestart(String seconds) => token('/warnrestart:$seconds');

  /// Prompts before restarting, outside of [quiet] mode (`/promptrestart`).
  WusaCmd promptRestart() => token('/promptrestart');

  /// With [quiet], closes running applications and restarts without asking
  /// (`/forcerestart`).
  WusaCmd forceRestart() => token('/forcerestart');

  /// Where to write the install/uninstall log (`/log:<file>`).
  WusaCmd log(String path) => token('/log:$path');

  /// Extracts the package's contents to a destination folder instead of
  /// installing it (`/extract:<destination>`).
  WusaCmd extract(String destination) => token('/extract:$destination');

  /// Prints usage help (`/?`, `/h`, `/help`).
  WusaCmd help() => token('/?');
}

/// `wusa`, ready to take its first option.
// ignore: non_constant_identifier_names
WusaCmd get Wusa => WusaCmd();
