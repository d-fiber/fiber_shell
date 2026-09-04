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

/// `printf`: formats and prints its arguments the way the C library function
/// does, on every Unix. Unlike the rest of this catalogue, its "options" are not
/// command-line flags but `%`-conversions inside the format string itself
/// (`%s`, `%d`, `%.2f`, `%b` for backslash-escaped strings, and so on) — this
/// wrapper does not model those individually, since they are data the caller
/// composes, not switches this builder would add.
///
/// ```dart
/// final ShellResult r = await Printf.format('%-10s %5d\n').arg('total').arg('42').output();
/// ```
///
/// GNU printf additionally answers `--help` and `--version`; BSD printf has
/// neither, and its shells' builtin `printf` (see `builtin(1)`) may differ from
/// this on-disk one. A leading `-` in the format string reads as an option to
/// `printf` itself unless preceded by `--`; use [endOfOptions] when the format
/// starts with a dash.
class PrintfCmd extends CommandBuilder<PrintfCmd> {
  @override
  final String executable = 'printf';

  /// Ends the options, for a format string that itself starts with `-` (`--`).
  PrintfCmd endOfOptions() => token('--');

  /// The format string, reused as many times as needed to consume every [arg].
  PrintfCmd format(String value) => token(value);

  /// Adds one argument consumed by the format string. Repeat for several.
  PrintfCmd arg(String value) => token(value);

  /// Prints the usage summary and exits (`--help`). GNU only.
  PrintfCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  PrintfCmd version() => token('--version');
}

/// `printf`, ready to take its format string.
// ignore: non_constant_identifier_names
PrintfCmd get Printf => PrintfCmd();
