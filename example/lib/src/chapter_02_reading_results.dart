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

/// What comes back from a command, and why a failure is a value here.
///
/// `execute()` throws on a non-zero status; `output()` never does. Reach for
/// `output()` whenever failing is one of the answers rather than an accident.
Future<void> run(Directory workspace) async {
  final File notes = File('${workspace.path}/notes.txt');
  await notes.writeAsString('alpha\nbeta\ngamma\n\ndelta\n');

  final ShellResult listed = await Grep.lineNumber().pattern('a').file(notes.path).output();
  print('  command  : ${listed.command}');
  print('  success  : ${listed.success}');
  print('  text     : ${listed.text.replaceAll('\n', ', ')}');
  print('  lines    : ${listed.lines.length} non-blank lines');
  print('  duration : ${listed.duration.inMilliseconds}ms');

  // A command that fails comes back through the same door, with its stderr
  // attached rather than thrown away.
  final ShellResult missing = await Grep.pattern('alpha').file('${workspace.path}/absent.txt').output();
  print('  failed   : ${missing.failed} (exit ${missing.exitCode})');
  print('  stderr   : ${missing.error}');

  // `textOrNull` folds "could not run" and "printed nothing" into the single
  // answer a lookup usually wants: no value.
  print('  fallback : ${missing.textOrNull ?? '<none>'}');

  // `orThrow()` is the other direction, for the cases with no sensible
  // fallback: the stderr becomes the message someone ends up reading.
  try {
    missing.orThrow();
  } on ShellException catch (error) {
    print('  orThrow  : $error');
  }

  // Output is kept as bytes and decoded on demand, so one type carries text and
  // binary alike: `openssl pkey -outform DER` writes a key, not a string.
  final ShellResult raw = await Find.path(workspace.path).type('f').output();
  print('  bytes    : ${raw.bytes.length} captured, decoded only when read');
}
