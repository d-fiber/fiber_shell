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

/// `spctl`, the command-line face of Gatekeeper: it assesses whether the
/// system's security policy would allow a file to execute, install or open.
/// macOS only.
///
/// ```dart
/// final ShellResult verdict = await Spctl.assess().type('execute').file(app.path).output();
/// if (verdict.failed) { /* Gatekeeper would block it */ }
/// ```
///
/// [assess] is the one to reach for; as of macOS 15 the rule-editing options
/// ([add], [disableRule], [enableRule], [remove], [resetDefault] and their
/// `--anchor`/`--hash`/`--path`/`--requirement`/`--rule` subjects) no longer
/// change anything and are kept here only because `spctl --help` still lists
/// them. [globalDisable] does not disable Gatekeeper outright; it reveals the
/// "allow applications from anywhere" toggle in Privacy & Security, which
/// still needs a human click.
class SpctlCmd extends CommandBuilder<SpctlCmd> {
  @override
  final String executable = 'spctl';

  /// Assesses the files given against system policy (`-a`, `--assess`).
  SpctlCmd assess() => token('--assess');

  /// Enables the assessment subsystem, so a denied operation actually fails
  /// (`--global-enable`). Requires root.
  SpctlCmd globalEnable() => token('--global-enable');

  /// Reveals the "allow applications downloaded from anywhere" toggle in
  /// Privacy & Security (`--global-disable`). Does not itself disable
  /// Gatekeeper; a human still has to flip the toggle.
  SpctlCmd globalDisable() => token('--global-disable');

  /// Reports whether the "anywhere" toggle is available (`--disable-status`).
  SpctlCmd disableStatus() => token('--disable-status');

  /// Reports whether the assessment subsystem is enabled or disabled
  /// (`--status`).
  SpctlCmd status() => token('--status');

  /// Keeps assessing the remaining files after one fails, instead of
  /// stopping at the first failure (`--continue`).
  SpctlCmd continueOnFailure() => token('--continue');

  /// Skips the assessment cache on the way in, which may slow things down
  /// noticeably (`--ignore-cache`).
  SpctlCmd ignoreCache() => token('--ignore-cache');

  /// Does not cache the outcome of this assessment for reuse (`--no-cache`).
  /// Existing cache entries are still used.
  SpctlCmd noCache() => token('--no-cache');

  /// Prints the assessment outcome as a raw XML property list instead of a
  /// parsed summary (`--raw`).
  SpctlCmd raw() => token('--raw');

  /// The kind of assessment to run: `execute`, `install` or `open` (`-t`,
  /// `--type`). Defaults to `execute`.
  SpctlCmd type(String kind) => pair('--type', kind);

  /// Increases output verbosity (`-v`, `--verbose`). Repeatable.
  SpctlCmd verbose() => token('-v');

  /// Adds a rule to the assessment database (`--add`). No longer supported
  /// as of macOS 15; see the class docs.
  SpctlCmd add() => token('--add');

  /// Disables a matching rule without removing it (`--disable`). No longer
  /// supported as of macOS 15.
  SpctlCmd disableRule() => token('--disable');

  /// Re-enables a rule disabled with [disableRule] (`--enable`). No longer
  /// supported as of macOS 15.
  SpctlCmd enableRule() => token('--enable');

  /// Removes a matching rule outright (`--remove`). No longer supported as
  /// of macOS 15.
  SpctlCmd remove() => token('--remove');

  /// Resets the policy database to its shipped defaults, discarding every
  /// administrator change (`--reset-default`). Requires root; reboot
  /// afterwards.
  SpctlCmd resetDefault() => token('--reset-default');

  /// In a rule-update operation, the subject is a hash of an anchor
  /// certificate, or the path to one (`--anchor`).
  SpctlCmd anchor() => token('--anchor');

  /// In a rule-update operation, the subject is a code directory hash
  /// (`--hash`).
  SpctlCmd hash() => token('--hash');

  /// Attaches, or matches, an arbitrary label on a rule (`--label`).
  SpctlCmd label(String value) => pair('--label', value);

  /// In a rule-update operation, the subject is a path to a program on
  /// disk, addressed by its Designated Requirement (`--path`).
  SpctlCmd path() => token('--path');

  /// The priority of a rule being created or changed, a floating-point
  /// number where higher wins (`--priority`).
  SpctlCmd priority(String value) => pair('--priority', value);

  /// In a rule-update operation, the subject is code requirement source
  /// text (`--requirement`).
  SpctlCmd requirement() => token('--requirement');

  /// In a rule-update operation, the subject is the index number of an
  /// existing rule (`--rule`).
  SpctlCmd rule() => token('--rule');

  /// Reads the file to assess from stdin, `-` as the path.
  SpctlCmd stdin() => token('-');

  /// A file to assess, or another bare argument such as a rule subject.
  SpctlCmd file(String path) => token(path);
}

/// `spctl`, ready to take its first option.
// ignore: non_constant_identifier_names
SpctlCmd get Spctl => SpctlCmd();
