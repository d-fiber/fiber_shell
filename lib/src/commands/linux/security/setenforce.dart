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

/// `setenforce`, the one-word SELinux mode switch. Linux only, and only on a
/// system running SELinux (Fedora, RHEL and their relatives; Debian and
/// Ubuntu default to AppArmor instead, where this binary does not exist).
///
/// ```dart
/// await Setenforce.permissive().asRoot().execute();
/// ```
///
/// It only flips between the two running modes and always needs root; it
/// cannot turn SELinux on or off; that lives in `/etc/selinux/config` and
/// wants a reboot. The change made here does not survive one either — after a
/// reboot, SELinux comes back in whatever `/etc/selinux/config` says.
class SetenforceCmd extends CommandBuilder<SetenforceCmd> {
  @override
  final String executable = 'setenforce';

  /// Puts SELinux in enforcing mode: violations are blocked and logged (`Enforcing`, `1`).
  SetenforceCmd enforcing() => token('Enforcing');

  /// Puts SELinux in permissive mode: violations are only logged, never blocked (`Permissive`, `0`).
  SetenforceCmd permissive() => token('Permissive');
}

/// `setenforce`, ready to take the mode to switch to.
// ignore: non_constant_identifier_names
SetenforceCmd get Setenforce => SetenforceCmd();
