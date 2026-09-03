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

/// `wc`, counting lines, words and bytes. On every Unix.
///
/// ```dart
/// final int lineCount = int.parse((await Wc.lines().file('CHANGELOG.md').output()).text.trim());
/// ```
///
/// With more than one flag, the counts print in a fixed order — lines, words,
/// characters, bytes, longest line — regardless of the order the flags were
/// given in. [chars] and [bytes] are the same number in a single-byte locale
/// and differ under UTF-8, which is the usual reason to reach for `wc` from
/// Dart at all rather than counting a `String`'s `.length` directly: this
/// counts what the file actually contains, not what Dart decoded it as.
/// [total] and [files0From] are GNU-only additions for summarising many files
/// at once.
class WcCmd extends CommandBuilder<WcCmd> {
  @override
  final String executable = 'wc';

  /// Counts bytes (`-c`, `--bytes`). Cancels a prior [chars] on GNU wc.
  WcCmd bytes() => token('-c');

  /// Counts characters, multi-byte aware (`-m`, `--chars`). Cancels a prior [bytes] on GNU wc.
  WcCmd chars() => token('-m');

  /// Counts lines (`-l`, `--lines`).
  WcCmd lines() => token('-l');

  /// Prints the length of the longest line, in bytes, or characters under [chars] (`-L`, `--max-line-length`).
  WcCmd maxLineLength() => token('-L');

  /// Counts words (`-w`, `--words`).
  WcCmd words() => token('-w');

  /// Reads the list of input files from this NUL-separated file instead of the command line (`--files0-from`). GNU only.
  WcCmd files0From(String path) => pair('--files0-from', path);

  /// Controls when the cumulative total line is printed: `auto`, `always`, `only` or `never` (`--total`). GNU only.
  WcCmd total(String mode) => pair('--total', mode);

  /// Prints which line-counting method was used, to stderr (`--debug`). GNU only.
  WcCmd debug() => token('--debug');

  /// Prints the usage summary (`--help`). GNU only.
  WcCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  WcCmd version() => token('--version');

  /// Adds a file to count. Repeat for several; without one, reads stdin.
  WcCmd file(String path) => token(path);
}

/// `wc`, ready to take its first option.
// ignore: non_constant_identifier_names
WcCmd get Wc => WcCmd();
