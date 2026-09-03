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

/// `apk`, the Alpine Linux package tool. Alpine and its derivatives only,
/// including most `FROM alpine` container images; a Fedora box has `dnf` and
/// an Arch one `pacman`.
///
/// ```dart
/// await Apk.add().arg('curl').asRoot().execute();
/// await Apk.add().virtual('.build-deps').arg('gcc').arg('musl-dev').asRoot().execute();
/// await Apk.search().arg('curl').output();
/// ```
///
/// [add], [del], [fix], [update], [upgrade] and [cache] all write to
/// `/lib/apk/db` and want `asRoot()`; a container that already runs as root
/// gets this for free, but the wrapper still names it, the way every other
/// wrapper in this package does. [list], [info], [search], [version] and
/// [policy] only read.
///
/// Two traps worth knowing before reaching for a flag by guesswork. [upgradeFlag]
/// is [add]'s `-u`, and it means "let this add upgrade packages and their
/// dependencies too", not "run the `update` subcommand first" — the two look
/// related but are not. And there is no short `-C` for [noCache]; despite the
/// pairing `-U`/`--update-cache` might suggest, `--no-cache` only has the long
/// spelling.
class ApkCmd extends CommandBuilder<ApkCmd> {
  @override
  final String executable = 'apk';

  /// Installs packages, and their dependencies (`add`).
  ApkCmd add() => token('add');

  /// Removes packages that nothing else installed still needs (`del`).
  ///
  /// `delete` is the older alias.
  ApkCmd del() => token('del');

  /// Reinstalls the packages a corrupted install left broken (`fix`).
  ApkCmd fix() => token('fix');

  /// Downloads the repository index without installing anything (`update`).
  ApkCmd update() => token('update');

  /// Upgrades every installed package to what the repositories now carry (`upgrade`).
  ApkCmd upgrade() => token('upgrade');

  /// Lists packages, installed or available (`list`).
  ApkCmd list() => token('list');

  /// Prints the detail of the named packages (`info`).
  ApkCmd info() => token('info');

  /// Searches package names for a pattern (`search`).
  ApkCmd search() => token('search');

  /// Builds a repository index from the packages in a directory (`index`).
  ApkCmd index() => token('index');

  /// Downloads packages without installing them (`fetch`).
  ApkCmd fetch() => token('fetch');

  /// Checks installed files against the package database for local changes (`audit`).
  ApkCmd audit() => token('audit');

  /// Checks the signature of a repository index or a package (`verify`).
  ApkCmd verify() => token('verify');

  /// Prints the installed apk-tools version (`version`).
  ApkCmd version() => token('version');

  /// Manages the local package cache, alongside `-U`/`--update-cache` (`cache`).
  ApkCmd cache() => token('cache');

  /// Prints package database statistics (`stats`).
  ApkCmd stats() => token('stats');

  /// Shows which repository a package would install from (`policy`).
  ApkCmd policy() => token('policy');

  /// Prints the list of files a package would install (`manifest`).
  ApkCmd manifest() => token('manifest');

  /// Prints the dependency graph in Graphviz format (`dot`).
  ApkCmd dot() => token('dot');

  /// Prints the command list and exits (`--help`).
  ApkCmd help() => token('--help');

  /// Treats this path as the filesystem root instead of `/` (`--root`).
  ApkCmd root(String path) => pair('--root', path);

  /// Adds a repository for this run only, on top of `/etc/apk/repositories` (`--repository`).
  ApkCmd repository(String repo) => pair('--repository', repo);

  /// Prints only what changed (`--quiet`).
  ApkCmd quiet() => token('--quiet');

  /// Prints more detail; can be given twice for even more (`--verbose`).
  ApkCmd verbose() => token('--verbose');

  /// Asks for confirmation before an operation that would otherwise run unattended (`--interactive`).
  ///
  /// The opposite of what a script wants, since there is nothing to answer the prompt.
  ApkCmd interactive() => token('--interactive');

  /// Enables the deprecated `--force-*` overrides as a group (`--force`).
  ApkCmd force() => token('--force');

  /// Refreshes the repository index as part of this command (`--update-cache`).
  ApkCmd updateCache() => token('--update-cache');

  /// Shows a progress bar while downloading (`--progress`).
  ApkCmd progress() => token('--progress');

  /// Hides it (`--no-progress`).
  ApkCmd noProgress() => token('--no-progress');

  /// Ignores the local package cache entirely (`--no-cache`).
  ///
  /// Long form only: apk has no `-C` short flag for this, unlike the `-U`
  /// short flag it does have for [updateCache].
  ApkCmd noCache() => token('--no-cache');

  /// Uses this directory as the package cache instead of the configured one (`--cache-dir`).
  ApkCmd cacheDir(String path) => pair('--cache-dir', path);

  /// Works entirely offline, from the cache and the installed database (`--no-network`).
  ApkCmd noNetwork() => token('--no-network');

  /// Waits up to this many seconds for the repository lock instead of failing immediately (`--wait`).
  ApkCmd wait(int seconds) => pair('--wait', '$seconds');

  /// Reads trusted signing keys from this directory instead of `/etc/apk/keys` (`--keys-dir`).
  ApkCmd keysDir(String path) => pair('--keys-dir', path);

  /// Reads the repository list from this file instead of `/etc/apk/repositories` (`--repositories-file`).
  ApkCmd repositoriesFile(String path) => pair('--repositories-file', path);

  /// Installs a package whose signature cannot be verified, or has none (`--allow-untrusted`).
  ///
  /// Only for a package built and signed locally with a key apk was never given.
  ApkCmd allowUntrusted() => token('--allow-untrusted');

  /// Deletes a package's modified configuration files instead of keeping them as `.apk-new` (`--purge`).
  ApkCmd purge() => token('--purge');

  /// Reports what the operation would change, without changing anything (`--simulate`).
  ApkCmd simulate() => token('--simulate');

  /// Skips the packages' install and uninstall scripts (`--no-scripts`).
  ApkCmd noScripts() => token('--no-scripts');

  /// Skips the pre- and post-transaction hook scripts, package scripts included otherwise (`--no-commit-hooks`).
  ApkCmd noCommitHooks() => token('--no-commit-hooks');

  /// Names the new virtual meta-package [add] creates to hold its targets as dependencies (`--virtual`).
  ///
  /// Removing the virtual package with [del] then removes the targets too,
  /// provided nothing else pulled them in. The usual build-dependency pattern:
  /// `Apk.add().virtual('.build-deps').arg('gcc').asRoot().execute()` followed
  /// later by `Apk.del().virtual('.build-deps')`.
  ApkCmd virtual(String name) => pair('--virtual', name);

  /// Lets [add] upgrade already-installed packages and their dependencies while it runs (`--upgrade`).
  ///
  /// This is `add`'s own `-u`, unrelated to the [update] subcommand despite
  /// the shared letter: without it, `add` only touches what installing the
  /// new target requires.
  ApkCmd upgradeFlag() => token('--upgrade');

  /// Always chooses the latest version a repository offers, package pinning aside (`--latest`).
  ///
  /// Shared by [add] and [upgrade].
  ApkCmd latest() => token('--latest');

  /// Resets every installed package to the version its repository currently carries (`--available`).
  ///
  /// `upgrade`'s own flag: it rewrites the versioned constraints `apk` recorded
  /// for the installed world.
  ApkCmd available() => token('--available');

  /// Skips apk-tools' own early self-upgrade during `upgrade` (`--no-self-upgrade`).
  ApkCmd noSelfUpgrade() => token('--no-self-upgrade');

  /// Upgrades every package except the ones named (`--ignore`).
  ///
  /// Inverts the usual meaning of a target list: these are the packages left alone.
  ApkCmd ignore(String pkg) => pair('--ignore', pkg);

  /// Also deletes a target's reverse dependencies, `del`'s own flag (`--rdepends`).
  ApkCmd rdepends() => token('--rdepends');

  /// Adds a package name, a virtual package name or a file path.
  ApkCmd arg(String value) => token(value);
}

/// `apk`, ready to take its first option.
// ignore: non_constant_identifier_names
ApkCmd get Apk => ApkCmd();
