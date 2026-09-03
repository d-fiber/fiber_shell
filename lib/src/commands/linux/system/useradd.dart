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

/// `useradd`, the account creator from shadow-utils. Linux only; macOS keeps
/// its accounts in Open Directory and creates them with `dscl`.
///
/// ```dart
/// await Useradd
///     .createHome()
///     .shell('/usr/sbin/nologin')
///     .comment('deploy service account')
///     .groups('docker')
///     .arg('deploy')
///     .asRoot()
///     .execute();
/// ```
///
/// **[createHome] is not the default.** Leave it out and the account gets a
/// `homeDirectory` entry with nothing behind it, which is invisible until
/// something tries to write there. [systemAccount] is the other flag worth
/// remembering for a service account: it picks a uid from the system range
/// and skips the aging fields a human login gets.
///
/// [groups] here only ever adds to the account being created, unlike
/// `UsermodCmd.groups` on an existing one, which replaces the list unless
/// `UsermodCmd.append` is set — there is no equivalent trap on creation.
///
/// Everything here wants `asRoot()`.
class UseraddCmd extends CommandBuilder<UseraddCmd> {
  @override
  final String executable = 'useradd';

  /// Allows a login name that would otherwise be rejected as invalid
  /// (`--badname`).
  UseraddCmd badName() => token('--badname');

  /// The base directory new home directories are created under, combined with
  /// the login name (`-b`, `--base-dir`).
  UseraddCmd baseDir(String path) => pair('--base-dir', path);

  /// The comment field, the account's real name by convention (`-c`,
  /// `--comment`).
  UseraddCmd comment(String value) => pair('--comment', value);

  /// The home directory (`-d`, `--home-dir`). Defaults to [baseDir] plus the
  /// login name.
  UseraddCmd homeDir(String path) => pair('--home-dir', path);

  /// Shows, or with further arguments sets, the `/etc/default/useradd`
  /// defaults instead of creating an account (`-D`, `--defaults`).
  UseraddCmd defaults() => token('--defaults');

  /// The date the account expires, `YYYY-MM-DD` (`-e`, `--expiredate`).
  UseraddCmd expireDate(String value) => pair('--expiredate', value);

  /// How many days after a password expires the account still works (`-f`,
  /// `--inactive`). `-1` disables the feature.
  UseraddCmd inactive(int days) => pair('--inactive', '$days');

  /// Updates the `/etc/subuid` and `/etc/subgid` ranges even for a
  /// [systemAccount], which is skipped by default (`-F`,
  /// `--add-subids-for-system`).
  UseraddCmd addSubidsForSystem() => token('--add-subids-for-system');

  /// The primary group, by name or gid (`-g`, `--gid`). Without it or
  /// [userGroup], a new group matching the login name is created.
  UseraddCmd gid(String value) => pair('--gid', value);

  /// The supplementary groups, comma separated (`-G`, `--groups`).
  UseraddCmd groups(String value) => pair('--groups', value);

  /// The skeleton directory copied into a new home (`-k`, `--skel`). Only
  /// means anything with [createHome].
  UseraddCmd skel(String path) => pair('--skel', path);

  /// Overrides a default from `/etc/login.defs` for this call only, `KEY=VALUE`
  /// (`-K`, `--key`). Repeatable.
  UseraddCmd key(String value) => pair('--key', value);

  /// Skips writing to the last-log and faillog databases, for restoring an
  /// account rather than really creating one (`-l`, `--no-log-init`).
  UseraddCmd noLogInit() => token('--no-log-init');

  /// Creates the home directory and copies the skeleton into it (`-m`,
  /// `--create-home`).
  UseraddCmd createHome() => token('--create-home');

  /// Leaves the home directory uncreated, the default on most distributions
  /// (`-M`, `--no-create-home`).
  UseraddCmd noCreateHome() => token('--no-create-home');

  /// Creates no group even named after the login, relying entirely on [gid]
  /// (`-N`, `--no-user-group`).
  UseraddCmd noUserGroup() => token('--no-user-group');

  /// Allows a uid that is already taken (`-o`, `--non-unique`). Only means
  /// anything with [uid].
  UseraddCmd nonUnique() => token('--non-unique');

  /// The encrypted password (`-p`, `--password`).
  ///
  /// It lands in the process arguments where `ps` can read it, and it wants
  /// the hash rather than the password. `chpasswd` on stdin is the safer path,
  /// and an account created without it starts locked.
  UseraddCmd password(String hash) => pair('--password', hash);

  /// Creates a system account: a uid from the system range, no password aging,
  /// and no home directory unless [createHome] is also set (`-r`, `--system`).
  UseraddCmd systemAccount() => token('--system');

  /// Works inside this chroot, as if it were `/` (`-R`, `--root`).
  UseraddCmd root(String path) => pair('--root', path);

  /// Works inside this directory tree without treating it as the root, for
  /// preparing an image (`-P`, `--prefix`).
  UseraddCmd prefix(String path) => pair('--prefix', path);

  /// The login shell (`-s`, `--shell`). `/usr/sbin/nologin` for a service
  /// account.
  UseraddCmd shell(String path) => pair('--shell', path);

  /// The uid (`-u`, `--uid`). Auto-assigned from the configured range when
  /// left out.
  UseraddCmd uid(String value) => pair('--uid', value);

  /// Creates a group named after the login and makes it the primary group,
  /// the default behaviour without [gid] (`-U`, `--user-group`).
  UseraddCmd userGroup() => token('--user-group');

  /// The SELinux user to map the login to (`-Z`, `--selinux-user`).
  UseraddCmd selinuxUser(String value) => pair('--selinux-user', value);

  /// The SELinux MLS range for the account (`--selinux-range`).
  UseraddCmd selinuxRange(String value) => pair('--selinux-range', value);

  /// The login name being created. Comes last.
  UseraddCmd login(String name) => token(name);

  /// Prints the usage summary (`-h`, `--help`).
  UseraddCmd help() => token('--help');
}

/// `useradd`, ready to take its first option.
// ignore: non_constant_identifier_names
UseraddCmd get Useradd => UseraddCmd();
