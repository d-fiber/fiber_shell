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

import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'pipeline_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ShellCommand>()])
MockShellCommand commandOf(String executable, List<String> args) {
  final MockShellCommand command = MockShellCommand();
  when(command.executable).thenReturn(executable);
  when(command.args).thenReturn(args);
  return command;
}

void main() {
  late Directory workspace;
  late File log;

  setUp(() async {
    workspace = await Directory.systemTemp.createTemp('fiber_shell_test.');
    log = File('${workspace.path}/server.log');
    await log.writeAsString('INFO up\nERROR timeout\nWARN old\nERROR disk full\n');
  });

  tearDown(() => workspace.delete(recursive: true));

  group('output', () {
    test('wires stdout into the next stdin', () async {
      final ShellResult result = await (Grep.pattern('ERROR').file(log.path) | Grep.count().pattern('.')).output();
      expect(result.text, '2');
    });

    test('composes more than two stages, from the left', () async {
      final ShellResult result =
          await (Grep.pattern('ERROR').file(log.path) |
                  Sed.expression('s/ERROR //') |
                  Grep.invertMatch().pattern('timeout'))
              .output();
      expect(result.lines, <String>['disk full']);
    });

    test('feeds input to the head of the pipeline', () async {
      final ShellResult result = await (Sed.expression('s/a/A/') | Sed.expression(r's/$/!/')).output(input: 'abc\n');
      expect(result.text, 'Abc!');
    });

    test('runs every stage in cwd when one is given', () async {
      final ShellResult result = await (Find.path('.').maxDepth('1').name('*.log') | Grep.count().pattern('.')).output(
        cwd: workspace.path,
      );
      expect(result.text, '1');
    });
  });

  group('pipefail', () {
    test('reports zero when every stage succeeded', () async {
      final ShellResult result = await (Grep.pattern('ERROR').file(log.path) | Sed.expression('s/a/b/')).output();
      expect(result.exitCode, 0);
    });

    test('reports a failing first stage that a happy last stage would hide', () async {
      final ShellResult result =
          await (Grep.pattern('x').file('${workspace.path}/absent.log') | Sed.expression('s/a/b/')).output();
      expect(result.exitCode, 2);
    });

    test('takes the rightmost failure when several stages fail', () async {
      final ShellResult result = await (Sh.c().script('exit 1') | Sh.c().script('exit 4')).output();
      expect(result.exitCode, 4);
    });

    test('keeps the stderr of every stage', () async {
      final ShellResult result =
          await (Grep.pattern('x').file('${workspace.path}/absent.log') | Sed.expression('s/a/b/')).output();
      expect(result.error, contains('absent.log'));
    });

    test('holds only the last stage stdout', () async {
      final ShellResult result = await (Sh.c().script('echo first') | Sh.c().script('echo last')).output();
      expect(result.text, 'last');
    });
  });

  group('execute', () {
    test('returns normally when the pipeline succeeds', () {
      expect((Grep.pattern('ERROR').file(log.path) | Grep.count().pattern('.')).execute(), completes);
    });

    test('throws when a stage fails, naming the whole pipeline', () {
      expect(
        (Sh.c().script('exit 1') | Sh.c().script('exit 0')).execute(),
        throwsA(isA<ShellException>().having((ShellException error) => error.message, 'message', contains(' | '))),
      );
    });
  });

  group('writeTo', () {
    test('sends the last stage stdout into the file', () async {
      final File out = File('${workspace.path}/errors.txt');
      await (Grep.pattern('ERROR').file(log.path) | Sed.expression('s/ERROR //')).writeTo(out);
      expect(await out.readAsLines(), <String>['timeout', 'disk full']);
    });

    test('overwrites what was there before', () async {
      final File out = File('${workspace.path}/errors.txt');
      await out.writeAsString('stale content that is much longer\n');
      await (Grep.pattern('WARN').file(log.path)).writeTo(out);
      expect(await out.readAsString(), 'WARN old\n');
    });

    test('throws on a failing stage', () {
      final File out = File('${workspace.path}/errors.txt');
      expect((Sh.c().script('exit 1') | Sh.c().script('cat')).writeTo(out), throwsA(isA<ShellException>()));
    });
  });

  group('line', () {
    test('joins the stages with a pipe', () {
      expect((Grep.pattern('a').file('f') | Grep.count().pattern('.')).line, 'grep a f | grep -c .');
    });
  });

  group('any ShellCommand can be a stage', () {
    test('a pipeline built from mocks runs like any other', () async {
      final Pipeline pipeline = Pipeline(<ShellCommand>[
        commandOf('echo', <String>['hello']),
        commandOf('tr', <String>['a-z', 'A-Z']),
      ]);

      expect(pipeline.line, 'echo hello | tr a-z A-Z');
      expect((await pipeline.output()).text, 'HELLO');
    });

    test('an elevated command is a stage like the others', () {
      final Pipeline pipeline = Grep.pattern('root').file('/etc/passwd').asRoot() | Grep.count().pattern('.');
      expect(pipeline.stages, hasLength(2));
      expect(pipeline.line, endsWith('| grep -c .'));
    });
  });
}
