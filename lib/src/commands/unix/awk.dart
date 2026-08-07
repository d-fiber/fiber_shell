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
