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

/// `pbpaste`, the read side of the macOS pasteboard (the Clipboard). Writes
/// whatever is on a pasteboard to stdout; see [Pbcopy] for the write half.
/// macOS only.
///
/// ```dart
/// final ShellResult clip = await Pbpaste.pasteboard().output();
/// await (Pbpaste.preferRtf() | Textutil.someRtfConsumer()).execute();
/// ```
///
/// Lookup order is plain text, then EPS, then RTF, unless overridden with
/// [preferPs] or [preferRtf]; if none of those three types is present,
/// `pbpaste` prints nothing and exits zero rather than failing — a script
/// that needs to distinguish "empty clipboard" from "clipboard holds an
/// unsupported type" cannot do so from the exit status alone.
class PbpasteCmd extends CommandBuilder<PbpasteCmd> {
  @override
  final String executable = 'pbpaste';

  /// Prints the usage summary (`-help`).
  PbpasteCmd help() => token('-help');

  /// Pastes from a specific pasteboard: `general`, `ruler`, `find` or `font`
  /// (`-pboard`). Defaults to `general` when omitted.
  PbpasteCmd pasteboard([String name = 'general']) => pair('-pboard', name);

  /// Looks for plain text first, the default behaviour made explicit
  /// (`-Prefer txt`). `ascii` is the deprecated spelling of the same thing.
  PbpasteCmd preferText() => pair('-Prefer', 'txt');

  /// Looks for Rich Text before falling back to the other types
  /// (`-Prefer rtf`).
  PbpasteCmd preferRtf() => pair('-Prefer', 'rtf');

  /// Looks for Encapsulated PostScript before falling back to the other
  /// types (`-Prefer ps`).
  PbpasteCmd preferPs() => pair('-Prefer', 'ps');
}

/// `pbpaste`, ready to take its first option.
// ignore: non_constant_identifier_names
PbpasteCmd get Pbpaste => PbpasteCmd();
