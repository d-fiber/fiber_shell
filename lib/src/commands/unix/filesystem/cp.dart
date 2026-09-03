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

/// `cp`, the copier, in `/bin` everywhere.
///
/// ```dart
/// await Cp.recursive().preserve().source(template.path).destination(project.path).execute();
/// ```
///
/// Most of the interesting flags here are BSD's: [clone], [noFileFlags],
/// [noSparse], [noExtendedAttributes] and [noCrossMounts] do not exist in GNU
/// coreutils, and [archive] means `-RpP` on macOS but something wider on Linux.
/// [recursive], [force], [preserve] and [symbolicLink] behave the same on both.
class CpCmd extends CommandBuilder<CpCmd> {
  @override
  final String executable = 'cp';

  /// Copies directories, in the lowercase spelling every platform accepts (`-r`).
  CpCmd recursive() => token('-r');

  /// The same, spelled the way the macOS man page documents it (`-R`).
  ///
  /// A source path ending in `/` copies the contents rather than the directory.
  CpCmd recursiveSubtree() => token('-R');

  /// Follows the symlinks named on the command line, but not those met on the way down (`-H`).
  CpCmd followCommandLineLinks() => token('-H');

  /// Follows every symlink, copying what they point at (`-L`).
  CpCmd followLinks() => token('-L');

  /// Copies symlinks as symlinks, which is already the default under [recursive] (`-P`).
  CpCmd noFollowLinks() => token('-P');

  /// Shorthand for `-RpP`: structure and attributes preserved (`-a`).
  CpCmd archive() => token('-a');

  /// Asks the filesystem to clone the file instead of copying its bytes (`-c`).
  ///
  /// Falls back to a real copy across filesystems, so it is never worse than the default. macOS only.
  CpCmd clone() => token('-c');

  /// Removes and recreates a destination that is in the way, whatever its permissions (`-f`).
  CpCmd force() => token('-f');

  /// Asks before overwriting anything (`-i`).
  CpCmd interactive() => token('-i');

  /// Hard links the regular files instead of copying them (`-l`).
  CpCmd hardLink() => token('-l');

  /// Leaves the BSD file flags behind when [preserve] is on (`-N`). macOS only.
  CpCmd noFileFlags() => token('-N');

  /// Leaves an existing destination alone (`-n`).
  CpCmd noOverwrite() => token('-n');

  /// Keeps times, mode, owner, flags, ACLs and extended attributes (`-p`).
  CpCmd preserve() => token('-p');

  /// Writes the holes of a sparse file out in full (`-S`). macOS only.
  CpCmd noSparse() => token('-S');

  /// Creates symlinks to the sources instead of copying them (`-s`).
  CpCmd symbolicLink() => token('-s');

  /// Prints each file as it is copied (`-v`).
  CpCmd verbose() => token('-v');

  /// Drops extended attributes and resource forks (`-X`). macOS only.
  CpCmd noExtendedAttributes() => token('-X');

  /// Stops the recursion at a mount point (`-x`).
  CpCmd noCrossMounts() => token('-x');

  /// Ends the options, for paths that start with a dash (`--`).
  CpCmd endOfOptions() => token('--');

  /// Adds a file or directory to copy. Repeat to copy several into a directory.
  CpCmd source(String path) => token(path);

  /// The target, which must be a directory when several sources are given. Comes last.
  CpCmd destination(String path) => token(path);
}

/// `cp`, ready to take its first option.
// ignore: non_constant_identifier_names
CpCmd get Cp => CpCmd();
