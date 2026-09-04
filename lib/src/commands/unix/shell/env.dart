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

import '../../../builder.dart';

/// `env`: prints the environment, or runs another program under a modified one.
/// POSIX-standard, present on every Unix; the flags beyond the bare POSIX form
/// are BSD extensions (this wrapper follows the BSD/macOS flag set, which is a
/// subset of GNU's — GNU env additionally answers `--split-string`, `-C`/`-u`
/// under long names, and a handful of other long-only options this class omits).
///
/// ```dart
/// final ShellResult r = await Env.unset('DEBUG').set('CI', '1').command('make').arg('test').output();
/// ```
///
/// With no `utility`, `env` prints every variable in its environment and exits;
/// give it one and every `name=value` pair set beforehand is added on top of the
/// inherited environment, not in place of it — reach for [ignoreEnvironment] when
/// the child must see nothing but what was explicitly set.
class EnvCmd extends CommandBuilder<EnvCmd> {
  @override
  final String executable = 'env';

  /// Ends each printed line with NUL instead of newline, when printing the
  /// environment with no `utility` given (`-0`).
  EnvCmd nullTerminated() => token('-0');

  /// Runs `utility` with only the `name=value` pairs given here; the inherited
  /// environment is otherwise ignored completely (`-i`).
  EnvCmd ignoreEnvironment() => token('-i');

  /// Changes to `dir` before running `utility` (`-C`).
  EnvCmd changeDirectory(String dir) => pair('-C', dir);

  /// Searches `path` for `utility` instead of `$PATH` (`-P`).
  EnvCmd searchPath(String path) => pair('-P', path);

  /// Splits `value` into several arguments the way a `#!/usr/bin/env -S ...`
  /// shebang line does, honouring quotes and a handful of backslash escapes
  /// (`-S`).
  EnvCmd splitString(String value) => pair('-S', value);

  /// Removes `name` from the environment before anything else runs (`-u`).
  EnvCmd unset(String name) => pair('-u', name);

  /// Prints each step `env` takes as it builds the environment and looks up
  /// `utility`; repeatable for more detail (`-v`).
  EnvCmd verbose() => token('-v');

  /// Sets `name` to `value` in the child's environment.
  EnvCmd set(String name, String value) => token('$name=$value');

  /// The program to run after the environment has been set up.
  EnvCmd command(String executable) => token(executable);

  /// Adds one argument for [command]. Repeat for several, in order.
  EnvCmd arg(String value) => token(value);
}

/// `env`, ready to take its first option.
// ignore: non_constant_identifier_names
EnvCmd get Env => EnvCmd();
