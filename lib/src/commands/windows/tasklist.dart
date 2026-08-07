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
