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

/// `pbcopy`, the command-line side of the macOS pasteboard (the Clipboard).
/// Takes stdin and places it on a pasteboard; see [Pbpaste] for the other
/// half. macOS only.
///
/// ```dart
/// await (Cat.file('secret.txt') | Pbcopy.pasteboard()).execute();
/// ```
///
/// The data lands as plain text unless it begins with an EPS or RTF file
/// header, in which case `pbcopy` stores it as that type instead — there is
/// no way to force plain text on input. Encoding follows the locale
/// environment (`LANG`); a script running under a stripped environment (a
/// launchd job, an SSH `ExecuteCommand`) may need `LANG=en_US.UTF-8` set
/// explicitly to avoid falling back to plain C encoding.
class PbcopyCmd extends CommandBuilder<PbcopyCmd> {
  @override
  final String executable = 'pbcopy';

  /// Prints the usage summary (`-help`).
  PbcopyCmd help() => token('-help');

  /// Copies to a specific pasteboard: `general`, `ruler`, `find` or `font`
  /// (`-pboard`). Defaults to `general` when omitted.
  PbcopyCmd pasteboard([String name = 'general']) => pair('-pboard', name);
}

/// `pbcopy`, ready to take its first option.
// ignore: non_constant_identifier_names
PbcopyCmd get Pbcopy => PbcopyCmd();
