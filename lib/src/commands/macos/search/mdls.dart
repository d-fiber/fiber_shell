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

/// `mdls`, which lists the Spotlight metadata attributes of a file. macOS
/// only, and [MdfindCmd]'s natural companion: `mdfind` finds the paths,
/// `mdls` explains what one of them is tagged with.
///
/// ```dart
/// final ShellResult kind = await Mdls.attribute('kMDItemKind').raw().file(path).output();
/// ```
///
/// With no [attribute] at all it dumps every attribute the file carries,
/// which is the exploratory form; name the attributes you actually want and
/// add [raw] once the script only cares about the values, not the
/// `attribute = value` framing.
class MdlsCmd extends CommandBuilder<MdlsCmd> {
  @override
  final String executable = 'mdls';

  /// Prints only this attribute's value (`-name`). Repeatable, and the order
  /// given is the order printed under [raw].
  MdlsCmd attribute(String name) => pair('-name', name);

  /// Prints raw values only, NUL-separated, with no `attribute = ` framing
  /// (`-raw`). Meant for piping into `xargs -0`.
  MdlsCmd raw() => token('-raw');

  /// Under [raw], the placeholder printed for an attribute the file has no
  /// value for (`-nullMarker`). Defaults to `(null)`.
  MdlsCmd nullMarker(String marker) => pair('-nullMarker', marker);

  /// The file to inspect. Repeatable.
  MdlsCmd file(String path) => token(path);
}

/// `mdls`, ready to take its first option.
// ignore: non_constant_identifier_names
MdlsCmd get Mdls => MdlsCmd();
