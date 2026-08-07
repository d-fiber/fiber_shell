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
