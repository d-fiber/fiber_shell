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

/// `sh`, the POSIX shell: a name rather than a program. On macOS it re-execs
/// whichever shell the system has selected, running in POSIX mode; on Linux it is
/// usually a link to dash, which is deliberately small and lacks the bash
/// extensions people reach for by habit.
///
/// ```dart
/// final ShellResult r = await Sh.c().script('command -v docker').output();
/// ```
///
/// What you actually get is therefore a per-machine question, so keep the script
/// to plain POSIX. Anything needing bash should say [Bash] out loud.
class ShCmd extends CommandBuilder<ShCmd> {
  @override
  final String executable = 'sh';

  /// Reads the program from the next argument rather than a file (`-c`).
  ShCmd c() => token('-c');

  /// Runs interactive (`-i`).
  ShCmd interactive() => token('-i');

  /// Behaves as a login shell (`-l`).
  ShCmd login() => token('-l');

  /// Runs restricted (`-r`).
  ShCmd restricted() => token('-r');

  /// Reads commands from stdin (`-s`).
  ShCmd readStdin() => token('-s');

  /// Turns a `set -o` option on (`-o`).
  ShCmd optionEnable(String name) => pair('-o', name);

  /// Turns a `set -o` option off (`+o`).
  ShCmd optionDisable(String name) => pair('+o', name);

  /// Exports every variable that gets assigned (`-a`).
  ShCmd allexport() => token('-a');

  /// Reports a finished background job at once (`-b`).
  ShCmd notify() => token('-b');

  /// Exits on the first command that fails (`-e`).
  ShCmd errexit() => token('-e');

  /// Turns off filename expansion (`-f`).
  ShCmd noglob() => token('-f');

  /// Stops remembering where commands live (`-h`).
  ShCmd noHashing() => token('-h');

  /// Turns job control on (`-m`).
  ShCmd monitor() => token('-m');

  /// Reads the commands without running them (`-n`).
  ShCmd noexec() => token('-n');

  /// Treats an unset variable as an error (`-u`).
  ShCmd nounset() => token('-u');

  /// Echoes each line as it is read (`-v`).
  ShCmd verbose() => token('-v');

  /// Echoes each command as it is run (`-x`).
  ShCmd xtrace() => token('-x');

  /// Refuses to overwrite a file through `>` (`-C`).
  ShCmd noclobber() => token('-C');

  /// Ends the options (`--`).
  ShCmd endOfOptions() => token('--');

  /// The program text, right after [c].
  ShCmd script(String value) => token(value);

  /// The script file to run.
  ShCmd file(String path) => token(path);

  /// Adds an argument for the script, landing in its `$1`, `$2` and so on.
  ShCmd scriptArg(String value) => token(value);
}

/// `sh`, ready to take its first option.
// ignore: non_constant_identifier_names
ShCmd get Sh => ShCmd();
