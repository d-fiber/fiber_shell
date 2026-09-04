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

/// `sw_vers`, which prints macOS version information for the running system.
/// macOS only.
///
/// ```dart
/// final ShellResult version = await SwVers.productVersion().output();
/// if (Version.parse(version.text) < Version(14, 0, 0)) { /* ... */ }
/// ```
///
/// With no options, `sw_vers` prints all four fields as a `Key: value` block
/// meant for a human; for a script, one of [productName], [productVersion],
/// [productVersionExtra] or [buildVersion] gives back just the value on its
/// own line. [productVersionExtra] is only non-empty when a Rapid Security
/// Response is installed (e.g. `(a)`), so a script splitting on it should
/// tolerate an empty result. There is no JSON or plist output mode.
class SwVersCmd extends CommandBuilder<SwVersCmd> {
  @override
  final String executable = 'sw_vers';

  /// Prints only the operating system release name, typically `macOS`
  /// (`--productName`).
  SwVersCmd productName() => token('--productName');

  /// Prints only the operating system version, e.g. `14.5` (`--productVersion`).
  SwVersCmd productVersion() => token('--productVersion');

  /// Prints only the Rapid Security Response suffix, e.g. `(a)`, or nothing
  /// if none is installed (`--productVersionExtra`).
  SwVersCmd productVersionExtra() => token('--productVersionExtra');

  /// Prints only the build number, e.g. `23F79` (`--buildVersion`).
  SwVersCmd buildVersion() => token('--buildVersion');
}

/// `sw_vers`, ready to take its first option.
// ignore: non_constant_identifier_names
SwVersCmd get SwVers => SwVersCmd();
