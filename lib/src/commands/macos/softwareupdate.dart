// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

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
