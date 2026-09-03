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

/// `mount`, the util-linux filesystem attacher. Present on macOS too under a
/// different, BSD-flavoured option set; this wrapper follows the Linux one, so
/// keep it off macOS.
///
/// ```dart
/// await Mount.types('nfs').options(['ro', 'soft']).arg('nas:/export').arg('/mnt/nas').asRoot().execute();
/// await Mount.bind().arg('/srv/data').arg('/var/www/data').asRoot().execute();
/// await Mount.mkdir().types('tmpfs').options(['size=64m', 'noexec', 'nosuid']).arg('tmpfs').arg('/run/build').asRoot().execute();
/// ```
///
/// Called with no device and no directory, `mount` just lists what is already
/// mounted, reading `/proc/self/mountinfo` — the safe, unprivileged form worth
/// reaching for before assuming a filesystem needs attaching at all.
///
/// [bind], [rbind] and [move] take a source and a target the way a plain mount
/// takes a device and a directory, but none of them formats or checks
/// anything; they only rewire the mount table.
///
/// [options] wraps the generic, filesystem-independent `-o` sub-options —
/// `ro`, `rw`, `noexec`, `nosuid`, `nodev`, `noatime`, `relatime`, `sync`,
/// `remount`, `defaults` and the rest — as one comma-separated argument, the
/// same shape [testOpts] takes to check them against `-a` without mounting
/// anything. Filesystem-specific sub-options (`size=` for `tmpfs`, `vers=` for
/// NFS, and so on) go through the same method; there is no closed list to
/// enumerate them against.
///
/// Almost everything that changes the mount table wants `asRoot()`.
class MountCmd extends CommandBuilder<MountCmd> {
  @override
  final String executable = 'mount';

  /// Mounts every filesystem listed in `/etc/fstab` that is not already
  /// mounted and not flagged `noauto` (`-a`, `--all`).
  MountCmd all() => token('--all');

  /// Mounts beneath the target's current top mount instead of on top of it,
  /// so the original can be unmounted independently later (`--beneath`).
  MountCmd beneath() => token('--beneath');

  /// Remounts a subtree elsewhere, the long form of [bind] (`-B`, `--bind`).
  MountCmd bind() => token('--bind');

  /// Skips canonicalizing paths (resolving symlinks, `..`) before mounting
  /// (`-c`, `--no-canonicalize`).
  MountCmd noCanonicalize() => token('--no-canonicalize');

  /// Requires the filesystem be mounted as a unique instance, refusing to
  /// reuse an existing superblock (`--exclusive`).
  MountCmd exclusive() => token('--exclusive');

  /// Forks a child process per device under [all], so a slow or hanging mount
  /// does not block the rest (`-F`, `--fork`).
  MountCmd fork() => token('--fork');

  /// Does everything but the actual `mount(2)` call, for a dry run (`-f`,
  /// `--fake`).
  MountCmd fake() => token('--fake');

  /// Uses only libmount's internal parser, skipping the `/sbin/mount.<type>`
  /// helper for the filesystem (`-i`, `--internal-only`).
  MountCmd internalOnly() => token('--internal-only');

  /// Mounts the partition carrying this label (`-L`, `--label`).
  MountCmd label(String value) => pair('--label', value);

  /// Adds the mount labels to the listing (`-l`, `--show-labels`).
  MountCmd showLabels() => token('--show-labels');

  /// Moves an already-mounted tree to a new mount point instead of unmounting
  /// and remounting it (`-M`, `--move`).
  MountCmd move() => token('--move');

  /// Creates the target directory first if it does not exist (`-m`,
  /// `--mkdir`).
  MountCmd mkdir() => token('--mkdir');

  /// Adds a group ID mapping for an idmapped mount, `first-id last-id count`
  /// or `@userns-fd` (`--map-groups`).
  MountCmd mapGroups(String mapping) => pair('--map-groups', mapping);

  /// Adds a user ID mapping for an idmapped mount, the same shape as
  /// [mapGroups] (`--map-users`).
  MountCmd mapUsers(String mapping) => pair('--map-users', mapping);

  /// Mounts without writing an entry to the mount table (`-n`, `--no-mtab`).
  ///
  /// Needed when `/etc/mtab` is not writable yet, such as mounting the root
  /// filesystem read-write during early boot.
  MountCmd noMtab() => token('--no-mtab');

  /// Performs the mount inside this mount namespace instead of the caller's
  /// own (`-N`, `--namespace`).
  MountCmd namespace(String value) => pair('--namespace', value);

  /// Under [all], only mounts filesystems whose fstab options match this
  /// comma-separated list (`-O`, `--test-opts`).
  MountCmd testOpts(List<String> opts) => joinedAll('--test-opts', opts);

  /// Mount options, comma separated: `ro`, `noexec`, `nosuid`, filesystem-
  /// specific ones (`-o`, `--options`).
  MountCmd options(List<String> opts) => joinedAll('--options', opts);

  /// Checks whether the target is already mounted at the given mount point
  /// before mounting again (`--onlyonce`).
  MountCmd onlyOnce() => token('--onlyonce');

  /// Controls how command-line [options] combine with the ones already in
  /// fstab: `ignore`, `append`, `prepend`, `replace` (`--options-mode`).
  MountCmd optionsMode(String value) => joined('--options-mode', value);

  /// Where the default mount options come from when none are given on the
  /// command line: `fstab`, `mtab`, `disable` (`--options-source`).
  MountCmd optionsSource(String value) => joined('--options-source', value);

  /// Uses the fstab options even when both a device and a directory are given
  /// on the command line (`--options-source-force`).
  MountCmd optionsSourceForce() => token('--options-source-force');

  /// Remounts a subtree and all of its submounts elsewhere, the recursive
  /// form of [bind] (`-R`, `--rbind`).
  MountCmd rbind() => token('--rbind');

  /// Mounts read-only (`-r`, `--ro`, `--read-only`).
  MountCmd readOnly() => token('--read-only');

  /// Tolerates mount options the filesystem does not understand instead of
  /// failing on them (`-s`).
  MountCmd sloppy() => token('-s');

  /// States explicitly that the following bare argument is the source rather
  /// than letting `mount` guess (`--source`).
  MountCmd source(String device) => pair('--source', device);

  /// States explicitly that the following bare argument is the target
  /// (`--target`).
  MountCmd target(String directory) => pair('--target', directory);

  /// Prepends this directory to every mount target under [all] (`--target-
  /// prefix`).
  MountCmd targetPrefix(String directory) => pair('--target-prefix', directory);

  /// Reads the mount table from this file instead of `/etc/fstab` (`-T`,
  /// `--fstab`).
  MountCmd fstab(String path) => pair('--fstab', path);

  /// The filesystem type, or a comma-separated list to try in order (`-t`,
  /// `--types`).
  MountCmd types(String value) => pair('--types', value);

  /// Mounts the partition carrying this UUID (`-U`, `--uuid`).
  MountCmd uuid(String value) => pair('--uuid', value);

  /// Talks more about what it is doing (`-v`, `--verbose`).
  MountCmd verbose() => token('--verbose');

  /// Mounts read-write, the default (`-w`, `--rw`, `--read-write`).
  MountCmd readWrite() => token('--read-write');

  /// Makes a shared mount, or a whole subtree of them: further mounts on
  /// either side propagate to the other (`--make-shared`).
  MountCmd makeShared() => token('--make-shared');

  /// Makes a private mount, the opposite of [makeShared] (`--make-private`).
  MountCmd makePrivate() => token('--make-private');

  /// Makes a slave mount: it receives propagation but does not send it back
  /// (`--make-slave`).
  MountCmd makeSlave() => token('--make-slave');

  /// Makes an unbindable mount: it cannot be the source of a [bind] at all
  /// (`--make-unbindable`).
  MountCmd makeUnbindable() => token('--make-unbindable');

  /// Adds a device, a directory, or a bare argument (a source, a target, a
  /// label such as `LABEL=root`, a UUID such as `UUID=...`).
  MountCmd arg(String value) => token(value);

  /// Prints the usage summary (`-h`, `--help`).
  MountCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  MountCmd version() => token('--version');
}

/// `mount`, ready to take its first option.
// ignore: non_constant_identifier_names
MountCmd get Mount => MountCmd();
