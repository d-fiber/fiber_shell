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

/// `ln`, the link maker. On every Unix, absent from Windows.
///
/// ```dart
/// await Ln.symbolic().force().noDereference().target(release.path).linkName(current.path).execute();
/// ```
///
/// That combination is the atomic deploy switch: a `current` symlink pointing at
/// a release directory, repointed in one operation so nothing ever sees it
/// missing.
///
/// **[force] alone is not enough** when the link already exists and points at a
/// directory: without [noDereference] `ln` follows it and creates the new link
/// *inside* the old target, which looks like it worked and is not what you asked
/// for. The pair together is the spelling that behaves.
///
/// A hard link cannot cross a filesystem and cannot point at a directory; a
/// symbolic one can do both, and breaks when its target moves.
class LnCmd extends CommandBuilder<LnCmd> {
  @override
  final String executable = 'ln';

  /// Makes a symbolic link rather than a hard one (`-s`).
  LnCmd symbolic() => token('-s');

  /// Replaces an existing link or file (`-f`).
  LnCmd force() => token('-f');

  /// Replaces a link rather than following it (`-h`).
  LnCmd noFollow() => token('-h');

  /// The same under its other spelling (`-n`).
  LnCmd noDereference() => token('-n');

  /// Asks before replacing anything (`-i`). Interactive.
  LnCmd interactive() => token('-i');

  /// Follows a symbolic link target when hard linking (`-L`).
  LnCmd followTarget() => token('-L');

  /// Hard links the symlink itself instead (`-P`).
  LnCmd linkSymlink() => token('-P');

  /// Replaces by unlinking first, so the window is smaller (`-F`).
  LnCmd removeFirst() => token('-F');

  /// Prints what it linked (`-v`).
  LnCmd verbose() => token('-v');

  /// Warns when the target of a symbolic link does not exist (`-w`).
  LnCmd warnDangling() => token('-w');

  /// Ends the options, for names starting with a dash (`--`).
  LnCmd endOfOptions() => token('--');

  /// What the link points at.
  LnCmd target(String path) => token(path);

  /// Where the link is created. Comes last.
  LnCmd linkName(String path) => token(path);
}

// ignore: non_constant_identifier_names
LnCmd get Ln => LnCmd();
