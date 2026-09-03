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

/// `pip3`, the Python package installer. Bundled with [Python3] on most
/// systems, but not all: a slim container image can carry one without the
/// other, so `commandExists` first regardless of whether `python3` answered.
///
/// ```dart
/// await Pip.noInput().disablePipVersionCheck().install().requirement('requirements.txt').execute();
/// final ShellResult frozen = await Pip.freeze().output();
/// ```
///
/// Three habits belong on almost every scripted call. [noInput] is what keeps
/// a credential prompt from hanging a non-interactive run. [breakSystemPackages]
/// is the flag PEP 668 forces on anything installing outside a virtualenv on a
/// modern distribution; pip refuses outright without it, on the system Python
/// it is genuinely risky to modify. And [dryRun] on [install] resolves the
/// dependency graph and reports what would happen without installing a single
/// file, the safe way to check a version constraint before committing to it.
class PipCmd extends CommandBuilder<PipCmd> {
  @override
  final String executable = 'pip3';

  /// Installs packages from PyPI, a VCS URL, a local path or an archive (`install`).
  PipCmd install() => token('install');

  /// Generates a lock file for the current requirements (`lock`).
  PipCmd lock() => token('lock');

  /// Downloads packages without installing them (`download`).
  PipCmd download() => token('download');

  /// Uninstalls packages (`uninstall`).
  PipCmd uninstall() => token('uninstall');

  /// Prints installed packages in `requirements.txt` format (`freeze`).
  PipCmd freeze() => token('freeze');

  /// Inspects the Python environment as structured JSON (`inspect`).
  PipCmd inspect() => token('inspect');

  /// Lists installed packages, editables included (`list`).
  PipCmd list() => token('list');

  /// Shows metadata about one or more installed packages (`show`).
  PipCmd show() => token('show');

  /// Verifies installed packages have compatible dependencies (`check`).
  PipCmd check() => token('check');

  /// Manages local and global configuration (`config`).
  ///
  /// Takes `list`, `edit`, `get`, `set`, `unset` or `debug` as the next positional argument, via [arg].
  PipCmd config() => token('config');

  /// Inspects and manages pip's wheel cache (`cache`).
  ///
  /// Takes `dir`, `info`, `list`, `remove` or `purge` as the next positional argument, via [arg].
  PipCmd cache() => token('cache');

  /// Searches PyPI for packages (`search`). Long disabled by PyPI itself; kept for completeness.
  PipCmd search() => token('search');

  /// Inspects information available from a package index (`index`).
  ///
  /// Takes `versions` as the next positional argument, via [arg].
  PipCmd index() => token('index');

  /// Builds wheels from requirements (`wheel`).
  PipCmd wheel() => token('wheel');

  /// Computes hashes of package archives, for [requirement] pinning (`hash`).
  PipCmd hash() => token('hash');

  /// A helper used for shell command completion (`completion`).
  PipCmd completion() => token('completion');

  /// Shows information useful for debugging pip itself (`debug`).
  PipCmd debug() => token('debug');

  /// Prints the help for pip, or for the subcommand already chained (`help`).
  PipCmd help() => token('help');

  /// Installs from this requirements file (`-r`, `--requirement`). Repeatable; also accepted by [uninstall], [download] and [freeze].
  PipCmd requirement(String file) => pair('--requirement', file);

  /// Constrains resolved versions using this constraints file (`-c`, `--constraint`). Repeatable.
  PipCmd constraint(String file) => pair('--constraint', file);

  /// Skips installing the package's own dependencies (`--no-deps`).
  PipCmd noDeps() => token('--no-deps');

  /// Includes pre-release and development versions (`--pre`).
  PipCmd pre() => token('--pre');

  /// Installs a local path or VCS URL in editable mode (`-e`, `--editable`).
  PipCmd editable(String pathOrUrl) => pair('--editable', pathOrUrl);

  /// Resolves and reports what would happen without installing anything (`--dry-run`).
  PipCmd dryRun() => token('--dry-run');

  /// Installs into this directory instead of the environment's site-packages (`-t`, `--target`).
  PipCmd target(String dir) => pair('--target', dir);

  /// Only uses wheels compatible with this platform tag (`--platform`). Repeatable.
  PipCmd platform(String value) => pair('--platform', value);

  /// The Python version wheel and `Requires-Python` compatibility is checked against (`--python-version`).
  PipCmd pythonVersion(String version) => pair('--python-version', version);

  /// Only uses wheels compatible with this Python implementation, `cp`, `pp`, `jy` or `ip` (`--implementation`).
  PipCmd implementation(String value) => pair('--implementation', value);

  /// Only uses wheels compatible with this ABI tag (`--abi`). Repeatable.
  PipCmd abi(String value) => pair('--abi', value);

  /// Installs into the user site-packages directory rather than the global one (`--user`).
  PipCmd userFlag() => token('--user');

  /// Installs relative to this alternate root directory (`--root`).
  PipCmd root(String dir) => pair('--root', dir);

  /// The installation prefix, under which `lib`, `bin` and the rest are placed (`--prefix`).
  PipCmd prefix(String dir) => pair('--prefix', dir);

  /// Where editable projects are checked out to (`--src`).
  PipCmd src(String dir) => pair('--src', dir);

  /// Upgrades every named package to the newest version the resolver allows (`-U`, `--upgrade`).
  PipCmd upgrade() => token('--upgrade');

  /// How aggressively [upgrade] upgrades dependencies: `eager` or `only-if-needed` (`--upgrade-strategy`).
  PipCmd upgradeStrategy(String value) => pair('--upgrade-strategy', value);

  /// Reinstalls every package even if it is already up to date (`--force-reinstall`).
  PipCmd forceReinstall() => token('--force-reinstall');

  /// Overwrites already-installed packages, regardless of version (`-I`, `--ignore-installed`).
  ///
  /// Can break a system whose existing copy came from a different package manager.
  PipCmd ignoreInstalled() => token('--ignore-installed');

  /// Ignores the package's declared `Requires-Python` (`--ignore-requires-python`).
  PipCmd ignoreRequiresPython() => token('--ignore-requires-python');

  /// Disables build isolation, requiring PEP 518 build dependencies to already be installed (`--no-build-isolation`).
  PipCmd noBuildIsolation() => token('--no-build-isolation');

  /// Allows pip to modify a system-managed, externally-managed Python installation (`--break-system-packages`).
  ///
  /// PEP 668's escape hatch. Required on a modern distribution's system Python; genuinely risky there.
  PipCmd breakSystemPackages() => token('--break-system-packages');

  /// A `KEY=VALUE` setting passed through to the PEP 517 build backend (`-C`, `--config-settings`). Repeatable.
  PipCmd configSettings(String assignment) => pair('--config-settings', assignment);

  /// Compiles installed Python source files to bytecode (`--compile`).
  PipCmd compile() => token('--compile');

  /// Skips bytecode compilation (`--no-compile`).
  PipCmd noCompile() => token('--no-compile');

  /// Suppresses the warning about scripts installed outside `PATH` (`--no-warn-script-location`).
  PipCmd noWarnScriptLocation() => token('--no-warn-script-location');

  /// Suppresses the warning about broken dependencies after install (`--no-warn-conflicts`).
  PipCmd noWarnConflicts() => token('--no-warn-conflicts');

  /// Excludes binary wheels for these packages, or `:all:`/`:none:` (`--no-binary`). Repeatable.
  PipCmd noBinary(String formatControl) => pair('--no-binary', formatControl);

  /// Excludes source distributions for these packages, or `:all:`/`:none:` (`--only-binary`). Repeatable.
  PipCmd onlyBinary(String formatControl) => pair('--only-binary', formatControl);

  /// Prefers a binary wheel over a newer source distribution (`--prefer-binary`).
  PipCmd preferBinary() => token('--prefer-binary');

  /// Requires every dependency to carry a `--hash`, for a reproducible install (`--require-hashes`).
  ///
  /// Implied automatically once any requirement in the file already sets a hash.
  PipCmd requireHashes() => token('--require-hashes');

  /// How the progress bar behaves: `auto`, `on`, `off` or `raw` (`--progress-bar`).
  PipCmd progressBar(String mode) => pair('--progress-bar', mode);

  /// What to do when pip runs as root: `warn` or `ignore` (`--root-user-action`).
  PipCmd rootUserAction(String action) => pair('--root-user-action', action);

  /// Writes a JSON report of what pip did to this file, `-` for stdout (`--report`).
  PipCmd report(String path) => pair('--report', path);

  /// Installs a named dependency group from `pyproject.toml` (`--group`).
  PipCmd group(String value) => pair('--group', value);

  /// Skips deleting the build directories once install finishes (`--no-clean`).
  PipCmd noClean() => token('--no-clean');

  /// Skips confirmation before removing files during [uninstall] (`-y`, `--yes`).
  PipCmd yes() => token('--yes');

  /// The base URL of the package index (`-i`, `--index-url`). Defaults to `https://pypi.org/simple`.
  PipCmd indexUrl(String url) => pair('--index-url', url);

  /// An additional package index URL, on top of [indexUrl] (`--extra-index-url`). Repeatable.
  PipCmd extraIndexUrl(String url) => pair('--extra-index-url', url);

  /// Ignores the package index entirely, using only [findLinks] (`--no-index`).
  PipCmd noIndex() => token('--no-index');

  /// A URL or local path to search for archive links (`-f`, `--find-links`). Repeatable.
  PipCmd findLinks(String urlOrPath) => pair('--find-links', urlOrPath);

  /// Marks a host as trusted, bypassing HTTPS certificate validation for it (`--trusted-host`). Repeatable.
  PipCmd trustedHost(String hostname) => pair('--trusted-host', hostname);

  /// A proxy to route requests through, `scheme://[user:pass@]host:port` (`--proxy`).
  PipCmd proxy(String value) => pair('--proxy', value);

  /// How many HTTP connection attempts before giving up (`--retries`).
  PipCmd retries(int count) => pair('--retries', '$count');

  /// The socket timeout, in seconds (`--timeout`).
  PipCmd timeout(int seconds) => pair('--timeout', '$seconds');

  /// The CA bundle to verify HTTPS connections against (`--cert`).
  PipCmd cert(String path) => pair('--cert', path);

  /// A client SSL certificate, key and cert combined in one PEM file (`--client-cert`).
  PipCmd clientCert(String path) => pair('--client-cert', path);

  /// The directory pip's cache is stored in (`--cache-dir`).
  PipCmd cacheDir(String dir) => pair('--cache-dir', dir);

  /// Disables the cache entirely (`--no-cache-dir`).
  PipCmd noCacheDir() => token('--no-cache-dir');

  /// Skips the periodic check for a newer pip release (`--disable-pip-version-check`). Implied by [noIndex].
  PipCmd disablePipVersionCheck() => token('--disable-pip-version-check');

  /// Never prompts for input (`--no-input`).
  ///
  /// What keeps a credential prompt from hanging a non-interactive run.
  PipCmd noInput() => token('--no-input');

  /// The credential lookup mechanism for the keyring library (`--keyring-provider`).
  PipCmd keyringProvider(String value) => pair('--keyring-provider', value);

  /// Runs in an isolated mode, ignoring environment variables and user configuration (`--isolated`).
  PipCmd isolated() => token('--isolated');

  /// Refuses to run outside a virtual environment (`--require-virtualenv`).
  PipCmd requireVirtualenv() => token('--require-virtualenv');

  /// Runs pip with a specific Python interpreter instead of its own (`--python`).
  PipCmd pythonInterpreter(String path) => pair('--python', path);

  /// Suppresses colored output (`--no-color`).
  PipCmd noColor() => token('--no-color');

  /// Lets unhandled exceptions propagate instead of being logged and swallowed (`--debug`).
  PipCmd debugFlag() => token('--debug');

  /// Talks more; additive, repeat up to three times (`-v`, `--verbose`).
  PipCmd verbose() => token('--verbose');

  /// Talks less; additive, repeat up to three times (`-q`, `--quiet`).
  PipCmd quiet() => token('--quiet');

  /// Appends a verbose log to this file (`--log`).
  PipCmd log(String path) => pair('--log', path);

  /// Prints the version and exits (`-V`, `--version`).
  PipCmd version() => token('--version');

  /// Only lists packages that are outdated (`-o`, `--outdated`). `list` only.
  PipCmd outdated() => token('--outdated');

  /// Only lists packages that are already up to date (`-u`, `--uptodate`). `list` only.
  PipCmd uptodate() => token('--uptodate');

  /// Restricts to this installation path (`--path`). Repeatable. `list` and `freeze`.
  PipCmd path(String dir) => pair('--path', dir);

  /// Restricted to the local environment, ignoring globally-installed packages (`-l`, `--local`). `list` and `freeze`.
  PipCmd local() => token('--local');

  /// The output format for `list`: `columns`, `freeze` or `json` (`--format`).
  PipCmd format(String value) => pair('--format', value);

  /// Lists packages that are not a dependency of any other installed package (`--not-required`). `list` only.
  PipCmd notRequired() => token('--not-required');

  /// Excludes a package from the output, by name (`--exclude`). Repeatable. `list` and `freeze`.
  PipCmd exclude(String package) => pair('--exclude', package);

  /// Shows the full list of files installed for each package (`-f`, `--files`). `show` only.
  PipCmd files() => token('--files');

  /// The editor `config edit` opens, otherwise `$VISUAL` or `$EDITOR` (`--editor`).
  PipCmd editor(String command) => pair('--editor', command);

  /// Scopes a `config` operation to the user-level file (`--user`). `config` only; distinct from [userFlag].
  PipCmd userScope() => token('--user');

  /// Scopes a `config` operation to the global, system-wide file (`--global`).
  PipCmd globalScope() => token('--global');

  /// Scopes a `config` operation to the current virtual environment's file (`--site`).
  PipCmd siteScope() => token('--site');

  /// Adds a bare positional argument: a package name, a spec, a config key, whatever the subcommand ahead of it expects next.
  PipCmd arg(String value) => token(value);
}

/// `pip3`, ready to take its first subcommand.
// ignore: non_constant_identifier_names
PipCmd get Pip => PipCmd();
