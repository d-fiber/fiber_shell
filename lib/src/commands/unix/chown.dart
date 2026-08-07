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

/// `chown`, the owner setter, in `/usr/sbin` on macOS and `/bin` on Linux.
///
/// ```dart
/// await Chown.recursive().ownerAndGroup('postgres', 'postgres').path(dataDir).execute().asRoot();
/// ```
///
/// Changing an owner is a root operation, so this almost always travels with
/// `asRoot()`. [noCrossMounts] is BSD only; the rest is common ground.
class ChownCmd extends CommandBuilder<ChownCmd> {
  @override
  final String executable = 'chown';

  /// Walks into directories (`-R`).
  ChownCmd recursive() => token('-R');

  /// Swallows the diagnostic, and the failure, when a file will not budge (`-f`).
  ChownCmd force() => token('-f');

  /// Changes the symlink itself rather than what it points at (`-h`).
  ChownCmd symbolicLink() => token('-h');

  /// Reads the owner and group as numbers, skipping the name lookup (`-n`).
  ChownCmd numeric() => token('-n');

  /// Prints each file as it is changed (`-v`).
  ChownCmd verbose() => token('-v');

  /// Stops the recursion at a mount point (`-x`). BSD only.
  ChownCmd noCrossMounts() => token('-x');

  /// Under [recursive], follows the symlinks named on the command line (`-H`).
  ChownCmd followCommandLineLinks() => token('-H');

  /// Under [recursive], follows every symlink (`-L`).
  ChownCmd followLinks() => token('-L');

  /// Under [recursive], follows none, which is the default (`-P`).
  ChownCmd noFollowLinks() => token('-P');

  /// Ends the options, for paths that start with a dash (`--`).
  ChownCmd endOfOptions() => token('--');

  /// Sets the owner alone, by name or uid.
  ChownCmd owner(String spec) => token(spec);

  /// Sets both at once, the `owner:group` form.
  ChownCmd ownerAndGroup(String owner, String group) => token('$owner:$group');

  /// Sets the group alone, the `:group` form.
  ChownCmd group(String name) => token(':$name');

  /// Adds a file to change. Repeat for several.
  ChownCmd path(String value) => token(value);
}

/// `chown`, ready to take its first option.
// ignore: non_constant_identifier_names
ChownCmd get Chown => ChownCmd();
