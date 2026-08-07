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
