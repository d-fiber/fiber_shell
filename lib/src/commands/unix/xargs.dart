// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

/// `xargs`, which turns a list on stdin into command arguments. On every Unix,
/// absent from Windows.
///
/// ```dart
/// await (Find.path(cache.path).type('f').modifiedTime('+30').print0()
///         | Xargs.nullSeparated().maxArgs('50').arg('rm'))
///     .execute();
/// ```
///
/// [nullSeparated] with `find -print0` is the only combination that survives a
/// filename containing a space or a newline. Without it xargs splits on
/// whitespace and quotes, and one awkward filename turns a cleanup into a
/// mistake.
///
/// **An empty input still runs the command once** on BSD, which is how `xargs
/// rm` with nothing to delete becomes an error, or worse, how `xargs rm -rf`
/// with a bare path deletes it. GNU has `--no-run-if-empty`; BSD does not, and
/// checking the input is empty beforehand is the portable answer.
///
/// [maxProcs] runs several at once, which is the cheapest parallelism there is
/// when the work is per-file.
class XargsCmd extends CommandBuilder<XargsCmd> {
  @override
  final String executable = 'xargs';

  /// Splits the input on NUL rather than whitespace (`-0`).
  XargsCmd nullSeparated() => token('-0');

  /// Stops reading at this word (`-E`).
  XargsCmd endOfFileString(String value) => pair('-E', value);

  /// Replaces this placeholder with the input, one line per run (`-I`).
  XargsCmd replace(String placeholder) => pair('-I', placeholder);

  /// The same, without turning off the other splitting (`-J`).
  XargsCmd insertAt(String placeholder) => pair('-J', placeholder);

  /// Uses this many input lines per run (`-L`).
  XargsCmd maxLines(String count) => pair('-L', count);

  /// Uses this many arguments per run (`-n`).
  XargsCmd maxArgs(String count) => pair('-n', count);

  /// Reopens stdin from the terminal for the child (`-o`).
  XargsCmd reopenStdin() => token('-o');

  /// Runs this many children at once (`-P`).
  XargsCmd maxProcs(String count) => pair('-P', count);

  /// Asks before each run (`-p`). Interactive.
  XargsCmd prompt() => token('-p');

  /// How many replacements [replace] may make per line (`-R`).
  XargsCmd maxReplacements(String count) => pair('-R', count);

  /// The size of the replacement buffer (`-S`).
  XargsCmd replaceSize(String value) => pair('-S', value);

  /// The largest command line to build, in bytes (`-s`).
  XargsCmd maxChars(String value) => pair('-s', value);

  /// Echoes each command before running it (`-t`).
  XargsCmd trace() => token('-t');

  /// Stops if a run exits non-zero (`-x`).
  XargsCmd exitOnError() => token('-x');

  /// Runs nothing when the input is empty (`-r`). GNU, and BSD only recently.
  XargsCmd noRunIfEmpty() => token('-r');

  /// The command to build, then its fixed arguments.
  XargsCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
XargsCmd get Xargs => XargsCmd();
