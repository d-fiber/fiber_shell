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

/// `sort`, sorting or merging lines of text. On every Unix.
///
/// ```dart
/// final ShellResult ranked = await Sort.numeric().reverse().key('2,2').file('scores.csv').output();
/// ```
///
/// [key] is where BSD and GNU agree least: both accept `start[,end]` with
/// `field.char` addressing and the single-letter modifiers (`n`, `r`, `f`, `b`
/// and so on) attached to a field, but GNU additionally accepts long modifier
/// names and a handful of extra ones BSD does not have. Keep a [key] call to
/// the shared subset — field numbers, `n`, `r`, `b` — and it runs the same on
/// both. [unique] combined with a [key] compares only that key, not the whole
/// line, which is easy to reach for by accident when deduplicating.
///
/// The algorithm hints ([radixSort] through [useMmap]) and every option past
/// [temporaryDirectory] are BSD or GNU only, called out flavour by flavour
/// below; a script that runs on both should stick to the ordering flags,
/// [key], [outputFile], [stable], [unique] and [fieldSeparator].
class SortCmd extends CommandBuilder<SortCmd> {
  @override
  final String executable = 'sort';

  /// Checks that the input is already sorted instead of sorting it (`-c`, `--check`).
  ///
  /// Exits non-zero and prints the first out-of-order line found.
  SortCmd checkSorted() => token('-c');

  /// Like [checkSorted], but prints nothing (`-C`, `--check=quiet`).
  SortCmd checkSortedSilent() => token('-C');

  /// Assumes the inputs are already sorted and merges them (`-m`, `--merge`).
  ///
  /// The output order is undefined if they were not actually sorted.
  SortCmd merge() => token('-m');

  /// Ignores leading blanks when comparing (`-b`, `--ignore-leading-blanks`).
  ///
  /// Applies globally before the first [key], or to one key when attached to its spec.
  SortCmd ignoreLeadingBlanks() => token('-b');

  /// Considers only blanks and alphanumerics when comparing (`-d`, `--dictionary-order`).
  SortCmd dictionaryOrder() => token('-d');

  /// Folds case before comparing (`-f`, `--ignore-case`).
  SortCmd ignoreCase() => token('-f');

  /// Sorts by general numeric value, floating point included (`-g`, `--general-numeric-sort`).
  ///
  /// Slower than [numeric]; prefer [numeric] whenever the input has no fractional part.
  SortCmd generalNumeric() => token('-g');

  /// Sorts by numeric value with an SI suffix, `1k` before `1M` (`-h`, `--human-numeric-sort`).
  ///
  /// Matches the units `du -h` and `df -h` print.
  SortCmd humanNumeric() => token('-h');

  /// Ignores non-printable characters when comparing (`-i`, `--ignore-nonprinting`).
  SortCmd ignoreNonprinting() => token('-i');

  /// Sorts by month abbreviation, `JAN` before `FEB` (`-M`, `--month-sort`). Unknown strings sort first.
  SortCmd monthSort() => token('-M');

  /// Sorts fields numerically by arithmetic value (`-n`, `--numeric-sort`).
  SortCmd numeric() => token('-n');

  /// Sorts by a random, but stable, permutation (`-R`, `--random-sort`). GNU only.
  SortCmd randomSort() => token('-R');

  /// Reverses the sort order (`-r`, `--reverse`).
  SortCmd reverse() => token('-r');

  /// Sorts by version number, `PREFIX-1.2` before `PREFIX-1.10` (`-V`, `--version-sort`).
  SortCmd versionSort() => token('-V');

  /// Sorts on a key, `start[,end]` with an optional letter modifier glued on (`-k`, `--key`). Repeatable.
  ///
  /// Stick to field numbers and the shared modifiers (`n`, `r`, `b`) to stay portable.
  SortCmd key(String spec) => pair('-k', spec);

  /// The field separator, one character (`-t`, `--field-separator`).
  SortCmd fieldSeparator(String char) => pair('-t', char);

  /// Separates records with NUL instead of newline (`-z`, `--zero-terminated`).
  SortCmd nullData() => token('-z');

  /// Writes the result to this file instead of stdout (`-o`, `--output`).
  ///
  /// Safe to name an input file: `sort` reads it fully before opening the output.
  SortCmd outputFile(String path) => pair('-o', path);

  /// Keeps the original order of lines that compare equal (`-s`, `--stable`).
  SortCmd stable() => token('-s');

  /// Discards all but one line per distinct key (`-u`, `--unique`).
  ///
  /// Compares only the [key] given, or the whole line without one. Implies [stable].
  SortCmd unique() => token('-u');

  /// The maximum memory to use for the sort buffer, e.g. `1G` (`-S`, `--buffer-size`).
  SortCmd bufferSize(String size) => pair('-S', size);

  /// Where to put temporary files when the input spills to disk (`-T`, `--temporary-directory`).
  SortCmd temporaryDirectory(String path) => pair('-T', path);

  /// Reads the source of the hash used by [randomSort] from this file (`--random-source`). GNU only.
  SortCmd randomSource(String path) => pair('--random-source', path);

  /// The number of files `sort` may open at once for a merge (`--batch-size`). Defaults to 16. GNU only.
  SortCmd batchSize(int count) => pair('--batch-size', '$count');

  /// Compresses temporary files through this program (`--compress-program`). GNU only.
  SortCmd compressProgram(String program) => pair('--compress-program', program);

  /// The maximum number of sorting threads (`--parallel`). Defaults to the CPU count. GNU only.
  SortCmd parallel(int count) => pair('--parallel', '$count');

  /// Reads the list of input files from this NUL-separated file instead of the command line (`--files0-from`). GNU only.
  SortCmd files0From(String path) => pair('--files0-from', path);

  /// Prints extra information about the sorting process to stdout (`--debug`).
  SortCmd debug() => token('--debug');

  /// Uses radix sort when the sort specification allows it (`--radixsort`). BSD only.
  SortCmd radixSort() => token('--radixsort');

  /// Uses merge sort, the universal fallback (`--mergesort`). BSD only.
  SortCmd mergeSortAlgorithm() => token('--mergesort');

  /// Uses quicksort when the specification allows it; incompatible with [stable] and [unique] (`--qsort`). BSD only.
  SortCmd quickSort() => token('--qsort');

  /// Uses heapsort when the specification allows it; incompatible with [stable] and [unique] (`--heapsort`). BSD only.
  SortCmd heapSort() => token('--heapsort');

  /// Tries to memory-map the input files for speed (`--mmap`). BSD only.
  SortCmd useMmap() => token('--mmap');

  /// Prints the usage summary (`--help`).
  SortCmd help() => token('--help');

  /// Prints the version and exits (`--version`).
  SortCmd version() => token('--version');

  /// Ends the options, so a filename starting with a dash is still a filename (`--`).
  SortCmd endOfOptions() => token('--');

  /// Adds a file to sort. Repeat for several; without one, reads stdin.
  SortCmd file(String path) => token(path);
}

/// `sort`, ready to take its first option.
// ignore: non_constant_identifier_names
SortCmd get Sort => SortCmd();
