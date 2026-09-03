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

/// `dnf`, the Fedora, RHEL and CentOS package tool. Fedora, RHEL, CentOS and
/// their derivatives only. A Debian box has `apt-get` instead and an Arch one
/// `pacman`, so a provisioning path that assumes this one is a provisioning
/// path that only works on a third of Linux.
///
/// ```dart
/// await Dnf.install().assumeYes().arg('nginx').asRoot().execute();
/// await Dnf.repoquery().installed().arg('nginx').output();
/// ```
///
/// Recent Fedora releases ship `dnf5`, a rewrite with a CLI that overlaps this
/// one but is not identical. This wrapper targets the long-established dnf4
/// surface documented at https://dnf.readthedocs.io/en/latest/command_ref.html,
/// which is still what most deployed RHEL and CentOS systems run.
///
/// Everything that writes wants `asRoot()`: [install], [upgrade], [remove],
/// [autoremove], [distroSync], [downgrade], [reinstall] and [makecache] chief
/// among them. [search], [info], [list], [repoquery] and [history] read only.
class DnfCmd extends CommandBuilder<DnfCmd> {
  @override
  final String executable = 'dnf';

  /// Installs or upgrades the named packages (`install`).
  DnfCmd install() => token('install');

  /// Upgrades the installed packages, or one named package (`upgrade`).
  ///
  /// `update` is the older alias; both spellings run the same code.
  DnfCmd upgrade() => token('upgrade');

  /// Upgrades only the packages needed to resolve a reported problem (`upgrade-minimal`).
  DnfCmd upgradeMinimal() => token('upgrade-minimal');

  /// Removes the named packages (`remove`).
  ///
  /// `erase` is the older alias.
  DnfCmd remove() => token('remove');

  /// Removes the packages nothing else depends on any more (`autoremove`).
  DnfCmd autoremove() => token('autoremove');

  /// Synchronises installed packages to exactly what the repositories carry (`distro-sync`).
  ///
  /// Unlike [upgrade], this can downgrade a package if the enabled repositories
  /// now carry an older build than what is installed.
  DnfCmd distroSync() => token('distro-sync');

  /// Installs an older build of the named packages (`downgrade`).
  DnfCmd downgrade() => token('downgrade');

  /// Reinstalls the named packages at their current version (`reinstall`).
  DnfCmd reinstall() => token('reinstall');

  /// Lists the packages an upgrade would touch, without changing anything (`check-update`).
  ///
  /// Exits `100` rather than `0` when updates are available, which is the
  /// signal a provisioning script polls for.
  DnfCmd checkUpdate() => token('check-update');

  /// Refreshes the metadata and looks for broken dependencies (`check`).
  DnfCmd check() => token('check');

  /// Searches package names and summaries for a term (`search`).
  DnfCmd search() => token('search');

  /// Prints the full description of the named packages (`info`).
  ///
  /// Also the `history info` and `module info` subcommand: see [history] and
  /// [module].
  DnfCmd info() => token('info');

  /// Lists packages, narrowed by [installed], [available], [updates],
  /// [extras], [obsoletes] or [recent] (`list`).
  ///
  /// Also the `history list` subcommand: see [history].
  DnfCmd list() => token('list');

  /// Narrows [list] to what is installed (`--installed`).
  DnfCmd installed() => token('--installed');

  /// Narrows [list] to what a repository offers but is not installed (`--available`).
  DnfCmd available() => token('--available');

  /// Narrows [list] to the installed packages an upgrade would change (`--updates`).
  DnfCmd updates() => token('--updates');

  /// Narrows [list] to installed packages no enabled repository still carries (`--extras`).
  DnfCmd extras() => token('--extras');

  /// Narrows [list] to installed packages no repository provides any more (`--obsoletes`).
  DnfCmd obsoletes() => token('--obsoletes');

  /// Narrows [list] to packages installed in the last week (`--recent`).
  DnfCmd recent() => token('--recent');

  /// Finds the packages that provide a file or a capability (`provides`).
  ///
  /// `whatprovides` is the older alias.
  DnfCmd provides() => token('provides');

  /// Queries the package metadata directly, the scriptable way to filter it (`repoquery`).
  ///
  /// Also the `module repoquery` subcommand.
  DnfCmd repoquery() => token('repoquery');

  /// Installs every package of a group (`groupinstall`).
  DnfCmd groupinstall() => token('groupinstall');

  /// Removes every package of a group (`groupremove`).
  DnfCmd groupremove() => token('groupremove');

  /// Upgrades every package of a group (`groupupdate`).
  DnfCmd groupupdate() => token('groupupdate');

  /// Lists the available groups (`grouplist`).
  DnfCmd grouplist() => token('grouplist');

  /// Describes a group and the packages it carries (`groupinfo`).
  DnfCmd groupinfo() => token('groupinfo');

  /// Reads or replays the transaction log (`history`).
  ///
  /// Follow with [undo], [redo], [rollback], [list] or [info] to name what to
  /// do with it; a bare `history` prints the log itself.
  DnfCmd history() => token('history');

  /// Reverses one transaction, `history undo <id>` (`undo`).
  DnfCmd undo() => token('undo');

  /// Reapplies a transaction an [undo] took back, `history redo <id>` (`redo`).
  DnfCmd redo() => token('redo');

  /// Undoes every transaction back to `<id>`, `history rollback <id>` (`rollback`).
  DnfCmd rollback() => token('rollback');

  /// Lists the configured repositories (`repolist`).
  DnfCmd repolist() => token('repolist');

  /// Describes the configured repositories in full (`repoinfo`).
  DnfCmd repoinfo() => token('repoinfo');

  /// Downloads the repository metadata ahead of time (`makecache`).
  DnfCmd makecache() => token('makecache');

  /// Deletes cached data, narrowed by [all], [packages], [metadata], [dbcache]
  /// or [expireCache] (`clean`).
  DnfCmd clean() => token('clean');

  /// Every cached thing (`all`).
  DnfCmd all() => token('all');

  /// The downloaded package files only (`packages`).
  DnfCmd packages() => token('packages');

  /// The downloaded repository metadata only (`metadata`).
  DnfCmd metadata() => token('metadata');

  /// The parsed metadata cache only (`dbcache`).
  DnfCmd dbcache() => token('dbcache');

  /// Marks the cached metadata as expired, without deleting it (`expire-cache`).
  DnfCmd expireCache() => token('expire-cache');

  /// Changes why a package is considered installed, `mark install`, `mark
  /// remove` or `mark group` (`mark`).
  ///
  /// Follow with [install], [remove] or [group].
  DnfCmd mark() => token('mark');

  /// The `mark group` target: attributes a package to a group instead of a
  /// user request (`group`).
  DnfCmd group() => token('group');

  /// Lists, installs or manages a module stream, narrowed by [list], [info],
  /// [install], [remove], [enable], [disable] or [reset] (`module`).
  DnfCmd module() => token('module');

  /// Switches a module to a given stream (`enable`).
  DnfCmd enable() => token('enable');

  /// Disallows a module stream from being installed (`disable`).
  DnfCmd disable() => token('disable');

  /// Forgets the stream a module was set to, back to unselected (`reset`).
  DnfCmd reset() => token('reset');

  /// Downloads packages without installing them (`download`).
  DnfCmd download() => token('download');

  /// Lists the runtime dependencies of a package (`deplist`).
  DnfCmd deplist() => token('deplist');

  /// Installs what is needed to build a package from its spec (`builddep`).
  DnfCmd builddep() => token('builddep');

  /// Reads or edits repository configuration (`config-manager`).
  DnfCmd configManager() => token('config-manager');

  /// Talks to a Copr build repository (`copr`).
  DnfCmd copr() => token('copr');

  /// Reports the security and bug advisories covering the installed packages (`updateinfo`).
  DnfCmd updateinfo() => token('updateinfo');

  /// Replaces an installed package with a different one that provides the same capability (`swap`).
  DnfCmd swap() => token('swap');

  /// Answers every prompt with yes (`--assumeyes`).
  DnfCmd assumeYes() => token('--assumeyes');

  /// Answers every prompt with no (`--assumeno`).
  DnfCmd assumeNo() => token('--assumeno');

  /// Prints only errors (`--quiet`).
  DnfCmd quiet() => token('--quiet');

  /// Prints debugging detail (`--verbose`).
  DnfCmd verbose() => token('--verbose');

  /// Runs entirely from the existing cache, touching the network for nothing (`--cacheonly`).
  DnfCmd cacheonly() => token('--cacheonly');

  /// Reads configuration from this file instead of `/etc/dnf/dnf.conf` (`--config`).
  DnfCmd configFile(String path) => pair('--config', path);

  /// Disables a repository for this run only (`--disablerepo`).
  DnfCmd disablerepo(String pattern) => joined('--disablerepo', pattern);

  /// Enables a repository for this run only (`--enablerepo`).
  DnfCmd enablerepo(String pattern) => joined('--enablerepo', pattern);

  /// Restricts the command to this repository (`--repo`).
  DnfCmd repo(String id) => joined('--repo', id);

  /// Pretends to run against a different release version (`--releasever`).
  DnfCmd releasever(String value) => joined('--releasever', value);

  /// Treats this path as the filesystem root (`--installroot`).
  DnfCmd installroot(String path) => joined('--installroot', path);

  /// Overrides one configuration option, `name=value` (`--setopt`).
  DnfCmd setopt(String assignment) => joined('--setopt', assignment);

  /// Skips the GPG signature check (`--nogpgcheck`).
  ///
  /// Only for a repository whose signing key is not worth wiring up, such as
  /// one built locally.
  DnfCmd nogpgcheck() => token('--nogpgcheck');

  /// Requires the best available version of every package or fails (`--best`).
  DnfCmd best() => token('--best');

  /// Allows a lesser version when the best cannot be installed (`--nobest`).
  DnfCmd nobest() => token('--nobest');

  /// Allows removing a package to resolve a conflict (`--allowerasing`).
  DnfCmd allowerasing() => token('--allowerasing');

  /// Excludes packages matching this pattern from the operation (`--exclude`).
  DnfCmd exclude(String pattern) => joined('--exclude', pattern);

  /// Skips installing package documentation (`--nodocs`).
  DnfCmd nodocs() => token('--nodocs');

  /// Downloads the packages without installing them (`--downloadonly`).
  DnfCmd downloadonly() => token('--downloadonly');

  /// Treats the cached metadata as expired before running (`--refresh`).
  DnfCmd refresh() => token('--refresh');

  /// Narrows an upgrade to the packages fixing a security issue (`--security`).
  DnfCmd security() => token('--security');

  /// Narrows an upgrade to the packages fixing a reported bug (`--bugfix`).
  DnfCmd bugfix() => token('--bugfix');

  /// Narrows an upgrade to one advisory, by id (`--advisory`).
  DnfCmd advisory(String id) => joined('--advisory', id);

  /// Narrows an upgrade to one CVE (`--cve`).
  DnfCmd cve(String id) => joined('--cve', id);

  /// Runs as if the machine were a different architecture (`--forcearch`).
  DnfCmd forcearch(String arch) => joined('--forcearch', arch);

  /// Adds a package name, optionally `name-version`, a group name or a path.
  DnfCmd arg(String value) => token(value);
}

/// `dnf`, ready to take its first option.
// ignore: non_constant_identifier_names
DnfCmd get Dnf => DnfCmd();
