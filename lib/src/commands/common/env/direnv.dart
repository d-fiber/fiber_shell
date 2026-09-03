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

/// `direnv`, the per-directory environment loader. One Go binary on every
/// platform, though it only pays off once the shell hook is installed, so treat
/// it as optional and check with `commandExists` first.
///
/// ```dart
/// await Direnv.allow().rcPath(envrc.path).execute();
/// ```
///
/// [allow] is the one that matters to a CLI. direnv refuses to load an `.envrc` it
/// has not been told to trust, and it retrusts on content, so writing the file and
/// forgetting this leaves the developer with a warning and no environment.
///
/// Every verb has synonyms: `allow`, `permit` and `grant` are the same call,
/// as are `block`, `deny`, `disallow` and `revoke`, because direnv accumulated
/// them over the years. Pick one spelling and stay with it.
class DirenvCmd extends CommandBuilder<DirenvCmd> {
  @override
  final String executable = 'direnv';

  /// Trusts an `.envrc`, so direnv will load it (`allow`).
  DirenvCmd allow() => token('allow');

  /// The same as [allow] (`permit`).
  DirenvCmd permit() => token('permit');

  /// The same as [allow] (`grant`).
  DirenvCmd grant() => token('grant');

  /// Withdraws the trust given to an `.envrc` (`block`).
  DirenvCmd block() => token('block');

  /// The same as [block] (`deny`).
  DirenvCmd deny() => token('deny');

  /// The same as [block] (`disallow`).
  DirenvCmd disallow() => token('disallow');

  /// The same as [block] (`revoke`).
  DirenvCmd revoke() => token('revoke');

  /// Opens the `.envrc` in `$EDITOR` and trusts it afterwards (`edit`). Interactive.
  DirenvCmd edit() => token('edit');

  /// Runs a command with the environment of a directory loaded (`exec`).
  DirenvCmd exec() => token('exec');

  /// Prints the environment diff as exports for a shell (`export`).
  ///
  /// Understands `bash`, `zsh`, `fish`, `tcsh`, `elvish`, `murex`, `pwsh`, `vim`, `json`, `gha`, `systemd` and `gzenv`.
  DirenvCmd exportShell(String shell) => pair('export', shell);

  /// Downloads a URL into direnv's content-addressed store (`fetchurl`).
  DirenvCmd fetchurl(String url) => pair('fetchurl', url);

  /// Prints the command list (`help`).
  DirenvCmd help() => token('help');

  /// Adds the private commands to [help] (`SHOW_PRIVATE`).
  DirenvCmd showPrivate() => token('SHOW_PRIVATE');

  /// Prints the shell hook to install, for the shell named (`hook`).
  DirenvCmd hook(String shell) => pair('hook', shell);

  /// Forgets the allow records whose `.envrc` is gone (`prune`).
  DirenvCmd prune() => token('prune');

  /// Forces a reload of the current environment (`reload`).
  DirenvCmd reload() => token('reload');

  /// Prints the debug status: which files loaded, which are trusted (`status`).
  DirenvCmd status() => token('status');

  /// Makes [status] print JSON (`--json`).
  DirenvCmd json() => token('--json');

  /// Prints the stdlib available inside an `.envrc` (`stdlib`).
  DirenvCmd stdlib() => token('stdlib');

  /// Prints the version, or checks it against a minimum (`version`).
  DirenvCmd version() => token('version');

  /// Logs a message through direnv (`log`).
  DirenvCmd log() => token('log');

  /// Logs it as a status line (`--status`).
  DirenvCmd logStatus() => token('--status');

  /// Logs it as an error (`--error`).
  DirenvCmd logError() => token('--error');

  /// The `.envrc` to act on. Defaults to the one found from the working directory.
  DirenvCmd rcPath(String path) => token(path);

  /// Adds a bare argument, for the subcommands this wrapper has no named option for.
  DirenvCmd arg(String value) => token(value);
}

/// `direnv`, ready to take its subcommand.
// ignore: non_constant_identifier_names
DirenvCmd get Direnv => DirenvCmd();
