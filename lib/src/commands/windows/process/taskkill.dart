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

/// `taskkill`, which ends processes, the counterpart of `kill`. Windows only.
///
/// ```dart
/// await Taskkill.imageName('deno.exe').tree().force().execute();
/// ```
///
/// Without [force] taskkill asks the process to close, which only a program with
/// a window will hear; a console process ignores it. With [force] it is killed
/// outright, and nothing is flushed: the same trade as `SIGTERM` against
/// `SIGKILL`, except there is no polite signal a background process can catch.
///
/// [tree] takes the children with it, which is what you want for anything that
/// spawned workers and what you do not want if you got the pid wrong.
///
/// **A remote kill is always forced**, whatever the flags say. And killing
/// nothing exits non-zero, which makes a reasonable "was it running" test.
class TaskkillCmd extends CommandBuilder<TaskkillCmd> {
  @override
  final String executable = 'taskkill';

  /// The remote machine (`/s`).
  TaskkillCmd server(String value) => pair('/s', value);

  /// The account to act as, `DOMAIN\\user` (`/u`). Needs [server].
  TaskkillCmd user(String value) => pair('/u', value);

  /// Its password (`/p`).
  TaskkillCmd password(String value) => pair('/p', value);

  /// Adds a filter, `"USERNAME eq NT AUTHORITY\\SYSTEM"` (`/fi`). Repeatable.
  TaskkillCmd filter(String expression) => pair('/fi', expression);

  /// The process id to end (`/pid`). Repeatable.
  TaskkillCmd pid(String value) => pair('/pid', value);

  /// The image name to end, `deno.exe` (`/im`). `*` only alongside a filter.
  TaskkillCmd imageName(String value) => pair('/im', value);

  /// Ends the process outright rather than asking (`/f`).
  TaskkillCmd force() => token('/f');

  /// Ends the children too (`/t`).
  TaskkillCmd tree() => token('/t');

  /// Adds a bare argument.
  TaskkillCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
TaskkillCmd get Taskkill => TaskkillCmd();
