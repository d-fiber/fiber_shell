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

/// `lscpu`, the util-linux CPU topology inspector. Linux only, since it reads
/// `sysfs` and `/proc/cpuinfo`.
///
/// ```dart
/// final ShellResult topology = await Lscpu.parse(columns: ['Core', 'Socket']).output();
/// final ShellResult everything = await Lscpu.json().extended().output();
/// ```
///
/// [parse] with `Core,Socket` is the format this ecosystem already leans on
/// for topology parsing: it is the one output shape `lscpu` promises never to
/// reorder or reword, where [extended] and the human-readable default are
/// both free to change between distributions.
class LscpuCmd extends CommandBuilder<LscpuCmd> {
  @override
  final String executable = 'lscpu';

  /// Includes both online and offline CPUs (`-a`, `--all`).
  LscpuCmd all() => token('--all');

  /// Limits the output to online CPUs, which is the default (`-b`, `--online`).
  LscpuCmd online() => token('--online');

  /// Limits the output to offline CPUs (`-c`, `--offline`).
  LscpuCmd offline() => token('--offline');

  /// Prints sizes in bytes rather than a human-readable unit (`-B`, `--bytes`).
  LscpuCmd bytes() => token('--bytes');

  /// Prints cache information (`-C`, `--caches`).
  ///
  /// With [columns], restricts the table to those column names; bare, it
  /// prints every cache column `lscpu` knows.
  LscpuCmd caches({List<String>? columns}) => columns == null ? token('--caches') : joinedAll('--caches', columns);

  /// Prints the parsable extended format (`-e`, `--extended`).
  ///
  /// With [columns], restricts the table to those column names; bare, it
  /// prints every extended column.
  LscpuCmd extended({List<String>? columns}) =>
      columns == null ? token('--extended') : joinedAll('--extended', columns);

  /// Renders the output as JSON (`-J`, `--json`).
  LscpuCmd json() => token('--json');

  /// Prints the legacy parsable format scripts have relied on since before
  /// [extended] existed (`-p`, `--parse`).
  ///
  /// With [columns], restricts the table to those column names, `Core,Socket`
  /// being the pair this ecosystem already reads; bare, it prints the
  /// default column set.
  LscpuCmd parse({List<String>? columns}) => columns == null ? token('--parse') : joinedAll('--parse', columns);

  /// Gathers CPU data for the Linux instance mounted at [path] instead of the
  /// running system, for inspecting another system's image (`-s`, `--sysroot`).
  LscpuCmd sysroot(String path) => joined('--sysroot', path);

  /// Prints CPU set masks as hexadecimal rather than as a list (`-x`, `--hex`).
  LscpuCmd hex() => token('--hex');

  /// Prints physical rather than logical IDs for topology elements (`-y`,
  /// `--physical`).
  LscpuCmd physical() => token('--physical');

  /// Outputs every available column, valid only alongside [extended], [parse]
  /// or [caches] (`--output-all`).
  LscpuCmd outputAll() => token('--output-all');

  /// Prints the usage summary (`-h`, `--help`).
  LscpuCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  LscpuCmd version() => token('--version');
}

/// `lscpu`, ready to take its first option.
// ignore: non_constant_identifier_names
LscpuCmd get Lscpu => LscpuCmd();
