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

/// `ps`, the process lister. On every Unix, absent from Windows.
///
/// ```dart
/// final ShellResult mine = await Ps.everyProcess().format('pid,ppid,comm').output();
/// ```
///
/// **The two syntaxes are the deep trap here.** `ps aux` is the BSD form, with
/// no dash; `ps -ef` is the POSIX one. Both work on macOS and on Linux, they
/// mean different things, and mixing them gives a third behaviour again. This
/// wrapper exposes the POSIX flags, which are the ones that behave the same on
/// both.
///
/// [format] is what makes the output parseable: it prints the columns you name,
/// in order, with no surprises. The default layout differs between systems, and
/// the last column may contain spaces, so split on whitespace with a limit, or
/// put the command last and take the rest.
///
/// A `ps` that finds nothing exits non-zero, which is a useful "is it running"
/// test but means [output] rather than [execute].
class PsCmd extends CommandBuilder<PsCmd> {
  @override
  final String executable = 'ps';

  /// Every process, whoever owns it (`-A`).
  PsCmd everyProcess() => token('-A');

  /// Includes the processes of other users (`-a`).
  PsCmd otherUsers() => token('-a');

  /// Drops the ones with no terminal (`-x` inverted).
  PsCmd includeNoTty() => token('-x');

  /// The full listing (`-f`).
  PsCmd full() => token('-f');

  /// The long listing (`-l`).
  PsCmd long() => token('-l');

  /// The job control columns (`-j`).
  PsCmd jobFormat() => token('-j');

  /// Prints the columns named here, comma separated (`-o`).
  ///
  /// `pid,ppid,user,%cpu,%mem,etime,comm` and the rest; a `=` after a name
  /// renames or empties its header.
  PsCmd format(String value) => pair('-o', value);

  /// Adds these columns to the default set (`-O`).
  PsCmd addFormat(String value) => pair('-O', value);

  /// Only these process ids (`-p`).
  PsCmd pids(String value) => pair('-p', value);

  /// Only the processes of these users (`-U`).
  PsCmd realUsers(String value) => pair('-U', value);

  /// Only those with these effective users (`-u`).
  PsCmd effectiveUsers(String value) => pair('-u', value);

  /// Only those of these groups (`-G`).
  PsCmd groups(String value) => pair('-G', value);

  /// Only those attached to these terminals (`-t`).
  PsCmd terminals(String value) => pair('-t', value);

  /// Sorts by cpu use (`-r`).
  PsCmd sortByCpu() => token('-r');

  /// Sorts by memory use (`-m`).
  PsCmd sortByMemory() => token('-m');

  /// Adds the threads (`-M`).
  PsCmd threads() => token('-M');

  /// Adds the child cpu time to the parent (`-S`).
  PsCmd sumChildren() => token('-S');

  /// Prints the command name rather than the whole argument list (`-c`).
  PsCmd commandNameOnly() => token('-c');

  /// Drops the header line (`-h` inverted on some systems).
  PsCmd repeatHeader() => token('-h');

  /// Does not truncate the lines to the terminal width (`-w`).
  ///
  /// Twice over on some systems. Without it a long command line is cut off, and
  /// the truncation looks exactly like data.
  PsCmd wide() => token('-w');

  /// Adds the virtual memory columns (`-v`).
  PsCmd virtualMemory() => token('-v');

  /// Adds the environment of each process (`-E`).
  PsCmd environment() => token('-E');

  /// Lists the column names this build understands (`-L`).
  PsCmd listFormats() => token('-L');

  /// Adds a bare argument.
  PsCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
PsCmd get Ps => PsCmd();
