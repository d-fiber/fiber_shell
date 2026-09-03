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

/// `diskutil`, the disk and volume tool. macOS only.
///
/// ```dart
/// final ShellResult volumes = await Diskutil.list().plist().output();
/// ```
///
/// [plist] on any of the reading verbs is what makes this scriptable: the plain
/// output is a tree drawn for a person, and it changes between releases.
/// [PlutilCmd] turns the result into JSON.
///
/// **Half the verbs here destroy data**, and they do it without asking:
/// [eraseDisk], [eraseVolume], [partitionDisk], [zeroDisk] and [secureErase]
/// take a device identifier and get on with it. Check what `disk4` is today
/// before writing it into a script, because it will not be the same disk
/// tomorrow.
///
/// Anything beyond reading wants `asRoot()`.
class DiskutilCmd extends CommandBuilder<DiskutilCmd> {
  @override
  final String executable = 'diskutil';

  /// Says less (`quiet`). Comes before the verb.
  DiskutilCmd quiet() => token('quiet');

  /// Lists the disks and their partitions (`list`).
  DiskutilCmd list() => token('list');

  /// Prints everything about a disk or a volume (`info`).
  DiskutilCmd info() => token('info');

  /// Lists the filesystems available for formatting (`listFilesystems`).
  DiskutilCmd listFilesystems() => token('listFilesystems');

  /// Lists the processes holding a disk management session (`listClients`).
  DiskutilCmd listClients() => token('listClients');

  /// Streams the disk arbitration events (`activity`).
  DiskutilCmd activity() => token('activity');

  /// Unmounts one volume (`unmount`).
  DiskutilCmd unmount() => token('unmount');

  /// Unmounts every volume of a disk (`unmountDisk`).
  DiskutilCmd unmountDisk() => token('unmountDisk');

  /// Ejects the disk (`eject`).
  DiskutilCmd eject() => token('eject');

  /// Mounts one volume (`mount`).
  DiskutilCmd mount() => token('mount');

  /// Mounts every mountable volume of a disk (`mountDisk`).
  DiskutilCmd mountDisk() => token('mountDisk');

  /// Turns HFS+ journaling on (`enableJournal`).
  DiskutilCmd enableJournal() => token('enableJournal');

  /// Turns it off (`disableJournal`).
  DiskutilCmd disableJournal() => token('disableJournal');

  /// Honours the on-disk user and group ids (`enableOwnership`).
  DiskutilCmd enableOwnership() => token('enableOwnership');

  /// Ignores them (`disableOwnership`).
  DiskutilCmd disableOwnership() => token('disableOwnership');

  /// Renames a volume (`rename`).
  DiskutilCmd rename() => token('rename');

  /// Checks a filesystem (`verifyVolume`).
  DiskutilCmd verifyVolume() => token('verifyVolume');

  /// Repairs one (`repairVolume`).
  DiskutilCmd repairVolume() => token('repairVolume');

  /// Checks a partition map (`verifyDisk`).
  DiskutilCmd verifyDisk() => token('verifyDisk');

  /// Repairs one (`repairDisk`).
  DiskutilCmd repairDisk() => token('repairDisk');

  /// Erases a whole disk, volumes and all (`eraseDisk`).
  DiskutilCmd eraseDisk() => token('eraseDisk');

  /// Erases one volume (`eraseVolume`).
  DiskutilCmd eraseVolume() => token('eraseVolume');

  /// Erases a volume and puts back the same name and type (`reformat`).
  DiskutilCmd reformat() => token('reformat');

  /// Writes zeros over a whole disk (`zeroDisk`).
  DiskutilCmd zeroDisk() => token('zeroDisk');

  /// Writes random data over it (`randomDisk`).
  DiskutilCmd randomDisk() => token('randomDisk');

  /// Securely erases a disk or the free space of a volume (`secureErase`).
  DiskutilCmd secureErase() => token('secureErase');

  /// Repartitions a disk, removing everything on it (`partitionDisk`).
  DiskutilCmd partitionDisk() => token('partitionDisk');

  /// Creates a partition in the free space (`addPartition`).
  DiskutilCmd addPartition() => token('addPartition');

  /// Splits a partition in two (`splitPartition`).
  DiskutilCmd splitPartition() => token('splitPartition');

  /// Merges partitions into one (`mergePartitions`).
  DiskutilCmd mergePartitions() => token('mergePartitions');

  /// Grows or shrinks a volume (`resizeVolume`).
  DiskutilCmd resizeVolume() => token('resizeVolume');

  /// The APFS verbs, `list` and `addVolume` among them (`apfs`).
  DiskutilCmd apfs() => token('apfs');

  /// The AppleRAID verbs (`appleRAID`).
  DiskutilCmd appleRaid() => token('appleRAID');

  /// The CoreStorage verbs (`coreStorage`).
  DiskutilCmd coreStorage() => token('coreStorage');

  /// The disk image verbs (`image`).
  DiskutilCmd image() => token('image');

  /// Prints the result as a property list (`-plist`).
  DiskutilCmd plist() => token('-plist');

  /// Forces the operation through (`force`).
  DiskutilCmd force() => token('force');

  /// Adds a bare argument: a device identifier, a mount point, a volume name.
  DiskutilCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
DiskutilCmd get Diskutil => DiskutilCmd();
