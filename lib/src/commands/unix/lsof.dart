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

/// `lsof`, which lists open files, and a socket is a file, so it answers "what
/// is holding port 5432". On macOS and the BSDs by default, packaged on Linux,
/// where [SsCmd] is the faster native answer.
///
/// ```dart
/// final ShellResult onPort = await Lsof.internet('tcp:5432').noPortNames().terse().output();
/// if (onPort.isNotEmpty) { /* something is already listening */ }
/// ```
///
/// **A selection that matches nothing exits `1`.** That is not an error, it is
/// the answer, so read [ShellResult.isNotEmpty] rather than the status, or a
/// free port looks like a failed command.
///
/// Its options are unlike anything else here: some take `+` instead of `-`, and
/// several selections are ORed together unless [andSelections] says otherwise,
/// which is the opposite of what most tools do.
///
/// Without root it only sees your own processes, and says nothing about the
/// ones it skipped. A port that looks free may simply belong to somebody else.
class LsofCmd extends CommandBuilder<LsofCmd> {
  @override
  final String executable = 'lsof';

  /// Requires every selection to match rather than any (`-a`).
  LsofCmd andSelections() => token('-a');

  /// Selects by internet address, `tcp:5432` or `@host:port` (`-i`).
  LsofCmd internet(String spec) => pair('-i', spec);

  /// Selects the processes of these users (`-u`).
  LsofCmd user(String value) => pair('-u', value);

  /// Selects these process ids (`-p`).
  LsofCmd pid(String value) => pair('-p', value);

  /// Selects by command name (`-c`).
  LsofCmd command(String value) => pair('-c', value);

  /// Selects by file descriptor set (`-d`).
  LsofCmd fileDescriptors(String value) => pair('-d', value);

  /// Selects the files open under this directory (`+d`). One level only.
  LsofCmd directory(String path) => pair('+d', path);

  /// The same, walking the whole tree (`+D`). Slow.
  LsofCmd directoryTree(String path) => pair('+D', path);

  /// Selects the Unix domain sockets (`-U`).
  LsofCmd unixSockets() => token('-U');

  /// Selects the NFS files (`-N`).
  LsofCmd nfs() => token('-N');

  /// Prints process ids and nothing else (`-t`).
  ///
  /// The form to pipe into `xargs kill`, and the only one with no header to skip.
  LsofCmd terse() => token('-t');

  /// Leaves the host names unresolved (`-n`). Much faster.
  LsofCmd noHostNames() => token('-n');

  /// Leaves the port numbers as numbers (`-P`). `:5432`, not `:postgresql`.
  LsofCmd noPortNames() => token('-P');

  /// Prints uids rather than user names (`-l`).
  LsofCmd numericUids() => token('-l');

  /// Adds the file size (`-s`).
  LsofCmd fileSize() => token('-s');

  /// Adds the file offset (`-o`).
  LsofCmd fileOffset() => token('-o');

  /// Adds the parent process id (`-R`).
  LsofCmd parentPid() => token('-R');

  /// Prints selected fields for a machine to read (`-F`).
  LsofCmd fields(String value) => pair('-F', value);

  /// Avoids the kernel calls that can block (`-b`).
  LsofCmd avoidBlocking() => token('-b');

  /// Silences the warnings (`-w`).
  LsofCmd noWarnings() => token('-w');

  /// Repeats the listing every so many seconds (`-r`).
  LsofCmd repeat(String seconds) => pair('-r', seconds);

  /// How long to wait on a stat before giving up (`-S`).
  LsofCmd statTimeout(String seconds) => pair('-S', seconds);

  /// Prints the version (`-v`).
  LsofCmd version() => token('-v');

  /// Ends the option scan (`--`).
  LsofCmd endOfOptions() => token('--');

  /// Adds a path to ask about.
  LsofCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
LsofCmd get Lsof => LsofCmd();
