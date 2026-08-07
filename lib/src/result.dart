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

import 'dart:convert';

import 'exception.dart';

/// What a finished command left behind: how it exited, what it wrote, and how
/// long it took.
///
/// Returned by `CommandBuilder.output()`, which never throws. A command that
/// fails is a value to inspect, not an exception to catch:
///
/// ```dart
/// final ShellResult result = await Git.status().porcelain().output();
/// if (result.failed) log.warn(result.error);
/// ```
class ShellResult {
  ShellResult({
    required this.command,
    required this.exitCode,
    required this.bytes,
    required this.errorBytes,
    required this.duration,
  });

  /// The command line that produced this result, `sudo` prefix included.
  final String command;

  /// The status the process exited with.
  final int exitCode;

  /// Everything the command wrote to stdout, undecoded.
  ///
  /// Output is kept as bytes so one class covers text and binary alike:
  /// `openssl pkey -outform DER` writes a key here, not a string.
  final List<int> bytes;

  /// Everything the command wrote to stderr, undecoded.
  final List<int> errorBytes;

  /// How long the process ran, from spawn to exit.
  final Duration duration;

  /// Whether the command exited with status zero.
  bool get success => exitCode == 0;

  /// Whether the command exited with anything else.
  bool get failed => exitCode != 0;

  /// [bytes] read as UTF-8, malformed sequences replaced.
  ///
  /// This never throws, so asking a command that emitted binary for its [stdout]
  /// gives nonsense rather than an error. Read [bytes] when the output is not
  /// text.
  String get stdout => utf8.decode(bytes, allowMalformed: true);

  /// [errorBytes] read as UTF-8, malformed sequences replaced.
  String get stderr => utf8.decode(errorBytes, allowMalformed: true);

  /// [stdout] without the trailing newline every well-behaved command adds.
  String get text => stdout.trim();

  /// [stderr] without its surrounding whitespace.
  String get error => stderr.trim();

  /// Whether the command printed nothing usable to stdout.
  bool get isEmpty => text.isEmpty;

  /// Whether the command printed something to stdout.
  bool get isNotEmpty => text.isNotEmpty;

  /// The non-blank lines of [stdout], in order.
  List<String> get lines =>
      const LineSplitter().convert(stdout).where((String line) => line.trim().isNotEmpty).toList();

  /// [text] if the command succeeded and printed something, otherwise null.
  ///
  /// The shape a lookup usually wants: an entry that is missing and one that
  /// could not be read both mean "no value" to the caller.
  String? get textOrNull => success && isNotEmpty ? text : null;

  /// Returns [text], or throws [ShellException] carrying [exitCode] and [error].
  ///
  /// For the cases with no sensible fallback, where the stderr belongs in the
  /// message the user ends up reading.
  String orThrow() {
    if (failed) throw ShellException('$command exited with code $exitCode${error.isEmpty ? '' : ': $error'}');
    return text;
  }

  @override
  String toString() => '$command → $exitCode (${duration.inMilliseconds}ms)';
}
