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

/// `mdfind`, a command-line query against the Spotlight metadata store.
/// macOS only, and only as good as the index: a volume with indexing disabled
/// or a path excluded from Spotlight in System Settings comes back empty
/// without a word of complaint.
///
/// ```dart
/// final ShellResult hits = await Mdfind.onlyIn(projectDir).query('kind:pdf').output();
/// ```
///
/// [live] is the trap: without it, `mdfind` gathers the current matches and
/// exits; with it, the process keeps running and streams updates as the index
/// changes, which means [execute] and [output] never return on their own.
/// Pair [live] with [count] and read the running total, or reach for
/// `background()` and `kill()` the job when done. A query with no [onlyIn]
/// scope walks every indexed volume, which is rarely what a script wants.
class MdfindCmd extends CommandBuilder<MdfindCmd> {
  @override
  final String executable = 'mdfind';

  /// Prints a NUL character after each result path instead of a newline
  /// (`-0`). Pairs with `xargs -0`.
  MdfindCmd nullSeparated() => token('-0');

  /// Keeps running after the first pass, streaming updated match counts as
  /// the index changes (`-live`). Never exits on its own; see the class docs.
  MdfindCmd live() => token('-live');

  /// Prints the number of matches instead of their paths (`-count`).
  MdfindCmd count() => token('-count');

  /// Scopes the search to this directory (`-onlyin`). Repeatable.
  MdfindCmd onlyIn(String directory) => pair('-onlyin', directory);

  /// Matches on file name only, rather than every metadata attribute
  /// (`-name`).
  MdfindCmd name(String fileName) => pair('-name', fileName);

  /// Takes the query string literally, with no interpretation (`-literal`).
  MdfindCmd literal() => token('-literal');

  /// Interprets the query the way the Spotlight menu would, expanding a bare
  /// word into a broader attribute match (`-interpret`).
  MdfindCmd interpret() => token('-interpret');

  /// The query itself: a bare string, or a metadata query expression such as
  /// `kMDItemAuthors == '*name*'`.
  MdfindCmd query(String value) => token(value);
}

/// `mdfind`, ready to take its first option.
// ignore: non_constant_identifier_names
MdfindCmd get Mdfind => MdfindCmd();
