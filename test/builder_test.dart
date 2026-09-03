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

import 'package:fiber_shell/fiber_shell.dart';
import 'package:test/test.dart';

class ProbeCmd extends CommandBuilder<ProbeCmd> {
  @override
  final String executable = 'probe';

  ProbeCmd flag() => token('--flag');

  ProbeCmd separate(String value) => pair('--name', value);

  ProbeCmd attached(String value) => joined('--name', value);

  ProbeCmd list(List<String> values) => joinedAll('--allow', values);
}

// ignore: non_constant_identifier_names
ProbeCmd get Probe => ProbeCmd();

void main() {
  group('token helpers', () {
    test('token adds one argument untouched', () {
      expect(Probe.flag().args, <String>['--flag']);
    });

    test('pair adds two separate arguments', () {
      expect(Probe.separate('value').args, <String>['--name', 'value']);
    });

    test('joined adds a single name=value argument', () {
      expect(Probe.attached('value').args, <String>['--name=value']);
    });

    test('joinedAll comma-separates the values into one argument', () {
      expect(Probe.list(<String>['read', 'net']).args, <String>['--allow=read,net']);
    });

    test('a value containing a space stays one argument', () {
      expect(Probe.separate('two words').args, <String>['--name', 'two words']);
    });

    test('arguments keep the order they were added in', () {
      final ProbeCmd command = Probe.flag().separate('a').attached('b').flag();
      expect(command.args, <String>['--flag', '--name', 'a', '--name=b', '--flag']);
    });

    test('each access to the getter builds a fresh command', () {
      Probe.flag();
      expect(Probe.args, isEmpty);
    });
  });

  group('typing', () {
    test('every option returns the concrete wrapper', () {
      expect(Probe.flag().separate('a').attached('b'), isA<ProbeCmd>());
    });

    test('the wrapper is a command, a script and a pipe stage', () {
      final ProbeCmd command = Probe.flag();
      expect(command, isA<ShellCommand>());
      expect(command, isA<ShellScript>());
      expect(command, isA<PipeStage>());
    });
  });

  group('line', () {
    test('renders the executable and its arguments', () {
      expect(Probe.flag().separate('value').line, 'probe --flag --name value');
    });

    test('does not quote, so a spaced argument reads as two words', () {
      expect(Probe.separate('two words').line, 'probe --name two words');
    });

    test('renders an empty command as the executable alone', () {
      expect(Probe.line, 'probe');
    });
  });

  group('stages', () {
    test('a single command is one stage', () {
      final ProbeCmd command = Probe.flag();
      expect(command.stages, <ShellCommand>[command]);
    });

    test('the pipe operator builds a pipeline in order', () {
      final Pipeline pipeline = Probe.flag() | Probe.separate('a');
      expect(pipeline.stages, hasLength(2));
      expect(pipeline.line, 'probe --flag | probe --name a');
    });

    test('pipelines build up from the left', () {
      final Pipeline pipeline = Probe.flag() | Probe.attached('a') | Probe.list(<String>['x']);
      expect(pipeline.stages, hasLength(3));
      expect(pipeline.line, 'probe --flag | probe --name=a | probe --allow=x');
    });
  });

  group('asRoot', () {
    test('wraps the command without losing its arguments', () {
      final ElevatedCommand elevated = Probe.flag().separate('a').asRoot();
      expect(elevated.args, contains('--flag'));
      expect(elevated.args, contains('a'));
    });

    test('keeps the original command reachable', () {
      final ProbeCmd command = Probe.flag();
      expect(command.asRoot().command, same(command));
    });

    test('is still a pipe stage', () {
      final Pipeline pipeline = Probe.flag().asRoot() | Probe.separate('a');
      expect(pipeline.stages, hasLength(2));
    });
  });
}
