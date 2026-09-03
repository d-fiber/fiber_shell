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

/// `driverquery`, the installed-driver lister: name, type, state, and
/// optionally the signing details. Windows only.
///
/// ```dart
/// final ShellResult drivers = await Driverquery.format('csv').verbose().output();
/// ```
///
/// [signedDrivers] (`/si`) is the one worth reaching for on a machine you do
/// not fully trust: it lists each driver's signer and whether the signature
/// verified, which the default listing says nothing about.
///
/// [verbose] and [signedDrivers] cannot be combined: `/v` is explicitly not
/// valid for signed-driver output. [noHeader] has no effect on `list`
/// format, only `table` and `csv`.
///
/// Every documented switch: `/s`, `/u`, `/p`, `/fo`, `/nh`, `/v`, `/si`.
class DriverqueryCmd extends CommandBuilder<DriverqueryCmd> {
  @override
  final String executable = 'driverquery';

  /// The remote machine to query (`/s`).
  DriverqueryCmd server(String value) => pair('/s', value);

  /// The account to query as, `[domain\\]user` (`/u`). Needs [server].
  DriverqueryCmd user(String value) => pair('/u', value);

  /// Its password (`/p`). Needs [user].
  DriverqueryCmd password(String value) => pair('/p', value);

  /// The output format: `table` (default), `list` or `csv` (`/fo`).
  DriverqueryCmd format(String value) => pair('/fo', value);

  /// Drops the header row (`/nh`). Not valid with `list` format.
  DriverqueryCmd noHeader() => token('/nh');

  /// The verbose listing, driver path and dates included (`/v`). Not valid
  /// with [signedDrivers].
  DriverqueryCmd verbose() => token('/v');

  /// The signed-driver listing: signer and verification state (`/si`). Not
  /// valid with [verbose].
  DriverqueryCmd signedDrivers() => token('/si');
}

/// `driverquery`, ready to take its first option.
// ignore: non_constant_identifier_names
DriverqueryCmd get Driverquery => DriverqueryCmd();
