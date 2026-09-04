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

/// `fdisk`, the util-linux partition table editor. Linux only, and squarely
/// interactive: with a device and no [list]-family flag it drops into a prompt
/// reading commands from stdin, which is not something a script wants to meet
/// by accident.
///
/// ```dart
/// final ShellResult table = await Fdisk.listDetails().device('/dev/sda').asRoot().output();
/// final ShellResult sectors = await Fdisk.getSize().device('/dev/sda').output();
/// ```
///
/// [list] and [listDetails] are the two read-only, non-interactive modes worth
/// scripting; everything that writes a partition table wants the interactive
/// session, which this wrapper can start (`asRoot().execute()` with
/// `stdio` inherited) but not script a sequence of keystrokes into — for that,
/// `sfdisk` reads a script on stdin instead. Every device this wrapper's
/// commands can see or change needs root unless the caller already owns it,
/// which is essentially never for a raw block device.
class FdiskCmd extends CommandBuilder<FdiskCmd> {
  @override
  final String executable = 'fdisk';

  /// Sets the logical sector size to assume: 512, 1024, 2048 or 4096 (`-b`, `--sector-size`).
  FdiskCmd sectorSize(int bytes) => pair('--sector-size', '$bytes');

  /// Leaves the first disk sector alone when creating a new label, instead of zeroing it (`-B`, `--protect-boot`).
  FdiskCmd protectBoot() => token('--protect-boot');

  /// Sets compatibility mode: `dos` or `nondos`, the default (`-c`, `--compatibility`).
  FdiskCmd compatibility([String? mode]) => mode == null ? token('--compatibility') : joined('--compatibility', mode);

  /// Colourises the output: `auto`, `never` or `always` (`-L`, `--color`).
  FdiskCmd color([String? when]) => when == null ? token('--color') : joined('--color', when);

  /// Prints the partition table of every device named, then exits (`-l`, `--list`).
  ///
  /// Read-only and non-interactive: the mode this wrapper is actually meant to script.
  FdiskCmd list() => token('--list');

  /// Like [list], with wider, more detailed columns (`-x`, `--list-details`).
  FdiskCmd listDetails() => token('--list-details');

  /// Takes the BSD lock before opening the device: `yes`, `no` or `nonblock` (`--lock`).
  FdiskCmd lock([String? mode]) => mode == null ? token('--lock') : joined('--lock', mode);

  /// Skips creating a default partition table on an empty device (`-n`, `--noauto-pt`).
  FdiskCmd noAutoPt() => token('--noauto-pt');

  /// Selects the columns [list]/[listDetails] print, comma separated (`-o`, `--output`).
  ///
  /// Named for the flag it wraps, not the runner: `CommandBuilder.output()` is
  /// what actually runs the command.
  FdiskCmd outputColumns(List<String> columns) => joinedAll('--output', columns);

  /// Prints sizes in bytes rather than a human-readable unit (`--bytes`).
  FdiskCmd bytes() => token('--bytes');

  /// Prints each given device's size in 512-byte sectors, then exits (`-s`, `--getsz`).
  FdiskCmd getSize() => token('--getsz');

  /// Enables support for only this disklabel type: `dos`, `gpt`, `sun`, `sgi`, `bsd` (`-t`, `--type`).
  FdiskCmd type(String value) => pair('--type', value);

  /// Shows sizes in `sectors` or `cylinders` instead of the default (`-u`, `--units`).
  FdiskCmd units([String? unit]) => unit == null ? token('--units') : joined('--units', unit);

  /// Sets the number of cylinders to assume, overriding what the kernel reports (`-C`, `--cylinders`).
  FdiskCmd cylinders(int count) => pair('--cylinders', '$count');

  /// Sets the number of heads to assume (`-H`, `--heads`).
  FdiskCmd heads(int count) => pair('--heads', '$count');

  /// Sets the number of sectors per track to assume (`-S`, `--sectors`).
  FdiskCmd sectors(int count) => pair('--sectors', '$count');

  /// Wipes filesystem/RAID/partition-table signatures before creating a new label: `auto`, `never`, `always` (`-w`, `--wipe`).
  FdiskCmd wipe(String when) => pair('--wipe', when);

  /// Wipes signatures from newly created partitions the same way (`-W`, `--wipe-partitions`).
  FdiskCmd wipePartitions(String when) => pair('--wipe-partitions', when);

  /// Prints the usage summary (`-h`, `--help`).
  FdiskCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  FdiskCmd version() => token('--version');

  /// Adds the device path to read or edit. Repeatable under [list]/[listDetails]; a single interactive session takes only one.
  FdiskCmd device(String path) => token(path);
}

/// `fdisk`, ready to take its first option.
// ignore: non_constant_identifier_names
FdiskCmd get Fdisk => FdiskCmd();
