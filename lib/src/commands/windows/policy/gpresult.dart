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

/// `gpresult`, which prints the Resultant Set of Policy (RSoP): the Group
/// Policy settings actually in effect for a user and computer, after every
/// applicable site/domain/OU policy has been merged. Windows only.
///
/// ```dart
/// final ShellResult summary = await Gpresult.summary().output();
///
/// await Gpresult.remoteSystem('srvmain').targetUser(r'maindom\hiropln').scope('user').verbose().execute();
/// ```
///
/// **Exactly one output option is required** — [summary] (`/r`), [verbose]
/// (`/v`), [everything] (`/z`), or a file sink through [xmlFile]/[htmlFile] —
/// except when calling [help] alone. Leaving all of them out is a usage
/// error, not a sensible default.
///
/// [xmlFile] and [htmlFile] cannot be combined with [remoteUser],
/// [remotePassword], [summary], [verbose] or [everything]; on ARM64 Windows,
/// only the `SysWow64` copy of `gpresult` honors [htmlFile] at all.
///
/// [verbose] and [everything] can produce a lot of text — redirecting stdout
/// to a file, or reading [ShellResult.text] rather than watching [execute]'s
/// live output, is the practical way to consume either.
class GpresultCmd extends CommandBuilder<GpresultCmd> {
  @override
  final String executable = 'gpresult';

  /// The remote computer to query, name or IP address, no backslashes
  /// (`/s <system>`). Defaults to the local computer.
  GpresultCmd remoteSystem(String system) => pair('/s', system);

  /// The account to run the query as, on a [remoteSystem] (`/u <username>`).
  /// Defaults to whoever is signed in to the computer issuing the command.
  GpresultCmd remoteUser(String username) => pair('/u', username);

  /// The password for [remoteUser] (`/p [<password>]`). Omit the value to
  /// have `gpresult` prompt for it interactively instead. Cannot be combined
  /// with [xmlFile] or [htmlFile].
  GpresultCmd remotePassword([String? password]) => password == null ? token('/p') : pair('/p', password);

  /// The remote user whose RSoP data to display, `[domain\]user`
  /// (`/user <target>`).
  GpresultCmd targetUser(String target) => pair('/user', target);

  /// Limits the report to `user` or `computer` policy (`/scope
  /// {user|computer}`). Both are shown if this is omitted.
  GpresultCmd scope(String value) => pair('/scope', value);

  /// Saves the report as XML at the given path (`/x <filename>`). Mutually
  /// exclusive with [htmlFile], [remoteUser], [remotePassword], [summary],
  /// [verbose] and [everything].
  GpresultCmd xmlFile(String path) => pair('/x', path);

  /// Saves the report as HTML at the given path (`/h <filename>`). Same
  /// exclusions as [xmlFile]. Only the SysWow64 `gpresult` honors this on
  /// ARM64 Windows.
  GpresultCmd htmlFile(String path) => pair('/h', path);

  /// With [xmlFile] or [htmlFile], overwrites an existing file at that path
  /// instead of failing (`/f`).
  GpresultCmd force() => token('/f');

  /// Prints RSoP summary data (`/r`). One of the required output options.
  GpresultCmd summary() => token('/r');

  /// Prints verbose policy information, including settings applied with
  /// precedence 1 (`/v`). One of the required output options.
  GpresultCmd verbose() => token('/v');

  /// Prints every available detail, including settings applied with
  /// precedence 1 and higher (`/z`). One of the required output options —
  /// and the noisiest one; consider redirecting output.
  GpresultCmd everything() => token('/z');

  /// Prints usage help (`/?`).
  GpresultCmd help() => token('/?');
}

/// `gpresult`, ready to take its first option.
// ignore: non_constant_identifier_names
GpresultCmd get Gpresult => GpresultCmd();
