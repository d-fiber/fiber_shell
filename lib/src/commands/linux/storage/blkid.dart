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

/// `blkid`, the util-linux block device identifier. Linux only: it reads the
/// same on-disk superblock signatures `lsblk --fs` gets from `udev`, but talks
/// to the devices directly.
///
/// ```dart
/// final ShellResult tags = await Blkid.outputFormat('export').device('/dev/sda1').output();
/// final ShellResult root = await Blkid.matchToken('LABEL=root').matchTag('UUID').output();
/// ```
///
/// Two modes live in one binary. With no [probe], `blkid` answers from its
/// cache (`/run/blkid/blkid.cache`), which can be stale right after a format or
/// a `wipefs`; [probe] bypasses the cache and reads the device directly, at the
/// cost of needing the device to exist and be readable. [outputFormat] wraps
/// `-o`/`--output`, not [CommandBuilder.output], the runner that captures the
/// result — `export` is the shape worth parsing, one `KEY=value` per line.
///
/// Reading needs no privilege on a device the caller can already open; nothing
/// here changes the system except [garbageCollect], which prunes the cache
/// file and wants root when that file is owned by root.
class BlkidCmd extends CommandBuilder<BlkidCmd> {
  @override
  final String executable = 'blkid';

  /// Reads from this cache file instead of the default (`-c`, `--cache-file`).
  BlkidCmd cacheFile(String path) => pair('--cache-file', path);

  /// Leaves non-printing characters unescaped in the output (`-d`, `--no-encoding`).
  BlkidCmd noEncoding() => token('--no-encoding');

  /// Drops `PART_ENTRY_*` partition-table tags from [probe] output (`-D`, `--no-part-details`).
  BlkidCmd noPartDetails() => token('--no-part-details');

  /// Removes cache entries for devices that no longer exist (`-g`, `--garbage-collect`).
  BlkidCmd garbageCollect() => token('--garbage-collect');

  /// Gives the probing functions a hint, `name=value` (`-H`, `--hint`).
  BlkidCmd hint(String value) => pair('--hint', value);

  /// Prints I/O limits (topology) instead of tags (`-i`, `--info`).
  BlkidCmd info() => token('--info');

  /// Lists the filesystem and RAID types this build recognises, then exits (`-k`, `--list-filesystems`).
  BlkidCmd listFilesystems() => token('--list-filesystems');

  /// Stops at the first device that matches, instead of listing every one (`-l`, `--list-one`).
  BlkidCmd listOne() => token('--list-one');

  /// Looks up the device carrying this filesystem label (`-L`, `--label`).
  BlkidCmd label(String value) => pair('--label', value);

  /// Restricts probing to this comma-separated list of superblock types (`-n`, `--match-types`).
  BlkidCmd matchTypes(List<String> types) => joinedAll('--match-types', types);

  /// Selects the output shape: `full`, `value`, `list`, `device`, `udev`, `export`, `json` (`-o`, `--output`).
  ///
  /// Named for the flag it wraps, not the runner: `CommandBuilder.output()` is
  /// what actually runs the command.
  BlkidCmd outputFormat(String format) => pair('--output', format);

  /// Probes at this byte offset; only meaningful with [probe] (`-O`, `--offset`).
  BlkidCmd offset(int bytes) => pair('--offset', '$bytes');

  /// Switches to low-level superblock probing, bypassing the cache (`-p`, `--probe`).
  BlkidCmd probe() => token('--probe');

  /// Shows only the tags matching this name, for every device (`-s`, `--match-tag`).
  BlkidCmd matchTag(String tag) => pair('--match-tag', tag);

  /// Overrides the device or file size; only meaningful with [probe] (`-S`, `--size`).
  BlkidCmd size(int bytes) => pair('--size', '$bytes');

  /// Searches for a device carrying this `NAME=value` token (`-t`, `--match-token`).
  BlkidCmd matchToken(String nameValue) => pair('--match-token', nameValue);

  /// Restricts probing to this comma-separated list of usage types: `filesystem`, `raid`, `crypto` (`-u`, `--usages`).
  BlkidCmd usages(List<String> types) => joinedAll('--usages', types);

  /// Looks up the device carrying this filesystem UUID (`-U`, `--uuid`).
  BlkidCmd uuid(String value) => pair('--uuid', value);

  /// Prints the usage summary (`-h`, `--help`).
  BlkidCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  BlkidCmd version() => token('--version');

  /// Adds a device path to restrict the listing to. Repeatable; omitted entirely, `blkid` walks every device it knows.
  BlkidCmd device(String path) => token(path);
}

/// `blkid`, ready to take its first option.
// ignore: non_constant_identifier_names
BlkidCmd get Blkid => BlkidCmd();
