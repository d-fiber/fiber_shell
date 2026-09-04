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

/// `takeown`, which makes an administrator the owner of a file or directory
/// that access was previously denied to. Windows only.
///
/// ```dart
/// await Takeown.file(r'C:\locked\report.docx').asRoot().execute();
///
/// await Takeown.file(r'C:\locked').recursive().defaultAnswer('Y').administrators().asRoot().execute();
/// ```
///
/// Taking ownership is not the same as having full permissions: `takeown`
/// changes who owns the object, but the ACLs themselves are untouched.
/// Reading or deleting the file afterwards usually still needs an explicit
/// grant through `Icacls` (see `icacls.dart`) — `takeown` alone gets you the
/// right to *change* permissions, not the permissions themselves.
///
/// [defaultAnswer] only matters together with [recursive]: partway through a
/// recursive walk, a subdirectory the current user cannot list or read
/// normally prompts for confirmation before `takeown` takes it over anyway.
/// [defaultAnswer]`('Y')` answers yes to every such prompt unattended;
/// `('N')` skips those directories instead of taking them over. Without
/// [recursive], [defaultAnswer] does nothing.
class TakeownCmd extends CommandBuilder<TakeownCmd> {
  @override
  final String executable = 'takeown';

  /// The remote computer to act on, name or IP address, no backslashes
  /// (`/s <computer>`). Applies to every file/directory named in the same
  /// command. Defaults to the local computer.
  TakeownCmd remoteSystem(String computer) => pair('/s', computer);

  /// The account to run as, on a [remoteSystem] (`/u [domain\]username`).
  /// Defaults to system permissions.
  TakeownCmd remoteUser(String username) => pair('/u', username);

  /// The password for [remoteUser] (`/p [<password>]`).
  TakeownCmd remotePassword([String? password]) => password == null ? token('/p') : pair('/p', password);

  /// The file or directory to take ownership of; `*` is a valid wildcard,
  /// and `<share>\<file>` is accepted too (`/f <filename>`). Required.
  TakeownCmd file(String pattern) => pair('/f', pattern);

  /// Gives ownership to the local Administrators group instead of the
  /// current user (`/a`).
  TakeownCmd administrators() => token('/a');

  /// Recurses into every file in the directory and its subdirectories
  /// (`/r`).
  TakeownCmd recursive() => token('/r');

  /// With [recursive], answers the confirmation prompt for a subdirectory
  /// the current user can't list/read: `'Y'` takes it over anyway, `'N'`
  /// skips it (`/d {Y|N}`). No effect without [recursive].
  TakeownCmd defaultAnswer(String answer) => pair('/d', answer);

  /// Prints usage help (`/?`).
  TakeownCmd help() => token('/?');
}

/// `takeown`, ready to take its first option.
// ignore: non_constant_identifier_names
TakeownCmd get Takeown => TakeownCmd();
