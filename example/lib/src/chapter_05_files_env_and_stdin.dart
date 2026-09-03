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

/// Where the output goes, where the input comes from, what the process sees.
Future<void> run(Directory workspace) async {
  final Directory sources = Directory('${workspace.path}/sources')..createSync(recursive: true);
  for (final String name in const <String>['app.dart', 'model.dart', 'README.md']) {
    await File('${sources.path}/$name').writeAsString('// $name\n');
  }

  // `writeTo` sends stdout into a file, the way `>` does. The redirection is
  // Dart's, so the destination is a path rather than a piece of shell syntax.
  //
  // Note the glob: `*.dart` reaches find untouched, because there is no shell
  // in front of it to expand it against the current directory first.
  final File inventory = File('${workspace.path}/inventory.txt');
  await Find.path(sources.path).type('f').name('*.dart').writeTo(inventory);
  print('  inventory: ${(await inventory.readAsLines()).length} files');

  // `input` feeds stdin. Some tools take their secret no other way. GNOME's
  // `secret-tool store` is the usual reason this parameter exists.
  final ShellResult framed = await Sed.expression('s/.*/[&]/').output(input: 'alpha\nbeta\n');
  print('  stdin    : ${framed.lines}');

  // `cwd` and `env` are per-run and available on every runner. Nothing leaks in
  // from a shell you did not start; what you pass is merged over the process's
  // own environment.
  final ShellResult located = await Find.path('.').maxDepth('1').name('*.dart').output(cwd: sources.path);
  print('  cwd      : ${located.lines.length} matches relative to sources/');

  final ShellResult greeted = await Sh.c()
      .script(r'echo "$GREETING from $(basename $(pwd))"')
      .output(cwd: sources.path, env: <String, String>{'GREETING': 'hello'});
  print('  env      : ${greeted.text}');

  // That last one used the `sh` wrapper, which exists for the times you
  // genuinely want a shell program. The difference from every other library is
  // that you chose it: nothing above this line went through one.

  // And before running something that may simply not be installed:
  print('  docker   : ${await commandExists('docker') ? 'available' : 'not on this machine'}');
}
