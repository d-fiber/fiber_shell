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

/// `winget`, the Windows Package Manager. Windows only: the executable does
/// not exist on the other platforms.
///
/// ```dart
/// await Winget.install().id('Microsoft.PowerToys').exact().silent().acceptPackageAgreements().execute();
/// ```
///
/// **This wrapper is a vocabulary, not a grammar.** Every top-level command is
/// a method, and the options shared across commands are a single method each,
/// reusable wherever winget accepts them. Nothing validates that
/// [architecture] goes with [install] rather than [list]; winget will say so
/// if you get it wrong.
///
/// Four names are shared by a top-level command and a sub-subcommand of
/// another one, and reused rather than duplicated, exactly as [list] already
/// serves `stash`, `worktree` and `remote` in the git wrapper: [add],
/// [remove], [update] and [reset] are each one method that also spells
/// `source add`, `source remove`, `source update`, `source reset`, `pin add`,
/// `pin remove` and `pin reset`. [show], [list], [validate] and [export] each
/// double as a `configure` or `settings` sub-subcommand for the same reason.
///
/// Watch two names where a flag and a subcommand share a word. [source] is
/// the `-s`, `--source` flag that every query-based command accepts; the
/// `winget source` subcommand is [sourceCommand]. And **`--silent` is `-h`,
/// not `-s`**, one letter away from `--source` and easy to fat-finger; this
/// wrapper always emits the long form so the two never get confused on the
/// command line.
class WingetCmd extends CommandBuilder<WingetCmd> {
  @override
  final String executable = 'winget';

  /// Installs a package (`install`). Aliased by winget itself as `add`.
  WingetCmd install() => token('install');

  /// Displays a package's metadata (`show`). Aliased by winget itself as `view`.
  ///
  /// Also the `configure show` sub-subcommand, which displays a configuration file instead.
  WingetCmd show() => token('show');

  /// Removes a package (`uninstall`). Aliased by winget itself as `remove`, `rm`.
  WingetCmd uninstall() => token('uninstall');

  /// Updates a package to its latest available version (`upgrade`). Aliased by winget itself as `update`.
  WingetCmd upgrade() => token('upgrade');

  /// Lists the installed packages, or the current pins, or a configuration's applied state (`list`).
  ///
  /// Also the `pin list` and `configure list` sub-subcommand.
  WingetCmd list() => token('list');

  /// Queries the sources for available packages (`search`). Aliased by winget itself as `find`.
  WingetCmd search() => token('search');

  /// Manages the sources winget reads from (`source`). The subcommand; the shared query flag is [source].
  WingetCmd sourceCommand() => token('source');

  /// Opens the settings file, or changes an administrator setting (`settings`). Aliased by winget itself as `config`.
  WingetCmd settings() => token('settings');

  /// Exports installed packages, a source, or configuration resources to a file (`export`).
  ///
  /// Also the `settings export` and `configure export` sub-subcommand.
  WingetCmd export() => token('export');

  /// Installs the packages listed in a file made by [export] (`import`).
  WingetCmd import() => token('import');

  /// Generates the SHA256 hash of a local installer file (`hash`).
  WingetCmd hash() => token('hash');

  /// Validates a package manifest (`validate`).
  ///
  /// Also the `configure validate` sub-subcommand, which validates a configuration file instead.
  WingetCmd validate() => token('validate');

  /// Lists the experimental features and their state (`features`).
  WingetCmd features() => token('features');

  /// Downloads a package's installer without running it (`download`).
  WingetCmd download() => token('download');

  /// Repairs a broken install without a full reinstall (`repair`). Aliased by winget itself as `fix`.
  WingetCmd repair() => token('repair');

  /// Pins a package against `upgrade --all`, blocks it, or gates it to a version range (`pin`).
  WingetCmd pin() => token('pin');

  /// Applies a WinGet Configuration file to the machine (`configure`). Aliased by winget itself as `configuration`, `dsc`.
  WingetCmd configure() => token('configure');

  /// The `add` sub-subcommand of [sourceCommand] and [pin].
  WingetCmd add() => token('add');

  /// The `remove` sub-subcommand of [sourceCommand] and [pin].
  WingetCmd remove() => token('remove');

  /// The `update` sub-subcommand of [sourceCommand], forcing a refresh of one or all sources.
  WingetCmd update() => token('update');

  /// The `reset` sub-subcommand of [sourceCommand] and [pin].
  WingetCmd reset() => token('reset');

  /// The `edit` sub-subcommand of [sourceCommand], toggling a source between explicit and implicit.
  WingetCmd edit() => token('edit');

  /// The `set` sub-subcommand of [settings], setting one administrator setting.
  WingetCmd set() => token('set');

  /// The `test` sub-subcommand of [configure], checking the machine against a configuration's desired state.
  WingetCmd test() => token('test');

  /// The query to search for, restricted to a field by [id], [name] or [moniker] (`-q`, `--query`).
  ///
  /// Positional in winget itself; passed as a named option here so it can be combined freely with the rest of the chain.
  WingetCmd query(String value) => pair('--query', value);

  /// Restricts the match to a package's ID (`--id`).
  WingetCmd id(String value) => pair('--id', value);

  /// Restricts the match to a package's name (`--name`).
  WingetCmd name(String value) => pair('--name', value);

  /// Restricts the match to a package's moniker (`--moniker`).
  WingetCmd moniker(String value) => pair('--moniker', value);

  /// Restricts the match to a package's tags (`--tag`).
  WingetCmd tag(String value) => pair('--tag', value);

  /// Restricts the match to a package's declared commands (`--cmd`, `--command`).
  WingetCmd command(String value) => pair('--command', value);

  /// Requires an exact, case-sensitive match instead of the default substring (`-e`, `--exact`).
  WingetCmd exact() => token('--exact');

  /// Restricts the operation to one source, by name (`-s`, `--source`). The flag; the subcommand is [sourceCommand].
  WingetCmd source(String value) => pair('--source', value);

  /// Targets `user` or `machine` scope (`--scope`).
  WingetCmd scope(String value) => pair('--scope', value);

  /// Selects the architecture, such as `x64` or `arm64` (`-a`, `--architecture`).
  WingetCmd architecture(String value) => pair('--architecture', value);

  /// Selects an exact version rather than the latest (`-v`, `--version`).
  WingetCmd version(String value) => pair('--version', value);

  /// Selects the installer locale, in BCP47 form (`--locale`).
  WingetCmd locale(String value) => pair('--locale', value);

  /// Directs the log to a file the caller can write to (`-o`, `--log`).
  WingetCmd log(String path) => pair('--log', path);

  /// Passes extra arguments to the installer, in addition to its defaults (`--custom`).
  WingetCmd custom(String value) => pair('--custom', value);

  /// Passes arguments straight to the installer, replacing its defaults (`--override`).
  ///
  /// Named apart from the `@override` annotation itself: a member called `override` shadows it for the rest of this class.
  WingetCmd overrideArgs(String value) => pair('--override', value);

  /// The path to install to, on installers that support it (`-l`, `--location`).
  WingetCmd location(String path) => pair('--location', path);

  /// Continues past a non-security issue that would otherwise stop the command (`--force`).
  WingetCmd force() => token('--force');

  /// Runs the installer or uninstaller interactively, showing its own UI (`-i`, `--interactive`). Not for a script.
  WingetCmd interactive() => token('--interactive');

  /// Runs the installer or uninstaller with no UI at all (`-h`, `--silent`).
  ///
  /// The short form is `-h`, not `-s`; this wrapper only ever emits `--silent`, so a chain never has to disambiguate it from [source].
  WingetCmd silent() => token('--silent');

  /// Skips the install if a version is already present (`--no-upgrade`).
  WingetCmd noUpgrade() => token('--no-upgrade');

  /// Deletes the files and directories of a portable package (`--purge`).
  WingetCmd purge() => token('--purge');

  /// Keeps the files and directories a portable package created (`--preserve`).
  WingetCmd preserve() => token('--preserve');

  /// Accepts the package's own license terms, suppressing the prompt (`--accept-package-agreements`).
  ///
  /// Covers the package's license only, not the source's; pair with [acceptSourceAgreements] for a fully unattended run.
  WingetCmd acceptPackageAgreements() => token('--accept-package-agreements');

  /// Accepts the source's license terms, suppressing the prompt (`--accept-source-agreements`).
  WingetCmd acceptSourceAgreements() => token('--accept-source-agreements');

  /// Refuses every interactive prompt instead of showing it (`--disable-interactivity`).
  WingetCmd disableInteractivity() => token('--disable-interactivity');

  /// Forces a verbose log regardless of the configured logging level (`--verbose`, `--verbose-logs`).
  WingetCmd verboseLogs() => token('--verbose-logs');

  /// Proceeds past a failed installer hash check (`--ignore-security-hash`). Not recommended.
  WingetCmd ignoreSecurityHash() => token('--ignore-security-hash');

  /// Allows a reboot the installer requests (`--allow-reboot`).
  WingetCmd allowReboot() => token('--allow-reboot');

  /// Skips dependency and Windows feature processing (`--skip-dependencies`).
  WingetCmd skipDependencies() => token('--skip-dependencies');

  /// Sets the optional REST source HTTP header (`--header`).
  WingetCmd header(String value) => pair('--header', value);

  /// Sets the authentication window preference: `silent`, `silentPreferred` or `interactive` (`--authentication-mode`).
  WingetCmd authenticationMode(String value) => pair('--authentication-mode', value);

  /// Sets the account used for authentication (`--authentication-account`).
  WingetCmd authenticationAccount(String value) => pair('--authentication-account', value);

  /// Renames the installed executable, for a portable package (`-r`, `--rename`).
  WingetCmd rename(String value) => pair('--rename', value);

  /// Runs from a local manifest file instead of a source (`-m`, `--manifest`).
  ///
  /// Must be enabled first with `winget settings --enable LocalManifestFiles`.
  WingetCmd manifest(String path) => pair('--manifest', path);

  /// Selects the installer type, such as `msi` or `msix` (`--installer-type`).
  WingetCmd installerType(String value) => pair('--installer-type', value);

  /// Filters an uninstall or a repair by product code instead of package ID (`--product-code`).
  WingetCmd productCode(String value) => pair('--product-code', value);

  /// Caps the number of results, between 1 and 1000 (`-n`, `--count`).
  WingetCmd count(int value) => joined('--count', '$value');

  /// Every installed package with an upgrade available (`-r`, `--recurse`, `--all`), for [upgrade].
  WingetCmd all() => token('--all');

  /// Every installed version of a package, for [uninstall] (`--all`, `--all-versions`).
  WingetCmd allVersions() => token('--all-versions');

  /// Lists a package's available versions instead of installing or showing one (`--versions`).
  WingetCmd versionsFlag() => token('--versions');

  /// Acts on a package even when its installed version cannot be determined (`-u`, `--unknown`, `--include-unknown`).
  WingetCmd includeUnknown() => token('--include-unknown');

  /// Acts on a package even though it carries a non-blocking pin (`--pinned`, `--include-pinned`).
  WingetCmd includePinned() => token('--include-pinned');

  /// Lists only the packages that have an upgrade available (`--upgrade-available`), for [list].
  WingetCmd upgradeAvailable() => token('--upgrade-available');

  /// Shows `show`-like detail for each matched package, for [list] (`--details`).
  WingetCmd details() => token('--details');

  /// Uninstalls the previous version as part of an upgrade, regardless of the manifest (`--uninstall-previous`).
  WingetCmd uninstallPrevious() => token('--uninstall-previous');

  /// Blocks a pin from being overridden until it is removed, for `pin add` (`--blocking`).
  WingetCmd blocking() => token('--blocking');

  /// Targets the installed version rather than the source, for `pin add` and `pin remove` (`--installed`).
  WingetCmd installed() => token('--installed');

  /// Sets the trust level of a source being added: `none` or `trusted` (`--trust-level`).
  WingetCmd trustLevel(String value) => pair('--trust-level', value);

  /// Marks a source as explicit, so it is only used when named with [source] (`--explicit`).
  WingetCmd explicitFlag() => token('--explicit');

  /// Enables an administrator setting or a configuration component (`--enable`), for [settings] and [configure].
  WingetCmd enableFlag() => token('--enable');

  /// Disables it (`--disable`), for [settings] and [configure].
  WingetCmd disableFlag() => token('--disable');

  /// The configuration resource's module, for `configure export` (`--module`).
  WingetCmd module(String value) => pair('--module', value);

  /// The configuration resource's name, for `configure export` (`--resource`).
  WingetCmd resource(String value) => pair('--resource', value);

  /// The package to export as a `WinGetPackage` resource, for `configure export` (`--package-id`).
  WingetCmd packageId(String value) => pair('--package-id', value);

  /// Where `configure` stores the PowerShell modules it downloads (`--module-path`).
  WingetCmd modulePath(String path) => pair('--module-path', path);

  /// The path to a custom configuration processor (`--processor-path`).
  WingetCmd processorPath(String path) => pair('--processor-path', path);

  /// Picks a configuration file from history instead of [file] (`-h`, `--history`), for [configure].
  WingetCmd history() => token('--history');

  /// Accepts a configuration file's warning, suppressing the prompt (`--accept-configuration-agreements`).
  WingetCmd acceptConfigurationAgreements() => token('--accept-configuration-agreements');

  /// Suppresses the initial configuration summary where possible (`--suppress-initial-details`).
  WingetCmd suppressInitialDetails() => token('--suppress-initial-details');

  /// Includes each package's installed version in an export (`--include-versions`).
  WingetCmd includeVersions() => token('--include-versions');

  /// The file an `export` writes to, or an `import` reads from's counterpart file path (`-o`, `--output`).
  ///
  /// Named apart from the base class's [output] so the two can never collide.
  WingetCmd outputFile(String path) => pair('--output', path);

  /// The JSON file listing the packages to install, for `import` (`-i`, `--import-file`).
  WingetCmd importFile(String path) => pair('--import-file', path);

  /// Skips a package that is not available instead of failing, for `import` (`--ignore-unavailable`).
  WingetCmd ignoreUnavailable() => token('--ignore-unavailable');

  /// Ignores the versions pinned in an import file and installs latest (`--ignore-versions`).
  WingetCmd ignoreVersions() => token('--ignore-versions');

  /// Also generates the MSIX `SignatureSha256`, for `hash` (`-m`, `--msix`).
  WingetCmd msix() => token('--msix');

  /// The local file to hash, or the configuration file to read (`-f`, `--file`).
  WingetCmd file(String path) => pair('--file', path);

  /// The directory installers are downloaded to, for `download` (`-d`, `--download-directory`).
  WingetCmd downloadDirectory(String path) => pair('--download-directory', path);

  /// Skips the Microsoft Store package's offline license, for `download` (`--skip-license`).
  WingetCmd skipLicense() => token('--skip-license');

  /// Selects the target platform, such as `Windows.Desktop`, for `download` (`--platform`).
  WingetCmd platform(String value) => pair('--platform', value);

  /// Adds a bare argument, for a flag this wrapper has no named option for.
  WingetCmd arg(String value) => token(value);
}

/// `winget`, ready to take its first option.
// ignore: non_constant_identifier_names
WingetCmd get Winget => WingetCmd();
