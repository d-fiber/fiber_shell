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

/// `kill`, the signal sender. On every Unix, absent from Windows. Dart can do
/// this itself with `Process.kill` when it started the process; this is for the
/// ones it did not.
///
/// ```dart
/// await Kill.signal('TERM').pid(pid).execute();
/// ```
///
/// The default signal is `TERM`, which asks a process to stop and lets it clean
/// up. `KILL` cannot be caught, so nothing is flushed and nothing is released:
/// it is the answer to a process that ignored `TERM`, not the first thing to
/// reach for.
///
/// Signalling a process you do not own needs `asRoot()`, and a `kill` that
/// matched nothing exits non-zero, which is a reasonable "was it there" test.
///
/// A negative pid signals the whole process group. Convenient, and the reason a
/// stray minus sign turns one dead process into a dead session.
class KillCmd extends CommandBuilder<KillCmd> {
  @override
  final String executable = 'kill';

  /// The signal to send, by name: `TERM`, `HUP`, `KILL` (`-s`).
  KillCmd signal(String name) => pair('-s', name);

  /// The signal by name, glued to the dash: `-TERM`.
  KillCmd signalNamed(String name) => token('-$name');

  /// The signal by number: `-15`.
  KillCmd signalNumber(String number) => token('-$number');

  /// Lists the signal names (`-l`).
  KillCmd listSignals() => token('-l');

  /// Adds a process id. Negative for a whole process group.
  KillCmd pid(String value) => token(value);
}

// ignore: non_constant_identifier_names
KillCmd get Kill => KillCmd();
