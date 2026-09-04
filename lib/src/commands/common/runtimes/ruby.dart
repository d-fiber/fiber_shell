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

/// `ruby`, the reference Ruby interpreter, alongside [NodeCmd], [Python3Cmd],
/// [DenoCmd] and [BunCmd] in this catalogue's `runtimes/` family.
///
/// ```dart
/// final ShellResult greeting = await Ruby.eval("puts 'hi'").output();
///
/// await Ruby.warnings().require('json').file('script.rb').execute();
/// ```
///
/// [eval] is the scriptable entry point — pass Ruby source directly, no file
/// needed, the way `python3 -c` and `node -e` do for their own runtimes.
/// [autosplit] and [nAutoprint] only do anything paired with [pattern] and read
/// from stdin line by line, the `awk`-flavoured mode Perl popularised; they are
/// rarely what a one-shot script wants. [inPlace] without an extension edits
/// files with no backup, so a mistake in the script is permanent — pass one to
/// keep the original.
class RubyCmd extends CommandBuilder<RubyCmd> {
  @override
  final String executable = 'ruby';

  /// Sets the input record separator; `\0` if no value is given (`-0[octal]`).
  RubyCmd recordSeparator([String? octal]) => token('-0${octal ?? ''}');

  /// Enables autosplit mode with [nAutoprint]/`-p`: splits `$_` into `$F` on each line (`-a`).
  RubyCmd autosplit() => token('-a');

  /// Changes to this directory before running the script (`-C`).
  RubyCmd chdir(String directory) => pair('-C', directory);

  /// Checks syntax only, without running the script (`-c`).
  RubyCmd checkSyntax() => token('-c');

  /// Sets `$DEBUG` to `true` (`-d`, `--debug`).
  RubyCmd debug() => token('-d');

  /// Sets the default external and, optionally, internal character encodings (`-E`, `--encoding`).
  RubyCmd encoding(String external, [String? internal]) =>
      pair('-E', internal == null ? external : '$external:$internal');

  /// The `split()` pattern used by [autosplit] (`-F`).
  RubyCmd pattern(String value) => pair('-F', value);

  /// Edits files named in `ARGV` in place; pass an extension to keep a backup under that suffix (`-i`).
  RubyCmd inPlace([String? extension]) => token('-i${extension ?? ''}');

  /// Adds a directory to `$LOAD_PATH`. Repeatable (`-I`).
  RubyCmd loadPath(String directory) => pair('-I', directory);

  /// Enables automatic line-ending processing (`-l`).
  RubyCmd lineEndings() => token('-l');

  /// Wraps the script in `while gets(); ... end`, reading stdin/`ARGV` files line by line (`-n`).
  RubyCmd nAutoprint() => token('-n');

  /// Like [nAutoprint], but also prints `$_` each iteration, `sed`-style (`-p`).
  RubyCmd printEachLine() => token('-p');

  /// Requires a library before running the script. Repeatable (`-r`).
  RubyCmd require(String library) => pair('-r', library);

  /// Enables switch parsing for arguments after the script name, exposed to the script as globals (`-s`).
  RubyCmd parseScriptSwitches() => token('-s');

  /// Looks up the script using `$PATH` instead of taking it as a literal path (`-S`).
  RubyCmd searchPath() => token('-S');

  /// Turns on tainting checks at the given level; default 1 (`-T`).
  RubyCmd taint([int level = 1]) => token('-T$level');

  /// Prints the version, then turns on verbose mode for the rest of the run (`-v`).
  RubyCmd verboseVersion() => token('-v');

  /// Turns on warnings for the script (`-w`).
  RubyCmd warnings() => token('-w');

  /// Sets the warning level: `0` silence, `1` medium, `2` verbose (`-W`).
  RubyCmd warningLevel(int level) => token('-W$level');

  /// Strips text before a `#!ruby` line, optionally changing to a directory first (`-x`).
  RubyCmd stripShebang([String? directory]) => token('-x${directory ?? ''}');

  /// Enables JIT compilation with default options — experimental (`--jit`).
  RubyCmd jit() => token('--jit');

  /// Enables JIT compilation with one specific option — experimental (`--jit-<option>`).
  RubyCmd jitOption(String option) => token('--jit-$option');

  /// Prints the JIT-warning messages (`--jit-warnings`).
  RubyCmd jitWarnings() => token('--jit-warnings');

  /// Enables (very slow) JIT debugging (`--jit-debug`).
  RubyCmd jitDebug() => token('--jit-debug');

  /// Waits for JIT compilation to finish on every call, for testing (`--jit-wait`).
  RubyCmd jitWait() => token('--jit-wait');

  /// Saves JIT temporary files under `$TMP`/`/tmp`, for testing (`--jit-save-temps`).
  RubyCmd jitSaveTemps() => token('--jit-save-temps');

  /// Sets the JIT log verbosity printed to stderr; default 0 (`--jit-verbose`).
  RubyCmd jitVerbose(int level) => joined('--jit-verbose', '$level');

  /// Caps the number of methods JIT-compiled at once; default 1000 (`--jit-max-cache`).
  RubyCmd jitMaxCache(int count) => joined('--jit-max-cache', '$count');

  /// Sets how many calls trigger JIT compilation, for testing; default 5 (`--jit-min-calls`).
  RubyCmd jitMinCalls(int count) => joined('--jit-min-calls', '$count');

  /// Prints the interpreter's copyright and exits (`--copyright`).
  RubyCmd copyright() => token('--copyright');

  /// Dumps internal debug information: `insns`, `yydebug`, `parsetree` or `parsetree_with_comment` (`--dump`).
  RubyCmd dump(String what) => joined('--dump', what);

  /// Enables one or more comma-separated features: `gems`, `did_you_mean`, `rubyopt`, `frozen-string-literal`, `jit` (`--enable`).
  RubyCmd enable(String features) => joined('--enable', features);

  /// Disables one or more comma-separated features, the negation of [enable] (`--disable`).
  RubyCmd disable(String features) => joined('--disable', features);

  /// Sets the default external character encoding (`--external-encoding`).
  RubyCmd externalEncoding(String value) => joined('--external-encoding', value);

  /// Sets the default internal character encoding (`--internal-encoding`).
  RubyCmd internalEncoding(String value) => joined('--internal-encoding', value);

  /// Turns on verbose mode and disables reading a script from stdin (`--verbose`).
  RubyCmd verboseFlag() => token('--verbose');

  /// Prints the version number and exits (`--version`).
  RubyCmd versionFlag() => token('--version');

  /// Prints the full help message and exits (`--help`).
  RubyCmd help() => token('--help');

  /// One line of script (`-e`). Repeatable; omits the need for [file].
  RubyCmd eval(String command) => pair('-e', command);

  /// Ends option parsing, so everything after is the script file and its own arguments (`--`).
  RubyCmd endOfOptions() => token('--');

  /// The script file to run, when not using [eval].
  RubyCmd file(String path) => token(path);

  /// An argument passed through to the script as `ARGV`.
  RubyCmd arg(String value) => token(value);
}

/// `ruby`, ready to take its first option.
// ignore: non_constant_identifier_names
RubyCmd get Ruby => RubyCmd();
