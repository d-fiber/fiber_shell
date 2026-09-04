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

/// `stat`: prints file metadata, on every Unix — and the one wrapper in this
/// catalogue where BSD and GNU do not just add a few extra flags to a shared
/// core, they use almost entirely different letters for the same job. BSD's
/// custom-format flag is [bsdFormat] (`-f`, `printf`-style directives such as
/// `%N`, `%z`, `%Sm`); GNU's is [gnuFormat] (`-c`/`--format`, directives such as
/// `%n`, `%s`, `%y`). Passing a BSD-style format string to GNU stat, or the
/// reverse, silently prints garbage rather than failing loudly.
///
/// ```dart
/// // BSD/macOS: name and size.
/// await Stat.bsdFormat('%N %z').file(path).output();
///
/// // GNU/Linux: name and size.
/// await Stat.gnuFormat('%n %s').file(path).output();
/// ```
///
/// [dereference] (`-L`) is the one flag both flavours agree on. Everything else
/// is platform-specific and documented as such below; reach for [bsdFormat] or
/// [gnuFormat] with an explicit, tested format string rather than the bare
/// default output, which differs release to release and was never meant to be
/// parsed.
class StatCmd extends CommandBuilder<StatCmd> {
  @override
  final String executable = 'stat';

  /// Appends a slash, asterisk, `@`, `%`, `=` or `|` after each name the way
  /// `ls -F` would, and implies [lsFormat] (`-F`). BSD only.
  StatCmd displayType() => token('-F');

  /// Follows the target of a symbolic link instead of reporting on the link
  /// itself. Shared by BSD and GNU (`-L`/`--dereference`).
  StatCmd dereference() => token('-L');

  /// Displays fields using this BSD `printf`-style format string, e.g. `%N`
  /// (name), `%z` (size), `%Sp` (permissions), `%Sm` (modified, readable)
  /// (`-f`). BSD only — see [gnuFormat] for the Linux equivalent.
  StatCmd bsdFormat(String format) => pair('-f', format);

  /// Reports on the filesystem containing the file rather than the file itself
  /// (`-f`/`--file-system`). GNU only, and a bare flag there — unrelated to
  /// [bsdFormat], which happens to share the same letter on BSD.
  StatCmd fileSystem() => token('-f');

  /// Displays output in `ls -lT` format (`-l`). BSD only.
  StatCmd lsFormat() => token('-l');

  /// Omits the trailing newline after each piece of output (`-n`). BSD only.
  StatCmd noNewline() => token('-n');

  /// Suppresses failure messages from the underlying `stat`/`lstat` call
  /// (`-q`). BSD only.
  StatCmd quiet() => token('-q');

  /// Displays raw, numeric values for every field: times as seconds since the
  /// epoch, and so on (`-r`). BSD only.
  StatCmd rawInfo() => token('-r');

  /// Displays output as `name=value` pairs suitable for a shell `eval`
  /// (`-s`). BSD only.
  StatCmd shellOutput() => token('-s');

  /// Formats timestamps with this `strftime`-style format, used together with
  /// [bsdFormat]'s `%Sm`/`%Sa`/`%Sc`/`%SB` directives (`-t`). BSD only.
  StatCmd timeFormat(String format) => pair('-t', format);

  /// Displays output in the more verbose style some Linux distributions use
  /// (`-x`). BSD only.
  StatCmd verboseLinux() => token('-x');

  /// Displays fields using this GNU format string, e.g. `%n` (name), `%s`
  /// (size), `%A` (permissions, human), `%y` (modified, human) (`-c`/`--format`).
  /// GNU only — see [bsdFormat] for the BSD/macOS equivalent.
  StatCmd gnuFormat(String format) => pair('-c', format);

  /// Like [gnuFormat], but interprets backslash escapes and adds no trailing
  /// newline of its own (`--printf`). GNU only.
  StatCmd printfFormat(String format) => joined('--printf', format);

  /// Prints one line per file in a fixed, terse field order instead of the
  /// verbose default (`-t`/`--terse`). GNU only — a bare flag there, unrelated
  /// to [timeFormat], which happens to share the same letter on BSD.
  StatCmd terse() => token('-t');

  /// Controls whether cached attributes may be used on a remote filesystem:
  /// `always`, `never` or `default` (`--cached`). GNU only.
  StatCmd cached(String mode) => joined('--cached', mode);

  /// The file, directory or filesystem to report on. Repeat for several.
  StatCmd file(String path) => token(path);

  /// Prints the usage summary and exits (`--help`). GNU only.
  StatCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  StatCmd version() => token('--version');
}

/// `stat`, ready to take its first option.
// ignore: non_constant_identifier_names
StatCmd get Stat => StatCmd();
