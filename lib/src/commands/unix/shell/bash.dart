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

/// `bash`. Present on every Unix, but not at the same age everywhere: macOS
/// still ships the last release made under the old licence, while Linux
/// distributions carry a current one, and a machine may have both with `PATH`
/// deciding. So a script using associative arrays or `${var^^}` can work on one
/// box and break on the next.
///
/// ```dart
/// await Bash.c().script('set -euo pipefail; make release').execute(cwd: repo);
/// ```
///
/// Prefer [ShellScript] composition to a `bash -c` string: `|`, `&&` and friends
/// are already there, without the quoting. This wrapper is for the cases where the
/// script really is a script.
class BashCmd extends CommandBuilder<BashCmd> {
  @override
  final String executable = 'bash';

  /// Reads the program from the next argument rather than a file (`-c`).
  BashCmd c() => token('-c');

  /// Runs interactive, prompts and all (`-i`).
  BashCmd interactive() => token('-i');

  /// Behaves as a login shell, so the profile files are read (`--login`).
  BashCmd login() => token('--login');

  /// Runs restricted: no `cd`, no absolute command paths, no redirections (`--restricted`).
  BashCmd restricted() => token('--restricted');

  /// Reads commands from stdin (`-s`).
  BashCmd readStdin() => token('-s');

  /// Dumps the translatable `$"..."` strings and exits (`-D`).
  BashCmd dumpTranslatable() => token('-D');

  /// Turns a `shopt` option on (`-O`).
  BashCmd shoptEnable(String name) => pair('-O', name);

  /// Turns a `shopt` option off (`+O`).
  BashCmd shoptDisable(String name) => pair('+O', name);

  /// Turns a `set -o` option on, `pipefail` and the like (`-o`).
  BashCmd optionEnable(String name) => pair('-o', name);

  /// Turns a `set -o` option off (`+o`).
  BashCmd optionDisable(String name) => pair('+o', name);

  /// Exports every variable that gets assigned (`-a`).
  BashCmd allexport() => token('-a');

  /// Reports a finished background job at once, not at the next prompt (`-b`).
  BashCmd notify() => token('-b');

  /// Exits on the first command that fails (`-e`).
  BashCmd errexit() => token('-e');

  /// Turns off filename expansion (`-f`).
  BashCmd noglob() => token('-f');

  /// Stops remembering where commands live (`-h`).
  BashCmd noHashing() => token('-h');

  /// Puts keyword arguments in the environment of the command (`-k`).
  BashCmd keyword() => token('-k');

  /// Turns job control on (`-m`).
  BashCmd monitor() => token('-m');

  /// Reads the commands without running them, so a syntax check (`-n`).
  BashCmd noexec() => token('-n');

  /// Ignores the startup files and the inherited functions (`-p`).
  BashCmd privileged() => token('-p');

  /// Exits after one command (`-t`).
  BashCmd onecmd() => token('-t');

  /// Treats an unset variable as an error (`-u`).
  BashCmd nounset() => token('-u');

  /// Echoes each line as it is read (`-v`).
  BashCmd verbose() => token('-v');

  /// Echoes each command as it is run, expanded (`-x`).
  BashCmd xtrace() => token('-x');

  /// Turns brace expansion on (`-B`).
  BashCmd braceExpand() => token('-B');

  /// Refuses to overwrite a file through `>` (`-C`).
  BashCmd noclobber() => token('-C');

  /// Lets functions and subshells inherit the `ERR` trap (`-E`).
  BashCmd errtrace() => token('-E');

  /// Turns `!` history expansion on (`-H`).
  BashCmd histexpand() => token('-H');

  /// Resolves symlinks when changing directory (`-P`).
  BashCmd physical() => token('-P');

  /// Lets functions and subshells inherit the `DEBUG` and `RETURN` traps (`-T`).
  BashCmd functrace() => token('-T');

  /// Turns the debugger profile on (`--debug`).
  BashCmd debug() => token('--debug');

  /// Loads the debugger profile before the script (`--debugger`).
  BashCmd debugger() => token('--debugger');

  /// Dumps the translatable strings in GNU gettext PO format (`--dump-po-strings`).
  BashCmd dumpPoStrings() => token('--dump-po-strings');

  /// The same dump as [dumpTranslatable] (`--dump-strings`).
  BashCmd dumpStrings() => token('--dump-strings');

  /// Prints the usage summary (`--help`).
  BashCmd help() => token('--help');

  /// Reads this file instead of `~/.bashrc` when interactive (`--init-file`).
  BashCmd initFile(String path) => pair('--init-file', path);

  /// The same as [initFile] under its other name (`--rcfile`).
  BashCmd rcfile(String path) => pair('--rcfile', path);

  /// Drops readline, so no line editing (`--noediting`).
  BashCmd noediting() => token('--noediting');

  /// Skips the system and user profile files (`--noprofile`).
  BashCmd noprofile() => token('--noprofile');

  /// Skips `~/.bashrc` (`--norc`).
  BashCmd norc() => token('--norc');

  /// Follows POSIX where bash normally differs (`--posix`).
  BashCmd posix() => token('--posix');

  /// Reprints the script in canonical form instead of running it (`--pretty-print`).
  BashCmd prettyPrint() => token('--pretty-print');

  /// Prints the version and exits (`--version`).
  BashCmd version() => token('--version');

  /// Ends the options (`--`).
  BashCmd endOfOptions() => token('--');

  /// The program text, right after [c].
  BashCmd script(String value) => token(value);

  /// The script file to run.
  BashCmd file(String path) => token(path);

  /// Adds an argument for the script, landing in its `$1`, `$2` and so on.
  BashCmd scriptArg(String value) => token(value);
}

/// `bash`, ready to take its first option.
// ignore: non_constant_identifier_names
BashCmd get Bash => BashCmd();
