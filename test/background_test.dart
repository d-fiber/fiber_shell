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
import 'package:test/test.dart';

void main() {
  group('background', () {
    test('comes back before the job is finished', () async {
      final BackgroundJob job = await Sh.c().script('sleep 1; echo done').background();
      expect(job.pid, greaterThan(0));

      final ShellResult result = await job.wait();
      expect(result.text, 'done');
      expect(result.success, isTrue);
    });

    test('collects the output while nobody is looking', () async {
      final BackgroundJob job = await Sh.c().script('echo early').background();
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect((await job.wait()).text, 'early');
    });

    test('wait is safe to call more than once', () async {
      final BackgroundJob job = await Sh.c().script('echo once').background();
      final ShellResult first = await job.wait();
      final ShellResult second = await job.wait();
      expect(first.text, second.text);
      expect(first.exitCode, second.exitCode);
    });

    test('reports the status of a job that failed', () async {
      final BackgroundJob job = await Sh.c().script('exit 7').background();
      expect((await job.wait()).exitCode, 7);
    });

    test('times how long the job ran', () async {
      final BackgroundJob job = await Sh.c().script('sleep 1').background();
      expect((await job.wait()).duration, greaterThan(const Duration(milliseconds: 500)));
    });
  });

  group('kill', () {
    test('stops the job and reports it took the signal', () async {
      final BackgroundJob job = await Sh.c().script('exec sleep 30').background();
      expect(job.kill(), isTrue);

      final ShellResult result = await job.wait();
      expect(result.success, isFalse);
    });

    test('wait still returns after a kill', () async {
      final BackgroundJob job = await Sh.c().script('exec sleep 30').background();
      job.kill();
      expect(job.wait(), completes);
    });

    test('takes the signal it is given', () async {
      final BackgroundJob job = await Sh.c().script('exec sleep 30').background();
      expect(job.kill(ProcessSignal.sigkill), isTrue);
      expect((await job.wait()).failed, isTrue);
    });
  });

  group('a pipeline in the background', () {
    test('runs every stage and reports the last one output', () async {
      final BackgroundJob job = await (Sh.c().script('echo piped') | Sh.c().script('cat')).background();
      expect(job.pid, greaterThan(0));
      expect((await job.wait()).text, 'piped');
    });
  });

  group('waiting for a job to be ready', () {
    test('waitUntil sees the flag the job drops', () async {
      final Directory workspace = await Directory.systemTemp.createTemp('fiber_shell_test.');
      addTearDown(() => workspace.delete(recursive: true));
      final File ready = File('${workspace.path}/ready');

      final BackgroundJob job = await Sh.c().script('sleep 1; : > "${ready.path}"; exec sleep 30').background();
      addTearDown(job.kill);

      expect(await waitUntil(<String>['test', '-f', ready.path], interval: 1, timeout: 15), isTrue);
    });
  });
}
