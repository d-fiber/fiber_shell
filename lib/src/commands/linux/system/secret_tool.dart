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

/// `secret-tool`, the command-line front end to the freedesktop Secret Service,
/// part of libsecret. Linux only, and not always installed even there: it ships
/// in `libsecret-tools` on Debian and Ubuntu, `libsecret` on Arch and Fedora. It
/// is the Linux branch of `Keyring`, next to `security` on macOS.
///
/// ```dart
/// final ShellResult secret = await SecretTool
///     .lookup()
///     .attribute('service', 'koko-cli')
///     .attribute('account', 'keystore')
///     .output();
/// ```
///
/// An item is identified by nothing but its attribute pairs: there is no key, no
/// path. Store with one set and look up with a different one and you get nothing
/// back, silently.
///
/// Two traps worth knowing. `store` reads the secret from **stdin** until EOF and
/// keeps every byte, trailing newline included, so pass it through `output(input:)`
/// and decide deliberately whether that newline belongs in the secret. And the tool
/// needs a Secret Service on the D-Bus session: gnome-keyring, KWallet, KeePassXC.
/// A headless server or a CI box usually has none, which is why `Keyring` checks
/// `commandExists` and falls back rather than trusting it.
class SecretToolCmd extends CommandBuilder<SecretToolCmd> {
  @override
  final String executable = 'secret-tool';

  /// Stores a secret under the attributes that follow (`store`).
  ///
  /// Needs [label], and reads the secret from stdin. Matching attributes replace the existing item.
  SecretToolCmd store() => token('store');

  /// Prints the secret of the first unlocked item matching the attributes (`lookup`).
  ///
  /// Prints nothing and exits non-zero when there is no match.
  SecretToolCmd lookup() => token('lookup');

  /// Removes every unlocked item matching the attributes (`clear`).
  SecretToolCmd clear() => token('clear');

  /// Prints the details of the matching items rather than the secret (`search`).
  SecretToolCmd search() => token('search');

  /// Locks the matching items (`lock`).
  SecretToolCmd lock() => token('lock');

  /// The name a password manager will show for the item (`--label`). Required by [store].
  SecretToolCmd label(String value) => joined('--label', value);

  /// The collection to work in, rather than the default one (`--collection`).
  SecretToolCmd collection(String value) => joined('--collection', value);

  /// Under [search], returns every match instead of the first (`--all`).
  SecretToolCmd all() => token('--all');

  /// Under [search], unlocks the locked items before printing them (`--unlock`).
  SecretToolCmd unlock() => token('--unlock');

  /// Prints the version and exits (`--version`).
  SecretToolCmd version() => token('--version');

  /// Prints the usage summary (`--help`).
  SecretToolCmd help() => token('--help');

  /// Adds an attribute pair. Repeat as needed; the pairs together are the item identity.
  SecretToolCmd attribute(String key, String value) => pair(key, value);

  /// Adds a bare argument, for anything this wrapper has no named option for.
  SecretToolCmd arg(String value) => token(value);
}

/// `secret-tool`, ready to take its subcommand.
// ignore: non_constant_identifier_names
SecretToolCmd get SecretTool => SecretToolCmd();
