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
