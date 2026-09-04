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

/// `fsutil`, the low-level FAT/NTFS file-system toolbox: reparse points,
/// sparse files, hard links, disk quotas, the USN change journal, volume
/// dismount, and more. Windows only, and needs an elevated
/// (Administrators-group) prompt.
///
/// ```dart
/// final ShellResult free = await Fsutil.volume().arg('diskfree').arg('C:').output();
///
/// await Fsutil.dirty().arg('set').arg('D:').asRoot().execute();
/// ```
///
/// Microsoft's own documentation calls this "a powerful command" meant for
/// "advanced users with a thorough understanding of Windows operating
/// systems" — it is a maintenance tool, not one with guard rails.
/// `fsutil volume dismount` forces a volume offline out from under whatever
/// has it open; `fsutil file setzerodata`/`setvaliddata` rewrite file
/// content and length directly; `fsutil usn deletejournal` destroys a
/// volume's change-tracking history. None of that is undoable from here.
///
/// Every command below names one of `fsutil`'s subcommand groups, verified
/// against Microsoft's own reference (`8dot3name`, `clfs`, `devdrv`, `dirty`,
/// `file`, `fsinfo`, `hardlink`, `objectid`, `quota`, `repair`,
/// `reparsepoint`, `resource`, `sparse`, `tiering`, `transaction`, `usn`,
/// `volume`, `wim`). Each group has its own further verbs and options —
/// `fsutil <group> help` prints them — so pass those, in order, through
/// [arg]; this class stops at naming the group correctly rather than
/// guessing at leaf syntax this wrapper hasn't verified against every
/// group's own `help` output.
class FsutilCmd extends CommandBuilder<FsutilCmd> {
  @override
  final String executable = 'fsutil';

  /// Short-file-name (`FILENAME~1.TXT`) generation behavior (`8dot3name`).
  FsutilCmd eightDotThreeName() => token('8dot3name');

  /// Common Log File System (CLFS) log-file authentication codes (`clfs`).
  FsutilCmd clfs() => token('clfs');

  /// Dev Drive management: the performance-tuned volume type for developer
  /// workloads, including its attached filter drivers (`devdrv`).
  FsutilCmd devDrv() => token('devdrv');

  /// A volume's dirty bit: whether `autochk` runs `chkdsk` on it at the next
  /// restart (`dirty`).
  FsutilCmd dirty() => token('dirty');

  /// Per-file operations: allocated ranges, short names, valid data length,
  /// zeroing data, creating a file of a given size, and id/name lookups
  /// (`file`).
  FsutilCmd file() => token('file');

  /// Drive and volume information: drive type, NTFS-specific details,
  /// file-system statistics (`fsinfo`).
  FsutilCmd fsInfo() => token('fsinfo');

  /// Hard links: listing the links to a file, or creating a new one
  /// (`hardlink`).
  FsutilCmd hardlink() => token('hardlink');

  /// Object identifiers, which Windows uses to track files and directories
  /// (`objectid`).
  FsutilCmd objectId() => token('objectid');

  /// Per-user NTFS disk quotas: hard and soft limits on network-based
  /// storage (`quota`).
  FsutilCmd quota() => token('quota');

  /// Self-healing NTFS: querying or setting whether the volume repairs
  /// corruption online without a full `chkdsk` (`repair`).
  FsutilCmd repair() => token('repair');

  /// Reparse points: the NTFS objects behind junctions, mount points and
  /// filter-driver markers — querying or deleting them (`reparsepoint`).
  FsutilCmd reparsePoint() => token('reparsepoint');

  /// Transactional Resource Managers: creating a secondary one, starting,
  /// stopping, inspecting or reconfiguring one (`resource`).
  FsutilCmd resource() => token('resource');

  /// Sparse files: regions of a file that read as zero without occupying
  /// disk space (`sparse`).
  FsutilCmd sparse() => token('sparse');

  /// Storage-tier management: setting or clearing tiering flags, listing
  /// tiers (`tiering`).
  FsutilCmd tiering() => token('tiering');

  /// NTFS transactions: committing, rolling back, or inspecting one
  /// (`transaction`).
  FsutilCmd transaction() => token('transaction');

  /// The USN change journal: the persistent log of every change made to
  /// files on a volume (`usn`).
  FsutilCmd usn() => token('usn');

  /// Volume-level operations: dismounting, free-space queries, and finding
  /// what file owns a given cluster (`volume`).
  FsutilCmd volume() => token('volume');

  /// WIM-backed files: discovering and managing files whose data lives in a
  /// mounted Windows image (`wim`).
  FsutilCmd wim() => token('wim');

  /// Adds a bare positional argument — the verb inside a subcommand group,
  /// a drive/volume/path, or a flag — in the order that group's own `help`
  /// output shows for the command you're building.
  FsutilCmd arg(String value) => token(value);
}

/// `fsutil`, ready to take its first subcommand group.
// ignore: non_constant_identifier_names
FsutilCmd get Fsutil => FsutilCmd();
