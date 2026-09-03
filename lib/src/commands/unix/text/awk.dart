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

/// `awk`, the field processor. On every Unix, absent from Windows.
///
/// ```dart
/// final ShellResult pids = await (Ps.everyProcess().format('pid,comm')
///         | Awk.fieldSeparator(' ').program(r'$2 ~ /postgres/ {print $1}'))
///     .output();
/// ```
///
/// Where it earns its place is exactly that: pulling a column out of another
/// tool's output inside a pipeline. For anything more, the program becomes a
/// second language embedded in a Dart string, and Dart does it better.
///
/// Three implementations answer to the name (the BSD one, `gawk` and `mawk`),
/// and they agree on the POSIX core and disagree past it. `gensub`, `asort` and
/// `\s` in a pattern are gawk extensions and simply fail elsewhere.
///
/// [assign] passes a value in as a variable rather than pasting it into the
/// program text, which is what keeps a quote in the data from rewriting the
/// program.
class AwkCmd extends CommandBuilder<AwkCmd> {
  @override
  final String executable = 'awk';

  /// The input field separator (`-F`). A single character, or a regular expression.
  AwkCmd fieldSeparator(String value) => pair('-F', value);

  /// Sets a variable before the program runs (`-v`), `name=value`.
  AwkCmd assign(String assignment) => pair('-v', assignment);

  /// Reads the program from a file (`-f`). Repeatable.
  AwkCmd programFile(String path) => pair('-f', path);

  /// Ends the options (`--`).
  AwkCmd endOfOptions() => token('--');

  /// The program text, when it has not been given through [programFile].
  AwkCmd program(String value) => token(value);

  /// Adds an input file. Without one awk reads stdin.
  AwkCmd file(String path) => token(path);

  /// Adds a bare argument, landing in the program's `ARGV`.
  AwkCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
AwkCmd get Awk => AwkCmd();
