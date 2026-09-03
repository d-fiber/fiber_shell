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

/// `npm`, the Node package manager. It travels with Node, so it is wherever Node
/// is and nowhere else, so `commandExists` before assuming.
///
/// ```dart
/// await Npm.ci().ignoreScripts().execute(cwd: hostingDir);
/// ```
///
/// The subcommand comes first, then its options, then the package specs. Most
/// options are really config keys, which is why they are written `--name=value`:
/// npm reads the same keys from `.npmrc`, and the command line simply wins.
///
/// [ci] over [install] in anything automated: it honours the lockfile exactly and
/// fails instead of quietly resolving something new.
class NpmCmd extends CommandBuilder<NpmCmd> {
  @override
  final String executable = 'npm';

  /// Manages the public or restricted access of a package (`access`).
  NpmCmd access() => token('access');

  /// Creates or logs into a registry account (`adduser`).
  NpmCmd adduser() => token('adduser');

  /// Reports the known vulnerabilities in the tree (`audit`).
  NpmCmd audit() => token('audit');

  /// Opens the package's bug tracker (`bugs`).
  NpmCmd bugs() => token('bugs');

  /// Inspects or clears the npm cache (`cache`).
  NpmCmd cache() => token('cache');

  /// Installs exactly what the lockfile says, after wiping `node_modules` (`ci`).
  ///
  /// Fails when the lockfile and `package.json` disagree, which is the point.
  NpmCmd ci() => token('ci');

  /// Prints the shell completion script (`completion`).
  NpmCmd completion() => token('completion');

  /// Reads and writes npm config (`config`).
  NpmCmd config() => token('config');

  /// Flattens duplicate packages in the tree (`dedupe`).
  NpmCmd dedupe() => token('dedupe');

  /// Marks a published version deprecated (`deprecate`).
  NpmCmd deprecate() => token('deprecate');

  /// Diffs two package versions (`diff`).
  NpmCmd diff() => token('diff');

  /// Manages the dist-tags of a package (`dist-tag`).
  NpmCmd distTag() => token('dist-tag');

  /// Opens the package's documentation (`docs`).
  NpmCmd docs() => token('docs');

  /// Checks that the npm installation is healthy (`doctor`).
  NpmCmd doctor() => token('doctor');

  /// Opens an installed package in the editor (`edit`).
  NpmCmd edit() => token('edit');

  /// Runs a package binary, fetching it if needed (`exec`). What `npx` calls.
  NpmCmd exec() => token('exec');

  /// Explains why a package is in the tree (`explain`).
  NpmCmd explain() => token('explain');

  /// Opens a subshell inside an installed package (`explore`).
  NpmCmd explore() => token('explore');

  /// Reports what [dedupe] would do (`find-dupes`).
  NpmCmd findDupes() => token('find-dupes');

  /// Lists the packages asking for funding (`fund`).
  NpmCmd fund() => token('fund');

  /// Reads one config value (`get`).
  NpmCmd getConfig() => token('get');

  /// Prints help for a command (`help`).
  NpmCmd help() => token('help');

  /// Searches the npm documentation (`help-search`).
  NpmCmd helpSearch() => token('help-search');

  /// Manages registry hooks (`hook`).
  NpmCmd hook() => token('hook');

  /// Creates a `package.json`, or runs a create-package (`init`).
  NpmCmd init() => token('init');

  /// Installs dependencies, resolving what the lockfile leaves open (`install`).
  NpmCmd install() => token('install');

  /// Runs [ci] then the tests (`install-ci-test`).
  NpmCmd installCiTest() => token('install-ci-test');

  /// Runs [install] then the tests (`install-test`).
  NpmCmd installTest() => token('install-test');

  /// Symlinks a package into the global folder, or out of it (`link`).
  NpmCmd link() => token('link');

  /// Lists the tree with detail (`ll`).
  NpmCmd ll() => token('ll');

  /// Logs into a registry (`login`).
  NpmCmd login() => token('login');

  /// Logs out of a registry (`logout`).
  NpmCmd logout() => token('logout');

  /// Lists the installed tree (`ls`).
  NpmCmd ls() => token('ls');

  /// Manages the members of an organisation (`org`).
  NpmCmd org() => token('org');

  /// Reports the dependencies that have moved on (`outdated`).
  NpmCmd outdated() => token('outdated');

  /// Manages the owners of a package (`owner`).
  NpmCmd owner() => token('owner');

  /// Builds the tarball that would be published (`pack`).
  NpmCmd pack() => token('pack');

  /// Checks the registry answers (`ping`).
  NpmCmd ping() => token('ping');

  /// Reads and writes fields of `package.json` (`pkg`).
  NpmCmd pkg() => token('pkg');

  /// Prints the prefix directory (`prefix`).
  NpmCmd prefixCommand() => token('prefix');

  /// Manages the registry profile (`profile`).
  NpmCmd profile() => token('profile');

  /// Removes the packages no longer in `package.json` (`prune`).
  NpmCmd prune() => token('prune');

  /// Publishes the package (`publish`).
  NpmCmd publish() => token('publish');

  /// Selects packages in the tree with a CSS-like query (`query`).
  NpmCmd query() => token('query');

  /// Rebuilds the native modules (`rebuild`).
  NpmCmd rebuild() => token('rebuild');

  /// Opens the package's repository (`repo`).
  NpmCmd repo() => token('repo');

  /// Runs the restart script (`restart`).
  NpmCmd restart() => token('restart');

  /// Prints the `node_modules` directory (`root`).
  NpmCmd root() => token('root');

  /// Runs a script from `package.json` (`run`).
  NpmCmd run() => token('run');

  /// The same as [run], spelled in full (`run-script`).
  NpmCmd runScript() => token('run-script');

  /// Emits a software bill of materials (`sbom`).
  NpmCmd sbom() => token('sbom');

  /// Searches the registry (`search`).
  NpmCmd search() => token('search');

  /// Writes one config value (`set`).
  NpmCmd setConfig() => token('set');

  /// Turns the lockfile into a publishable `npm-shrinkwrap.json` (`shrinkwrap`).
  NpmCmd shrinkwrap() => token('shrinkwrap');

  /// Stars a package (`star`).
  NpmCmd star() => token('star');

  /// Lists the packages starred (`stars`).
  NpmCmd stars() => token('stars');

  /// Runs the start script (`start`).
  NpmCmd start() => token('start');

  /// Runs the stop script (`stop`).
  NpmCmd stop() => token('stop');

  /// Manages the teams of an organisation (`team`).
  NpmCmd team() => token('team');

  /// Runs the test script (`test`).
  NpmCmd test() => token('test');

  /// Manages registry authentication tokens (`token`).
  NpmCmd tokenCommand() => token('token');

  /// Removes a dependency (`uninstall`).
  NpmCmd uninstall() => token('uninstall');

  /// Removes a published version from the registry (`unpublish`).
  NpmCmd unpublish() => token('unpublish');

  /// Unstars a package (`unstar`).
  NpmCmd unstar() => token('unstar');

  /// Updates dependencies within their declared ranges (`update`).
  NpmCmd update() => token('update');

  /// Bumps the version and tags the commit (`version`).
  NpmCmd version() => token('version');

  /// Prints registry metadata about a package (`view`).
  NpmCmd view() => token('view');

  /// Prints the logged-in user (`whoami`).
  NpmCmd whoami() => token('whoami');

  /// Records the package in `dependencies` (`--save`). Already the default.
  NpmCmd save() => token('--save');

  /// Installs without touching `package.json` (`--no-save`).
  NpmCmd noSave() => token('--no-save');

  /// Records it in `dependencies` explicitly (`--save-prod`).
  NpmCmd saveProd() => token('--save-prod');

  /// Records it in `devDependencies` (`--save-dev`).
  NpmCmd saveDev() => token('--save-dev');

  /// Records it in `optionalDependencies` (`--save-optional`).
  NpmCmd saveOptional() => token('--save-optional');

  /// Records it in `peerDependencies` (`--save-peer`).
  NpmCmd savePeer() => token('--save-peer');

  /// Adds it to `bundleDependencies` as well (`--save-bundle`).
  NpmCmd saveBundle() => token('--save-bundle');

  /// Records the exact version, without a `^` range (`--save-exact`).
  NpmCmd saveExact() => token('--save-exact');

  /// Works on the global install rather than this project (`--global`).
  NpmCmd global() => token('--global');

  /// How to lay out the tree: `hoisted`, `nested`, `shallow` or `linked` (`--install-strategy`).
  NpmCmd installStrategy(String value) => pair('--install-strategy', value);

  /// Lays the tree out the npm 3 way, nothing hoisted (`--legacy-bundling`).
  NpmCmd legacyBundling() => token('--legacy-bundling');

  /// Keeps the top level flat, hoisting nothing above it (`--global-style`).
  NpmCmd globalStyle() => token('--global-style');

  /// Leaves out a dependency type: `dev`, `optional` or `peer` (`--omit`). Repeatable.
  NpmCmd omit(String value) => pair('--omit', value);

  /// Puts a dependency type back in: `prod`, `dev`, `optional` or `peer` (`--include`).
  NpmCmd include(String value) => pair('--include', value);

  /// Fails on a peer dependency conflict instead of picking (`--strict-peer-deps`).
  NpmCmd strictPeerDeps() => token('--strict-peer-deps');

  /// Ignores peer dependencies entirely, npm 6 style (`--legacy-peer-deps`).
  NpmCmd legacyPeerDeps() => token('--legacy-peer-deps');

  /// Prefers reusing a package over installing another copy (`--prefer-dedupe`).
  NpmCmd preferDedupe() => token('--prefer-dedupe');

  /// Neither reads nor writes the lockfile (`--no-package-lock`).
  NpmCmd noPackageLock() => token('--no-package-lock');

  /// Updates the lockfile without touching `node_modules` (`--package-lock-only`).
  NpmCmd packageLockOnly() => token('--package-lock-only');

  /// Shows the output of lifecycle scripts as they run (`--foreground-scripts`).
  NpmCmd foregroundScripts() => token('--foreground-scripts');

  /// Runs no lifecycle script at all (`--ignore-scripts`).
  ///
  /// Worth setting whenever the dependencies are not fully trusted; an install script is arbitrary code.
  NpmCmd ignoreScripts() => token('--ignore-scripts');

  /// Skips the audit report (`--no-audit`).
  NpmCmd noAudit() => token('--no-audit');

  /// Creates no symlinks in `.bin` (`--no-bin-links`).
  NpmCmd noBinLinks() => token('--no-bin-links');

  /// Skips the funding notice (`--no-fund`).
  NpmCmd noFund() => token('--no-fund');

  /// Reports what would happen and changes nothing (`--dry-run`).
  NpmCmd dryRun() => token('--dry-run');

  /// Installs for this cpu rather than the host one (`--cpu`).
  NpmCmd cpu(String value) => pair('--cpu', value);

  /// Installs for this operating system rather than the host one (`--os`).
  NpmCmd os(String value) => pair('--os', value);

  /// Installs for this libc, `glibc` or `musl` (`--libc`).
  NpmCmd libc(String value) => pair('--libc', value);

  /// Restricts the command to this workspace (`--workspace`). Repeatable.
  NpmCmd workspace(String name) => pair('--workspace', name);

  /// Runs across every workspace (`--workspaces`).
  NpmCmd workspaces() => token('--workspaces');

  /// Includes the root package alongside the workspaces (`--include-workspace-root`).
  NpmCmd includeWorkspaceRoot() => token('--include-workspace-root');

  /// Installs `file:` dependencies as real copies rather than symlinks (`--install-links`).
  NpmCmd installLinks() => token('--install-links');

  /// Exits quietly when the script does not exist (`--if-present`).
  NpmCmd ifPresent() => token('--if-present');

  /// The shell to run scripts with, instead of `/bin/sh` (`--script-shell`).
  NpmCmd scriptShell(String value) => pair('--script-shell', value);

  /// Fails when the declared engine range does not match (`--engine-strict=true`).
  NpmCmd engineStrict() => joined('--engine-strict', 'true');

  /// Downgrades that failure to a warning (`--engine-strict=false`).
  ///
  /// The escape hatch for a dependency whose `engines` field has gone stale.
  NpmCmd engineStrictFalse() => joined('--engine-strict', 'false');

  /// Pushes through the checks npm would otherwise stop at (`--force`).
  NpmCmd force() => token('--force');

  /// Answers yes to the prompts, which `npm init` and `npm exec` ask (`--yes`).
  NpmCmd yes() => token('--yes');

  /// Prints nothing but the command output (`--silent`).
  NpmCmd silent() => token('--silent');

  /// How much to say: `silent` through `silly` (`--loglevel`).
  NpmCmd loglevel(String value) => joined('--loglevel', value);

  /// The registry to talk to (`--registry`).
  NpmCmd registry(String url) => joined('--registry', url);

  /// The directory to install into (`--prefix`).
  NpmCmd prefix(String path) => joined('--prefix', path);

  /// The `.npmrc` to read instead of the one in `$HOME` (`--userconfig`).
  NpmCmd userconfig(String path) => joined('--userconfig', path);

  /// The cache directory (`--cache`).
  NpmCmd cacheDir(String path) => joined('--cache', path);

  /// The dist-tag to publish under, or install from (`--tag`).
  NpmCmd tag(String value) => joined('--tag', value);

  /// The access of a published package: `public` or `restricted` (`--access`).
  NpmCmd accessLevel(String value) => joined('--access', value);

  /// Prints JSON instead of prose (`--json`).
  NpmCmd json() => token('--json');

  /// Prints the long form of a listing (`--long`).
  NpmCmd long() => token('--long');

  /// Prints tab-separated output for another program to read (`--parseable`).
  NpmCmd parseable() => token('--parseable');

  /// How deep to walk the tree (`--depth`).
  NpmCmd depth(int value) => joined('--depth', '$value');

  /// The old spelling of `--omit=dev` (`--production`). Deprecated but still honoured.
  NpmCmd production() => token('--production');

  /// Ends the npm options, so the rest belongs to the script (`--`).
  NpmCmd separator() => token('--');

  /// Adds a package spec, `name`, `name@version` or a URL.
  NpmCmd packageSpec(String value) => token(value);

  /// The name of the script to run, after [run].
  NpmCmd script(String name) => token(name);

  /// Adds a bare argument, for anything this wrapper has no named option for.
  NpmCmd arg(String value) => token(value);
}

/// `npm`, ready to take its subcommand.
// ignore: non_constant_identifier_names
NpmCmd get Npm => NpmCmd();
