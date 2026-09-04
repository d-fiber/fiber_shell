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

/// `unshare`, the util-linux tool that runs a program in new, empty
/// namespaces instead of borrowing existing ones the way [Nsenter] does.
/// Linux only.
///
/// ```dart
/// final ShellResult isolated = await Unshare.net().mount().fork().mountProc().arg('ip').arg('addr').output();
/// final ShellResult rootless = await Unshare.user().mapRootUser().fork().arg('whoami').output();
/// ```
///
/// Most namespace flags ([mount], [uts], [ipc], [net], [pid], [user],
/// [cgroup], [time]) can also make the new namespace persistent by taking a
/// path: passing one bind-mounts the namespace there so another process can
/// join it later with `nsenter --net=path`. A new [pid] namespace needs
/// [fork] to actually put the new process at PID 1 of it and to mount a fresh
/// `/proc` with [mountProc], or tools reading `/proc` inside see the outer
/// system's processes. [mapRootUser] and [user] together are the pairing that
/// gets an unprivileged caller root inside its own new namespaces without
/// `asRoot()` at all — the whole point of user namespaces.
class UnshareCmd extends CommandBuilder<UnshareCmd> {
  @override
  final String executable = 'unshare';

  /// Creates a new IPC namespace; a file argument bind-mounts it there to persist (`-i`, `--ipc`).
  UnshareCmd ipc([String? file]) => file == null ? token('--ipc') : joined('--ipc', file);

  /// Creates a new mount namespace (`-m`, `--mount`).
  UnshareCmd mount([String? file]) => file == null ? token('--mount') : joined('--mount', file);

  /// Creates a new network namespace (`-n`, `--net`).
  UnshareCmd net([String? file]) => file == null ? token('--net') : joined('--net', file);

  /// Creates a new PID namespace; pair with [fork] and [mountProc] (`-p`, `--pid`).
  UnshareCmd pidNamespace([String? file]) => file == null ? token('--pid') : joined('--pid', file);

  /// Creates a new UTS namespace (hostname, domain name) (`-u`, `--uts`).
  UnshareCmd uts([String? file]) => file == null ? token('--uts') : joined('--uts', file);

  /// Creates a new user namespace (`-U`, `--user`).
  UnshareCmd user([String? file]) => file == null ? token('--user') : joined('--user', file);

  /// Creates a new cgroup namespace (`-C`, `--cgroup`).
  UnshareCmd cgroup([String? file]) => file == null ? token('--cgroup') : joined('--cgroup', file);

  /// Creates a new time namespace (`-T`, `--time`).
  UnshareCmd time([String? file]) => file == null ? token('--time') : joined('--time', file);

  /// Runs the program as a forked child instead of replacing `unshare` itself (`-f`, `--fork`).
  ///
  /// Required for a new [pidNamespace] to actually seat the program at PID 1
  /// of it.
  UnshareCmd fork() => token('--fork');

  /// Forwards `SIGTERM`/`SIGINT` received by `unshare` on to the forked child (`--forward-signals`).
  UnshareCmd forwardSignals() => token('--forward-signals');

  /// Keeps capabilities in the child after entering a new user namespace (`--keep-caps`).
  UnshareCmd keepCaps() => token('--keep-caps');

  /// Sends this signal to the child when `unshare` itself is killed; defaults to `SIGKILL` (`--kill-child`).
  UnshareCmd killChild([String? signal]) => signal == null ? token('--kill-child') : joined('--kill-child', signal);

  /// Mounts a fresh `/proc` at this mountpoint (default `/proc`) before running the program (`--mount-proc`).
  ///
  /// Needed alongside a new [pidNamespace] so `/proc` reflects the new
  /// namespace instead of the outer system's.
  UnshareCmd mountProc([String? mountpoint]) =>
      mountpoint == null ? token('--mount-proc') : joined('--mount-proc', mountpoint);

  /// Mounts `binfmt_misc` at this mountpoint before running the program (`--mount-binfmt`).
  UnshareCmd mountBinfmt([String? mountpoint]) =>
      mountpoint == null ? token('--mount-binfmt') : joined('--mount-binfmt', mountpoint);

  /// Maps the caller's UID to this UID or name inside the new user namespace (`--map-user`).
  UnshareCmd mapUser(String uidOrName) => joined('--map-user', uidOrName);

  /// Maps a block of subordinate UIDs, `inner:outer:count`, `auto`, `subids` or `all` (`--map-users`).
  UnshareCmd mapUsers(String spec) => joined('--map-users', spec);

  /// Maps the caller's GID to this GID or name (`--map-group`).
  UnshareCmd mapGroup(String gidOrName) => joined('--map-group', gidOrName);

  /// Maps a block of subordinate GIDs the same way as [mapUsers] (`--map-groups`).
  UnshareCmd mapGroups(String spec) => joined('--map-groups', spec);

  /// Maps subordinate UIDs/GIDs straight out of `/etc/subuid` and `/etc/subgid` (`--map-auto`).
  UnshareCmd mapAuto() => token('--map-auto');

  /// Identity-maps the subordinate ID ranges (`--map-subids`).
  UnshareCmd mapSubids() => token('--map-subids');

  /// Maps the caller to root (UID/GID 0) inside the new user namespace (`-r`, `--map-root-user`).
  ///
  /// The usual companion to an unprivileged [user] namespace.
  UnshareCmd mapRootUser() => token('--map-root-user');

  /// Maps the caller to the same UID/GID inside the new user namespace as outside it (`-c`, `--map-current-user`).
  UnshareCmd mapCurrentUser() => token('--map-current-user');

  /// Sets the owning UID and GID of the new user namespace, `uid:gid` (`--owner`).
  UnshareCmd owner(String uidGid) => joined('--owner', uidGid);

  /// Sets mount propagation recursively on `/`: `private`, `shared`, `slave` or `unchanged` (`--propagation`).
  UnshareCmd propagation(String mode) => joined('--propagation', mode);

  /// Allows or denies `setgroups(2)` in the new user namespace (`--setgroups`).
  UnshareCmd setgroups(String allowOrDeny) => joined('--setgroups', allowOrDeny);

  /// Sets the root directory of the new process (`-R`, `--root`).
  UnshareCmd root(String directory) => pair('--root', directory);

  /// Sets the working directory of the new process (`-w`, `--wd`).
  UnshareCmd workingDirectory(String directory) => pair('--wd', directory);

  /// Sets the UID inside the entered user namespace (`-S`, `--setuid`).
  UnshareCmd setuid(int uid) => pair('--setuid', '$uid');

  /// Sets the GID and drops supplementary groups (`-G`, `--setgid`).
  UnshareCmd setgid(int gid) => pair('--setgid', '$gid');

  /// Loads this `binfmt_misc` definition string into the new namespace (`-l`, `--load-interp`).
  UnshareCmd loadInterp(String definition) => pair('--load-interp', definition);

  /// Sets the `CLOCK_MONOTONIC` offset, in seconds, of a new time namespace (`--monotonic`).
  UnshareCmd monotonic(String offset) => joined('--monotonic', offset);

  /// Sets the `CLOCK_BOOTTIME` offset, in seconds, of a new time namespace (`--boottime`).
  UnshareCmd boottime(String offset) => joined('--boottime', offset);

  /// Runs the program with no inherited environment variables at all (`--clear-env`).
  UnshareCmd clearEnv() => token('--clear-env');

  /// Keeps only these environment variables, comma separated (`--whitelist-env`).
  UnshareCmd whitelistEnv(List<String> names) => joinedAll('--whitelist-env', names);

  /// Prints the usage summary (`-h`, `--help`).
  UnshareCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  UnshareCmd version() => token('--version');

  /// Adds one token of the command to run in the new namespaces.
  ///
  /// Left out entirely, `unshare` runs `$SHELL`.
  UnshareCmd arg(String value) => token(value);
}

/// `unshare`, ready to take its namespace selection.
// ignore: non_constant_identifier_names
UnshareCmd get Unshare => UnshareCmd();
