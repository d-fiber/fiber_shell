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

/// `uniq`, collapsing adjacent duplicate lines. On every Unix.
///
/// ```dart
/// final ShellResult counted = await (Sort.file('visitors.log') | Uniq.count()).output();
/// ```
///
/// **Only adjacent duplicates are collapsed.** `uniq` never sorts, so a file
/// with the same line in two places that are not next to each other passes
/// both through untouched; pipe it behind `Sort` first, as above, whenever the
/// input is not already grouped. [group] is a GNU-only relative of
/// [allRepeated]: where [allRepeated] prints only the repeated lines, [group]
/// prints every line, repeated or not, separated into runs.
class UniqCmd extends CommandBuilder<UniqCmd> {
  @override
  final String executable = 'uniq';

  /// Prefixes each output line with how many times it occurred (`-c`, `--count`).
  UniqCmd count() => token('-c');

  /// Prints one copy of each line that occurred more than once (`-d`, `--repeated`).
  ///
  /// Ignored when [allRepeated] is also given.
  UniqCmd repeated() => token('-d');

  /// Prints every copy of each repeated line, not just one (`-D`, `--all-repeated`).
  UniqCmd allRepeated() => token('-D');

  /// Like [allRepeated], separating each group of repeated lines (`-D` with an argument). GNU only.
  ///
  /// [method] is one of `none` (the default), `prepend` or `separate`.
  UniqCmd allRepeatedGrouped(String method) => joined('-D', method);

  /// Prints every line, separating groups by [method]: `none`, `prepend`, `append` or `both` (`--group`). GNU only.
  UniqCmd group([String? method]) => method == null ? token('--group') : joined('--group', method);

  /// Skips this many leading fields when comparing (`-f`, `--skip-fields`).
  UniqCmd skipFields(int count) => pair('-f', '$count');

  /// Folds case before comparing (`-i`, `--ignore-case`).
  UniqCmd ignoreCase() => token('-i');

  /// Skips this many leading characters when comparing, after [skipFields] (`-s`, `--skip-chars`).
  UniqCmd skipChars(int count) => pair('-s', '$count');

  /// Prints only lines that were not repeated at all (`-u`, `--unique`).
  UniqCmd unique() => token('-u');

  /// Compares no more than this many characters per line (`-w`, `--check-chars`).
  UniqCmd checkChars(int count) => pair('-w', '$count');

  /// Separates records with NUL instead of newline (`-z`, `--zero-terminated`). GNU only.
  UniqCmd zeroTerminated() => token('-z');

  /// Prints the usage summary (`--help`). GNU only.
  UniqCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  UniqCmd version() => token('--version');

  /// The file to read. Without one, reads stdin.
  UniqCmd inputFile(String path) => token(path);

  /// The file to write. Without one, writes stdout. Must follow [inputFile].
  UniqCmd outputFile(String path) => token(path);
}

/// `uniq`, ready to take its first option.
// ignore: non_constant_identifier_names
UniqCmd get Uniq => UniqCmd();
