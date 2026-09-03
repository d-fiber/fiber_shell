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

/// `chmod`, the permission setter, in `/bin` everywhere.
///
/// ```dart
/// await Chmod.mode('600').path(keyFile.path).execute();
/// ```
///
/// The mode flags are portable. Everything under [aclAdd] and its neighbours is
/// macOS: those spellings drive the macOS ACLs and have no GNU counterpart, where
/// `setfacl` does the job instead.
class ChmodCmd extends CommandBuilder<ChmodCmd> {
  @override
  final String executable = 'chmod';

  /// Swallows the diagnostic, and the failure, when a file will not budge (`-f`).
  ChmodCmd force() => token('-f');

  /// Changes the symlink itself rather than what it points at (`-h`).
  ChmodCmd symbolicLink() => token('-h');

  /// Prints each file as it is changed; twice over shows the old and new modes (`-v`).
  ChmodCmd verbose() => token('-v');

  /// Walks into directories (`-R`). Careful with a `.*` glob, it matches `..` too.
  ChmodCmd recursive() => token('-R');

  /// Under [recursive], follows the symlinks named on the command line (`-H`).
  ChmodCmd followCommandLineLinks() => token('-H');

  /// Under [recursive], follows every symlink (`-L`).
  ChmodCmd followLinks() => token('-L');

  /// Under [recursive], follows none, which is the default (`-P`).
  ChmodCmd noFollowLinks() => token('-P');

  /// Inserts an ACL entry (`+a`). macOS only.
  ChmodCmd aclAdd(String ace) => pair('+a', ace);

  /// Deletes an ACL entry (`-a`). macOS only.
  ChmodCmd aclRemove(String ace) => pair('-a', ace);

  /// Rewrites an ACL entry in place (`=a`). macOS only.
  ChmodCmd aclRewrite(String ace) => pair('=a', ace);

  /// Opens the ACL in `$EDITOR` (`-E`). macOS only, and interactive, so not for a script.
  ChmodCmd aclEdit() => token('-E');

  /// Reorders the ACL into canonical form (`-C`). macOS only.
  ChmodCmd aclCanonicalize() => token('-C');

  /// Strips the ACL entirely (`-N`). macOS only.
  ChmodCmd aclClear() => token('-N');

  /// Drops the inherited entries (`-i`). macOS only.
  ChmodCmd aclRemoveInherited() => token('-i');

  /// Drops the inheritance flags themselves (`-I`). macOS only.
  ChmodCmd aclRemoveInheritance() => token('-I');

  /// Makes the file executable for everyone the umask allows (`+x`).
  ChmodCmd plusX() => token('+x');

  /// Grants write (`+w`).
  ChmodCmd plusW() => token('+w');

  /// Grants read (`+r`).
  ChmodCmd plusR() => token('+r');

  /// Takes execute away (`-x`).
  ChmodCmd minusX() => token('-x');

  /// Takes write away (`-w`).
  ChmodCmd minusW() => token('-w');

  /// Takes read away (`-r`).
  ChmodCmd minusR() => token('-r');

  /// Ends the options, for paths that start with a dash (`--`).
  ChmodCmd endOfOptions() => token('--');

  /// The mode, octal like `600` or symbolic like `u+rw,go-rwx`.
  ChmodCmd mode(String value) => token(value);

  /// Adds a file to change. Repeat for several.
  ChmodCmd path(String value) => token(value);
}

/// `chmod`, ready to take its first option.
// ignore: non_constant_identifier_names
ChmodCmd get Chmod => ChmodCmd();
