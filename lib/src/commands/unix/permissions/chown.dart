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
