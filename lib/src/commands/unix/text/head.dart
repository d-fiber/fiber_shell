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

/// `head`, the first-lines-of-a-file filter. On every Unix.
///
/// ```dart
/// final ShellResult firstTen = await Head.file('access.log').output();
/// ```
///
/// BSD head takes only [lines] or [bytes], one or the other, and no long
/// options, no [quiet], no [verbose]. GNU head adds those three, [zeroTerminated],
/// and a leading `-` on the count of [lines] or [bytes] to mean "print
/// everything except the last N", which BSD head cannot do at all. When more
/// than one [file] is given, both flavours print an `==> name <==` header
/// before each block; [quiet] turns that off and [verbose] forces it on even
/// for one file.
class HeadCmd extends CommandBuilder<HeadCmd> {
  @override
  final String executable = 'head';

  /// Prints the first [count] lines of each file (`-n`, `--lines`). Defaults to 10.
  ///
  /// A count prefixed with `-`, e.g. `'-5'`, prints everything but the last 5 lines. GNU only.
  HeadCmd lines(String count) => pair('-n', count);

  /// Prints the first [count] bytes of each file (`-c`, `--bytes`).
  ///
  /// A count prefixed with `-` prints everything but the last N bytes. GNU only.
  HeadCmd bytes(String count) => pair('-c', count);

  /// Suppresses the `==> name <==` headers printed for multiple files (`-q`, `--quiet`, `--silent`). GNU only.
  HeadCmd quiet() => token('-q');

  /// Prints a header even for a single file (`-v`, `--verbose`). GNU only.
  HeadCmd verbose() => token('-v');

  /// Separates output with NUL instead of newline (`-z`, `--zero-terminated`). GNU only.
  HeadCmd zeroTerminated() => token('-z');

  /// Prints the usage summary (`--help`). GNU only.
  HeadCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  HeadCmd version() => token('--version');

  /// Adds a file to read. Repeat for several; without one, reads stdin.
  HeadCmd file(String path) => token(path);
}

/// `head`, ready to take its first option.
// ignore: non_constant_identifier_names
HeadCmd get Head => HeadCmd();
