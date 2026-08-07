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
