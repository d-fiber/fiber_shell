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

/// `apt-get`, the Debian package tool. Debian and its derivatives only. A
/// Fedora or Alpine box has `dnf` or `apk` instead, so a provisioning path that
/// assumes this one is a provisioning path that only works on half of Linux.
///
/// ```dart
/// await AptGet.update().quiet().asRoot().execute();
/// await AptGet.install().assumeYes().noInstallRecommends().arg('wireguard').asRoot().execute();
/// ```
///
/// `apt-get` rather than `apt`: the latter is built for people, warns that it
/// has no stable interface, and changes its output between releases. This one is
/// the scripting interface, and it stays put.
///
/// Three things an unattended run needs. [assumeYes], or apt-get stops at a
/// prompt; `DEBIAN_FRONTEND=noninteractive` in the environment, or a package
/// with a debconf question does the same from inside; and an [update] before the
/// first [install], since a stale index installs a version that is no longer on
/// the mirror.
///
/// Everything that writes wants `asRoot()`.
class AptGetCmd extends CommandBuilder<AptGetCmd> {
  @override
  final String executable = 'apt-get';

  /// Refreshes the package index (`update`). Installs nothing.
  AptGetCmd update() => token('update');

  /// Upgrades the installed packages, never removing one (`upgrade`).
  AptGetCmd upgrade() => token('upgrade');

  /// Upgrades and lets dependencies be removed to do it (`dist-upgrade`).
  AptGetCmd distUpgrade() => token('dist-upgrade');

  /// Installs or upgrades the named packages (`install`).
  AptGetCmd install() => token('install');

  /// Removes packages, leaving their configuration behind (`remove`).
  AptGetCmd remove() => token('remove');

  /// Removes packages and their configuration (`purge`).
  AptGetCmd purge() => token('purge');

  /// Removes the dependencies nothing needs any more (`autoremove`).
  AptGetCmd autoremove() => token('autoremove');

  /// Deletes the cached files that can no longer be downloaded (`autoclean`).
  AptGetCmd autoclean() => token('autoclean');

  /// Empties the package cache (`clean`).
  AptGetCmd clean() => token('clean');

  /// Fetches the source of a package (`source`).
  AptGetCmd source() => token('source');

  /// Installs what is needed to build a package (`build-dep`).
  AptGetCmd buildDep() => token('build-dep');

  /// Updates the cache and looks for broken dependencies (`check`).
  AptGetCmd check() => token('check');

  /// Downloads a package without installing it (`download`).
  AptGetCmd download() => token('download');

  /// Installs whatever satisfies the given dependency strings (`satisfy`).
  AptGetCmd satisfy() => token('satisfy');

  /// Answers yes to every prompt (`--assume-yes`).
  AptGetCmd assumeYes() => token('--assume-yes');

  /// Answers no to every prompt (`--assume-no`).
  AptGetCmd assumeNo() => token('--assume-no');

  /// Drops the progress indicators, leaving output fit for a log (`--quiet`).
  AptGetCmd quiet() => token('--quiet');

  /// Reports what would happen and changes nothing (`--simulate`).
  AptGetCmd simulate() => token('--simulate');

  /// Downloads the packages without unpacking them (`--download-only`).
  AptGetCmd downloadOnly() => token('--download-only');

  /// Tries to repair the broken dependencies it finds (`--fix-broken`).
  AptGetCmd fixBroken() => token('--fix-broken');

  /// Carries on when a package cannot be fetched (`--ignore-missing`).
  AptGetCmd ignoreMissing() => token('--ignore-missing');

  /// Installs the dependencies but not the recommendations (`--no-install-recommends`).
  ///
  /// What keeps a one-package install from dragging in a desktop environment.
  AptGetCmd noInstallRecommends() => token('--no-install-recommends');

  /// Installs the suggestions too (`--install-suggests`).
  AptGetCmd installSuggests() => token('--install-suggests');

  /// Allows a package to be replaced by an older version (`--allow-downgrades`).
  AptGetCmd allowDowngrades() => token('--allow-downgrades');

  /// Allows an essential package to be removed (`--allow-remove-essential`).
  ///
  /// Almost always a mistake; the prompt it silences is there for a reason.
  AptGetCmd allowRemoveEssential() => token('--allow-remove-essential');

  /// Allows a held package to change (`--allow-change-held-packages`).
  AptGetCmd allowChangeHeldPackages() => token('--allow-change-held-packages');

  /// Leaves an already-installed package at its current version (`--no-upgrade`).
  AptGetCmd noUpgrade() => token('--no-upgrade');

  /// Only upgrades, never installs something new (`--only-upgrade`).
  AptGetCmd onlyUpgrade() => token('--only-upgrade');

  /// Reinstalls a package already at the newest version (`--reinstall`).
  AptGetCmd reinstall() => token('--reinstall');

  /// Prints the full version of everything it touches (`--verbose-versions`).
  AptGetCmd verboseVersions() => token('--verbose-versions');

  /// Sets a configuration option, `Key::Sub=value` (`--option`).
  AptGetCmd option(String assignment) => pair('--option', assignment);

  /// The configuration file to read (`--config-file`).
  AptGetCmd configFile(String path) => pair('--config-file', path);

  /// Prefers this release, `stable` or `bookworm-backports` (`--target-release`).
  AptGetCmd targetRelease(String value) => pair('--target-release', value);

  /// Purges rather than removes whatever gets removed (`--purge`).
  AptGetCmd purgeFlag() => token('--purge');

  /// Also removes the dependencies nothing needs any more (`--auto-remove`).
  AptGetCmd autoRemoveFlag() => token('--auto-remove');

  /// Prints progress while working (`--show-progress`).
  AptGetCmd showProgress() => token('--show-progress');

  /// Adds a package name, optionally `name=version`.
  AptGetCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
AptGetCmd get AptGet => AptGetCmd();
