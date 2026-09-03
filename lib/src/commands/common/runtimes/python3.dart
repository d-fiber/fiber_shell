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

/// `python3`. The least portable assumption in this directory: some systems ship
/// only a stub that points at a developer toolchain, a slim container image often
/// has none at all, and the interpreter that does answer may be missing the
/// third-party module you need. Check with `commandExists`, and be ready for the
/// import to fail anyway.
///
/// ```dart
/// final ShellResult hash = await Python3
///     .evalCode('import bcrypt,sys; print(bcrypt.hashpw(sys.argv[1].encode(), bcrypt.gensalt(10)).decode())')
///     .scriptArg(password)
///     .output();
/// ```
///
/// That is the one real use for it: bcrypt, which Dart has no good pure
/// implementation of. Note the shape: the password travels as an argv value read
/// through `sys.argv`, never interpolated into the source string, so a quote in the
/// password cannot become code.
///
/// [evalCode] and [module] both end the option list: everything after them belongs
/// to the script.
class Python3Cmd extends CommandBuilder<Python3Cmd> {
  @override
  final String executable = 'python3';

  /// The program, passed as a string (`-c`). Ends the options.
  Python3Cmd evalCode(String code) => pair('-c', code);

  /// Runs a library module as a script (`-m`). Ends the options.
  Python3Cmd module(String name) => pair('-m', name);

  /// Warns when bytes and str are compared or converted (`-b`).
  Python3Cmd bytesWarning() => token('-b');

  /// Makes those warnings errors (`-bb`).
  Python3Cmd bytesError() => token('-bb');

  /// Writes no `.pyc` files on import (`-B`).
  Python3Cmd dontWriteBytecode() => token('-B');

  /// Turns on parser debugging (`-d`). Debug builds only.
  Python3Cmd parserDebug() => token('-d');

  /// Ignores the `PYTHON*` environment variables (`-E`).
  Python3Cmd ignoreEnvironment() => token('-E');

  /// Prints the usage summary (`-h`).
  Python3Cmd help() => token('-h');

  /// Drops into the interpreter once the script is done (`-i`).
  Python3Cmd inspect() => token('-i');

  /// Isolates from the user environment, implying `-E`, `-P` and `-s` (`-I`).
  ///
  /// The flag to reach for when the script must not depend on the machine it runs on.
  Python3Cmd isolated() => token('-I');

  /// Drops `assert` and `__debug__` branches (`-O`).
  Python3Cmd optimize() => token('-O');

  /// The same, plus docstrings (`-OO`).
  Python3Cmd optimizeMore() => token('-OO');

  /// Keeps the script directory off `sys.path` (`-P`).
  Python3Cmd safePath() => token('-P');

  /// Skips the version banner on an interactive start (`-q`).
  Python3Cmd quiet() => token('-q');

  /// Keeps the user site directory off `sys.path` (`-s`).
  Python3Cmd noUserSite() => token('-s');

  /// Skips `import site` entirely (`-S`).
  Python3Cmd noSite() => token('-S');

  /// Leaves stdout and stderr unbuffered (`-u`).
  ///
  /// Worth it when the output is piped and you want it as it comes.
  Python3Cmd unbuffered() => token('-u');

  /// Traces each import (`-v`). Repeatable for more.
  Python3Cmd verbose() => token('-v');

  /// Prints the version and exits (`-V`).
  Python3Cmd version() => token('-V');

  /// Adds a warning filter, `action:message:category:module:lineno` (`-W`).
  Python3Cmd warning(String value) => pair('-W', value);

  /// Skips the first line of the source, for non-Unix shebangs (`-x`).
  Python3Cmd skipFirstLine() => token('-x');

  /// Sets an implementation-specific option (`-X`).
  Python3Cmd implementationOption(String value) => pair('-X', value);

  /// How to validate hash-based `.pyc` files: `always`, `default` or `never`.
  Python3Cmd checkHashBasedPycs(String mode) => pair('--check-hash-based-pycs', mode);

  /// Explains the environment variables and exits (`--help-env`).
  Python3Cmd helpEnv() => token('--help-env');

  /// Explains the `-X` options and exits (`--help-xoptions`).
  Python3Cmd helpXOptions() => token('--help-xoptions');

  /// Prints the complete help and exits (`--help-all`).
  Python3Cmd helpAll() => token('--help-all');

  /// Reads the program from stdin (`-`).
  Python3Cmd stdin() => token('-');

  /// The script file to run.
  Python3Cmd file(String path) => token(path);

  /// Adds an argument for the script, landing in its `sys.argv`.
  Python3Cmd scriptArg(String value) => token(value);
}

/// `python3`, ready to take its first option.
// ignore: non_constant_identifier_names
Python3Cmd get Python3 => Python3Cmd();
