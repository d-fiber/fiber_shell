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

/// `jq`, the JSON processor. One small binary for every platform, and the only
/// tool here that is not preinstalled anywhere, so `commandExists` before reaching
/// for it, or parse the JSON in Dart instead, which is usually the better answer
/// inside a Dart CLI.
///
/// Where it does earn its place is in the middle of a pipeline, turning another
/// tool's JSON into the one field you wanted:
///
/// ```dart
/// final ShellResult ids = await (Docker.ps().format('json') | Jq.rawOutput().filter('.ID')).output();
/// ```
///
/// [rawOutput] is nearly always wanted: without it a string comes back wrapped in
/// the quotes jq uses for JSON, which then have to be stripped anyway.
///
/// [exitStatus] turns jq into a test: `false` or `null` output exits `1`, no
/// output at all exits `4`. That is how you ask a question of a JSON document and
/// read the answer from [ShellResult.success].
///
/// Never build a filter by string concatenation around a value. [argString] and
/// [argJson] bind a value to a name jq reads as data, which keeps a quote in the
/// input from rewriting the program.
class JqCmd extends CommandBuilder<JqCmd> {
  @override
  final String executable = 'jq';

  /// Uses `null` as the input, so the filter runs without reading anything (`--null-input`).
  JqCmd nullInput() => token('--null-input');

  /// Reads each line as a string rather than as JSON (`--raw-input`).
  JqCmd rawInput() => token('--raw-input');

  /// Reads every input into one array (`--slurp`).
  JqCmd slurp() => token('--slurp');

  /// Prints one line per result instead of indenting (`--compact-output`).
  JqCmd compactOutput() => token('--compact-output');

  /// Prints strings bare, without the JSON quotes and escapes (`--raw-output`).
  JqCmd rawOutput() => token('--raw-output');

  /// Implies [rawOutput] and ends each result with a NUL (`--raw-output0`).
  JqCmd rawOutputNul() => token('--raw-output0');

  /// Implies [rawOutput] and writes no newline between results (`--join-output`).
  JqCmd joinOutput() => token('--join-output');

  /// Escapes everything outside ASCII (`--ascii-output`).
  JqCmd asciiOutput() => token('--ascii-output');

  /// Sorts the keys of every object (`--sort-keys`).
  ///
  /// What makes two runs of the same query comparable.
  JqCmd sortKeys() => token('--sort-keys');

  /// Colours the output (`--color-output`).
  JqCmd colorOutput() => token('--color-output');

  /// Leaves the output uncoloured (`--monochrome-output`).
  JqCmd monochromeOutput() => token('--monochrome-output');

  /// Indents with tabs (`--tab`).
  JqCmd tab() => token('--tab');

  /// Indents with this many spaces, seven at most (`--indent`).
  JqCmd indent(String spaces) => pair('--indent', spaces);

  /// Flushes after every result (`--unbuffered`).
  ///
  /// What you want when jq sits in a pipeline reading a stream that never ends.
  JqCmd unbuffered() => token('--unbuffered');

  /// Parses the input as a stream of path and value pairs (`--stream`).
  ///
  /// The way through a document too large to hold in memory.
  JqCmd stream() => token('--stream');

  /// Implies [stream] and reports a parse error as an array (`--stream-errors`).
  JqCmd streamErrors() => token('--stream-errors');

  /// Reads and writes `application/json-seq` (`--seq`).
  JqCmd seq() => token('--seq');

  /// Reads the filter from this file (`--from-file`).
  JqCmd fromFile(String path) => pair('--from-file', path);

  /// Adds a directory to the module search path (`--library-path`).
  JqCmd libraryPath(String path) => pair('--library-path', path);

  /// Binds a name to a string value (`--arg`).
  JqCmd argString(String name, String value) {
    tokens
      ..add('--arg')
      ..add(name)
      ..add(value);
    return self;
  }

  /// Binds a name to a JSON value (`--argjson`).
  JqCmd argJson(String name, String json) {
    tokens
      ..add('--argjson')
      ..add(name)
      ..add(json);
    return self;
  }

  /// Binds a name to an array of the JSON values in a file (`--slurpfile`).
  JqCmd slurpFile(String name, String path) {
    tokens
      ..add('--slurpfile')
      ..add(name)
      ..add(path);
    return self;
  }

  /// Binds a name to the raw contents of a file (`--rawfile`).
  JqCmd rawFile(String name, String path) {
    tokens
      ..add('--rawfile')
      ..add(name)
      ..add(path);
    return self;
  }

  /// Reads the rest of the arguments as positional strings (`--args`).
  JqCmd positionalStrings() => token('--args');

  /// Reads the rest of the arguments as positional JSON values (`--jsonargs`).
  JqCmd positionalJson() => token('--jsonargs');

  /// Derives the exit status from the output (`--exit-status`).
  ///
  /// `1` when the last result was `false` or `null`, `4` when there was no result
  /// at all. Turns a query into a question.
  JqCmd exitStatus() => token('--exit-status');

  /// Prints the version (`--version`).
  JqCmd version() => token('--version');

  /// Prints how this jq was built (`--build-configuration`).
  JqCmd buildConfiguration() => token('--build-configuration');

  /// Prints the usage summary (`--help`).
  JqCmd help() => token('--help');

  /// Ends the options (`--`).
  JqCmd endOfOptions() => token('--');

  /// The filter, the jq program itself.
  JqCmd filter(String program) => token(program);

  /// Adds an input file. Without one jq reads stdin.
  JqCmd file(String path) => token(path);
}

// ignore: non_constant_identifier_names
JqCmd get Jq => JqCmd();
