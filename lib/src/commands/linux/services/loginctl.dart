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

/// `loginctl`, systemd-logind's control front end for sessions, users and
/// seats. systemd only, so Linux only, and only where `systemd-logind` is the
/// one managing logins.
///
/// ```dart
/// final ShellResult sessions = await Loginctl.listSessions().outputFormat('json').output();
/// await Loginctl.terminateSession().id('7').asRoot().execute();
/// await Loginctl.enableLinger().user('deploy').asRoot().execute();
/// ```
///
/// [enableLinger] is the one worth knowing about ahead of time: without it, a
/// user's systemd `--user` services and timers stop the moment their last
/// session ends, which quietly kills anything long-running (a dev server, an
/// agent) started from an SSH session once that session closes. Session,
/// user and seat identifiers are added with [id] after the verb selects what
/// kind of target it is. Most verbs that change or terminate something want
/// `asRoot()`; the list/status/show verbs work as any user for their own
/// sessions.
class LoginctlCmd extends CommandBuilder<LoginctlCmd> {
  @override
  final String executable = 'loginctl';

  /// Lists current sessions (`list-sessions`).
  LoginctlCmd listSessions() => token('list-sessions');

  /// Shows runtime status and recent journal entries for one or more sessions (`session-status`).
  LoginctlCmd sessionStatus() => token('session-status');

  /// Shows the properties of one or more sessions, or the manager itself with none named (`show-session`).
  LoginctlCmd showSession() => token('show-session');

  /// Brings a session to the foreground on its seat (`activate`).
  LoginctlCmd activate() => token('activate');

  /// Activates the screen lock on the given sessions (`lock-session`).
  LoginctlCmd lockSession() => token('lock-session');

  /// Deactivates the screen lock on the given sessions (`unlock-session`).
  LoginctlCmd unlockSession() => token('unlock-session');

  /// Activates the screen lock on every session that supports it (`lock-sessions`).
  LoginctlCmd lockSessions() => token('lock-sessions');

  /// Deactivates the screen lock on every session (`unlock-sessions`).
  LoginctlCmd unlockSessions() => token('unlock-sessions');

  /// Kills every process of a session and deallocates its resources (`terminate-session`).
  LoginctlCmd terminateSession() => token('terminate-session');

  /// Sends a signal to the processes of a session; pick it with [signal] (`kill-session`).
  LoginctlCmd killSession() => token('kill-session');

  /// Lists currently logged-in users (`list-users`).
  LoginctlCmd listUsers() => token('list-users');

  /// Shows runtime status and journal entries for one or more users (`user-status`).
  LoginctlCmd userStatus() => token('user-status');

  /// Shows the properties of one or more users, or the manager itself with none named (`show-user`).
  LoginctlCmd showUser() => token('show-user');

  /// Keeps a user's systemd `--user` manager running after their last session ends (`enable-linger`).
  ///
  /// Without this, a user's `--user` services and timers stop the moment
  /// their last login session closes.
  LoginctlCmd enableLinger() => token('enable-linger');

  /// Reverts [enableLinger] (`disable-linger`).
  LoginctlCmd disableLinger() => token('disable-linger');

  /// Ends every session belonging to the given users (`terminate-user`).
  LoginctlCmd terminateUser() => token('terminate-user');

  /// Sends a signal to every process of the given users (`kill-user`).
  LoginctlCmd killUser() => token('kill-user');

  /// Lists the seats currently available on this system (`list-seats`).
  LoginctlCmd listSeats() => token('list-seats');

  /// Shows runtime status for one or more seats (`seat-status`).
  LoginctlCmd seatStatus() => token('seat-status');

  /// Shows the properties of one or more seats, or the manager itself with none named (`show-seat`).
  LoginctlCmd showSeat() => token('show-seat');

  /// Persistently attaches one or more devices to a seat, creating the seat if needed (`attach`).
  LoginctlCmd attach() => token('attach');

  /// Removes every device assignment previously made with [attach] (`flush-devices`).
  LoginctlCmd flushDevices() => token('flush-devices');

  /// Ends every session on the given seats (`terminate-seat`).
  LoginctlCmd terminateSeat() => token('terminate-seat');

  /// Adds a session ID, username or seat name for the verb to act on. Repeatable.
  LoginctlCmd id(String value) => token(value);

  /// Skips the polkit authentication prompt for a privileged call (`--no-ask-password`).
  LoginctlCmd noAskPassword() => token('--no-ask-password');

  /// Limits [showSession]/[showUser]/[showSeat] to this property name. Repeatable (`-p`, `--property`).
  LoginctlCmd property(String name) => joined('--property', name);

  /// Prints only the value, not the `Key=` prefix (`--value`).
  LoginctlCmd valueOnly() => token('--value');

  /// Shows every property, including ones that are empty or unset (`-a`, `--all`).
  LoginctlCmd all() => token('--all');

  /// Does not ellipsize process tree entries in [sessionStatus]/[userStatus] (`-l`, `--full`).
  LoginctlCmd full() => token('--full');

  /// Under [killSession]/[killUser], selects which processes to signal: `leader` or `all` (`--kill-whom`).
  LoginctlCmd killWhom(String value) => joined('--kill-whom', value);

  /// The signal [killSession]/[killUser] sends, e.g. `SIGTERM` (`-s`, `--signal`).
  LoginctlCmd signal(String value) => pair('--signal', value);

  /// How many journal lines [sessionStatus]/[userStatus] show; defaults to 10 (`-n`, `--lines`).
  LoginctlCmd lines(int count) => pair('--lines', '$count');

  /// The journal output format, as in `journalctl(1)` (`-o`, `--output`).
  ///
  /// Named for the flag it wraps, not the runner: `CommandBuilder.output()` is
  /// what actually runs the command.
  LoginctlCmd outputFormat(String format) => pair('--output', format);

  /// Runs against a remote machine over SSH (`-H`, `--host`).
  LoginctlCmd host(String value) => pair('--host', value);

  /// Runs against a local container or VM (`-M`, `--machine`).
  LoginctlCmd machine(String value) => pair('--machine', value);

  /// Writes straight out rather than through a pager (`--no-pager`).
  LoginctlCmd noPager() => token('--no-pager');

  /// Drops the column headers and summary footer from list output (`--no-legend`).
  LoginctlCmd noLegend() => token('--no-legend');

  /// Prints the usage summary (`-h`, `--help`).
  LoginctlCmd help() => token('--help');

  /// Prints the version (`--version`).
  LoginctlCmd version() => token('--version');
}

/// `loginctl`, ready to take its verb.
// ignore: non_constant_identifier_names
LoginctlCmd get Loginctl => LoginctlCmd();
