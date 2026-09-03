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

/// `df`, reporting free space on mounted filesystems. On every Unix.
///
/// ```dart
/// final ShellResult usage = await Df.humanReadable().path('/').output();
/// ```
///
/// [humanReadable] scales by 1024 on both flavours, matching the `Ki`/`Mi`/`Gi`
/// units `du` also uses; [siUnits] scales by 1000 on both instead. Column
/// layout is the other trap: GNU df and BSD df do not print the same columns
/// in the same order, so a script parsing the output has to pick one flavour
/// to trust, or pass [portable] and parse the POSIX-mandated layout instead.
///
/// **`-T` and `-t` swap meaning between the flavours**, the same kind of trap
/// as `sed`'s `-i`. BSD spells "restrict to these filesystem types" as `-T`
/// and "add a type column" as `-Y`; GNU spells the same two operations `-t`
/// and `-T` respectively. [typeBsd]/[typeGnu] and
/// [printTypeColumnBsd]/[printTypeColumnGnu] keep the four apart rather than
/// guessing which platform is running.
class DfCmd extends CommandBuilder<DfCmd> {
  @override
  final String executable = 'df';

  /// Generates output through `libxo`, in a chosen human or machine format (`--libxo`). BSD only.
  DfCmd libxo() => token('--libxo');

  /// Shows every mount point, pseudo and inaccessible filesystems included (`-a`, `--all`).
  DfCmd all() => token('-a');

  /// Uses 512-byte blocks explicitly, the same as [portable] (`-b`). BSD only.
  DfCmd blocks512() => token('-b');

  /// Scales sizes by an explicit unit, e.g. `1M` (`-B`, `--block-size`). GNU only.
  DfCmd blockSize(String size) => joined('--block-size', size);

  /// Prints a grand total line at the end (`-c`). BSD only; see [total] for the GNU equivalent.
  DfCmd grandTotalBsd() => token('-c');

  /// Elides insignificant entries and prints a grand total (`--total`). GNU only.
  DfCmd total() => token('--total');

  /// Uses 1 GiB blocks rather than the default (`-g`). BSD only.
  DfCmd gibibyteBlocks() => token('-g');

  /// Scales sizes to a human-readable unit, `Ki`/`Mi`/`Gi`, powers of 1024 (`-h`, `--human-readable`).
  DfCmd humanReadable() => token('-h');

  /// Scales sizes to a human-readable unit, powers of 1000 (`-H`, `--si`).
  DfCmd siUnits() => token('-H');

  /// Suppresses inode counts, which are printed by default (`-I`). BSD only; see [inodes] for the opt-in GNU form.
  DfCmd suppressInodeCounts() => token('-I');

  /// Adds free and used inode counts to the output (`-i`, `--inodes`).
  DfCmd inodes() => token('-i');

  /// Uses 1 KiB blocks rather than the default (`-k`).
  DfCmd kilobyteBlocks() => token('-k');

  /// Restricts the listing to locally-mounted filesystems, network mounts excluded (`-l`, `--local`).
  DfCmd local() => token('-l');

  /// Uses 1 MiB blocks rather than the default (`-m`). BSD only.
  DfCmd mebibyteBlocks() => token('-m');

  /// Reports previously-collected statistics instead of asking each filesystem again (`-n`). BSD only.
  ///
  /// Useful when a filesystem might otherwise stall the call for a long time.
  DfCmd cached() => token('-n');

  /// Skips the `sync` call normally made before reading usage, the default (`--no-sync`). GNU only.
  DfCmd noSync() => token('--no-sync');

  /// Calls `sync` before reading usage (`--sync`). GNU only.
  DfCmd sync() => token('--sync');

  /// Chooses the output columns explicitly, comma-separated (`--output`). GNU only.
  DfCmd outputFields(String fields) => joined('--output', fields);

  /// Uses the POSIX output format, one predictable column layout (`-P`, `--portability`).
  DfCmd portable() => token('-P');

  /// Restricts the listing to these filesystem types, comma-separated and optionally `no`-prefixed (`-T`). BSD only; see [typeGnu].
  DfCmd typeBsd(String types) => pair('-T', types);

  /// Restricts the listing to this filesystem type (`-t`, `--type`). Repeatable. GNU only; see [typeBsd].
  DfCmd typeGnu(String type) => pair('-t', type);

  /// Excludes this filesystem type from the listing (`-x`, `--exclude-type`). Repeatable. GNU only.
  DfCmd excludeType(String type) => pair('-x', type);

  /// Adds a filesystem type column to the output (`-Y`). BSD only; see [printTypeColumnGnu].
  DfCmd printTypeColumnBsd() => token('-Y');

  /// Adds a filesystem type column to the output (`-T`, `--print-type`). GNU only; see [printTypeColumnBsd].
  DfCmd printTypeColumnGnu() => token('-T');

  /// Groups digits with the locale's thousands separator (`-,`). BSD only.
  DfCmd commaGrouping() => token('-,');

  /// Ignored, accepted only for compatibility (`-v`). GNU only.
  DfCmd verboseIgnored() => token('-v');

  /// Prints the usage summary (`--help`). GNU only.
  DfCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  DfCmd version() => token('--version');

  /// Adds a path or mounted device to report on. Without one, reports on everything mounted.
  DfCmd path(String value) => token(value);
}

/// `df`, ready to take its first option.
// ignore: non_constant_identifier_names
DfCmd get Df => DfCmd();
