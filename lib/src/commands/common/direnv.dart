// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

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
