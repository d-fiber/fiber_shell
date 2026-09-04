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

/// `nsenter`, the util-linux tool that runs a program inside the namespaces of
/// another, already-running process. Linux only: namespaces are a Linux kernel
/// feature, and this is how `docker exec` and friends are built on top of.
///
/// ```dart
/// final ShellResult inside = await Nsenter.target(1234).mount().net().arg('cat').arg('/etc/resolv.conf').output();
/// final ShellResult shell = await Nsenter.target(containerPid).all().asRoot().execute();
/// ```
///
/// [target] names the process to borrow namespaces from; every namespace flag
/// ([mount], [uts], [ipc], [net], [pid], [user], [cgroup], [time]) can instead
/// take a bare namespace file (`/proc/PID/ns/net`, or a path from `ip netns`)
/// so no live process needs to still be running. Entering a [pid] namespace
/// without [noFork] forks a child that becomes PID 1 of the target's PID
/// namespace's *view*, not the caller's — that fork is what makes `wait()`
/// and signals behave the way a script expects; [noFork] execs in place
/// instead, which some callers need for correct signal delivery but which
/// changes that behaviour. Almost every real target belongs to another user or a
/// container runtime, so this wants `asRoot()`.
class NsenterCmd extends CommandBuilder<NsenterCmd> {
  @override
  final String executable = 'nsenter';

  /// Enters every namespace of the target process, at the default `/proc/<pid>/ns/*` paths (`-a`, `--all`).
  NsenterCmd all() => token('--all');

  /// Enters the mount namespace; pass a namespace file or `:nsid` to pick one directly instead of [target]'s (`-m`, `--mount`).
  NsenterCmd mount([String? fileOrNsid]) => fileOrNsid == null ? token('--mount') : joined('--mount', fileOrNsid);

  /// Enters the UTS namespace (hostname, domain name) (`-u`, `--uts`).
  NsenterCmd uts([String? fileOrNsid]) => fileOrNsid == null ? token('--uts') : joined('--uts', fileOrNsid);

  /// Enters the IPC namespace (System V IPC, POSIX message queues) (`-i`, `--ipc`).
  NsenterCmd ipc([String? fileOrNsid]) => fileOrNsid == null ? token('--ipc') : joined('--ipc', fileOrNsid);

  /// Enters the network namespace (`-n`, `--net`).
  NsenterCmd net([String? fileOrNsid]) => fileOrNsid == null ? token('--net') : joined('--net', fileOrNsid);

  /// Enters the network namespace of the process that owns this open socket file descriptor (`-N`, `--net-socket`).
  NsenterCmd netSocket(int fd) => pair('--net-socket', '$fd');

  /// Enters the PID namespace; the new process only sees processes inside it, but forks unless [noFork] blocks that (`-p`, `--pid`).
  NsenterCmd pid([String? fileOrNsid]) => fileOrNsid == null ? token('--pid') : joined('--pid', fileOrNsid);

  /// Enters the user namespace (UID/GID mapping) (`-U`, `--user`).
  NsenterCmd user([String? fileOrNsid]) => fileOrNsid == null ? token('--user') : joined('--user', fileOrNsid);

  /// Enters the parent of the target's user namespace instead of its own (`--user-parent`).
  NsenterCmd userParent() => token('--user-parent');

  /// Enters the cgroup namespace (`-C`, `--cgroup`).
  NsenterCmd cgroup([String? fileOrNsid]) => fileOrNsid == null ? token('--cgroup') : joined('--cgroup', fileOrNsid);

  /// Enters the time namespace (`-T`, `--time`).
  NsenterCmd time([String? fileOrNsid]) => fileOrNsid == null ? token('--time') : joined('--time', fileOrNsid);

  /// The process whose namespaces to enter, `PID[:inode]` (`-t`, `--target`).
  NsenterCmd target(int pid) => pair('--target', '$pid');

  /// Sets the UID inside the entered namespace; defaults to 0 when [target] gives no hint (`-S`, `--setuid`).
  NsenterCmd setuid(int uid) => pair('--setuid', '$uid');

  /// Sets the GID inside the entered namespace (`-G`, `--setgid`).
  NsenterCmd setgid(int gid) => pair('--setgid', '$gid');

  /// Keeps capabilities across entering a user namespace, instead of dropping them (`--keep-caps`).
  NsenterCmd keepCaps() => token('--keep-caps');

  /// Skips resetting the UID/GID/capabilities when entering a user namespace (`--preserve-credentials`).
  NsenterCmd preserveCredentials() => token('--preserve-credentials');

  /// Sets the root directory of the new process, opened before switching namespaces (`-r`, `--root`).
  NsenterCmd root([String? directory]) => directory == null ? token('--root') : joined('--root', directory);

  /// Sets the working directory, opened before switching namespaces (`-w`, `--wd`).
  NsenterCmd workingDirectory([String? directory]) => directory == null ? token('--wd') : joined('--wd', directory);

  /// Sets the working directory, opened after switching namespaces — needed when the path only exists inside the target's mount namespace (`-W`, `--wdns`).
  NsenterCmd workingDirectoryAfterSwitch([String? directory]) =>
      directory == null ? token('--wdns') : joined('--wdns', directory);

  /// Copies environment variables from the target process into the new one (`-e`, `--env`).
  NsenterCmd env() => token('--env');

  /// Execs the program directly instead of forking a child first (`-F`, `--no-fork`).
  ///
  /// Without it, entering a [pid] namespace runs the program as a child so it
  /// becomes PID 1 there; with it, `nsenter` itself is replaced, which some
  /// callers need for correct signal delivery.
  NsenterCmd noFork() => token('--no-fork');

  /// Sets the SELinux security context used for exec (`-Z`, `--follow-context`).
  NsenterCmd followContext() => token('--follow-context');

  /// Adds the process to the target's cgroup before running it (`-c`, `--join-cgroup`).
  NsenterCmd joinCgroup() => token('--join-cgroup');

  /// Prints the usage summary (`-h`, `--help`).
  NsenterCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  NsenterCmd version() => token('--version');

  /// Adds one token of the command to run once the namespaces are entered.
  ///
  /// Left out entirely, `nsenter` runs `$SHELL`.
  NsenterCmd arg(String value) => token(value);
}

/// `nsenter`, ready to take its target and namespace selection.
// ignore: non_constant_identifier_names
NsenterCmd get Nsenter => NsenterCmd();
