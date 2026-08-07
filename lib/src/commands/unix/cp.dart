// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

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
