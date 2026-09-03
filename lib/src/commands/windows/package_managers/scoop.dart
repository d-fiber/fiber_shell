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

/// `scoop`, the command-line installer for Windows. Windows only: the
/// executable does not exist on the other platforms.
///
/// ```dart
/// await Scoop.install().global().independent().arg('git').execute();
/// ```
///
/// **This wrapper is a vocabulary, not a grammar.** Every top-level command is
/// a method, and the options shared across commands are a single method each,
/// reusable wherever scoop accepts them. Nothing validates that [global] goes
/// with [install] rather than [search]; scoop will say so if you get it
/// wrong.
///
/// `scoop update` alone refreshes scoop and the bucket manifests; `scoop
/// update` followed by an app name installs a newer version of that one app
/// if scoop knows of one. Both are the same [update] method, followed by
/// either nothing or [arg].
///
/// Two pairs of names collide on their short flag across different
/// subcommands, and are kept as separate methods rather than merged: [noCache]
/// is `install`'s and `update`'s `-k`, `--no-cache`, while [removeCache] is
/// `cleanup`'s `-k`, `--cache`, a different flag that happens to share the
/// letter. The same goes for [config], the subcommand, against
/// [includeConfig], `export`'s `-c`, `--config`. And mind [purge]: its short
/// form is `-p`, not `-u`, and the hash-check skip is spelled out as
/// [skipHashCheck] because scoop's own flag is `--skip-hash-check`, not
/// `--skip`.
class ScoopCmd extends CommandBuilder<ScoopCmd> {
  @override
  final String executable = 'scoop';

  /// Installs an app (`install`).
  ScoopCmd install() => token('install');

  /// Removes an app (`uninstall`).
  ScoopCmd uninstall() => token('uninstall');

  /// Updates scoop and the bucket manifests, or one app when followed by [arg] (`update`).
  ScoopCmd update() => token('update');

  /// Lists the installed apps, or those matching a query passed through [arg] (`list`).
  ///
  /// Also the `shim list` sub-subcommand, which lists shims instead.
  ScoopCmd list() => token('list');

  /// Searches the known buckets for apps matching a query passed through [arg] (`search`).
  ScoopCmd search() => token('search');

  /// Displays an app's manifest details (`info`).
  ///
  /// Also the `shim info` sub-subcommand, which describes a shim instead.
  ScoopCmd info() => token('info');

  /// Shows outdated apps and buckets (`status`).
  ScoopCmd status() => token('status');

  /// Manages the buckets scoop installs from (`bucket`). Use with [add], [list], [known] or [rm].
  ScoopCmd bucket() => token('bucket');

  /// Shows or clears the download cache (`cache`). Use with [show] or [rm].
  ScoopCmd cacheCommand() => token('cache');

  /// Prints an app's manifest (`cat`).
  ScoopCmd cat() => token('cat');

  /// Runs the diagnostic checks for common problems (`checkup`).
  ScoopCmd checkup() => token('checkup');

  /// Removes old versions of an app, or of every app (`cleanup`).
  ScoopCmd cleanup() => token('cleanup');

  /// Reads or writes a scoop configuration value (`config`). The subcommand; `export`'s flag is [includeConfig].
  ScoopCmd config() => token('config');

  /// Lists an app's dependencies in install order (`depends`).
  ScoopCmd depends() => token('depends');

  /// Prints the installed apps, buckets and configuration as JSON (`export`).
  ScoopCmd export() => token('export');

  /// Excludes an app from [update] (`hold`).
  ScoopCmd hold() => token('hold');

  /// Reverses [hold] (`unhold`).
  ScoopCmd unhold() => token('unhold');

  /// Opens an app's homepage (`home`).
  ScoopCmd home() => token('home');

  /// Installs the apps, buckets and configuration described by an [export] file (`import`).
  ScoopCmd import() => token('import');

  /// Prints the install directory of an app (`prefix`).
  ScoopCmd prefix() => token('prefix');

  /// Resolves a conflict between apps that provide the same command, in favour of one (`reset`).
  ScoopCmd reset() => token('reset');

  /// Manages the shims scoop puts on the path (`shim`). Use with [add], [rm], [list], [info] or [alter].
  ScoopCmd shim() => token('shim');

  /// Looks up an app's hash or URL on VirusTotal (`virustotal`).
  ScoopCmd virustotal() => token('virustotal');

  /// Locates the shim or executable a command resolves to (`which`).
  ScoopCmd which() => token('which');

  /// The `add` sub-subcommand of [bucket] and [shim].
  ScoopCmd add() => token('add');

  /// The `rm` sub-subcommand of [bucket], [cacheCommand] and [shim].
  ScoopCmd rm() => token('rm');

  /// The `known` sub-subcommand of [bucket], listing the buckets scoop recognises by name.
  ScoopCmd known() => token('known');

  /// The `show` sub-subcommand of [cacheCommand], printing what is cached.
  ScoopCmd show() => token('show');

  /// The `alter` sub-subcommand of [shim], switching a shim to its next target source.
  ScoopCmd alter() => token('alter');

  /// Acts at machine scope instead of the current user's (`-g`, `--global`).
  ScoopCmd global() => token('--global');

  /// Skips installing dependencies automatically (`-i`, `--independent`).
  ScoopCmd independent() => token('--independent');

  /// Skips the download cache and fetches fresh (`-k`, `--no-cache`), for [install] and [update].
  ///
  /// Not [removeCache]: that one deletes what is already cached instead of bypassing it.
  ScoopCmd noCache() => token('--no-cache');

  /// Skips validating the download's hash (`-s`, `--skip-hash-check`). Use with caution.
  ScoopCmd skipHashCheck() => token('--skip-hash-check');

  /// Skips updating scoop itself first (`-u`, `--no-update-scoop`), for [install], [update] and [virustotal].
  ScoopCmd noUpdateScoop() => token('--no-update-scoop');

  /// Targets an architecture: `32bit`, `64bit` or `arm64` (`-a`, `--arch`), for [install] and [depends].
  ScoopCmd arch(String value) => pair('--arch', value);

  /// Also deletes an app's persisted data on [uninstall] (`-p`, `--purge`).
  ScoopCmd purge() => token('--purge');

  /// Updates even when no newer version is available (`-f`, `--force`), for [update].
  ScoopCmd force() => token('--force');

  /// Hides the extraneous messages (`-q`, `--quiet`), for [update].
  ScoopCmd quiet() => token('--quiet');

  /// Acts on every app instead of one, in place of `*` (`-a`, `--all`).
  ScoopCmd all() => token('--all');

  /// Deletes the outdated download cache (`-k`, `--cache`), for [cleanup].
  ///
  /// Not [noCache]: that one skips the cache during a run instead of clearing what is stored.
  ScoopCmd removeCache() => token('--cache');

  /// Includes the scoop configuration file in an [export] (`-c`, `--config`). The flag; the subcommand is [config].
  ScoopCmd includeConfig() => token('--config');

  /// Restricts a [status] check to locally installed apps, skipping remote fetches (`-l`, `--local`).
  ScoopCmd local() => token('--local');

  /// Shows full paths and URLs instead of abbreviated ones, for [info] (`-v`, `--verbose`).
  ScoopCmd verbose() => token('--verbose');

  /// Submits a download for scanning when VirusTotal has no information yet (`-s`, `--scan`).
  ///
  /// Requires `virustotal_api_key` to be set through [config].
  ScoopCmd scan() => token('--scan');

  /// Skips checking a package's dependencies, for [virustotal] (`-n`, `--no-depends`).
  ScoopCmd noDepends() => token('--no-depends');

  /// Returns a [virustotal] report as an object instead of printing it (`-p`, `--passthru`).
  ScoopCmd passthru() => token('--passthru');

  /// Adds a bare argument, for an app name, a manifest, a URL, a shim name or a config key.
  ScoopCmd arg(String value) => token(value);
}

/// `scoop`, ready to take its first option.
// ignore: non_constant_identifier_names
ScoopCmd get Scoop => ScoopCmd();
