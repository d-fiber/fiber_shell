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

/// `diff`, comparing two files or two directory trees. On every Unix.
///
/// ```dart
/// final ShellResult patch = await Diff.unified().label('a/config.yml').label('b/config.yml')
///     .file(oldPath).file(newPath).output();
/// if (patch.exitCode == 1) print(patch.text); // 1 means "they differ", not an error
/// ```
///
/// **Exit status is the answer, the way [GrepCmd.quiet] uses it.** `0` means
/// identical, `1` means they differ, anything above that means `diff` itself
/// failed to run — reach for [output] and read [ShellResult.exitCode] rather
/// than [execute], which would throw on the ordinary case of two files
/// differing. [recursive] compares two directories entry by entry; give it two
/// [file] paths that are directories rather than two individual files.
///
/// [algorithm] takes different names on the two flavours: BSD diff knows
/// `myers`, `patience` and `stone`; GNU diff knows `myers` (called `--minimal`
/// there via [minimal] instead of `-A`), `patience` and `histogram`. Stick to
/// `patience`, the one name both accept, for a portable call. A handful of
/// long options past [suppressBlankEmpty] are GNU-only extensions with no BSD
/// equivalent, noted flavour by flavour below.
class DiffCmd extends CommandBuilder<DiffCmd> {
  @override
  final String executable = 'diff';

  /// Forces the default, no-frills output format (`--normal`). GNU only.
  DiffCmd normalFormat() => token('--normal');

  /// Emits a unified diff with this many lines of context (`-U`, `--unified`). Default is 3 with [unified] alone.
  DiffCmd unified([int? lines]) => lines == null ? token('-u') : pair('-U', '$lines');

  /// Emits a context diff with this many lines of context (`-C`, `--context`). Default is 3 with [context] alone.
  DiffCmd context([int? lines]) => lines == null ? token('-c') : pair('-C', '$lines');

  /// Emits an ed script that reproduces the change (`-e`, `--ed`).
  DiffCmd edScript() => token('-e');

  /// Emits the same as [edScript], in reverse order and not usable by `ed` (`-f`, `--forward-ed`).
  DiffCmd forwardEdScript() => token('-f');

  /// Emits an RCS-format script, the form `rcsdiff` uses (`-n`, `--rcs`).
  DiffCmd rcsFormat() => token('-n');

  /// Merges the files with C preprocessor `#ifdef NAME` guards around the differences (`-D`, `--ifdef`).
  DiffCmd ifdef(String name) => pair('-D', name);

  /// Reports only whether the files differ, not how (`-q`, `--brief`).
  DiffCmd brief() => token('-q');

  /// Reports pairs that are identical too, which are otherwise not mentioned (`-s`, `--report-identical-files`).
  DiffCmd reportIdenticalFiles() => token('-s');

  /// Renders side by side, two columns, marked `|`, `<` or `>` between them (`-y`, `--side-by-side`).
  DiffCmd sideBySide() => token('-y');

  /// The output width for [sideBySide] (`-W`, `--width`). Defaults to 130.
  DiffCmd width(int columns) => pair('-W', '$columns');

  /// Under [sideBySide], prints only the left column of a common line (`--left-column`). GNU only.
  DiffCmd leftColumn() => token('--left-column');

  /// Under [sideBySide], omits common lines entirely (`--suppress-common-lines`).
  DiffCmd suppressCommonLines() => token('--suppress-common-lines');

  /// Passes the output through `pr` to paginate it (`-l`, `--paginate`).
  DiffCmd paginate() => token('-l');

  /// With [unified] or [context], shows the last line starting a function above each change (`-p`, `--show-c-function`).
  DiffCmd showCFunction() => token('-p');

  /// Like [showCFunction], but matching this regular expression instead of a C-style declaration (`-F`, `--show-function-line`).
  DiffCmd showFunctionLine(String pattern) => pair('-F', pattern);

  /// The label to print instead of the filename and timestamp, for [unified] and [context] output (`-L`, `--label`). Repeatable.
  DiffCmd label(String value) => pair('-L', value);

  /// Expands tabs to spaces in the output (`-t`, `--expand-tabs`).
  DiffCmd expandTabs() => token('-t');

  /// Prints a tab rather than a space before the rest of the line, so tabs stay aligned (`-T`, `--initial-tab`).
  DiffCmd initialTab() => token('-T');

  /// The number of spaces a tab represents, for [expandTabs] and [initialTab] (`--tabsize`). Defaults to 8.
  DiffCmd tabSize(int columns) => pair('--tabsize', '$columns');

  /// Omits the space or tab that would otherwise precede an empty output line (`--suppress-blank-empty`). GNU only.
  DiffCmd suppressBlankEmpty() => token('--suppress-blank-empty');

  /// Walks into common subdirectories recursively (`-r`, `--recursive`).
  DiffCmd recursive() => token('-r');

  /// Does not follow symbolic links (`--no-dereference`).
  DiffCmd noDereference() => token('--no-dereference');

  /// Treats a file missing from one directory as present but empty, instead of skipping it (`-N`, `--new-file`).
  DiffCmd newFile() => token('-N');

  /// Like [newFile], but only for files missing from the first directory (`-P`, `--unidirectional-new-file`).
  DiffCmd unidirectionalNewFile() => token('-P');

  /// Folds case when matching filenames between the two directories (`--ignore-file-name-case`). GNU only.
  DiffCmd ignoreFileNameCase() => token('--ignore-file-name-case');

  /// The default: filenames are matched case-sensitively (`--no-ignore-file-name-case`).
  DiffCmd noIgnoreFileNameCase() => token('--no-ignore-file-name-case');

  /// Restarts a directory comparison partway through, at this file (`-S`, `--starting-file`).
  DiffCmd startingFile(String name) => pair('-S', name);

  /// Skips files and subdirectories whose basename matches a pattern listed in this file (`-X`, `--exclude-from`). Repeatable.
  DiffCmd excludeFrom(String path) => pair('-X', path);

  /// Skips files and subdirectories whose basename matches this shell glob (`-x`, `--exclude`). Repeatable.
  DiffCmd exclude(String pattern) => pair('-x', pattern);

  /// Folds case when comparing file contents (`-i`, `--ignore-case`).
  DiffCmd ignoreCase() => token('-i');

  /// Ignores changes caused only by tab expansion (`-E`, `--ignore-tab-expansion`). GNU only.
  DiffCmd ignoreTabExpansion() => token('-E');

  /// Ignores trailing whitespace at the end of a line (`-Z`, `--ignore-trailing-space`). GNU only.
  DiffCmd ignoreTrailingSpace() => token('-Z');

  /// Ignores changes in the amount of whitespace, trailing blanks included (`-b`, `--ignore-space-change`).
  DiffCmd ignoreSpaceChange() => token('-b');

  /// Ignores whitespace entirely (`-w`, `--ignore-all-space`).
  DiffCmd ignoreAllSpace() => token('-w');

  /// Ignores changes made up only of blank lines (`-B`, `--ignore-blank-lines`).
  DiffCmd ignoreBlankLines() => token('-B');

  /// Ignores a change whose every line matches this extended regular expression (`-I`, `--ignore-matching-lines`). Repeatable.
  DiffCmd ignoreMatchingLines(String pattern) => pair('-I', pattern);

  /// Treats all files as text, skipping the binary check (`-a`, `--text`).
  DiffCmd text() => token('-a');

  /// Strips a trailing carriage return from each input line before comparing (`--strip-trailing-cr`).
  DiffCmd stripTrailingCr() => token('--strip-trailing-cr');

  /// Selects the comparison algorithm: `myers`, `patience` or, on BSD, `stone`; on GNU, `histogram` (`-A`, `--algorithm`).
  DiffCmd algorithm(String name) => pair('-A', name);

  /// Tries hard to produce the smallest possible diff, at the cost of speed (`-d`, `--minimal`).
  DiffCmd minimal() => token('-d');

  /// A compatibility stub for large, sparsely-changed files; accepted and mostly ignored (`--speed-large-files`).
  DiffCmd speedLargeFiles() => token('--speed-large-files');

  /// Colours additions and removals when writing to a terminal: `never`, `always` or `auto` (`--color`).
  DiffCmd color(String when) => joined('--color', when);

  /// The number of leading and trailing context lines kept whole around a change, for performance (`--horizon-lines`). GNU only.
  DiffCmd horizonLines(int count) => pair('--horizon-lines', '$count');

  /// Compares this file against every operand named on the command line (`--from-file`). GNU only.
  DiffCmd fromFile(String path) => pair('--from-file', path);

  /// Compares every operand named on the command line against this file (`--to-file`). GNU only.
  DiffCmd toFile(String path) => pair('--to-file', path);

  /// Prints the usage summary (`--help`).
  DiffCmd help() => token('--help');

  /// Prints the version and exits (`--version`).
  DiffCmd version() => token('--version');

  /// Ends the options, so a filename starting with a dash is still a filename (`--`).
  DiffCmd endOfOptions() => token('--');

  /// Adds a file or directory to compare. Exactly two calls define the comparison.
  DiffCmd file(String path) => token(path);
}

/// `diff`, ready to take its first option.
// ignore: non_constant_identifier_names
DiffCmd get Diff => DiffCmd();
