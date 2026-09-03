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

/// `lsblk`, the util-linux block device lister. Linux only: it walks `sysfs`
/// under `/sys/block`, which has no equivalent elsewhere.
///
/// ```dart
/// final ShellResult disks = await Lsblk.json().fs().paths().output();
/// final ShellResult table = await Lsblk.pairs().outputColumns(['NAME', 'SIZE', 'MOUNTPOINT']).output();
/// ```
///
/// The default columns and their widths are not guaranteed across versions;
/// [json] and [pairs] are the two shapes meant to be parsed, [json] being the
/// one worth reaching for first. [nodeps] is the flag that turns a tree walk
/// into one row per device, which matters when the output is fed into
/// something that expects a flat list.
///
/// [outputColumns] wraps `-o`/`--output`, which this class cannot call
/// `output` — that name belongs to [CommandBuilder.output], the runner that
/// captures the result.
///
/// Reading needs no privilege; nothing here changes the system.
class LsblkCmd extends CommandBuilder<LsblkCmd> {
  @override
  final String executable = 'lsblk';

  /// Hides empty devices (`-A`, `--noempty`).
  LsblkCmd noEmpty() => token('--noempty');

  /// Disables every built-in filter, listing empty and RAM disk devices too
  /// (`-a`, `--all`).
  LsblkCmd all() => token('--all');

  /// Sizes in bytes rather than a human-readable unit (`-b`, `--bytes`).
  LsblkCmd bytes() => token('--bytes');

  /// Lists the available output columns instead of device data (`-H`,
  /// `--list-columns`).
  LsblkCmd listColumns() => token('--list-columns');

  /// Prints discard capability columns: TRIM, UNMAP support (`-D`,
  /// `--discard`).
  LsblkCmd discard() => token('--discard');

  /// Lists only the devices named on the command line, not their holders or
  /// slaves (`-d`, `--nodeps`).
  LsblkCmd nodeps() => token('--nodeps');

  /// De-duplicates the tree using this column as the key, collapsing devices
  /// that share it (`-E`, `--dedup`).
  LsblkCmd dedup(String column) => pair('--dedup', column);

  /// Skips devices whose major number is in this comma-separated list
  /// (`-e`, `--exclude`). Defaults to excluding RAM disks and loop devices.
  LsblkCmd exclude(List<String> majors) => joinedAll('--exclude', majors);

  /// Prints filesystem information: type, label, UUID, usage (`-f`, `--fs`).
  LsblkCmd fs() => token('--fs');

  /// Prints paths as terminal hyperlinks; [when] is `auto`, `never` or
  /// `always` (`--hyperlink`).
  LsblkCmd hyperlink([String? when]) => when == null ? token('--hyperlink') : joined('--hyperlink', when);

  /// Includes only devices whose major number is in this comma-separated list
  /// (`-I`, `--include`).
  LsblkCmd include(List<String> majors) => joinedAll('--include', majors);

  /// Draws the device tree with plain ASCII characters (`-i`, `--ascii`).
  LsblkCmd ascii() => token('--ascii');

  /// Renders the output as JSON (`-J`, `--json`).
  LsblkCmd json() => token('--json');

  /// Prints one line per device instead of a tree (`-l`, `--list`).
  LsblkCmd list() => token('--list');

  /// Merges a device tree that spans a RAID or device-mapper node into one
  /// entry (`-M`, `--merge`).
  LsblkCmd merge() => token('--merge');

  /// Prints owner, group and mode columns (`-m`, `--perms`).
  LsblkCmd perms() => token('--perms');

  /// Restricts the listing to NVMe devices (`-N`, `--nvme`).
  LsblkCmd nvme() => token('--nvme');

  /// Restricts the listing to virtio devices (`-v`, `--virtio`).
  LsblkCmd virtio() => token('--virtio');

  /// Drops the column header row (`-n`, `--noheadings`).
  LsblkCmd noHeadings() => token('--noheadings');

  /// Selects the columns to print, comma separated (`-o`, `--output`).
  ///
  /// Named for the flag it wraps, not the runner: `CommandBuilder.output()` is
  /// what actually runs the command.
  LsblkCmd outputColumns(List<String> columns) => joinedAll('--output', columns);

  /// Prints every column `lsblk` knows, ignoring [outputColumns] (`-O`,
  /// `--output-all`).
  LsblkCmd outputAll() => token('--output-all');

  /// Prints `KEY="value"` pairs, one line per device, the other parseable
  /// shape besides [json] (`-P`, `--pairs`).
  LsblkCmd pairs() => token('--pairs');

  /// Prints device paths under `/dev` instead of bare names (`-p`, `--paths`).
  LsblkCmd paths() => token('--paths');

  /// Prints only the devices matching this filter expression (`-Q`,
  /// `--filter`).
  LsblkCmd filter(String expression) => pair('--filter', expression);

  /// Colourises the lines matching this expression (`--highlight`).
  LsblkCmd highlight(String expression) => joined('--highlight', expression);

  /// Defines a custom counter as `name:expr`, printed in the summary
  /// (`--ct`). Repeatable.
  LsblkCmd ct(String value) => joined('--ct', value);

  /// Restricts the next [ct] counter to rows matching this expression
  /// (`--ct-filter`).
  LsblkCmd ctFilter(String expression) => joined('--ct-filter', expression);

  /// Prints raw, unaligned, unquoted fields (`-r`, `--raw`).
  LsblkCmd raw() => token('--raw');

  /// Limits the listing to SCSI devices (`-S`, `--scsi`).
  LsblkCmd scsi() => token('--scsi');

  /// Prints dependencies in inverse order, children before parents (`-s`,
  /// `--inverse`).
  LsblkCmd inverse() => token('--inverse');

  /// Forces the tree-like output format (`-T`, `--tree`).
  LsblkCmd tree() => token('--tree');

  /// Prints block-device topology information: alignment, I/O sizes (`-t`,
  /// `--topology`).
  LsblkCmd topology() => token('--topology');

  /// The output width in characters; `0` means as wide as needed (`-w`,
  /// `--width`).
  LsblkCmd width(int columns) => pair('--width', '$columns');

  /// Sorts the output by this column (`-x`, `--sort`).
  LsblkCmd sort(String column) => pair('--sort', column);

  /// Rewrites column names to be valid shell variable identifiers, for
  /// `eval`-ing [pairs] output (`-y`, `--shell`).
  LsblkCmd shell() => token('--shell');

  /// Prints zone model information for zoned block devices (`-z`, `--zoned`).
  LsblkCmd zoned() => token('--zoned');

  /// Gathers device data for the Linux instance mounted at [path] instead of
  /// the running system (`--sysroot`).
  LsblkCmd sysroot(String path) => joined('--sysroot', path);

  /// The methods used to gather filesystem and partition table info, comma
  /// separated: `udev`, `blkid`, `stat` (`--properties-by`).
  LsblkCmd propertiesBy(List<String> methods) => joinedAll('--properties-by', methods);

  /// Adds an annotation to each column header, `column:annotation`
  /// (`--annotate`).
  LsblkCmd annotate(String value) => joined('--annotate', value);

  /// Adds a device name to restrict the listing to. Repeatable.
  LsblkCmd device(String path) => token(path);

  /// Prints the usage summary (`-h`, `--help`).
  LsblkCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  LsblkCmd version() => token('--version');
}

/// `lsblk`, ready to take its first option.
// ignore: non_constant_identifier_names
LsblkCmd get Lsblk => LsblkCmd();
