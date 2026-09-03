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

/// `journalctl`, the systemd log reader. Comes with systemd, so the same caveat
/// as [SystemctlCmd]: Linux, and only where systemd runs.
///
/// ```dart
/// final ShellResult recent = await Journalctl
///     .unit('api')
///     .since('-1h')
///     .noPager()
///     .output_('json')
///     .output();
/// ```
///
/// [noPager] belongs on every scripted call. journalctl pipes into a pager when
/// it thinks it is talking to a terminal, and a pager waiting for a keypress is
/// a process that never returns.
///
/// [output_] with `json` gives one JSON object per line, the format to parse.
/// The default is aligned for reading and loses information.
///
/// Reading another service's logs usually needs `asRoot()`, or membership of the
/// `systemd-journal` group.
class JournalctlCmd extends CommandBuilder<JournalctlCmd> {
  @override
  final String executable = 'journalctl';

  /// Only the entries of this unit (`--unit`).
  JournalctlCmd unit(String name) => joined('--unit', name);

  /// Keeps printing new entries as they arrive (`--follow`).
  JournalctlCmd follow() => token('--follow');

  /// At most this many entries, or `all` (`--lines`).
  JournalctlCmd lines(String count) => joined('--lines', count);

  /// Only what happened at or after this time (`--since`).
  ///
  /// Takes a date, and also the relative forms `-1h` and `yesterday`.
  JournalctlCmd since(String value) => joined('--since', value);

  /// Only what happened at or before this time (`--until`).
  JournalctlCmd until(String value) => joined('--until', value);

  /// Only this priority or below: `emerg` through `debug` (`--priority`).
  JournalctlCmd priority(String value) => joined('--priority', value);

  /// The output format: `short`, `json`, `json-pretty`, `cat`, `export` (`--output`).
  JournalctlCmd output_(String value) => joined('--output', value);

  /// Writes straight out rather than through a pager (`--no-pager`).
  JournalctlCmd noPager() => token('--no-pager');

  /// Only the kernel messages (`--dmesg`).
  JournalctlCmd kernel() => token('--dmesg');

  /// Only this boot, `0` for the current one and `-1` for the previous (`--boot`).
  JournalctlCmd boot(String value) => joined('--boot', value);

  /// Newest first (`--reverse`).
  JournalctlCmd reverse() => token('--reverse');

  /// Adds the catalog explanation to the entries that have one (`--catalog`).
  JournalctlCmd catalog() => token('--catalog');

  /// Deletes the oldest archives until the journal fits in this size (`--vacuum-size`).
  JournalctlCmd vacuumSize(String value) => joined('--vacuum-size', value);

  /// Deletes the archives older than this (`--vacuum-time`).
  JournalctlCmd vacuumTime(String value) => joined('--vacuum-time', value);

  /// Prints how much disk the journal is using (`--disk-usage`).
  JournalctlCmd diskUsage() => token('--disk-usage');

  /// Checks the journal files for damage (`--verify`).
  JournalctlCmd verify() => token('--verify');

  /// Only the entries whose message matches this regular expression (`--grep`).
  ///
  /// Filtered by the journal itself rather than by a `grep` downstream, so the
  /// structure of the entry survives.
  JournalctlCmd grep(String pattern) => joined('--grep', pattern);

  /// The system journal (`--system`).
  JournalctlCmd system() => token('--system');

  /// The calling user's journal (`--user`).
  JournalctlCmd user() => token('--user');

  /// Suppresses the informational messages (`--quiet`).
  JournalctlCmd quiet() => token('--quiet');

  /// Prints the timestamps in UTC (`--utc`).
  JournalctlCmd utc() => token('--utc');

  /// Jumps to the end of the journal inside the pager (`--pager-end`).
  JournalctlCmd pagerEnd() => token('--pager-end');

  /// Prints every field in full, however long or unprintable (`--all`).
  JournalctlCmd all() => token('--all');

  /// Only these fields, comma separated (`--output-fields`).
  JournalctlCmd outputFields(String value) => joined('--output-fields', value);

  /// Only the entries of this syslog identifier (`--identifier`).
  JournalctlCmd identifier(String value) => joined('--identifier', value);

  /// Only this syslog facility (`--facility`).
  JournalctlCmd facility(String value) => joined('--facility', value);

  /// Reads this journal directory instead of the system one (`--directory`).
  JournalctlCmd directory(String path) => joined('--directory', path);

  /// Reads the journal files matching this glob (`--file`).
  JournalctlCmd file(String glob) => joined('--file', glob);

  /// Asks the daemon to rotate the journal files (`--rotate`).
  JournalctlCmd rotate() => token('--rotate');

  /// Asks the daemon to move the runtime journal onto disk (`--flush`).
  JournalctlCmd flush() => token('--flush');

  /// Asks the daemon to write everything pending to disk (`--sync`).
  ///
  /// Worth calling before reading a log a moment after the event that wrote it.
  JournalctlCmd sync() => token('--sync');

  /// Adds a match, `FIELD=value`, or a bare argument.
  JournalctlCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
JournalctlCmd get Journalctl => JournalctlCmd();
