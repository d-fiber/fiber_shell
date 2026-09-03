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

@TestOn('!windows')
library;

import 'dart:convert';

import 'package:fiber_shell/fiber_shell.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'script_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ShellScript>()])
ShellScript get succeeding => Sh.c().script('exit 0');

ShellScript get failing => Sh.c().script('exit 3');

ShellResult resultOf({int exitCode = 0, String stdout = ''}) {
  return ShellResult(
    command: 'right',
    exitCode: exitCode,
    bytes: utf8.encode(stdout),
    errorBytes: <int>[],
    duration: Duration.zero,
  );
}

void main() {
  late MockShellScript right;

  setUp(() {
    right = MockShellScript();
    when(right.line).thenReturn('right');
    when(
      right.output(cwd: anyNamed('cwd'), env: anyNamed('env'), input: anyNamed('input')),
    ).thenAnswer((_) async => resultOf(stdout: 'right\n'));
    when(right.execute(cwd: anyNamed('cwd'), env: anyNamed('env'))).thenAnswer((_) async {});
  });

  Future<void> expectRan() async =>
      verify(right.output(cwd: anyNamed('cwd'), env: anyNamed('env'), input: anyNamed('input'))).called(1);

  void expectSkipped() =>
      verifyNever(right.output(cwd: anyNamed('cwd'), env: anyNamed('env'), input: anyNamed('input')));

  group('and, through output', () {
    test('runs the right side when the left succeeds', () async {
      await succeeding.and(right).output();
      await expectRan();
    });

    test('leaves the right side alone when the left fails', () async {
      await failing.and(right).output();
      expectSkipped();
    });

    test('reports the left status when it short-circuits', () async {
      final ShellResult result = await failing.and(right).output();
      expect(result.exitCode, 3);
    });

    test('reports the right status when both ran', () async {
      when(
        right.output(cwd: anyNamed('cwd'), env: anyNamed('env'), input: anyNamed('input')),
      ).thenAnswer((_) async => resultOf(exitCode: 4));

      final ShellResult result = await succeeding.and(right).output();
      expect(result.exitCode, 4);
    });

    test('names the whole chain in the result', () async {
      final ShellResult result = await failing.and(right).output();
      expect(result.command, 'sh -c exit 3 && right');
    });

    test('concatenates the output of both sides', () async {
      final ShellResult result = await Sh.c().script('echo left').and(right).output();
      expect(result.lines, <String>['left', 'right']);
    });
  });

  group('or, through output', () {
    test('runs the right side when the left fails', () async {
      await failing.or(right).output();
      await expectRan();
    });

    test('leaves the right side alone when the left succeeds', () async {
      await succeeding.or(right).output();
      expectSkipped();
    });

    test('reports the left status when it short-circuits', () async {
      final ShellResult result = await succeeding.or(right).output();
      expect(result.exitCode, 0);
    });
  });

  group('then, through output', () {
    test('runs the right side after a success', () async {
      await succeeding.then(right).output();
      await expectRan();
    });

    test('runs the right side after a failure too', () async {
      await failing.then(right).output();
      await expectRan();
    });

    test('takes its status from the right side, swallowing the left failure', () async {
      final ShellResult result = await failing.then(right).output();
      expect(result.exitCode, 0);
    });
  });

  group('and, through execute', () {
    test('runs the right side when the left succeeds', () async {
      await succeeding.and(right).execute();
      verify(right.execute(cwd: anyNamed('cwd'), env: anyNamed('env'))).called(1);
    });

    test('throws and never reaches the right side when the left fails', () async {
      await expectLater(failing.and(right).execute(), throwsA(isA<ShellException>()));
      verifyNever(right.execute(cwd: anyNamed('cwd'), env: anyNamed('env')));
    });
  });

  group('or, through execute', () {
    test('swallows the left failure and runs the right side', () async {
      await expectLater(failing.or(right).execute(), completes);
      verify(right.execute(cwd: anyNamed('cwd'), env: anyNamed('env'))).called(1);
    });

    test('returns without running the right side when the left succeeds', () async {
      await succeeding.or(right).execute();
      verifyNever(right.execute(cwd: anyNamed('cwd'), env: anyNamed('env')));
    });
  });

  group('then, through execute', () {
    test('runs the right side whatever the left did', () async {
      await failing.then(right).execute();
      verify(right.execute(cwd: anyNamed('cwd'), env: anyNamed('env'))).called(1);
    });
  });

  group('cwd and env travel down the chain', () {
    test('reach the right side of an and', () async {
      await succeeding.and(right).output(cwd: '/tmp', env: <String, String>{'A': 'b'});
      verify(right.output(cwd: '/tmp', env: <String, String>{'A': 'b'})).called(1);
    });

    test('input goes to whatever runs first, not to the right side', () async {
      await succeeding.and(right).output(input: 'fed');
      verify(right.output(cwd: anyNamed('cwd'), env: anyNamed('env'), input: null)).called(1);
    });
  });

  group('line', () {
    test('renders and as &&', () {
      expect(succeeding.and(right).line, 'sh -c exit 0 && right');
    });

    test('renders or as ||', () {
      expect(succeeding.or(right).line, 'sh -c exit 0 || right');
    });

    test('renders then as ;', () {
      expect(succeeding.then(right).line, 'sh -c exit 0 ; right');
    });

    test('nests left to right', () {
      expect(succeeding.and(right).or(right).line, 'sh -c exit 0 && right || right');
    });
  });

  test('a chain is deliberately not a pipe stage', () {
    expect(succeeding.and(right), isNot(isA<PipeStage>()));
  });
}
