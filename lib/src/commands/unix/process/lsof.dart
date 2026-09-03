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
