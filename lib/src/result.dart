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
