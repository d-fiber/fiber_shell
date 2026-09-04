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

/// `age`, the modern file-encryption tool: small key sizes, no configuration,
/// no key rings, and a deliberately tiny flag surface compared to [OpenSSLCmd]
/// or [GpgCmd].
///
/// ```dart
/// // Encrypt to a recipient's public key, armored so it survives a text field.
/// await Age.encrypt().armor().recipient(publicKey).outputFile('secret.age').file('plain.txt').execute();
///
/// // Decrypt with a local identity file.
/// final ShellResult clear = await Age.decrypt().identity('key.txt').file('secret.age').output();
/// ```
///
/// Exactly one of [encrypt] or [decrypt] applies; `age` infers encryption by
/// default when neither is given and a recipient is present, but naming the
/// mode explicitly is what keeps a script's intent legible. [passphrase] opens
/// an interactive prompt on stdin/stderr, which is useless for automation — a
/// script wants [recipient] or [identity] instead, both of which take no
/// terminal at all. There is no `--force`: `age` never overwrites a file passed
/// to [outputFile] that already exists on disk when stdout is a pipe, but it
/// will happily overwrite when writing through a real file argument, so guard
/// that in the caller.
class AgeCmd extends CommandBuilder<AgeCmd> {
  @override
  final String executable = 'age';

  /// Encrypts the input (`-e`, `--encrypt`).
  AgeCmd encrypt() => token('-e');

  /// Decrypts the input (`-d`, `--decrypt`).
  AgeCmd decrypt() => token('-d');

  /// Writes the result here instead of stdout (`-o`, `--output`).
  ///
  /// Named to avoid colliding with [CommandBuilder.output], the runner that captures a result.
  AgeCmd outputFile(String path) => pair('-o', path);

  /// Wraps encrypted output in ASCII armor, so it survives a text field or an email body (`-a`, `--armor`).
  AgeCmd armor() => token('-a');

  /// Encrypts with a passphrase instead of a key, prompted interactively — not for automation (`-p`, `--passphrase`).
  AgeCmd passphrase() => token('-p');

  /// Adds a recipient's public key to encrypt to (`-r`, `--recipient`). Repeatable.
  AgeCmd recipient(String publicKey) => pair('-r', publicKey);

  /// Reads recipient public keys from a file, one per line (`-R`, `--recipients-file`). Repeatable.
  AgeCmd recipientsFile(String path) => pair('-R', path);

  /// Adds an identity (private key) file to decrypt with, or to encrypt to its matching recipient (`-i`, `--identity`).
  ///
  /// Repeatable; each file may itself hold several identities.
  AgeCmd identity(String path) => pair('-i', path);

  /// Prints the version and exits (`-v`, `--version`).
  AgeCmd version() => token('-v');

  /// The file to read, in place of stdin. `-` means stdin explicitly.
  AgeCmd file(String path) => token(path);
}

/// `age`, ready to take its first option.
// ignore: non_constant_identifier_names
AgeCmd get Age => AgeCmd();
