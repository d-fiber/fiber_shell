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

/// `uptime`, how long the system has been running. On every Unix.
///
/// ```dart
/// final ShellResult status = await Uptime.output();
/// print(status.text); // '11:23  up 3 days, 1:02, 4 users, load averages: 1.20 1.05 0.98'
/// ```
///
/// BSD `uptime` (macOS included) takes no useful arguments at all — only
/// `--libxo`, for a machine-readable rendering this wrapper does not expose.
/// [pretty], [raw], [since] and [container] are Linux's `procps` `uptime`
/// only; a script meant to run on both should parse the one line every
/// `uptime` prints, splitting on `load average` and taking the tail, rather
/// than reaching for these.
class UptimeCmd extends CommandBuilder<UptimeCmd> {
  @override
  final String executable = 'uptime';

  /// Prints the uptime in a human sentence, `"up 3 days, 1 hour, 2 minutes"` (`-p`, `--pretty`). Linux only.
  UptimeCmd pretty() => token('-p');

  /// Prints the current time and uptime as raw seconds instead of a formatted line (`-r`, `--raw`). Linux only.
  UptimeCmd raw() => token('-r');

  /// Prints when the system booted, `yyyy-mm-dd HH:MM:SS` (`-s`, `--since`). Linux only.
  UptimeCmd since() => token('-s');

  /// Shows the container's uptime instead of the host's (`-c`, `--container`). Linux only.
  UptimeCmd container() => token('-c');

  /// Prints the usage summary (`-h`, `--help`). Linux only.
  UptimeCmd help() => token('-h');

  /// Prints the version and exits (`-V`, `--version`). Linux only.
  UptimeCmd version() => token('-V');
}

/// `uptime`, ready to run.
// ignore: non_constant_identifier_names
UptimeCmd get Uptime => UptimeCmd();
