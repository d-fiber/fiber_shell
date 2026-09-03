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

/// `crontab`, the per-user cron table editor shipped by cronie and Vixie cron.
/// Linux only in this wrapper's scope, though the same name exists on macOS
/// and most other Unixes with a smaller flag set.
///
/// ```dart
/// final ShellResult existing = await Crontab.list().output();
/// await Crontab.file('deploy.cron').output();
/// await Crontab.remove().user('deploy').asRoot().output();
/// ```
///
/// **[edit] opens `$VISUAL` or `$EDITOR` on a terminal**, which is not
/// something a script can drive; [list], [remove] and [file] are the ones
/// automation actually uses. [file] installs a whole new table from a path,
/// replacing whatever was there — there is no way to add a single line to an
/// existing table without reading [list], editing the text, and writing it
/// back through [file] with `-` for stdin. [testSyntax] checks a file the same
/// way without installing it, worth running before either.
///
/// A bare call, with no [user], reads or writes the caller's own table.
/// Naming another [user]'s wants `asRoot()`, as does [selectHost] and
/// [showHost] on a cluster where cron jobs run on one designated node.
class CrontabCmd extends CommandBuilder<CrontabCmd> {
  @override
  final String executable = 'crontab';

  /// Installs the table from this file, or from stdin when it is `-`. The
  /// default action when a path is given with no other option.
  CrontabCmd file(String path) => token(path);

  /// Checks a table's syntax without installing it (`-T`).
  CrontabCmd testSyntax() => token('-T');

  /// Prints the current table (`-l`).
  CrontabCmd list() => token('-l');

  /// Removes the current table (`-r`).
  CrontabCmd remove() => token('-r');

  /// Asks for confirmation before [remove] deletes anything (`-i`).
  ///
  /// Interactive, like [edit]; leave it out for an unattended run.
  CrontabCmd confirmRemove() => token('-i');

  /// Opens the table in `$VISUAL` or `$EDITOR` (`-e`). Interactive, not for a
  /// script.
  CrontabCmd edit() => token('-e');

  /// Appends the caller's SELinux security context as an `MLS_LEVEL` setting
  /// before editing or replacing the table (`-s`).
  CrontabCmd selinuxContext() => token('-s');

  /// Sets which host in a cluster should run the jobs in this table; with no
  /// [hostname], clears the setting back to the local host (`-n`).
  CrontabCmd selectHost([String? hostname]) => hostname == null ? token('-n') : pair('-n', hostname);

  /// Prints which host in the cluster currently runs the jobs in this table
  /// (`-c`).
  CrontabCmd showHost() => token('-c');

  /// Works on this user's table instead of the caller's own (`-u`). Needs
  /// root, or the equivalent cron permission, for anyone but yourself.
  CrontabCmd user(String name) => pair('-u', name);

  /// Prints the version (`-V`).
  CrontabCmd version() => token('-V');
}

/// `crontab`, ready to take its first option.
// ignore: non_constant_identifier_names
CrontabCmd get Crontab => CrontabCmd();
