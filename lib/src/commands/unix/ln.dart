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
