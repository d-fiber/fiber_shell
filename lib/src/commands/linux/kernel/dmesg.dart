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

/// `dmesg`, the util-linux kernel ring buffer reader. Linux only: the buffer
/// itself, and the `syslog(2)` call this reads it through, are Linux kernel
/// features.
///
/// ```dart
/// final ShellResult boot = await Dmesg.ctime().level(['err', 'warn']).output();
/// await Dmesg.follow().execute();
/// ```
///
/// **Reading the buffer at all may need `asRoot()`** on distributions that
/// set `kernel.dmesg_restrict=1`, the default on several since it can leak
/// kernel addresses to an unprivileged user. A permission error from an
/// otherwise-correct call usually means that sysctl, not a mistake here.
///
/// [ctime] is worth defaulting to over the bare timestamps `dmesg` prints
/// otherwise, which are seconds since boot and mean nothing without also
/// knowing when the machine booted. [follow] and [followNew] stream new lines
/// as the kernel logs them, the way `tail -f` would; neither one returns on
/// its own.
class DmesgCmd extends CommandBuilder<DmesgCmd> {
  @override
  final String executable = 'dmesg';

  /// Clears the ring buffer without printing it first (`-C`, `--clear`).
  ///
  /// [readClear] is almost always the better choice: this one throws the
  /// messages away unread.
  DmesgCmd clear() => token('--clear');

  /// Prints the buffer, then clears it (`-c`, `--read-clear`).
  DmesgCmd readClear() => token('--read-clear');

  /// Disables kernel messages being written to the console (`-D`,
  /// `--console-off`).
  DmesgCmd consoleOff() => token('--console-off');

  /// Shows the time elapsed since the previous message, alongside the
  /// timestamp (`-d`, `--show-delta`).
  DmesgCmd showDelta() => token('--show-delta');

  /// Re-enables kernel messages on the console, undoing [consoleOff] (`-E`,
  /// `--console-on`).
  DmesgCmd consoleOn() => token('--console-on');

  /// Prints the local time and the delta since the previous message, in
  /// human-readable form (`-e`, `--reltime`).
  DmesgCmd relTime() => token('--reltime');

  /// Reads syslog messages from this file instead of the kernel buffer
  /// (`-F`, `--file`).
  DmesgCmd file(String path) => pair('--file', path);

  /// Restricts the output to these syslog facilities, comma separated:
  /// `kern`, `user`, `daemon` and so on (`-f`, `--facility`).
  DmesgCmd facility(List<String> names) => joinedAll('--facility', names);

  /// Enables human-readable output: relative timestamps and colour together
  /// (`-H`, `--human`).
  DmesgCmd human() => token('--human');

  /// Renders the output as JSON (`-J`, `--json`).
  DmesgCmd json() => token('--json');

  /// Reads `/dev/kmsg`-formatted messages from this file instead of the
  /// live device (`-K`, `--kmsg-file`).
  DmesgCmd kmsgFile(String path) => pair('--kmsg-file', path);

  /// Restricts the output to kernel messages, dropping ones logged by
  /// userspace through `/dev/kmsg` (`-k`, `--kernel`).
  DmesgCmd kernel() => token('--kernel');

  /// Whether to colourise the output; [when] is `auto`, `never` or `always`,
  /// defaulting to `auto` when left out (`-L`, `--color`).
  DmesgCmd colorize([String? when]) => when == null ? token('--color') : joined('--color', when);

  /// Restricts the output to these priority levels, comma separated: `emerg`,
  /// `alert`, `crit`, `err`, `warn`, `notice`, `info`, `debug` (`-l`,
  /// `--level`).
  DmesgCmd level(List<String> names) => joinedAll('--level', names);

  /// Sets the console log level, the messages the kernel prints to the
  /// console rather than only to the buffer (`-n`, `--console-level`).
  DmesgCmd consoleLevel(String level) => pair('--console-level', level);

  /// Disables escaping of unprintable and unsafe characters in the message
  /// text (`--noescape`).
  DmesgCmd noEscape() => token('--noescape');

  /// Writes straight out rather than through a pager (`-P`, `--nopager`).
  DmesgCmd noPager() => token('--nopager');

  /// Prefixes every line with its facility and level, even ones that would
  /// otherwise look plain (`-p`, `--force-prefix`).
  DmesgCmd forcePrefix() => token('--force-prefix');

  /// Prints the raw, unparsed messages exactly as the kernel wrote them
  /// (`-r`, `--raw`).
  DmesgCmd raw() => token('--raw');

  /// Reads from the syslog(2) buffer even when `/dev/kmsg` is available
  /// (`-S`, `--syslog`). The pre-3.5-kernel fallback path.
  DmesgCmd syslog() => token('--syslog');

  /// The size of the buffer to read, when the kernel exposes more than one
  /// size (`-s`, `--buffer-size`).
  DmesgCmd bufferSize(String size) => pair('--buffer-size', size);

  /// Prints human-readable wall-clock timestamps instead of the kernel's raw
  /// seconds-since-boot ones (`-T`, `--ctime`).
  ///
  /// The manual page's own warning applies: on a machine with an adjusted or
  /// suspended clock, these times can be inaccurate.
  DmesgCmd ctime() => token('--ctime');

  /// Prints only records logged after this time (`--since`). Accepts the
  /// same formats as `date`.
  DmesgCmd since(String time) => joined('--since', time);

  /// Prints only records logged before this time (`--until`).
  DmesgCmd until(String time) => joined('--until', time);

  /// Drops the timestamp entirely (`-t`, `--notime`).
  DmesgCmd noTime() => token('--notime');

  /// The timestamp format: `ctime`, `reltime`, `delta`, `iso`, `raw`
  /// (`--time-format`).
  DmesgCmd timeFormat(String value) => joined('--time-format', value);

  /// Restricts the output to messages logged by userspace through
  /// `/dev/kmsg`, the counterpart to [kernel] (`-u`, `--userspace`).
  DmesgCmd userspace() => token('--userspace');

  /// Waits for new messages and prints them as they arrive (`-w`, `--follow`).
  /// Never returns.
  DmesgCmd follow() => token('--follow');

  /// The same streaming behaviour as [follow], but only for messages logged
  /// after the call started (`-W`, `--follow-new`). Never returns.
  DmesgCmd followNew() => token('--follow-new');

  /// Decodes facility and level numbers into their names (`-x`, `--decode`).
  DmesgCmd decode() => token('--decode');

  /// Prints the usage summary (`-h`, `--help`).
  DmesgCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  DmesgCmd version() => token('--version');
}

/// `dmesg`, ready to take its first option.
// ignore: non_constant_identifier_names
DmesgCmd get Dmesg => DmesgCmd();
