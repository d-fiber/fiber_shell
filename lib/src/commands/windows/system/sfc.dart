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

/// `sfc`, the System File Checker: scans protected system files against
/// known-good versions and replaces the ones that were overwritten. Windows
/// only, and requires an elevated (Administrators-group) prompt.
///
/// ```dart
/// final ShellResult scan = await Sfc.scanNow().asRoot().output();
/// if (scan.failed) { /* corruption sfc could not fix on its own */ }
/// ```
///
/// [scanNow] repairs what it finds; [verifyOnly] only reports. There is no
/// dry-run distinct from [verifyOnly] — a plain `sfc` with no arguments does
/// nothing useful from a script's point of view.
///
/// [scanFile]/[verifyFile] target one file instead of the whole protected
/// set, which is what a script chasing a single known-bad DLL wants instead
/// of a full [scanNow] pass.
///
/// The offline-repair trio — [offlineWindowsDirectory], [offlineBootDirectory]
/// and [offlineLogFile] — only makes sense together, against a Windows
/// installation that isn't the one currently running (mounted from WinPE, a
/// dual-boot volume, or similar); passing just one of them without the others
/// is a documented-but-useless combination.
class SfcCmd extends CommandBuilder<SfcCmd> {
  @override
  final String executable = 'sfc';

  /// Scans every protected system file and repairs what it can (`/scannow`).
  SfcCmd scanNow() => token('/scannow');

  /// Scans every protected system file without repairing anything
  /// (`/verifyonly`).
  SfcCmd verifyOnly() => token('/verifyonly');

  /// Scans one file, full path and filename, and repairs it if broken
  /// (`/scanfile=<file>`).
  SfcCmd scanFile(String path) => token('/scanfile=$path');

  /// Verifies one file, full path and filename, without repairing it
  /// (`/verifyfile=<file>`).
  SfcCmd verifyFile(String path) => token('/verifyfile=$path');

  /// The offline Windows directory to repair, for use alongside
  /// [offlineBootDirectory] and [offlineLogFile] (`/offwindir=<dir>`).
  SfcCmd offlineWindowsDirectory(String path) => token('/offwindir=$path');

  /// The offline boot directory, for use alongside [offlineWindowsDirectory]
  /// (`/offbootdir=<dir>`).
  SfcCmd offlineBootDirectory(String path) => token('/offbootdir=$path');

  /// Where to write the log for an offline repair, instead of the default
  /// location (`/offlogfile=<file>`).
  SfcCmd offlineLogFile(String path) => token('/offlogfile=$path');

  /// Prints usage help (`/?`).
  SfcCmd help() => token('/?');
}

/// `sfc`, ready to take its first option.
// ignore: non_constant_identifier_names
SfcCmd get Sfc => SfcCmd();
