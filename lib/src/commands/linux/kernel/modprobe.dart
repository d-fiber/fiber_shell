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

/// `modprobe`, the kmod module loader. Linux only, and the tool that resolves
/// a module's dependencies before `insmod` would just fail on a missing
/// symbol.
///
/// ```dart
/// await Modprobe.arg('nf_tables').asRoot().execute();
/// await Modprobe.remove().arg('nf_tables').asRoot().execute();
/// final ShellResult plan = await Modprobe.dryRun().verbose().arg('btrfs').output();
/// ```
///
/// [dryRun] paired with [verbose] is the way to see what a load would pull in
/// — every dependency, in order — without touching the running kernel, worth
/// reaching for before a [remove] on a module other things might depend on.
///
/// A module blacklisted in `/etc/modprobe.d/` is silently skipped unless
/// [useBlacklist] is left off or [force] is set; [showConfig] is how to check
/// whether that is what happened before assuming the module itself is broken.
///
/// Loading, removing and reconfiguring modules all want `asRoot()`.
class ModprobeCmd extends CommandBuilder<ModprobeCmd> {
  @override
  final String executable = 'modprobe';

  /// Loads (or removes, with [remove]) every module matching an alias, rather
  /// than stopping at the first match (`-a`, `--all`).
  ModprobeCmd all() => token('--all');

  /// Applies the blacklist entries from `/etc/modprobe.d/` even to a module
  /// named explicitly, the default behaviour for aliases (`-b`,
  /// `--use-blacklist`).
  ModprobeCmd useBlacklist() => token('--use-blacklist');

  /// Reads configuration from this file or directory instead of
  /// `/etc/modprobe.d/` (`-C`, `--config`).
  ModprobeCmd config(String path) => pair('--config', path);

  /// Prints the resolved configuration instead of loading anything (`-c`,
  /// `--show-config`).
  ModprobeCmd showConfig() => token('--show-config');

  /// Prints the module version information a module requires, without
  /// loading it (`--show-modversions`).
  ModprobeCmd showModversions(String path) => joined('--show-modversions', path);

  /// Lists the symbols a module exports, without loading it
  /// (`--show-exports`).
  ModprobeCmd showExports() => token('--show-exports');

  /// Looks for modules under this directory instead of
  /// `/lib/modules/$(uname -r)` (`-d`, `--dirname`).
  ModprobeCmd dirname(String path) => pair('--dirname', path);

  /// Fails the call if it would not actually insert or remove anything,
  /// instead of succeeding quietly (`--first-time`).
  ModprobeCmd firstTime() => token('--first-time');

  /// Loads the module even if its vermagic string does not match the running
  /// kernel (`--force-vermagic`). A last resort, not a fix.
  ModprobeCmd forceVermagic() => token('--force-vermagic');

  /// Loads the module even if the running kernel's module version does not
  /// match (`--force-modversion`).
  ModprobeCmd forceModversion() => token('--force-modversion');

  /// Both [forceVermagic] and [forceModversion] at once (`-f`, `--force`).
  ModprobeCmd force() => token('--force');

  /// Ignores the `install` or `remove` command configured for the module in
  /// `/etc/modprobe.d/` (`-i`, `--ignore-install`, `--ignore-remove`).
  ///
  /// Which of the two config directives is skipped follows whether [remove]
  /// is also set.
  ModprobeCmd ignoreInstall() => token('--ignore-install');

  /// Performs every step except actually inserting or deleting a module
  /// (`-n`, `--dry-run`). Pair with [verbose] to see the dependency chain.
  ModprobeCmd dryRun() => token('--dry-run');

  /// Says nothing about a module that is already loaded, or already absent,
  /// rather than treating it as an error (`-q`, `--quiet`).
  ModprobeCmd quiet() => token('--quiet');

  /// Prints every module name matching an alias, without loading any of them
  /// (`-R`, `--show-alias`).
  ModprobeCmd showAlias() => token('--show-alias');

  /// Unloads modules instead of loading them (`-r`, `--remove`).
  ///
  /// Fails while the module is in use; nothing here forces an unload out from
  /// under a caller.
  ModprobeCmd remove() => token('--remove');

  /// Removes the named modules and anything that depends on them, rather than
  /// failing while a dependent is loaded (`--remove-holders`).
  ModprobeCmd removeHolders() => token('--remove-holders');

  /// Under [remove], retries for up to this many milliseconds if the module
  /// is busy, instead of failing immediately (`-w`, `--wait`).
  ModprobeCmd wait(int milliseconds) => pair('--wait', '$milliseconds');

  /// Resolves modules against this kernel version instead of `uname -r`
  /// (`-S`, `--set-version`).
  ModprobeCmd setVersion(String version) => pair('--set-version', version);

  /// Lists a module's or alias's dependencies, without loading anything
  /// (`--show-depends`).
  ModprobeCmd showDepends() => token('--show-depends');

  /// Reports error messages through syslog instead of stderr (`-s`,
  /// `--syslog`).
  ModprobeCmd syslog() => token('--syslog');

  /// Prints each step: dependency resolution, the actual `insmod`/`rmmod`
  /// calls (`-v`, `--verbose`).
  ModprobeCmd verbose() => token('--verbose');

  /// Adds a module name, or a `key=value` module parameter after the module
  /// name.
  ModprobeCmd arg(String value) => token(value);

  /// Prints the usage summary (`-h`, `--help`).
  ModprobeCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  ModprobeCmd version() => token('--version');
}

/// `modprobe`, ready to take its first option.
// ignore: non_constant_identifier_names
ModprobeCmd get Modprobe => ModprobeCmd();
