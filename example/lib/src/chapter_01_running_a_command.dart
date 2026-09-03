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

/// Building a command, looking at it, then running it.
///
/// The three ideas the rest of the library rests on are all here: one method is
/// one option, the chain stays typed to the end, and nothing runs until asked.
Future<void> run(Directory workspace) async {
  final String artifacts = '${workspace.path}/build/artifacts';

  // Nothing has happened yet. `Mkdir` hands back a fresh builder, and every
  // option returns that same builder, so a chain only collects arguments.
  final MkdirCmd command = Mkdir.parents().path(artifacts);

  // `line` renders the command the way a terminal would show it, without
  // running it. This is all a `--dry-run` flag needs to be.
  print('  \$ ${command.line}');

  // `execute()` runs it with stdio inherited, so whatever the command prints
  // lands straight in this terminal. A non-zero status throws ShellException.
  await command.execute();
  print('  created  : ${Directory(artifacts).existsSync()}');

  // Each argument is passed as its own argument, never pasted into a string.
  // A space and a pair of parentheses in a path are just characters here: there
  // is no shell to quote them for.
  final String awkward = '$artifacts/report final (v2).txt';
  await File(awkward).writeAsString('done\n');
  final ShellResult found = await Find.path(artifacts).type('f').output();
  print('  found    : ${found.text.split('/').last}');

  // A status that was never going to be zero is not an accident, so it is not
  // always worth an exception. Chapter 2 is about the other runner; this is the
  // shape `execute()` takes when a command does fail.
  try {
    await Mkdir.path(artifacts).execute();
  } on ShellException catch (error) {
    print('  refused  : $error');
  }
}
