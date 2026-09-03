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

/// `groupadd`, the group creator from shadow-utils. Linux only; macOS keeps
/// its groups in Open Directory and creates them with `dscl`.
///
/// ```dart
/// await Groupadd.systemGroup().arg('docker').asRoot().execute();
/// await Groupadd.users(['alice', 'bob']).arg('deploy').asRoot().execute();
/// ```
///
/// [users] is the exception to the rule that `groupadd` only ever creates an
/// empty group: it seeds initial members in the same call. Adding a member
/// afterwards is `UsermodCmd.groups` with `UsermodCmd.append`, or `usermod
/// -aG` in shell terms.
///
/// Everything here wants `asRoot()`.
class GroupaddCmd extends CommandBuilder<GroupaddCmd> {
  @override
  final String executable = 'groupadd';

  /// Succeeds quietly when the group already exists, changing nothing about it
  /// (`-f`, `--force`).
  ///
  /// Without it, creating an existing group is an error. With it and [gid]
  /// both, a gid collision with a different group is still an error.
  GroupaddCmd force() => token('--force');

  /// The gid (`-g`, `--gid`). Auto-assigned from the configured range when
  /// left out.
  GroupaddCmd gid(String value) => pair('--gid', value);

  /// Overrides a default from `/etc/login.defs` for this call only, `KEY=VALUE`
  /// (`-K`, `--key`). Repeatable.
  GroupaddCmd key(String value) => pair('--key', value);

  /// Allows a gid that is already taken (`-o`, `--non-unique`). Only means
  /// anything with [gid].
  GroupaddCmd nonUnique() => token('--non-unique');

  /// The encrypted group password (`-p`, `--password`). Group passwords are a
  /// legacy feature `newgrp` reads; almost nothing sets one deliberately.
  GroupaddCmd password(String hash) => pair('--password', hash);

  /// Creates a system group: a gid from the system range, the one service
  /// accounts should share rather than each getting a fresh user group
  /// (`-r`, `--system`).
  GroupaddCmd systemGroup() => token('--system');

  /// Works inside this chroot, as if it were `/` (`-R`, `--root`).
  GroupaddCmd root(String path) => pair('--root', path);

  /// Works inside this directory tree without treating it as the root, for
  /// preparing an image (`-P`, `--prefix`).
  GroupaddCmd prefix(String path) => pair('--prefix', path);

  /// Seeds the group with these initial members, comma separated (`-U`,
  /// `--users`).
  GroupaddCmd users(List<String> names) => joinedAll('--users', names);

  /// The group name being created. Comes last.
  GroupaddCmd name(String value) => token(value);

  /// Prints the usage summary (`-h`, `--help`).
  GroupaddCmd help() => token('--help');
}

/// `groupadd`, ready to take its first option.
// ignore: non_constant_identifier_names
GroupaddCmd get Groupadd => GroupaddCmd();
