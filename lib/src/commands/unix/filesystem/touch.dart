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

/// `touch`, creating an empty file or updating its timestamps. On every Unix.
///
/// ```dart
/// await Touch.path('build/.gitkeep').execute();
/// ```
///
/// [modificationTime] takes `[[CC]YY]MMDDhhmm[.SS]` on both flavours. [date]
/// is GNU only and takes a free-form string GNU parses with its own date
/// parser; BSD touch has a `-d` too, but a strict
/// `YYYY-MM-DDThh:mm:SS[.frac][tz]` rather than GNU's forgiving grammar, so a
/// [date] string that works on one is not guaranteed to work on the other.
/// [referenceFile] is the portable way to copy a timestamp from one file to
/// another. [adjust] is a BSD-only relative nudge; GNU has no equivalent.
class TouchCmd extends CommandBuilder<TouchCmd> {
  @override
  final String executable = 'touch';

  /// Changes only the access time (`-a`).
  TouchCmd accessTimeOnly() => token('-a');

  /// Changes only the modification time (`-m`).
  TouchCmd modificationTimeOnly() => token('-m');

  /// Selects which time [date], [modificationTime] or the current time apply to: `access`/`atime`/`use` or `modify`/`mtime` (`--time`). GNU only.
  TouchCmd timeWord(String word) => pair('--time', word);

  /// Does not create the file if it is missing (`-c`, `--no-create`).
  TouchCmd noCreate() => token('-c');

  /// Changes the timestamps of a symlink itself rather than its target (`-h`, `--no-dereference`).
  ///
  /// Implies [noCreate]: it will not create a new file.
  TouchCmd noDereference() => token('-h');

  /// Uses this file's timestamps instead of the current time (`-r`, `--reference`).
  TouchCmd referenceFile(String path) => pair('-r', path);

  /// Sets the timestamp explicitly, `[[CC]YY]MMDDhhmm[.SS]` (`-t`).
  TouchCmd modificationTime(String value) => pair('-t', value);

  /// Sets the timestamp from a string GNU's date parser understands (`-d`). GNU only; BSD's `-d` wants strict ISO-8601.
  TouchCmd date(String value) => pair('-d', value);

  /// Adjusts the existing timestamps by `[-][[hh]mm]SS` rather than setting them outright (`-A`). BSD only.
  TouchCmd adjust(String value) => pair('-A', value);

  /// Prints the usage summary (`--help`). GNU only.
  TouchCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  TouchCmd version() => token('--version');

  /// Adds a path to touch. Repeat for several.
  TouchCmd path(String value) => token(value);
}

/// `touch`, ready to take its first option.
// ignore: non_constant_identifier_names
TouchCmd get Touch => TouchCmd();
