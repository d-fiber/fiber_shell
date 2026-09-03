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

import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';

/// Pipes, wired between processes in Dart rather than handed to a shell.
Future<void> run(Directory workspace) async {
  final File log = File('${workspace.path}/server.log');
  await log.writeAsString(
    const <String>[
      '12:00:01 INFO  listening on :8080',
      '12:00:04 ERROR upstream timeout',
      '12:00:09 WARN  deprecated header',
      '12:00:12 ERROR upstream timeout',
      '12:00:20 ERROR disk full',
      '',
    ].join('\n'),
  );

  // Every stage starts at once and each stdout is wired into the next stdin,
  // exactly as a shell would, except the wiring is a Dart stream, so there is
  // no `sh -c` in the middle and no argument to escape.
  final Pipeline pipeline = Grep.pattern('ERROR').file(log.path) | Sed.expression('s/^[0-9:]* ERROR //');
  print('  \$ ${pipeline.line}');

  final ShellResult errors = await pipeline.output();
  print('  errors   : ${errors.lines}');

  // Pipelines build from the left, so a third stage is just another `|`.
  final ShellResult filtered =
      await (Grep.pattern('ERROR').file(log.path) |
              Sed.expression('s/^[0-9:]* ERROR //') |
              Grep.invertMatch().pattern('timeout'))
          .output();
  print('  filtered : ${filtered.lines}');

  // The status is the one `set -o pipefail` gives: the rightmost stage that
  // failed. Below, grep cannot open the file and sed is perfectly happy about
  // reading nothing; plain shell semantics would report 0 and hide the broken
  // first stage behind the successful last one.
  final ShellResult broken =
      await (Grep.pattern('ERROR').file('${workspace.path}/absent.log') | Sed.expression('s/a/b/')).output();
  print('  pipefail : exit ${broken.exitCode} for `${broken.command}`');

  // stdout of the last stage is in `bytes`; the stderr of every stage is kept
  // too, in order, so a failure in the middle is still readable.
  print('  stderr   : ${broken.error}');
}
