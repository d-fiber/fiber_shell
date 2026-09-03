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

/// `&&`, `||` and `;`, as methods.
///
/// Dart cannot overload `&&` and `||`: they short-circuit, which makes them
/// syntax rather than operators, and `&` already reads as "background" to
/// anyone who knows a shell. So they are named: [ShellScript.and],
/// [ShellScript.or] and [ShellScript.then].
Future<void> run(Directory workspace) async {
  final Directory sources = Directory('${workspace.path}/sources')..createSync(recursive: true);
  await File('${sources.path}/app.dart').writeAsString('void main() {}\n');
  final String release = '${workspace.path}/release';

  // `and` is `&&`: the copy only happens if the directory was created.
  final ShellScript deploy = Mkdir.parents()
      .path(release)
      .and(Cp.recursive().source(sources.path).destination(release));
  print('  \$ ${deploy.line}');
  await deploy.execute();
  print('  copied   : ${File('$release/sources/app.dart').existsSync()}');

  // `or` is `||`: the fallback only runs if the first one failed. Here neither
  // file has the pattern, so the pair reports the fallback's own status.
  final ShellResult token = await Grep.quiet()
      .pattern('token')
      .file('${workspace.path}/absent.env')
      .or(Grep.quiet().pattern('token').file('${sources.path}/app.dart'))
      .output();
  print('  fallback : exit ${token.exitCode}');

  // `then` is `;`: the second runs whatever happened, and its status is the
  // pair's. The `rm` below fails and says so on stderr; nobody cares.
  final ShellScript cleanup = Rm.path('$release/not-there').then(Mkdir.parents().path('$release/logs'));
  print('  \$ ${cleanup.line}');
  final ShellResult swallowed = await cleanup.output();
  print('  swallowed: exit ${swallowed.exitCode}');

  // A chain is deliberately not a pipe stage. A shell needs a subshell to pipe
  // out of one, and there is no reason to fake that here: pipe the stages,
  // chain the outcomes.
}
