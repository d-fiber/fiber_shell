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

import 'package:fiber_shell/fiber_shell.dart';
import 'package:test/test.dart';

ShellResult resultOf({
  String command = 'probe',
  int exitCode = 0,
  String stdout = '',
  String stderr = '',
  List<int>? bytes,
  Duration duration = const Duration(milliseconds: 12),
}) {
  return ShellResult(
    command: command,
    exitCode: exitCode,
    bytes: bytes ?? utf8.encode(stdout),
    errorBytes: utf8.encode(stderr),
    duration: duration,
  );
}

void main() {
  group('status', () {
    test('zero is a success', () {
      expect(resultOf().success, isTrue);
      expect(resultOf().failed, isFalse);
    });

    test('anything else is a failure', () {
      expect(resultOf(exitCode: 2).failed, isTrue);
      expect(resultOf(exitCode: 2).success, isFalse);
    });

    test('a negative status, the shape a signalled process takes, is a failure', () {
      expect(resultOf(exitCode: -15).failed, isTrue);
    });
  });

  group('decoding', () {
    test('stdout keeps what the command wrote, newline included', () {
      expect(resultOf(stdout: 'value\n').stdout, 'value\n');
    });

    test('text drops the trailing newline', () {
      expect(resultOf(stdout: 'value\n').text, 'value');
    });

    test('error trims the surrounding whitespace of stderr', () {
      expect(resultOf(stderr: '  boom \n').error, 'boom');
    });

    test('lines keeps the non-blank lines in order', () {
      expect(resultOf(stdout: 'a\n\nb\n   \nc\n').lines, <String>['a', 'b', 'c']);
    });

    test('bytes are kept undecoded, so binary survives', () {
      final List<int> binary = <int>[0x00, 0xff, 0xfe, 0x42];
      expect(resultOf(bytes: binary).bytes, binary);
    });

    test('decoding malformed bytes replaces rather than throwing', () {
      final ShellResult result = resultOf(bytes: <int>[0xff, 0xfe]);
      expect(result.stdout, isNotEmpty);
      expect(() => result.text, returnsNormally);
    });

    test('isEmpty follows the decoded text, not the raw bytes', () {
      expect(resultOf(stdout: '\n  \n').isEmpty, isTrue);
      expect(resultOf(stdout: 'x').isNotEmpty, isTrue);
    });
  });

  group('textOrNull', () {
    test('gives the text when the command succeeded and printed something', () {
      expect(resultOf(stdout: 'value\n').textOrNull, 'value');
    });

    test('gives null when the command failed', () {
      expect(resultOf(exitCode: 1, stdout: 'value\n').textOrNull, isNull);
    });

    test('gives null when the command printed nothing', () {
      expect(resultOf(stdout: '\n').textOrNull, isNull);
    });
  });

  group('orThrow', () {
    test('returns the text on success', () {
      expect(resultOf(stdout: 'value\n').orThrow(), 'value');
    });

    test('throws on a non-zero status', () {
      expect(() => resultOf(exitCode: 2).orThrow(), throwsA(isA<ShellException>()));
    });

    test('carries the command, the status and the stderr into the message', () {
      final ShellResult result = resultOf(command: 'probe --flag', exitCode: 2, stderr: 'no such file');
      expect(
        () => result.orThrow(),
        throwsA(
          isA<ShellException>().having(
            (ShellException error) => error.message,
            'message',
            allOf(contains('probe --flag'), contains('2'), contains('no such file')),
          ),
        ),
      );
    });

    test('leaves the message without a trailing colon when stderr is empty', () {
      expect(
        () => resultOf(exitCode: 1).orThrow(),
        throwsA(isA<ShellException>().having((ShellException error) => error.message, 'message', endsWith('code 1'))),
      );
    });
  });

  test('toString reports the command, the status and the duration', () {
    final ShellResult result = resultOf(command: 'probe', exitCode: 3, duration: const Duration(milliseconds: 40));
    expect(result.toString(), contains('probe'));
    expect(result.toString(), contains('3'));
    expect(result.toString(), contains('40ms'));
  });
}
