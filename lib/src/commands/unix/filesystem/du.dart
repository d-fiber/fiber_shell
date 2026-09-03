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

/// `du`, the disk usage reporter. On every Unix, absent from Windows.
///
/// ```dart
/// final ShellResult size = await Du.summarize().kilobytes().arg(volume.path).output();
/// ```
///
/// It reports **space on disk**, not the sum of the file sizes: a sparse file
/// counts what it occupies, a hard link counts once, and a filesystem that
/// compresses reports what it really used. That is usually the number you
/// wanted, and it is not the one Dart's `File.length` gives.
///
/// [summarize] with a unit flag is the shape to script against. Fix the unit
/// with [kilobytes], [megabytes] or [gigabytes] rather than [humanReadable],
/// whose `1.4G` has to be parsed back into a number, in a format that depends on
/// the locale.
///
/// A directory du cannot read produces a warning on stderr and a **non-zero
/// exit** while still printing a total, so read [ShellResult.text] rather than
/// giving up on the status.
class DuCmd extends CommandBuilder<DuCmd> {
  @override
  final String executable = 'du';

  /// One total per named argument, nothing below (`-s`).
  DuCmd summarize() => token('-s');

  /// A line per file, not just per directory (`-a`).
  DuCmd allFiles() => token('-a');

  /// How deep to report (`-d`).
  DuCmd maxDepth(String value) => pair('-d', value);

  /// Adds a grand total (`-c`).
  DuCmd total() => token('-c');

  /// In kibibytes (`-k`).
  DuCmd kilobytes() => token('-k');

  /// In mebibytes (`-m`).
  DuCmd megabytes() => token('-m');

  /// In gibibytes (`-g`).
  DuCmd gigabytes() => token('-g');

  /// In whichever unit keeps the number short (`-h`).
  DuCmd humanReadable() => token('-h');

  /// In blocks of this size (`-B`).
  DuCmd blockSize(String value) => pair('-B', value);

  /// Reports the apparent size rather than the space used (`-A`).
  DuCmd apparentSize() => token('-A');

  /// Stays on one filesystem (`-x`).
  ///
  /// Without it a `du` over a mount point walks into the volume mounted there.
  DuCmd noCrossMounts() => token('-x');

  /// Follows the symlinks named on the command line (`-H`).
  DuCmd followCommandLineLinks() => token('-H');

  /// Follows every symlink (`-L`).
  DuCmd followLinks() => token('-L');

  /// Follows none, which is the default (`-P`).
  DuCmd noFollowLinks() => token('-P');

  /// Counts a hard-linked file every time it is seen (`-l`).
  DuCmd countHardLinks() => token('-l');

  /// Skips the paths matching this glob (`-I`).
  DuCmd ignore(String pattern) => pair('-I', pattern);

  /// Only the entries at least this large (`-t`).
  DuCmd threshold(String value) => pair('-t', value);

  /// Says nothing about the directories it could not read (`-r` inverted).
  DuCmd noWarnings() => token('-r');

  /// Adds a path to measure. Without one du walks the current directory.
  DuCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
DuCmd get Du => DuCmd();
