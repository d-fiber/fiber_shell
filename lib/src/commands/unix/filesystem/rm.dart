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

/// `rm`, the file remover, in `/bin` everywhere.
///
/// ```dart
/// await Rm.recursive().force().path(cache.path).execute();
/// ```
///
/// BSD and GNU part ways here: [confirmOnce], [undelete] and [noCrossMounts] are
/// macOS only, and [legacyOverwrite] does nothing at all on either. Stick to
/// [recursive], [force] and [directories] for anything meant to run on both.
class RmCmd extends CommandBuilder<RmCmd> {
  @override
  final String executable = 'rm';

  /// Walks into directories and removes what it finds (`-r`).
  RmCmd recursive() => token('-r');

  /// The same walk under its other spelling (`-R`), the one the man page documents.
  RmCmd recursiveHierarchy() => token('-R');

  /// Never prompts, never complains about a file that is not there (`-f`).
  ///
  /// It also flips the exit status: a missing file stops being an error.
  RmCmd force() => token('-f');

  /// Asks before every single file (`-i`).
  RmCmd interactive() => token('-i');

  /// Asks once, and only past three files or a recursive removal (`-I`). macOS only.
  RmCmd confirmOnce() => token('-I');

  /// Removes empty directories as well as files (`-d`).
  RmCmd directories() => token('-d');

  /// Does nothing (`-P`). Kept because 4.4BSD-Lite2 scripts still pass it.
  RmCmd legacyOverwrite() => token('-P');

  /// Prints each file as it goes (`-v`).
  RmCmd verbose() => token('-v');

  /// Recovers files hidden by a whiteout in a union filesystem (`-W`). macOS only.
  RmCmd undelete() => token('-W');

  /// Stops the recursion at a mount point (`-x`). macOS only.
  RmCmd noCrossMounts() => token('-x');

  /// Ends the options, the only way to remove a file whose name starts with a dash (`--`).
  RmCmd endOfOptions() => token('--');

  /// Adds a file or directory to remove. Repeat for several.
  RmCmd path(String value) => token(value);
}

/// `rm`, ready to take its first option.
// ignore: non_constant_identifier_names
RmCmd get Rm => RmCmd();
