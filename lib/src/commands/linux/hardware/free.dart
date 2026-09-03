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

/// `free`, the procps-ng memory reporter. Linux only: it reads `/proc/meminfo`,
/// which has no macOS or Windows equivalent with the same fields.
///
/// ```dart
/// final ShellResult snapshot = await Free.human().total().output();
/// final ShellResult sampled = await Free.seconds(2).count(5).output();
/// ```
///
/// Pick one unit and stick with it in a parser: [bytes], [kibi], [mebi],
/// [gibi], [tebi], [pebi] and their SI-scaled cousins [kilo], [mega], [giga],
/// [tera], [peta] all change how the numbers are printed, not just how they
/// look, so a script written against one silently misparses another. [human]
/// picks whichever unit keeps the number at three digits, which is readable
/// but not what a fixed-column parser wants.
///
/// [count] only means anything alongside [seconds]: without a sampling
/// interval there is nothing to repeat.
class FreeCmd extends CommandBuilder<FreeCmd> {
  @override
  final String executable = 'free';

  /// Sizes in bytes (`-b`, `--bytes`).
  FreeCmd bytes() => token('--bytes');

  /// Sizes in kibibytes, the default (`-k`, `--kibi`).
  FreeCmd kibi() => token('--kibi');

  /// Sizes in mebibytes (`-m`, `--mebi`).
  FreeCmd mebi() => token('--mebi');

  /// Sizes in gibibytes (`-g`, `--gibi`).
  FreeCmd gibi() => token('--gibi');

  /// Sizes in tebibytes (`--tebi`).
  FreeCmd tebi() => token('--tebi');

  /// Sizes in pebibytes (`--pebi`).
  FreeCmd pebi() => token('--pebi');

  /// Sizes in kilobytes, base 1000 (`--kilo`).
  FreeCmd kilo() => token('--kilo');

  /// Sizes in megabytes, base 1000 (`--mega`).
  FreeCmd mega() => token('--mega');

  /// Sizes in gigabytes, base 1000 (`--giga`).
  FreeCmd giga() => token('--giga');

  /// Sizes in terabytes, base 1000 (`--tera`).
  FreeCmd tera() => token('--tera');

  /// Sizes in petabytes, base 1000 (`--peta`).
  FreeCmd peta() => token('--peta');

  /// Picks the largest unit that keeps the number under four digits, and
  /// shows its suffix (`-h`, `--human`).
  FreeCmd human() => token('--human');

  /// Uses powers of 1000 instead of 1024 for the unit named by a size flag
  /// (`--si`).
  FreeCmd si() => token('--si');

  /// Adds a wider column layout with separate buffers and cache (`-w`,
  /// `--wide`).
  FreeCmd wide() => token('--wide');

  /// Prints the report as a single line (`-L`, `--line`).
  FreeCmd line_() => token('--line');

  /// Adds a line with the totals across memory and swap (`-t`, `--total`).
  FreeCmd total() => token('--total');

  /// Adds a line for the memory committed to and beyond physical RAM (`-v`,
  /// `--committed`).
  FreeCmd committed() => token('--committed');

  /// Shows the historical low/high-memory split rather than the modern layout
  /// (`-l`, `--lohi`).
  FreeCmd lohi() => token('--lohi');

  /// Repeats the report [count] times (`-c`, `--count`). Only means anything
  /// alongside [seconds].
  FreeCmd count(int count) => pair('--count', '$count');

  /// Repeats the report every [seconds] seconds until interrupted, or
  /// [count] times if given (`-s`, `--seconds`).
  FreeCmd seconds(num seconds) => pair('--seconds', '$seconds');

  /// Prints the usage summary (`--help`).
  FreeCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  FreeCmd version() => token('--version');
}

/// `free`, ready to take its first option.
// ignore: non_constant_identifier_names
FreeCmd get Free => FreeCmd();
