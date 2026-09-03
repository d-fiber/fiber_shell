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

/// `wc`, a wrapper the catalogue does not ship yet.
///
/// A wrapper is a class that names itself as its own type argument. That is
/// what keeps a chain typed: every option below returns `WcCmd` rather than the
/// base class, so the last call in a chain still knows what it is holding.
///
/// Four helpers cover the argument shapes command-line tools use:
///
/// - `token('-l')` for a bare flag
/// - `pair('-C', path)` when the value is its own argument
/// - `joined('--max-count', '5')` when the tool wants `--name=value`
/// - `joinedAll('--allow', <String>['read', 'net'])` for a comma-separated list
class WcCmd extends CommandBuilder<WcCmd> {
  @override
  final String executable = 'wc';

  /// Counts lines (`-l`).
  WcCmd lines() => token('-l');

  /// Counts words (`-w`).
  WcCmd words() => token('-w');

  /// Counts bytes (`-c`).
  WcCmd bytes() => token('-c');

  /// Adds a path to count.
  WcCmd file(String path) => token(path);
}

/// `wc`, ready to take its first option.
// ignore: non_constant_identifier_names
WcCmd get Wc => WcCmd();

/// Writing the wrapper the catalogue is missing.
Future<void> run(Directory workspace) async {
  final File log = File('${workspace.path}/audit.log');
  await log.writeAsString('ok\nok\nERROR broken\nok\nERROR broken again\n');

  final ShellResult counted = await Wc.lines().file(log.path).output();
  print('  wc says  : ${counted.text.split('/').first.trim()} lines');

  // The new wrapper composes with everything else from the moment it exists.
  // Pipes, chains, elevation, background jobs and `line` all come from the base
  // class, so there is nothing else to implement.
  final Pipeline errors = Grep.pattern('ERROR').file(log.path) | Wc.lines();
  print('  \$ ${errors.line}');
  print('  errors   : ${(await errors.output()).text.trim()}');

  // One thing to watch when naming options: `execute`, `output`, `writeTo`,
  // `line`, `asRoot`, `stages`, `token`, `pair`, `joined` and `joinedAll` are
  // already taken by the base class. Colliding with one is an invalid override,
  // so it fails to compile rather than misbehaving at runtime, which is how
  // curl's `-o` ended up as `outputFile()` in this package.
}
