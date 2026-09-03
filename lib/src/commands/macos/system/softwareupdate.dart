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

/// `softwareupdate`, the system update tool. macOS only, and the counterpart of
/// `apt-get` in this directory: for the operating system, not for the packages
/// a developer installs.
///
/// ```dart
/// final ShellResult available = await Softwareupdate.list().noScan().output();
/// ```
///
/// **[install] with [all] can restart the machine**, and [restartIfRequired]
/// says so out loud. Running it unattended on a machine that hosts anything is a
/// decision, not a detail.
///
/// [list] contacts Apple and can sit there for a minute; [noScan] reuses the
/// last scan and answers immediately, which is what a status check wants.
///
/// On Apple silicon, installing a system update needs an owner's credentials.
/// There are flags for passing them, and they put a password where `ps` can read
/// it. A machine that must patch itself unattended is better served by the
/// built-in automatic updates.
///
/// Installing wants `asRoot()`.
class SoftwareupdateCmd extends CommandBuilder<SoftwareupdateCmd> {
  @override
  final String executable = 'softwareupdate';

  /// Lists the available updates by label (`--list`).
  SoftwareupdateCmd list() => token('--list');

  /// Downloads without installing (`--download`).
  SoftwareupdateCmd download() => token('--download');

  /// Installs updates (`--install`).
  SoftwareupdateCmd install() => token('--install');

  /// Every applicable update (`--all`).
  SoftwareupdateCmd all() => token('--all');

  /// Restarts or shuts down if the install needs it (`--restart`).
  SoftwareupdateCmd restartIfRequired() => token('--restart');

  /// Only the ones Apple recommends (`--recommended`).
  SoftwareupdateCmd recommended() => token('--recommended');

  /// Only the operating system updates (`--os-only`).
  SoftwareupdateCmd osOnly() => token('--os-only');

  /// Only the Safari updates (`--safari-only`).
  SoftwareupdateCmd safariOnly() => token('--safari-only');

  /// The owner password, on Apple silicon (`--stdinpass`).
  SoftwareupdateCmd stdinPassword() => token('--stdinpass');

  /// The owner account, on Apple silicon (`--user`).
  SoftwareupdateCmd user(String name) => pair('--user', name);

  /// Lists the full macOS installers available (`--list-full-installers`).
  SoftwareupdateCmd listFullInstallers() => token('--list-full-installers');

  /// Downloads the recommended full installer (`--fetch-full-installer`).
  SoftwareupdateCmd fetchFullInstaller() => token('--fetch-full-installer');

  /// Which version that installer should be (`--full-installer-version`).
  SoftwareupdateCmd fullInstallerVersion(String value) => pair('--full-installer-version', value);

  /// Installs Rosetta 2 (`--install-rosetta`).
  SoftwareupdateCmd installRosetta() => token('--install-rosetta');

  /// Triggers a background scan and update (`--background`).
  SoftwareupdateCmd backgroundScan() => token('--background');

  /// Logs the update daemon's internal state (`--dump-state`).
  SoftwareupdateCmd dumpState() => token('--dump-state');

  /// Evaluates the product keys given by [products] (`--evaluate-products`).
  SoftwareupdateCmd evaluateProducts() => token('--evaluate-products');

  /// Prints the install history (`--history`). Local, and immediate.
  SoftwareupdateCmd history() => token('--history');

  /// Reuses the last scan instead of contacting Apple (`--no-scan`).
  SoftwareupdateCmd noScan() => token('--no-scan');

  /// Limits a scan to a product type, `macOS` or `Safari` (`--product-types`).
  SoftwareupdateCmd productTypes(String value) => pair('--product-types', value);

  /// The product keys to act on, comma separated (`--products`).
  SoftwareupdateCmd products(String value) => pair('--products', value);

  /// Forces the operation through (`--force`).
  SoftwareupdateCmd force() => token('--force');

  /// Accepts the licence without asking (`--agree-to-license`).
  SoftwareupdateCmd agreeToLicense() => token('--agree-to-license');

  /// Says more (`--verbose`).
  SoftwareupdateCmd verbose() => token('--verbose');

  /// Prints the usage summary (`--help`).
  SoftwareupdateCmd help() => token('--help');

  /// Adds a bare argument, an update label above all.
  SoftwareupdateCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
SoftwareupdateCmd get Softwareupdate => SoftwareupdateCmd();
