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

/// `xcode-select`, which points `xcrun`, `xcodebuild`, `cc` and the rest of
/// the Xcode and BSD developer tools at a developer directory. macOS only.
///
/// ```dart
/// final ShellResult active = await XcodeSelect.printPath().output();
/// await XcodeSelect.switchTo('/Applications/Xcode.app').asRoot().execute();
/// ```
///
/// [switchTo] and [reset] change the setting system-wide and require root;
/// to point only the current shell session at a different Xcode without
/// touching every user, set the `DEVELOPER_DIR` environment variable instead
/// (the `env` parameter every runner takes) and leave this wrapper for
/// reading and for the one-time system default.
class XcodeSelectCmd extends CommandBuilder<XcodeSelectCmd> {
  @override
  final String executable = 'xcode-select';

  /// Prints the usage message (`-h`, `--help`).
  XcodeSelectCmd help() => token('-h');

  /// Sets the active developer directory system-wide, for example
  /// `/Applications/Xcode-beta.app` (`-s`, `--switch`). Requires root.
  XcodeSelectCmd switchTo(String path) => pair('-s', path);

  /// Prints the currently selected developer directory (`-p`,
  /// `--print-path`). For a script that needs to locate a tool inside it,
  /// prefer `xcrun --find` instead.
  XcodeSelectCmd printPath() => token('-p');

  /// Clears the system-wide developer directory override, reverting to the
  /// default search (`-r`, `--reset`). Requires root.
  XcodeSelectCmd reset() => token('-r');

  /// Prints the `xcode-select` version (`-v`, `--version`).
  XcodeSelectCmd version() => token('-v');

  /// Opens the UI dialog to install the command line developer tools
  /// (`--install`). Interactive; not for an unattended script.
  XcodeSelectCmd install() => token('--install');
}

/// `xcode-select`, ready to take its first option.
// ignore: non_constant_identifier_names
XcodeSelectCmd get XcodeSelect => XcodeSelectCmd();
