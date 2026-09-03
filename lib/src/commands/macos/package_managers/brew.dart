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

/// `brew`, the macOS (and Linux) package manager for formulae and casks.
///
/// **This wrapper is a vocabulary, not a grammar.** Every subcommand `brew commands`
/// lists is a method, and the flags shared across subcommands are a single method
/// each, reusable wherever brew accepts them. Nothing validates that `--greedy` goes
/// with `upgrade` rather than `tap`; brew will say so if you get it wrong.
///
/// ```dart
/// await Brew.install().cask().arg('visual-studio-code').execute();
/// final ShellResult outdated = await Brew.outdated().json().output();
/// ```
///
/// Homebrew is macOS-first, but it also runs on Linux, under `/home/linuxbrew`
/// rather than `/opt/homebrew` or `/usr/local`. A formula install rarely needs
/// `sudo`, and brew actively refuses to run most commands as root, the opposite of
/// most package managers in this catalogue: reach for [asRoot] on `services` when a
/// daemon must start at boot, not on `install`.
///
/// Three names collide with a subcommand and a flag. [head] is the `--HEAD` flag
/// shared by `install`, `link`, `create` and others, and the `formula` subcommand
/// that prints a path is [formulaPath]; [formula] and [cask] are the `--formula`
/// and `--cask` scoping flags, and the command that lists installable casks is
/// [casks]. `search --eval-all` is deprecated upstream with no replacement, so it
/// has no method here.
///
/// [uninstall], [remove] and [rm] are the same command under its three names, as
/// are [list] and [ls], [update] and [up], [doctor] and [dr], [home] and
/// [homepage], [livecheck] and [lc].
class BrewCmd extends CommandBuilder<BrewCmd> {
  @override
  final String executable = 'brew';

  /// Installs a formula or cask (`install`).
  BrewCmd install() => token('install');

  /// Removes an installed formula or cask (`uninstall`).
  BrewCmd uninstall() => token('uninstall');

  /// The same command, under its `remove` name.
  BrewCmd remove() => token('remove');

  /// The same command, under its `rm` name.
  BrewCmd rm() => token('rm');

  /// Lists the installed formulae and casks (`list`).
  BrewCmd list() => token('list');

  /// The same command, under its `ls` name.
  BrewCmd ls() => token('ls');

  /// Searches formula names and cask tokens for a substring or `/regex/` (`search`).
  BrewCmd search() => token('search');

  /// Shows information about a formula or cask (`info`).
  BrewCmd info() => token('info');

  /// The same command, under its `abv` name.
  BrewCmd abv() => token('abv');

  /// Fetches the newest Homebrew and formula definitions (`update`).
  BrewCmd update() => token('update');

  /// The same command, under its `up` name.
  BrewCmd up() => token('up');

  /// Upgrades the outdated, unpinned formulae and casks (`upgrade`).
  BrewCmd upgrade() => token('upgrade');

  /// Lists the installed packages with a newer version available (`outdated`).
  BrewCmd outdated() => token('outdated');

  /// Removes stale cache files and old kegs (`cleanup`).
  BrewCmd cleanup() => token('cleanup');

  /// Checks the system for problems Homebrew maintainers would ask about (`doctor`).
  BrewCmd doctor() => token('doctor');

  /// The same command, under its `dr` name.
  BrewCmd dr() => token('dr');

  /// Prints the Homebrew and system configuration (`config`).
  BrewCmd config() => token('config');

  /// Adds a tap, or lists the installed taps with no argument (`tap`).
  BrewCmd tap() => token('tap');

  /// Removes a tapped repository (`untap`).
  BrewCmd untap() => token('untap');

  /// Manages background services through `launchctl` or `systemctl` (`services`).
  BrewCmd services() => token('services');

  /// Shows the dependencies of a formula or cask (`deps`).
  BrewCmd deps() => token('deps');

  /// Shows what depends on a formula or cask (`uses`).
  BrewCmd uses() => token('uses');

  /// Lists the installed formulae that nothing else depends on (`leaves`).
  BrewCmd leaves() => token('leaves');

  /// Checks installed kegs and casks for missing dependencies (`missing`).
  BrewCmd missing() => token('missing');

  /// Symlinks a formula's installed files into the prefix (`link`).
  BrewCmd link() => token('link');

  /// The same command, under its `ln` name.
  BrewCmd ln() => token('ln');

  /// Removes a formula's symlinks from the prefix (`unlink`).
  BrewCmd unlink() => token('unlink');

  /// Excludes a formula from `upgrade` (`pin`).
  BrewCmd pin() => token('pin');

  /// Reverses [pin] (`unpin`).
  BrewCmd unpin() => token('unpin');

  /// Prints the path Homebrew's download cache uses (`--cache`).
  ///
  /// It is spelled with the leading dashes even as the first token: `brew --cache`
  /// is how the CLI itself lists it among its built-in commands.
  BrewCmd cache() => token('--cache');

  /// Opens a formula, cask, or Homebrew's own homepage in a browser (`home`).
  BrewCmd home() => token('home');

  /// The same command, under its `homepage` name.
  BrewCmd homepage() => token('homepage');

  /// Opens a formula, cask, or tap in `$EDITOR` (`edit`).
  ///
  /// Also the `bundle edit` subcommand, for the current directory's Brewfile.
  BrewCmd edit() => token('edit');

  /// Generates a formula or cask template for a URL and opens it in `$EDITOR` (`create`).
  BrewCmd create() => token('create');

  /// Shows the git log for a formula, cask, or the Homebrew repository (`log`).
  BrewCmd log() => token('log');

  /// Checks formulae or files against the Homebrew style guidelines (`style`).
  BrewCmd style() => token('style');

  /// Checks a formula or cask for the issues `brew style` alone would miss (`audit`).
  BrewCmd audit() => token('audit');

  /// Runs the `test` block an installed formula ships (`test`).
  BrewCmd test() => token('test');

  /// Manages non-Ruby dependencies through a Brewfile (`bundle`).
  BrewCmd bundle() => token('bundle');

  /// The `bundle` subcommand that writes the current state to a Brewfile (`dump`).
  BrewCmd dump() => token('dump');

  /// The `bundle` subcommand that checks the Brewfile is satisfied (`check`).
  BrewCmd check() => token('check');

  /// Controls Homebrew's anonymous analytics (`analytics`).
  BrewCmd analytics() => token('analytics');

  /// Removes the formulae that were only installed as a dependency and are no longer
  /// needed (`autoremove`).
  BrewCmd autoremove() => token('autoremove');

  /// Shows or edits a shell alias for a brew command (`alias`).
  BrewCmd alias() => token('alias');

  /// Lists the built-in and external commands (`commands`).
  BrewCmd commands() => token('commands');

  /// Prints the export statements that put this Homebrew on `$PATH` (`shellenv`).
  BrewCmd shellenv() => token('shellenv');

  /// Checks upstream for a newer version of a formula or cask (`livecheck`).
  BrewCmd livecheck() => token('livecheck');

  /// The same command, under its `lc` name.
  BrewCmd lc() => token('lc');

  /// Opens a pull request bumping a formula's URL, tag, or version (`bump-formula-pr`).
  BrewCmd bumpFormulaPr() => token('bump-formula-pr');

  /// Prints the path a formula's definition lives at (`formula`).
  ///
  /// The subcommand; the `--formula` scoping flag is [formula].
  BrewCmd formulaPath() => token('formula');

  /// Lists every locally installable cask, short names included (`casks`).
  BrewCmd casks() => token('casks');

  /// The `services` subcommand that runs a service without registering it (`run`).
  BrewCmd run() => token('run');

  /// The `services` subcommand that starts and registers a service (`start`).
  BrewCmd start() => token('start');

  /// The `services` subcommand that stops and unregisters a service (`stop`).
  BrewCmd stop() => token('stop');

  /// The `services` subcommand that stops then starts a service (`restart`).
  BrewCmd restart() => token('restart');

  /// The `services` subcommand that stops a service but leaves it registered (`kill`).
  BrewCmd kill() => token('kill');

  /// The `analytics` subcommand that turns collection on (`on`).
  BrewCmd on() => token('on');

  /// The `analytics` subcommand that turns collection off (`off`).
  BrewCmd off() => token('off');

  /// The `analytics` subcommand that prints whether collection is on (`state`).
  BrewCmd state() => token('state');

  /// Prints more of what a command does (`--verbose`).
  BrewCmd verbose() => token('--verbose');

  /// Prints a trace of the shell commands and Ruby calls a command makes (`--debug`).
  BrewCmd debug() => token('--debug');

  /// Prints less (`--quiet`).
  BrewCmd quiet() => token('--quiet');

  /// Overrides the check that would otherwise stop the command (`--force`).
  ///
  /// Its exact effect depends on the subcommand: `install` skips the keg-only
  /// version check, `uninstall` deletes every installed version, `tap` forces a
  /// core tap even under API mode.
  BrewCmd force() => token('--force');

  /// Reports what would happen and changes nothing (`--dry-run`).
  BrewCmd dryRun() => token('--dry-run');

  /// Answers the confirmation prompt automatically (`--yes`).
  BrewCmd yes() => token('--yes');

  /// Downloads and patches the formula, then opens a shell to configure it by hand
  /// (`--interactive`). Not for a script.
  BrewCmd interactive() => token('--interactive');

  /// Treats every named argument as a formula (`--formula`).
  BrewCmd formula() => token('--formula');

  /// Treats every named argument as a cask (`--cask`).
  ///
  /// Also the `create` flag that generates a cask template instead of a formula one.
  BrewCmd cask() => token('--cask');

  /// Prints a JSON representation instead of the human format (`--json`).
  BrewCmd json() => token('--json');

  /// Restricts the command to what is currently installed (`--installed`).
  BrewCmd installed() => token('--installed');

  /// Installs, links, or shows the HEAD version rather than the stable one (`--HEAD`).
  ///
  /// The flag; the `formula` subcommand that prints a path is [formulaPath].
  BrewCmd head() => token('--HEAD');

  /// Fetches the upstream repository to detect a stale HEAD install (`--fetch-HEAD`).
  BrewCmd fetchHead() => token('--fetch-HEAD');

  /// Keeps the temporary build or test files instead of deleting them (`--keep-tmp`).
  BrewCmd keepTmp() => token('--keep-tmp');

  /// Compiles from source even where a bottle is available (`--build-from-source`).
  BrewCmd buildFromSource() => token('--build-from-source');

  /// Installs from a bottle even where it would not normally be used (`--force-bottle`).
  BrewCmd forceBottle() => token('--force-bottle');

  /// Deletes files already present in the prefix while linking (`--overwrite`).
  BrewCmd overwrite() => token('--overwrite');

  /// Skips installing any dependencies (`--ignore-dependencies`).
  ///
  /// The formula or cask will misbehave if the dependencies are not already present
  /// some other way.
  BrewCmd ignoreDependencies() => token('--ignore-dependencies');

  /// Installs the dependencies with the given options but not the formula itself
  /// (`--only-dependencies`).
  BrewCmd onlyDependencies() => token('--only-dependencies');

  /// Includes casks that would otherwise be skipped as auto-updating or `:latest`
  /// (`--greedy`).
  BrewCmd greedy() => token('--greedy');

  /// Includes only the casks versioned `:latest` (`--greedy-latest`).
  BrewCmd greedyLatest() => token('--greedy-latest');

  /// Includes only the casks that auto-update (`--greedy-auto-updates`).
  BrewCmd greedyAutoUpdates() => token('--greedy-auto-updates');

  /// Includes the `:build` dependencies (`--include-build`).
  BrewCmd includeBuild() => token('--include-build');

  /// Includes the `:optional` dependencies (`--include-optional`).
  BrewCmd includeOptional() => token('--include-optional');

  /// Includes the `:test` dependencies (`--include-test`).
  ///
  /// On `install`, these are the dependencies `brew test` itself needs.
  BrewCmd includeTest() => token('--include-test');

  /// Skips the `:recommended` dependencies (`--skip-recommended`).
  BrewCmd skipRecommended() => token('--skip-recommended');

  /// Shows only the missing entries (`--missing`).
  ///
  /// The flag shared by `deps` and `uses`; the `missing` subcommand itself is
  /// [missing].
  BrewCmd onlyMissing() => token('--missing');

  /// Prints fully qualified names, tap included (`--full-name`).
  BrewCmd fullName() => token('--full-name');

  /// Scopes the command to one tap, given as `user/repo` (`--tap`).
  ///
  /// The value-taking flag on `create`, `style`, `audit` and `livecheck`. The
  /// argument `tap` itself takes is [tapTarget], and the bare scoping flag `bundle`
  /// uses is [tapsOnly].
  BrewCmd tapScope(String value) => joined('--tap', value);

  /// Runs the additional, stricter style checks (`--strict`).
  BrewCmd strict() => token('--strict');

  /// Runs the additional checks that need a network connection (`--online`).
  BrewCmd online() => token('--online');

  /// Applies RuboCop's auto-correct to the style violations found (`--fix`).
  BrewCmd fix() => token('--fix');

  /// Restricts the check to the files changed from the main branch (`--changed`).
  BrewCmd changed() => token('--changed');

  /// Checks only the given comma-separated RuboCop cops (`--only-cops`).
  BrewCmd onlyCops(String value) => joined('--only-cops', value);

  /// Skips the given comma-separated RuboCop cops (`--except-cops`).
  BrewCmd exceptCops(String value) => joined('--except-cops', value);

  /// Enables debugging and profiling of the audit methods themselves (`--audit-debug`).
  BrewCmd auditDebug() => token('--audit-debug');

  /// Reads from or writes to this path instead of the default location (`--file`).
  ///
  /// Shared by `services` (a launchd or systemd unit) and `bundle` (a Brewfile).
  /// Pass `-` to mean stdin or stdout.
  BrewCmd file(String path) => pair('--file', path);

  /// Only lists or restores the pinned packages (`--minimum-version`).
  BrewCmd minimumVersion(String value) => joined('--minimum-version', value);

  /// Skips installing a cask's own dependencies (`--skip-cask-deps`).
  BrewCmd skipCaskDeps() => token('--skip-cask-deps');

  /// Leaves the cask's running application alone during an upgrade (`--no-quit`).
  BrewCmd noQuit() => token('--no-quit');

  /// Links the cask's helper executables (`--binaries`). Enabled by default.
  BrewCmd binaries() => token('--binaries');

  /// Skips linking the cask's helper executables (`--no-binaries`).
  BrewCmd noBinaries() => token('--no-binaries');

  /// Refuses to install a cask that has no checksum (`--require-sha`).
  BrewCmd requireSha() => token('--require-sha');

  /// Creates a git repository around the build, for producing patches (`--git`).
  ///
  /// Also `audit`'s flag for the slower checks that walk the git history.
  BrewCmd git() => token('--git');

  /// Prints how long each package took to install, at the end of the run
  /// (`--display-times`).
  BrewCmd displayTimes() => token('--display-times');

  /// Generates debug symbols and retains the source in a cache directory
  /// (`--debug-symbols`).
  BrewCmd debugSymbols() => token('--debug-symbols');

  /// Prepares the build for bottling, skipping the post-install steps
  /// (`--build-bottle`).
  BrewCmd buildBottle() => token('--build-bottle');

  /// Installs but skips the post-install steps (`--skip-post-install`).
  BrewCmd skipPostInstall() => token('--skip-post-install');

  /// Installs but does not link the keg into the prefix (`--skip-link`).
  BrewCmd skipLink() => token('--skip-link');

  /// Marks the install as a dependency rather than one requested on its own
  /// (`--as-dependency`).
  BrewCmd asDependency() => token('--as-dependency');

  /// Optimises the bottle for this architecture instead of the oldest one the build
  /// host supports (`--bottle-arch`).
  BrewCmd bottleArch(String arch) => joined('--bottle-arch', arch);

  /// Adopts the cask's existing artifacts instead of failing on them (`--adopt`).
  ///
  /// Cannot be combined with [force].
  BrewCmd adopt() => token('--adopt');

  /// Removes every file a cask left behind, shared ones included (`--zap`).
  BrewCmd zap() => token('--zap');

  /// Compiles with this named compiler instead of the default one (`--cc`).
  BrewCmd cc(String compiler) => joined('--cc', compiler);

  /// Scopes the command to this operating system (`--os`).
  BrewCmd os(String value) => joined('--os', value);

  /// Scopes the command to this CPU architecture (`--arch`).
  BrewCmd arch(String value) => joined('--arch', value);

  /// Shows the version number of each installed formula (`--versions`).
  BrewCmd versions() => token('--versions');

  /// Lists only the pinned packages (`--pinned`).
  BrewCmd pinned() => token('--pinned');

  /// Shows only the formulae with more than one version installed (`--multiple`).
  ///
  /// Implies [versions].
  BrewCmd multiple() => token('--multiple');

  /// Lists the formulae installed on request rather than as a dependency
  /// (`--installed-on-request`).
  BrewCmd installedOnRequest() => token('--installed-on-request');

  /// Lists the formulae installed only as a dependency
  /// (`--no-installed-on-request`).
  BrewCmd noInstalledOnRequest() => token('--no-installed-on-request');

  /// Lists the formulae that were poured from a bottle (`--poured-from-bottle`).
  BrewCmd pouredFromBottle() => token('--poured-from-bottle');

  /// Lists the formulae that were compiled from source (`--built-from-source`).
  BrewCmd builtFromSource() => token('--built-from-source');

  /// Forces one entry per output line (`-1`).
  ///
  /// The default already, once stdout is not a terminal.
  BrewCmd oneEntryPerLine() => token('-1');

  /// Lists in long format, as `ls -l` would (`-l`).
  BrewCmd longFormat() => token('-l');

  /// Lists the oldest entries first (`-r`).
  BrewCmd reverseOrder() => token('-r');

  /// Sorts by time modified, most recent first (`-t`).
  BrewCmd sortByTime() => token('-t');

  /// Searches formula descriptions, not only their names (`--desc`).
  BrewCmd desc() => token('--desc');

  /// Lists the anonymous analytics for a formula's installs and build errors
  /// (`--analytics`).
  ///
  /// The `info` flag; the subcommand that turns collection on or off is
  /// [analytics].
  BrewCmd analyticsData() => token('--analytics');

  /// How many days of analytics to retrieve: 30, 90 or 365 (`--days`).
  BrewCmd days(int value) => joined('--days', '$value');

  /// Which analytics category to retrieve (`--category`).
  BrewCmd category(String value) => joined('--category', value);

  /// Opens the formula or cask's GitHub source page in a browser (`--github`).
  BrewCmd github() => token('--github');

  /// Includes the resolved variations hash in the JSON output (`--variations`).
  BrewCmd variations() => token('--variations');

  /// Shows the on-disk size of installed formulae and casks (`--sizes`).
  BrewCmd sizes() => token('--sizes');

  /// Skips the slower steps `update` normally runs before an install
  /// (`--auto-update`).
  BrewCmd autoUpdate() => token('--auto-update');

  /// Removes cache files older than the given number of days, or `all`
  /// (`--prune`).
  ///
  /// Shares its name with `deps`' `--prune`, which prunes tree branches already
  /// seen rather than cache files.
  BrewCmd prune() => token('--prune');

  /// The same flag, given an explicit age (`--prune=<days|all>`).
  BrewCmd pruneDays(String value) => joined('--prune', value);

  /// Scrubs the cache, downloads for the latest versions included (`--scrub`).
  ///
  /// Downloads for formulae or casks still installed are kept regardless.
  BrewCmd scrub() => token('--scrub');

  /// Only prunes the symlinks and directories under the prefix (`--prune-prefix`).
  BrewCmd prunePrefix() => token('--prune-prefix');

  /// Lists every diagnostic check `doctor` can run on its own (`--list-checks`).
  BrewCmd listChecks() => token('--list-checks');

  /// Adds the `user/repo` shorthand naming the tap (an argument, not a flag).
  BrewCmd tapTarget(String value) => token(value);

  /// Adds the URL a two-argument `tap` clones from, for a tap not hosted on GitHub.
  BrewCmd tapUrl(String value) => token(value);

  /// Installs or changes a tap with a custom remote, useful for mirrors
  /// (`--custom-remote`).
  BrewCmd customRemote() => token('--custom-remote');

  /// Restores a tap's manpage symlinks and corrects its remote refs (`--repair`).
  BrewCmd repair() => token('--repair');

  /// Runs the `services` command against every known service (`--all`).
  BrewCmd servicesAll() => token('--all');

  /// Runs the service as this user, when brew itself runs as root (`--sudo-service-user`).
  BrewCmd sudoServiceUser(String user) => pair('--sudo-service-user', user);

  /// Sorts the dependency list topologically (`--topological`).
  BrewCmd topological() => token('--topological');

  /// Shows only the direct dependencies the formula declares (`--direct`).
  BrewCmd direct() => token('--direct');

  /// Shows the union of dependencies across every named formula, instead of the
  /// intersection (`--union`).
  BrewCmd union() => token('--union');

  /// Includes the implicit dependencies used to download and unpack the source
  /// (`--include-implicit`).
  BrewCmd includeImplicit() => token('--include-implicit');

  /// Includes the requirements alongside the dependencies (`--include-requirements`).
  BrewCmd includeRequirements() => token('--include-requirements');

  /// Shows the dependencies as a tree (`--tree`).
  BrewCmd tree() => token('--tree');

  /// Shows text-based dependency output in DOT format (`--dot`).
  BrewCmd dot() => token('--dot');

  /// Shows the dependencies as a directed graph (`--graph`).
  BrewCmd graph() => token('--graph');

  /// Marks each dependency as build, test, implicit, optional, or recommended
  /// (`--annotate`).
  BrewCmd annotate() => token('--annotate');

  /// Reads the formulae and casks to use from a Brewfile (`--brewfile`).
  ///
  /// Defaults to `./Brewfile`.
  BrewCmd brewfile() => token('--brewfile');

  /// The same flag, given an explicit path (`--brewfile=<path>`).
  BrewCmd brewfilePath(String path) => joined('--brewfile', path);

  /// Lists one formula per line instead of evaluating every formula and cask
  /// together (`--for-each`).
  BrewCmd forEach() => token('--for-each');

  /// Resolves more than one level of dependents (`--recursive`).
  BrewCmd recursive() => token('--recursive');

  /// Only lists the leaves installed as a dependency of something else
  /// (`--installed-as-dependency`).
  BrewCmd installedAsDependency() => token('--installed-as-dependency');

  /// Ignores this comma-separated list of formulae or casks when checking for
  /// missing dependencies (`--hide`).
  BrewCmd hide(String value) => joined('--hide', value);

  /// Shows the cache file for this bottle tag instead of the current platform's
  /// (`--bottle-tag`).
  BrewCmd bottleTag(String tag) => joined('--bottle-tag', tag);

  /// Prints the path that would be opened, without opening an editor
  /// (`--print-path`).
  BrewCmd printPath() => token('--print-path');

  /// Templates the new formula for an Autotools-style build (`--autotools`).
  BrewCmd autotools() => token('--autotools');

  /// Templates it for a Cabal build (`--cabal`).
  BrewCmd cabal() => token('--cabal');

  /// Templates it for a CMake-style build (`--cmake`).
  BrewCmd cmake() => token('--cmake');

  /// Templates it for a Crystal build (`--crystal`).
  BrewCmd crystal() => token('--crystal');

  /// Templates it for a Go build (`--go`).
  BrewCmd go() => token('--go');

  /// Templates it for a Meson-style build (`--meson`).
  BrewCmd meson() => token('--meson');

  /// Templates it for a Node build (`--node`).
  BrewCmd node() => token('--node');

  /// Templates it for a Perl build (`--perl`).
  BrewCmd perl() => token('--perl');

  /// Templates it for a Python build (`--python`).
  BrewCmd python() => token('--python');

  /// Templates it for a Ruby build (`--ruby`).
  BrewCmd ruby() => token('--ruby');

  /// Templates it for a Rust build (`--rust`).
  BrewCmd rust() => token('--rust');

  /// Templates it for a Zig build (`--zig`).
  BrewCmd zig() => token('--zig');

  /// Skips downloading the URL, so no checksum or GitHub metadata gets filled in
  /// (`--no-fetch`).
  BrewCmd noFetch() => token('--no-fetch');

  /// Sets the new formula or cask's name explicitly (`--set-name`).
  BrewCmd setName(String value) => joined('--set-name', value);

  /// Sets its version explicitly (`--set-version`).
  BrewCmd setVersion(String value) => joined('--set-version', value);

  /// Sets its license explicitly (`--set-license`).
  BrewCmd setLicense(String value) => joined('--set-license', value);

  /// Prints the patch alongside each commit (`--patch`).
  BrewCmd patch() => token('--patch');

  /// Prints a diffstat alongside each commit (`--stat`).
  BrewCmd stat() => token('--stat');

  /// Prints one line per commit (`--oneline`).
  BrewCmd oneline() => token('--oneline');

  /// Prints only the single most recent commit (`-1`).
  ///
  /// `log`'s own single-character flag; `list`'s `-1` is [oneEntryPerLine].
  BrewCmd onlyOneCommit() => token('-1');

  /// Prints at most this many commits (`--max-count`).
  BrewCmd maxCount(int value) => joined('--max-count', '$value');

  /// Adds a RuboCop `todo` comment for the violations `--fix` could not clear
  /// (`--todo`).
  ///
  /// Requires [fix].
  BrewCmd todo() => token('--todo');

  /// Resets the RuboCop cache before checking (`--reset-cache`).
  BrewCmd resetCache() => token('--reset-cache');

  /// Runs the extra checks that decide if a new formula or cask is eligible for
  /// Homebrew (`--new`).
  ///
  /// Implies [strict] and [online].
  BrewCmd newFormula() => token('--new');

  /// Prefixes every output line with the file or formula name audited
  /// (`--display-filename`).
  BrewCmd displayFilename() => token('--display-filename');

  /// Skips the non-RuboCop style checks, leaving them to `brew style`
  /// (`--skip-style`).
  BrewCmd skipStyle() => token('--skip-style');

  /// Runs only this comma-separated list of audit methods (`--only`).
  BrewCmd only(String value) => joined('--only', value);

  /// Skips this comma-separated list of audit methods (`--except`).
  BrewCmd except(String value) => joined('--except', value);

  /// Retries the formula's test block if it fails once (`--retry`).
  BrewCmd retry() => token('--retry');

  /// Reads or writes the user's global Brewfile rather than the one in the current
  /// directory (`--global`).
  BrewCmd global() => token('--global');

  /// Restricts a Brewfile edit to its tap entries (`--tap`).
  ///
  /// `bundle`'s bare scoping flag; the value-taking flag on `create`, `style`,
  /// `audit` and `livecheck` is [tapScope].
  BrewCmd tapsOnly() => token('--tap');

  /// Restricts a Brewfile edit to its Mac App Store entries (`--mas`).
  BrewCmd mas() => token('--mas');

  /// Edits the aliases file, one alias or all of them (`--edit`).
  BrewCmd aliasEdit() => token('--edit');

  /// Includes the aliases of the built-in commands (`--include-aliases`).
  BrewCmd includeAliases() => token('--include-aliases');

  /// Names the shell to print the export statements for (an argument, not a flag).
  ///
  /// One of `bash`, `csh`, `fish`, `pwsh`, `sh`, `tcsh` or `zsh`. Detected
  /// automatically, not always correctly, when this is left unset.
  BrewCmd forShell(String shell) => token(shell);

  /// Shows the latest version only when it is newer than the installed one
  /// (`--newer-only`).
  BrewCmd newerOnly() => token('--newer-only');

  /// Also checks a formula's resources for a newer version (`--resources`).
  BrewCmd resources() => token('--resources');

  /// Enables the `ExtractPlist` strategy across multiple casks at once
  /// (`--extract-plist`).
  BrewCmd extractPlist() => token('--extract-plist');

  /// Includes the packages BrewTestBot already auto-bumps, skipped by default
  /// (`--autobump`).
  BrewCmd autobump() => token('--autobump');

  /// Makes the file changes without any Git action (`--write-only`).
  BrewCmd writeOnly() => token('--write-only');

  /// Commits the changes `--write-only` made (`--commit`).
  BrewCmd commit() => token('--commit');

  /// Skips running `brew audit` before opening the pull request (`--no-audit`).
  BrewCmd noAudit() => token('--no-audit');

  /// Prints the pull request URL instead of opening it in a browser (`--no-browse`).
  BrewCmd noBrowse() => token('--no-browse');

  /// Does not try to fork the repository first (`--no-fork`).
  BrewCmd noFork() => token('--no-fork');

  /// Adds one or more mirror URLs, comma-separated (`--mirror`).
  BrewCmd mirror(String value) => joined('--mirror', value);

  /// Forks into this GitHub organization instead of the user's own account
  /// (`--fork-org`).
  BrewCmd forkOrg(String value) => joined('--fork-org', value);

  /// Overrides the version parsed from the URL or tag (`--version`).
  ///
  /// Pass `0` to delete an existing override that has become redundant.
  BrewCmd versionOverride(String value) => joined('--version', value);

  /// Prepends this text to the pull request's default message (`--message`).
  BrewCmd prMessage(String value) => joined('--message', value);

  /// Sets the URL for the new download (`--url`).
  ///
  /// Its checksum should be given too, through [sha256].
  BrewCmd url(String value) => joined('--url', value);

  /// Sets the SHA-256 checksum of the new download (`--sha256`).
  BrewCmd sha256(String value) => joined('--sha256', value);

  /// Sets the new git tag for the formula (`--tag`).
  BrewCmd tag(String value) => joined('--tag', value);

  /// Sets the commit revision the given tag or version corresponds to
  /// (`--revision`).
  BrewCmd revision(String value) => joined('--revision', value);

  /// Installs the dependencies a resource update needs to be resolved
  /// (`--install-dependencies`).
  BrewCmd installDependencies() => token('--install-dependencies');

  /// Names the package to look up Python resources under, when it cannot be
  /// inferred from the formula's URL (`--python-package-name`).
  BrewCmd pythonPackageName(String value) => joined('--python-package-name', value);

  /// Includes these additional Python packages when resolving resources
  /// (`--python-extra-packages`).
  BrewCmd pythonExtraPackages(String value) => joined('--python-extra-packages', value);

  /// Excludes these Python packages when resolving resources
  /// (`--python-exclude-packages`).
  BrewCmd pythonExcludePackages(String value) => joined('--python-exclude-packages', value);

  /// Adds a bare argument, for the formula, cask or value this wrapper has no named
  /// option for.
  BrewCmd arg(String value) => token(value);
}

/// `brew`, ready to take its first option.
// ignore: non_constant_identifier_names
BrewCmd get Brew => BrewCmd();
