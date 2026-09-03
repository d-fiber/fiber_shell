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

/// `tasklist`, the process lister, the counterpart of `ps`. Windows only.
///
/// ```dart
/// final ShellResult running = await Tasklist
///     .format('csv')
///     .noHeader()
///     .filter('IMAGENAME eq deno.exe')
///     .output();
/// ```
///
/// [format] `csv` with [noHeader] is the shape to parse: the default table pads
/// with spaces and **truncates the columns**, so a long path comes back cut off
/// and the truncation looks exactly like data.
///
/// A filter is one string, `"PID gt 1000"`, with the operator in the middle:
/// `eq`, `ne`, `gt`, `lt`, `ge`, `le`. Several [filter] calls are ANDed. The
/// `WINDOWTITLE` and `STATUS` filters do not work against a remote machine.
///
/// **A filter matching nothing still exits zero**, printing an informational
/// line rather than nothing at all, so read [ShellResult.text], not the status.
class TasklistCmd extends CommandBuilder<TasklistCmd> {
  @override
  final String executable = 'tasklist';

  /// The remote machine to query (`/s`).
  TasklistCmd server(String value) => pair('/s', value);

  /// The account to query as, `DOMAIN\\user` (`/u`). Needs [server].
  TasklistCmd user(String value) => pair('/u', value);

  /// Its password (`/p`).
  TasklistCmd password(String value) => pair('/p', value);

  /// Only the processes that loaded a matching DLL (`/m`).
  TasklistCmd module(String pattern) => pair('/m', pattern);

  /// Adds the services hosted by each process (`/svc`). Table format only.
  TasklistCmd services() => token('/svc');

  /// The verbose listing (`/v`).
  TasklistCmd verbose() => token('/v');

  /// Adds a filter, `"PID gt 1000"` (`/fi`). Repeatable, and ANDed.
  TasklistCmd filter(String expression) => pair('/fi', expression);

  /// The output format: `table`, `list` or `csv` (`/fo`).
  TasklistCmd format(String value) => pair('/fo', value);

  /// Drops the column headers (`/nh`). Table and csv only.
  TasklistCmd noHeader() => token('/nh');

  /// Lists the packaged applications rather than the processes (`/apps`).
  TasklistCmd apps() => token('/apps');

  /// Adds a bare argument.
  TasklistCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
TasklistCmd get Tasklist => TasklistCmd();
