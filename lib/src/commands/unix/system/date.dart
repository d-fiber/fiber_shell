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

/// `date`: prints or sets the system date and time, on every Unix. Joins
/// [DfCmd] and `uptime` as the third member of `unix/system/`.
///
/// ```dart
/// // BSD/macOS: today's date as YYYY-MM-DD.
/// final ShellResult d = await Date.outputFormat('%Y-%m-%d').output();
///
/// // GNU/Linux: parse an arbitrary date expression instead of "now".
/// final ShellResult g = await Date.gnuDate('next friday').outputFormat('%F').output();
/// ```
///
/// BSD and GNU agree on the `+format` operand ([outputFormat], `strftime`
/// directives) and on [utc]/[rfc2822]/[isoFormat]. They part ways on how to
/// display an arbitrary date rather than "now": BSD parses a positional
/// operand against [inputFormat] (`-f`, `strptime`-style) with [dryRun] (`-j`)
/// to stop it from actually setting the clock; GNU instead takes the
/// expression directly through [gnuDate] (`-d`, English-ish free text like
/// `"next friday"` or `"3 days ago"`) and never needs a dry-run flag, since
/// `-d` alone never sets anything. [referenceFile] (`-r` with a path) is the
/// one flag that means the same thing — a file's modification time — on both.
class DateCmd extends CommandBuilder<DateCmd> {
  @override
  final String executable = 'date';

  /// Parses the operand against this `strptime`-style format instead of the
  /// default `[[[mm]dd]HH]MM[[cc]yy][.SS]` (`-f`). BSD only — pairs with
  /// [dryRun] and a positional date via [newDate]. See [gnuDate] for the GNU
  /// equivalent.
  DateCmd inputFormat(String format) => pair('-f', format);

  /// Formats the output as ISO 8601, at the given precision if any: `date`
  /// (the default), `hours`, `minutes`, `seconds` or `ns` (`-I[FMT]`).
  DateCmd isoFormat([String? precision]) => token(precision == null ? '-I' : '-I$precision');

  /// Computes and displays the adjusted date without actually setting the
  /// system clock; required alongside [inputFormat] to convert one format to
  /// another rather than set the time (`-j`). BSD only.
  DateCmd dryRun() => token('-j');

  /// Displays RFC 2822/5322 date and time (`-R`).
  DateCmd rfc2822() => token('-R');

  /// Displays the modification time of this file instead of the current time
  /// (`-r`). Shared meaning on BSD and GNU.
  DateCmd referenceFile(String path) => pair('-r', path);

  /// Displays the date and time represented by these seconds since the epoch
  /// (`-r`). BSD only — GNU's `-r` takes only a file, see [referenceFile].
  DateCmd referenceSeconds(int epochSeconds) => pair('-r', '$epochSeconds');

  /// Displays or sets the date in UTC rather than the local zone (`-u`).
  DateCmd utc() => token('-u');

  /// Switches to this timezone just before printing, handy with [dryRun] to
  /// convert between zones (`-z`). BSD only.
  DateCmd outputZone(String timezone) => pair('-z', timezone);

  /// Adjusts one part of the date: a signed value followed by `y`, `m`, `w`,
  /// `d`, `H`, `M` or `S` (e.g. `+1d`); repeatable, applied left to right
  /// (`-v`). BSD only.
  DateCmd adjust(String value) => pair('-v', value);

  /// Displays the date described by this free-text expression — `"next
  /// friday"`, `"2 days ago"`, an ISO string — instead of "now" (`-d`/
  /// `--date`). GNU only; see [inputFormat] for BSD's `strptime`-based
  /// equivalent.
  DateCmd gnuDate(String expression) => pair('-d', expression);

  /// Reads one date expression per line from this file (or stdin, given `-`),
  /// as if each had been passed to [gnuDate] in turn (`-f`/`--file`). GNU
  /// only — shares its letter with BSD's [inputFormat] but a different job.
  DateCmd gnuDateFile(String path) => pair('-f', path);

  /// Sets the system time to this free-text expression (`-s`/`--set`). GNU
  /// only.
  DateCmd gnuSet(String expression) => pair('-s', expression);

  /// Displays the date/time per RFC 3339, at the given precision: `date`,
  /// `seconds` or `ns` (`--rfc-3339`). GNU only.
  DateCmd rfc3339(String precision) => joined('--rfc-3339', precision);

  /// Annotates how the date expression was parsed and warns about
  /// questionable input, to stderr (`--debug`). GNU only.
  DateCmd debug() => token('--debug');

  /// Prints the available timestamp resolution and exits (`--resolution`).
  /// GNU only.
  DateCmd resolution() => token('--resolution');

  /// The positional date/time to set, in BSD's canonical
  /// `[[[mm]dd]HH]MM[[cc]yy][.SS]` form, or the string [inputFormat] should
  /// parse.
  DateCmd newDate(String value) => token(value);

  /// The `strftime`-style output format, e.g. `%Y-%m-%d`. Rendered with a
  /// leading `+` the way `date` expects.
  DateCmd outputFormat(String format) => token('+$format');

  /// Prints the usage summary and exits (`--help`). GNU only.
  DateCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  DateCmd version() => token('--version');
}

/// `date`, ready to take its first option.
// ignore: non_constant_identifier_names
DateCmd get Date => DateCmd();
