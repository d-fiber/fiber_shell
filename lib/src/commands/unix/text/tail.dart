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

/// `tail`, the last-lines-of-a-file filter, and the closest thing here to
/// `Get-Content -Wait`. On every Unix.
///
/// ```dart
/// final BackgroundJob logs = await Tail.followName().retry().pid(serverPid).file('server.log').background();
/// ```
///
/// **[follow] and [followRotate] are the reason to reach for this over reading
/// the file in Dart.** GNU tail's [follow] takes an implicit `descriptor` mode
/// that keeps reading the same inode even if it is renamed; [followName] tracks
/// the path instead and reopens it when a new file appears there, which is what
/// a log rotator needs and is the mode [followRotate] (`-F`) turns on together
/// with [retry]. BSD tail's `-f` is always name-based already, so [follow] alone
/// is the portable spelling and [followName] is a GNU-only alias for the same
/// behaviour spelled out. Both only make sense with [execute] or [background]:
/// [output] waits for the process to exit, which a following `tail` never does
/// on its own.
///
/// [reverse] is BSD only and changes what [lines], [bytes] and [blocks] mean:
/// normally they count from the end, under [reverse] they count how many of
/// the already-reversed lines to print from the start. GNU tail has no
/// equivalent; use `Sed` or a Dart-side reverse for a portable call.
class TailCmd extends CommandBuilder<TailCmd> {
  @override
  final String executable = 'tail';

  /// Waits for more data as the file grows, instead of stopping at EOF (`-f`).
  ///
  /// Ignored on a pipe; use [file] with a real path, not stdin. GNU tail tracks the
  /// file descriptor under this flag; see [followName] for the rotation-safe mode.
  TailCmd follow() => token('-f');

  /// Follows by filename rather than descriptor, reopening it if replaced (`--follow=name`). GNU only.
  TailCmd followName() => joined('--follow', 'name');

  /// Like [follow], and reopens the file if it is renamed or rotated (`-F`).
  ///
  /// Equivalent to `--follow=name --retry` on GNU tail.
  TailCmd followRotate() => token('-F');

  /// Keeps trying to open a file that is initially inaccessible, under [follow] (`--retry`). GNU only.
  TailCmd retry() => token('--retry');

  /// Exits once this process id no longer exists, under [follow] (`--pid`). Repeatable. GNU only.
  TailCmd pid(int value) => pair('--pid', '$value');

  /// Under `--follow=name`, reopens a file that has not changed size after this many checks (`--max-unchanged-stats`). GNU only.
  TailCmd maxUnchangedStats(int iterations) => pair('--max-unchanged-stats', '$iterations');

  /// The delay between checks under [follow], in seconds (`-s`, `--sleep-interval`). Defaults to 1.0. GNU only.
  TailCmd sleepInterval(num seconds) => pair('-s', '$seconds');

  /// Displays the input in reverse line order (`-r`). BSD only.
  TailCmd reverse() => token('-r');

  /// Suppresses the `==> name <==` headers printed for multiple files (`-q`, `--quiet`, `--silent`).
  TailCmd quiet() => token('-q');

  /// Prints a header even for a single file (`-v`, `--verbose`).
  TailCmd verbose() => token('-v');

  /// Separates output with NUL instead of newline (`-z`, `--zero-terminated`). GNU only.
  TailCmd zeroTerminated() => token('-z');

  /// The starting point in 512-byte blocks; `+N` counts from the start (`-b`). BSD only.
  TailCmd blocks(String value) => pair('-b', value);

  /// The starting point in bytes; `+N` counts from the start (`-c`, `--bytes`).
  TailCmd bytes(String value) => pair('-c', value);

  /// The starting point in lines; `+N` counts from the start (`-n`, `--lines`). Defaults to 10.
  TailCmd lines(String value) => pair('-n', value);

  /// Prints which `--follow` implementation was chosen (`--debug`). GNU only.
  TailCmd debug() => token('--debug');

  /// Prints the usage summary (`--help`). GNU only.
  TailCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  TailCmd version() => token('--version');

  /// Adds a file to read. Repeat for several; without one, reads stdin.
  TailCmd file(String path) => token(path);
}

/// `tail`, ready to take its first option.
// ignore: non_constant_identifier_names
TailCmd get Tail => TailCmd();
