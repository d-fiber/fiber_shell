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

/// `usermod`, the account editor from shadow-utils. Linux only; macOS keeps its
/// accounts in Open Directory and edits them with `dscl`.
///
/// ```dart
/// await Usermod.append().groups('docker').arg('deploy').asRoot().execute();
/// ```
///
/// **[groups] without [append] replaces the list**, which is how an account
/// quietly loses every group it had. The pair above is the only spelling worth
/// using unless you really mean to reset them.
///
/// The user must not be logged in when its uid or home directory changes, and
/// group membership only reaches a process at its next login, so a shell that
/// was already open still cannot reach the docker socket.
///
/// Everything here wants `asRoot()`.
class UsermodCmd extends CommandBuilder<UsermodCmd> {
  @override
  final String executable = 'usermod';

  /// Adds to the supplementary groups rather than replacing them (`--append`).
  ///
  /// Only means anything next to [groups].
  UsermodCmd append() => token('--append');

  /// The supplementary groups, comma separated (`--groups`).
  UsermodCmd groups(String value) => pair('--groups', value);

  /// The primary group, by name or gid (`--gid`).
  UsermodCmd gid(String value) => pair('--gid', value);

  /// The comment field, the account's real name by convention (`--comment`).
  UsermodCmd comment(String value) => pair('--comment', value);

  /// The new home directory (`--home`). Pair with [moveHome] to take the files.
  UsermodCmd home(String path) => pair('--home', path);

  /// Moves the contents of the old home to the new one (`--move-home`).
  UsermodCmd moveHome() => token('--move-home');

  /// The date the account expires, `YYYY-MM-DD` (`--expiredate`).
  UsermodCmd expireDate(String value) => pair('--expiredate', value);

  /// How many days after a password expires the account still works (`--inactive`).
  UsermodCmd inactive(String days) => pair('--inactive', days);

  /// The new login name (`--login`). Leaves the home directory alone.
  UsermodCmd login(String name) => pair('--login', name);

  /// Locks the password, so password login stops working (`--lock`).
  ///
  /// It does not touch the SSH keys: a locked account still logs in with one.
  UsermodCmd lock() => token('--lock');

  /// Unlocks the password (`--unlock`).
  UsermodCmd unlock() => token('--unlock');

  /// Allows a uid that is already taken (`--non-unique`).
  UsermodCmd nonUnique() => token('--non-unique');

  /// The encrypted password (`--password`).
  ///
  /// It lands in the process arguments where `ps` can read it, and it wants the
  /// hash rather than the password. `chpasswd` on stdin is the better path.
  UsermodCmd password(String hash) => pair('--password', hash);

  /// Removes the account from the groups named by [groups] (`--remove`).
  UsermodCmd remove() => token('--remove');

  /// Works inside this chroot (`--root`).
  UsermodCmd root(String path) => pair('--root', path);

  /// Works inside this directory tree, for cross-compilation (`--prefix`).
  UsermodCmd prefix(String path) => pair('--prefix', path);

  /// The login shell (`--shell`). `/usr/sbin/nologin` for a service account.
  UsermodCmd shell(String path) => pair('--shell', path);

  /// The new uid (`--uid`).
  UsermodCmd uid(String value) => pair('--uid', value);

  /// Allows a name the usual rules would reject (`--badname`).
  UsermodCmd badName() => token('--badname');

  /// Adds a subordinate uid range, for user namespaces (`--add-subuids`).
  UsermodCmd addSubUids(String range) => pair('--add-subuids', range);

  /// Removes a subordinate uid range (`--del-subuids`).
  UsermodCmd delSubUids(String range) => pair('--del-subuids', range);

  /// Adds a subordinate gid range (`--add-subgids`).
  UsermodCmd addSubGids(String range) => pair('--add-subgids', range);

  /// Removes a subordinate gid range (`--del-subgids`).
  UsermodCmd delSubGids(String range) => pair('--del-subgids', range);

  /// The SELinux user to map the login to (`--selinux-user`).
  UsermodCmd selinuxUser(String value) => pair('--selinux-user', value);

  /// The account to modify. Comes last.
  UsermodCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
UsermodCmd get Usermod => UsermodCmd();
