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

/// `chroot`, the GNU coreutils command that runs a program with a new `/`.
/// Present on every Linux distribution; a `chroot` binary also ships on macOS
/// and BSD, but with a different, narrower option set than the GNU one this
/// wrapper models.
///
/// ```dart
/// final ShellResult result = await Chroot.newRoot('/mnt/target').userspec('nobody:nogroup').arg('/bin/sh').arg('-c').arg('echo hi').output();
/// ```
///
/// A chroot is not a sandbox: it changes what a path resolves to, not what a
/// process can reach through an open file descriptor, a bind mount, or
/// `/proc/self/root/..` if the caller has `CAP_SYS_CHROOT` without also
/// dropping privileges afterwards. Pair it with [Unshare] or [Nsenter] for
/// anything that needs to hold. Almost every real use needs root: [newRoot]
/// itself requires the privilege to call `chroot(2)`, before [userspec] even
/// gets a chance to drop it back down inside.
class ChrootCmd extends CommandBuilder<ChrootCmd> {
  @override
  final String executable = 'chroot';

  /// Overrides the supplementary groups the new process runs with, comma separated (`--groups`).
  ///
  /// Pass an empty list to disable supplementary-group lookup entirely.
  ChrootCmd groups(List<String> groups) => joinedAll('--groups', groups);

  /// Runs the command as this user, and optionally this primary group, `user[:group]` (`--userspec`).
  ///
  /// Without a group, supplementary groups are looked up for the user unless
  /// [groups] overrides them.
  ChrootCmd userspec(String userAndGroup) => joined('--userspec', userAndGroup);

  /// Skips changing the working directory to `/` after the chroot (`--skip-chdir`).
  ///
  /// Only valid when [newRoot] is `/` itself, which is what makes [groups] or
  /// [userspec] useful without also relocating the filesystem root.
  ChrootCmd skipChdir() => token('--skip-chdir');

  /// Prints the usage summary (`--help`).
  ChrootCmd help() => token('--help');

  /// Prints the version (`--version`).
  ChrootCmd version() => token('--version');

  /// The directory to become the new `/`.
  ChrootCmd newRoot(String path) => token(path);

  /// Adds one token of the command to run inside the chroot, and its arguments.
  ///
  /// Left out entirely, `chroot` runs `$SHELL -i`, or `/bin/sh -i` with no
  /// `$SHELL` — interactive, and not what a script wants.
  ChrootCmd arg(String value) => token(value);
}

/// `chroot`, ready to take its new root.
// ignore: non_constant_identifier_names
ChrootCmd get Chroot => ChrootCmd();
