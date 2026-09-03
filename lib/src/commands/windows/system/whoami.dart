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

/// `whoami`, the identity printer: which account, which groups, which
/// privileges, which claims. Windows only — the Unix `whoami` is a different,
/// far simpler program and not what this wraps.
///
/// ```dart
/// final ShellResult admin = await Whoami.groups().format('csv').noHeader().output();
/// ```
///
/// Plain `whoami` prints only `DOMAIN\user`. [all] is the one a script wants:
/// user, SID, groups and privileges together, in one call instead of four.
///
/// [format] and [noHeader] only apply to the [user]/[groups]/[claims]/[priv]/
/// [all] forms; [userPrincipalName], [fullyQualifiedDomainName] and
/// [logonId] are each their own bare form and cannot be combined with the
/// others or with a format.
///
/// Every documented switch: `/upn`, `/fqdn`, `/logonid`, `/user`, `/groups`,
/// `/claims`, `/priv`, `/fo`, `/all`, `/nh`.
class WhoamiCmd extends CommandBuilder<WhoamiCmd> {
  @override
  final String executable = 'whoami';

  /// The user name in User Principal Name format (`/upn`). Its own bare
  /// form.
  WhoamiCmd userPrincipalName() => token('/upn');

  /// The user name in Fully Qualified Domain Name format (`/fqdn`). Its own
  /// bare form.
  WhoamiCmd fullyQualifiedDomainName() => token('/fqdn');

  /// The logon ID of the current user (`/logonid`). Its own bare form.
  WhoamiCmd logonId() => token('/logonid');

  /// The current domain, user name and SID (`/user`).
  WhoamiCmd user() => token('/user');

  /// The groups the current user belongs to (`/groups`).
  WhoamiCmd groups() => token('/groups');

  /// The claims for the current user: name, flags, type and values
  /// (`/claims`).
  WhoamiCmd claims() => token('/claims');

  /// The security privileges held by the current user (`/priv`).
  WhoamiCmd priv() => token('/priv');

  /// User, SID, groups, privileges and claims together (`/all`).
  WhoamiCmd all() => token('/all');

  /// The output format: `table` (default), `list` or `csv` (`/fo`). Needs
  /// [user], [groups], [claims], [priv] or [all].
  WhoamiCmd format(String value) => pair('/fo', value);

  /// Drops the column headers (`/nh`). `table` and `csv` only.
  WhoamiCmd noHeader() => token('/nh');
}

/// `whoami`, ready to take its first option.
// ignore: non_constant_identifier_names
WhoamiCmd get Whoami => WhoamiCmd();
