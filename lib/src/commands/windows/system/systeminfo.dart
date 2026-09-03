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

/// `systeminfo`, the machine's full configuration dump: OS build, hotfixes,
/// memory, boot time, domain. Windows only.
///
/// ```dart
/// final ShellResult info = await Systeminfo.format('csv').output();
/// ```
///
/// It is **slow**: several seconds even on a local machine, because it queries
/// WMI for hotfixes and network adapters along the way. Do not call it in a
/// hot path or a loop.
///
/// [format] `csv` is the shape a script wants; the default is a fixed layout
/// meant for a person reading a terminal, not a parser. `csv` still comes with
/// a header row unless [noHeader] is added.
///
/// Every documented switch: `/s`, `/u`, `/p`, `/fo`, `/nh`.
class SysteminfoCmd extends CommandBuilder<SysteminfoCmd> {
  @override
  final String executable = 'systeminfo';

  /// The remote machine to query (`/s`).
  SysteminfoCmd server(String value) => pair('/s', value);

  /// The account to query as, `DOMAIN\\user` (`/u`). Needs [server].
  SysteminfoCmd user(String value) => pair('/u', value);

  /// Its password (`/p`).
  SysteminfoCmd password(String value) => pair('/p', value);

  /// The output format: `TABLE`, `LIST` or `CSV` (`/fo`).
  SysteminfoCmd format(String value) => pair('/fo', value);

  /// Drops the column headers (`/nh`). `TABLE` and `CSV` only.
  SysteminfoCmd noHeader() => token('/nh');
}

/// `systeminfo`, ready to take its first option.
// ignore: non_constant_identifier_names
SysteminfoCmd get Systeminfo => SysteminfoCmd();
