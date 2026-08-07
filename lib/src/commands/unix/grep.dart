// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

/// `grep`, the pattern matcher, on every Unix. BSD on the macOS and BSD side,
/// GNU on Linux; the BSD one calls itself GNU compatible and mostly is.
///
/// ```dart
/// final ShellResult found = await Grep.quiet().fixedStrings().lineRegexp().pattern(line).file(rc.path).output();
/// if (found.failed) { /* not there yet */ }
/// ```
///
/// Exit status is the whole point of the tool: `0` matched, `1` matched nothing,
/// above that something broke. So [output] and [ShellResult.success] rather than
/// [execute], which would throw on the perfectly ordinary "no match".
///
/// Watch the flavours. [bzip2], [lzma], [xz], [decompress], [followListedLinks],
/// [noFollowLinks] and [followAllLinks] are BSD; GNU grep answers `-P` for Perl
/// regexes, which BSD has never had. [extendedRegexp] and [fixedStrings] are the
/// portable way to say what you mean.
class GrepCmd extends CommandBuilder<GrepCmd> {
  @override
  final String executable = 'grep';

  /// Prints this many lines after each match (`-A`).
  GrepCmd afterContext(int lines) => pair('-A', '$lines');

  /// Prints this many lines before each match (`-B`).
  GrepCmd beforeContext(int lines) => pair('-B', '$lines');

  /// Prints this many lines either side of each match (`-C`).
  GrepCmd context(int lines) => pair('-C', '$lines');

  /// Treats every file as text, binary or not (`-a`).
  GrepCmd text() => token('-a');

  /// Prefixes each match with its byte offset (`-b`).
  GrepCmd byteOffset() => token('-b');

  /// Prints how many lines matched instead of the lines (`-c`).
  GrepCmd count() => token('-c');

  /// Marks up the matches: `never`, `always` or `auto` (`--color`).
  GrepCmd color(String when) => joined('--color', when);

  /// What to do with devices, FIFOs and sockets: `read` or `skip` (`-D`).
  GrepCmd devices(String action) => pair('-D', action);

  /// What to do with directories: `read`, `skip` or `recurse` (`-d`).
  GrepCmd directories(String action) => pair('-d', action);

  /// Reads the pattern as an extended regular expression, `egrep` style (`-E`).
  GrepCmd extendedRegexp() => token('-E');

  /// Adds a pattern (`-e`). Repeatable, and the only way to pass one starting with a dash.
  GrepCmd regexp(String value) => pair('-e', value);

  /// Skips the files whose path matches this glob (`--exclude`).
  GrepCmd exclude(String glob) => joined('--exclude', glob);

  /// Under [recursive], skips the directories matching this glob (`--exclude-dir`).
  GrepCmd excludeDir(String glob) => joined('--exclude-dir', glob);

  /// Reads the pattern as a plain string, no regex at all, `fgrep` style (`-F`).
  GrepCmd fixedStrings() => token('-F');

  /// Reads the patterns from this file, one per line (`-f`).
  GrepCmd patternFile(String path) => pair('-f', path);

  /// Reads the pattern as a basic regular expression, the default (`-G`).
  GrepCmd basicRegexp() => token('-G');

  /// Always prefixes the filename, even for a single file (`-H`).
  GrepCmd withFilename() => token('-H');

  /// Never prefixes the filename (`-h`).
  GrepCmd noFilename() => token('-h');

  /// Prints the usage summary (`--help`).
  GrepCmd help() => token('--help');

  /// Skips binary files outright (`-I`).
  GrepCmd ignoreBinary() => token('-I');

  /// Matches without regard to case (`-i`).
  GrepCmd ignoreCase() => token('-i');

  /// Searches only the files whose path matches this glob (`--include`).
  GrepCmd include(String glob) => joined('--include', glob);

  /// Under [recursive], searches only the directories matching this glob (`--include-dir`).
  GrepCmd includeDir(String glob) => joined('--include-dir', glob);

  /// Decompresses bzip2 files on the way in (`-J`). BSD only.
  GrepCmd bzip2() => token('-J');

  /// Prints the names of the files that matched nothing (`-L`).
  GrepCmd filesWithoutMatch() => token('-L');

  /// Prints the names of the files that matched, and stops reading each at its first hit (`-l`).
  GrepCmd filesWithMatches() => token('-l');

  /// The name to print instead of `(standard input)` (`--label`).
  GrepCmd label(String value) => joined('--label', value);

  /// Reads with `mmap` (`--mmap`). Faster sometimes, undefined behaviour others.
  GrepCmd mmap() => token('--mmap');

  /// Decompresses LZMA files on the way in (`-M`). BSD only.
  GrepCmd lzma() => token('-M');

  /// Stops reading a file after this many matches (`-m`).
  GrepCmd maxCount(int value) => pair('-m', '$value');

  /// Prefixes each match with its line number (`-n`).
  GrepCmd lineNumber() => token('-n');

  /// Ends each printed filename with a NUL rather than a newline (`--null`).
  GrepCmd nullByte() => token('--null');

  /// Under [recursive], follows only the symlinks named on the command line (`-O`).
  GrepCmd followListedLinks() => token('-O');

  /// Prints the matching part rather than the whole line (`-o`).
  GrepCmd onlyMatching() => token('-o');

  /// Under [recursive], follows no symlink, which is the default (`-p`).
  GrepCmd noFollowLinks() => token('-p');

  /// Prints nothing and stops at the first match (`-q`). The status carries the answer.
  GrepCmd quiet() => token('-q');

  /// Walks into the directories listed (`-r`).
  GrepCmd recursive() => token('-r');

  /// The same walk under its other spelling (`-R`).
  GrepCmd recursiveFollow() => token('-R');

  /// Under [recursive], follows every symlink (`-S`).
  GrepCmd followAllLinks() => token('-S');

  /// Says nothing about files that are missing or unreadable (`-s`).
  GrepCmd noMessages() => token('-s');

  /// Searches binary files without printing them (`-U`).
  GrepCmd binary() => token('-U');

  /// Prints the version and exits (`-V`).
  GrepCmd version() => token('-V');

  /// Keeps the lines that match nothing (`-v`).
  GrepCmd invertMatch() => token('-v');

  /// Requires the match to be a whole word (`-w`). Ignored when [lineRegexp] is on.
  GrepCmd wordRegexp() => token('-w');

  /// Requires the match to be the whole line (`-x`).
  GrepCmd lineRegexp() => token('-x');

  /// Decompresses xz files on the way in (`-X`). BSD only.
  GrepCmd xz() => token('-X');

  /// Behaves as `zgrep`, decompressing on the way in (`-Z`). BSD only.
  GrepCmd decompress() => token('-Z');

  /// Treats input and output as NUL-separated rather than newline-separated (`-z`).
  GrepCmd nullData() => token('-z');

  /// What to do with binary files: `binary`, `without-match` or `text` (`--binary-files`).
  GrepCmd binaryFiles(String value) => joined('--binary-files', value);

  /// Flushes a line at a time, instead of buffering when stdout is a pipe (`--line-buffered`).
  GrepCmd lineBuffered() => token('--line-buffered');

  /// Ends the options, for a pattern or path that starts with a dash (`--`).
  GrepCmd endOfOptions() => token('--');

  /// The pattern, when it has not already been given through [regexp].
  GrepCmd pattern(String value) => token(value);

  /// Adds a file to search. Repeat for several; `-` means stdin.
  GrepCmd file(String path) => token(path);
}

/// `grep`, ready to take its first option.
// ignore: non_constant_identifier_names
GrepCmd get Grep => GrepCmd();
