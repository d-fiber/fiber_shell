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

/// `top`: a periodically-refreshing, sorted process list — but a genuinely
/// different program on BSD/macOS and on Linux (procps). This wrapper covers
/// both flag sets, since neither is a subset of the other; methods below say
/// which platform they belong to. The sort-key vocabulary for [sortKey] also
/// differs completely between the two (`cpu`, `mem`, `pid` on BSD; `%CPU`,
/// `RES`, `PID` and dozens more on Linux) — pass whatever your platform's `top
/// -o` help lists.
///
/// ```dart
/// // BSD/macOS: one non-interactive sample, top 10 by CPU.
/// final ShellResult r = await Top.logSamples(1).maxProcesses(10).sortKey('cpu').output();
///
/// // GNU/Linux: three batch-mode iterations, no colour, sorted by memory.
/// final ShellResult g = await Top.batch().iterations(3).sortKey('%MEM').output();
/// ```
///
/// Plain `top` with no flags is interactive and never exits on its own — always
/// pair it with a sample/iteration limit ([logSamples] on BSD, [batch] plus
/// [iterations] on Linux) before running it through [output] or [execute], or
/// the process hangs waiting for a terminal that a script never provides.
class TopCmd extends CommandBuilder<TopCmd> {
  @override
  final String executable = 'top';

  /// Shortcut for accumulative event-counting mode, counting since `top`
  /// launched (`-a`, same as `-c a`). BSD only.
  TopCmd accumulative() => token('-a');

  /// Sets the event-counting mode: `a` (accumulative), `d` (delta), `e`
  /// (absolute) or `n` (non-event, the default) (`-c`). BSD only.
  TopCmd eventMode(String mode) => pair('-c', mode);

  /// Shortcut for delta event-counting mode, relative to the previous sample
  /// (`-d`, same as `-c d`). BSD only.
  TopCmd delta() => token('-d');

  /// Shortcut for absolute event-counting mode (`-e`, same as `-c e`). BSD
  /// only.
  TopCmd absolute() => token('-e');

  /// Skips statistics on shared libraries/frameworks (`-F`). BSD only.
  TopCmd noFrameworkStats() => token('-F');

  /// Calculates statistics on shared libraries/frameworks, the default
  /// (`-f`). BSD only.
  TopCmd frameworkStats() => token('-f');

  /// Prints the usage summary and exits (`-h`).
  TopCmd help() => token('-h');

  /// Refreshes framework statistics every this many samples, trading accuracy
  /// for CPU cost (`-i`). BSD only.
  TopCmd frameworkInterval(int samples) => pair('-i', '$samples');

  /// Runs in logging mode and prints this many samples even when stdout is a
  /// terminal; `0` means unlimited. The value a non-interactive script wants
  /// (`-l`). BSD only.
  TopCmd logSamples(int samples) => pair('-l', '$samples');

  /// Limits the display to this many columns wide, in logging mode (`-ncols`).
  /// BSD only.
  TopCmd columns(int count) => pair('-ncols', '$count');

  /// Displays at most this many processes (`-n`). BSD only — on GNU `-n` sets
  /// [iterations] instead.
  TopCmd maxProcesses(int count) => pair('-n', '$count');

  /// Sets the secondary sort key, same vocabulary as [sortKey] (`-O`). BSD
  /// only.
  TopCmd secondaryKey(String key) => pair('-O', key);

  /// Sorts the process display by this key, descending by default; prefix
  /// with `+` or `-` for ascending/descending explicitly. Platform-specific
  /// vocabulary — see the class comment (`-o`).
  TopCmd sortKey(String key) => pair('-o', key);

  /// Skips the memory object map for each process, the default (`-R`). BSD
  /// only.
  TopCmd noMemoryMap() => token('-R');

  /// Reports the memory object map for each process (`-r`). BSD only.
  TopCmd memoryMap() => token('-r');

  /// Displays global swap and purgeable-memory statistics (`-S`). BSD only.
  TopCmd globalStats() => token('-S');

  /// Sets the delay between updates, in seconds; the BSD default is 1 (`-s`).
  /// BSD only.
  TopCmd delay(int seconds) => pair('-s', '$seconds');

  /// Displays only these comma-separated statistics, same key vocabulary as
  /// [sortKey] (`-stats`). BSD only.
  TopCmd stats(List<String> keys) => pair('-stats', keys.join(','));

  /// Displays only this process ID; repeatable (`-pid`). BSD only.
  TopCmd pid(int pid) => pair('-pid', '$pid');

  /// Displays only processes owned by this user (`-user`). BSD only.
  TopCmd user(String name) => pair('-user', name);

  /// Alias for [user] (`-U`). Shared spelling with GNU's `--filter-any-user`,
  /// though the two implementations differ.
  TopCmd userAlias(String name) => pair('-U', name);

  /// Shortcut equivalent to `sortKey('cpu')` plus `secondaryKey('time')`
  /// (`-u`). BSD only — on GNU, `-u` instead filters by effective user ID and
  /// takes a value; see [filterEffectiveUser].
  TopCmd cpuOrder() => token('-u');

  /// Runs non-interactively for scripting/piping instead of drawing a screen
  /// (`-b`/`--batch`). GNU only.
  TopCmd batch() => token('-b');

  /// Exits after this many updates instead of running forever (`-n`/
  /// `--iterations`). GNU only — on BSD, `-n` instead caps the process count;
  /// see [maxProcesses].
  TopCmd iterations(int count) => pair('-n', '$count');

  /// Sets the delay between updates, in seconds, fractions allowed (`-d`/
  /// `--delay`). GNU only — BSD's equivalent is [delay] with a whole-second
  /// value under `-s`.
  TopCmd gnuDelay(num seconds) => pair('-d', '$seconds');

  /// Monitors only these process IDs, up to 20; repeat to add more (`-p`/
  /// `--pid`). GNU only.
  TopCmd gnuPid(int pid) => pair('-p', '$pid');

  /// Shows individual threads as separate rows (`-H`/`--threads-show`). GNU
  /// only.
  TopCmd threads() => token('-H');

  /// Filters to processes with this effective user ID or name (`-u`/
  /// `--filter-only-euser`). GNU only — see [cpuOrder] for BSD's `-u`.
  TopCmd filterEffectiveUser(String user) => pair('-u', user);

  /// Filters to processes matching this user ID or name under any of real,
  /// effective, saved or filesystem UID (`-U`/`--filter-any-user`). GNU only;
  /// shares its letter with [userAlias] but a different filter model.
  TopCmd filterAnyUser(String user) => pair('-U', user);

  /// Sets the output width used in batch mode (`-w`/`--width`). GNU only.
  TopCmd width(int columns) => pair('-w', '$columns');

  /// Prints available field names for [sortKey], one per line, and exits
  /// (`-O`/`--list-fields`). GNU only; shares its letter with BSD's
  /// [secondaryKey] but a different job.
  TopCmd listFields() => token('-O');

  /// Ignores every configuration file but `/etc/toprc` (`-A`/
  /// `--apply-defaults`). GNU only.
  TopCmd applyDefaults() => token('-A');

  /// Prints the version and exits (`-V`/`--version`). GNU only.
  TopCmd version() => token('-V');
}

/// `top`, ready to take its first option.
// ignore: non_constant_identifier_names
TopCmd get Top => TopCmd();
