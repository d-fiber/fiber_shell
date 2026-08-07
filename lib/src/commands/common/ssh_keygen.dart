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

/// `ssh-keygen`, the OpenSSH key tool. Same package as `ssh`, so present on all
/// three platforms.
///
/// ```dart
/// await SshKeygen
///     .keyType('ed25519')
///     .comment('koko deploy')
///     .noPassphrase()
///     .keyFile(deployKey.path)
///     .execute();
/// ```
///
/// It does far more than make keys: it reads fingerprints ([showFingerprint]),
/// prints the public half of a private key ([extractPublicKey]), rewrites
/// passphrases ([changePassphrase]) and edits `known_hosts` ([removeHost]).
///
/// Two things bite in automation. Generating a key **prompts for a passphrase**
/// unless [noPassphrase] or [newPassphrase] says otherwise, and it **refuses to
/// overwrite** an existing file by asking a yes-or-no question, so check the path
/// yourself first rather than discovering it at a prompt nobody can answer.
///
/// `ed25519` is the sensible default: small, fast, no parameter to get wrong.
class SshKeygenCmd extends CommandBuilder<SshKeygenCmd> {
  @override
  final String executable = 'ssh-keygen';

  /// The key type: `ed25519`, `ecdsa`, `rsa`, or their `-sk` FIDO variants (`-t`).
  SshKeygenCmd keyType(String value) => pair('-t', value);

  /// The key size in bits (`-b`). Meaningless for `ed25519`.
  SshKeygenCmd bits(String value) => pair('-b', value);

  /// The comment written into the key (`-C`).
  SshKeygenCmd comment(String value) => pair('-C', value);

  /// Where to write the key (`-f`). The public half lands next to it as `.pub`.
  SshKeygenCmd keyFile(String path) => pair('-f', path);

  /// The passphrase for the new key (`-N`).
  SshKeygenCmd newPassphrase(String value) => pair('-N', value);

  /// Generates a key with no passphrase at all (`-N ''`).
  SshKeygenCmd noPassphrase() => pair('-N', '');

  /// The passphrase of the existing key (`-P`).
  SshKeygenCmd oldPassphrase(String value) => pair('-P', value);

  /// How many KDF rounds protect the private key (`-a`).
  SshKeygenCmd rounds(String value) => pair('-a', value);

  /// The key file format: `RFC4716`, `PKCS8` or `PEM` (`-m`).
  SshKeygenCmd keyFormat(String value) => pair('-m', value);

  /// The cipher protecting the private key (`-Z`).
  SshKeygenCmd cipher(String value) => pair('-Z', value);

  /// The FIDO authenticator library to use (`-w`).
  SshKeygenCmd securityKeyProvider(String path) => pair('-w', path);

  /// Sets a type-specific option, repeatable (`-O`).
  SshKeygenCmd option(String value) => pair('-O', value);

  /// Says nothing while working (`-q`).
  SshKeygenCmd quiet() => token('-q');

  /// Prints debugging messages (`-v`).
  SshKeygenCmd verbose() => token('-v');

  /// Generates the host keys of every default type, if missing (`-A`).
  SshKeygenCmd generateHostKeys() => token('-A');

  /// Changes the passphrase of an existing key (`-p`).
  SshKeygenCmd changePassphrase() => token('-p');

  /// Changes the comment of an existing key (`-c`).
  SshKeygenCmd changeComment() => token('-c');

  /// Prints the fingerprint of a key (`-l`).
  SshKeygenCmd showFingerprint() => token('-l');

  /// The hash for the fingerprint: `md5` or `sha256` (`-E`).
  SshKeygenCmd fingerprintHash(String value) => pair('-E', value);

  /// Prints the bubblebabble digest of a key (`-B`).
  SshKeygenCmd bubbleBabble() => token('-B');

  /// Prints the public key of a private key file (`-y`).
  ///
  /// The way to recover a lost `.pub` without regenerating anything.
  SshKeygenCmd extractPublicKey() => token('-y');

  /// Exports a key into the format named by [keyFormat] (`-e`).
  SshKeygenCmd exportKey() => token('-e');

  /// Imports a key from the format named by [keyFormat] (`-i`).
  SshKeygenCmd importKey() => token('-i');

  /// Downloads the public keys from a PKCS#11 library (`-D`).
  SshKeygenCmd pkcs11(String path) => pair('-D', path);

  /// Downloads the resident keys from a FIDO authenticator (`-K`).
  SshKeygenCmd downloadResidentKeys() => token('-K');

  /// Finds a host in `known_hosts` (`-F`).
  SshKeygenCmd findHost(String hostname) => pair('-F', hostname);

  /// Hashes the hostnames in `known_hosts` (`-H`).
  SshKeygenCmd hashKnownHosts() => token('-H');

  /// Removes a host from `known_hosts` (`-R`).
  ///
  /// What to run when a rebuilt server trips the changed-key warning.
  SshKeygenCmd removeHost(String hostname) => pair('-R', hostname);

  /// Prints the DNS SSHFP records for a host (`-r`).
  SshKeygenCmd dnsRecord(String hostname) => pair('-r', hostname);

  /// Uses the generic DNS format for [dnsRecord] (`-g`).
  SshKeygenCmd genericDnsFormat() => token('-g');

  /// Signs a key with this CA key, making a certificate (`-s`).
  SshKeygenCmd signWithCa(String path) => pair('-s', path);

  /// The identity the certificate names (`-I`).
  SshKeygenCmd certificateIdentity(String value) => pair('-I', value);

  /// The principals the certificate is valid for (`-n`).
  SshKeygenCmd principals(String value) => pair('-n', value);

  /// How long the certificate is valid (`-V`).
  SshKeygenCmd validity(String interval) => pair('-V', interval);

  /// The serial number of the certificate (`-z`).
  SshKeygenCmd serial(String value) => pair('-z', value);

  /// Signs a host certificate rather than a user one (`-h`).
  SshKeygenCmd hostCertificate() => token('-h');

  /// Says the CA key lives in a PKCS#11 token (`-U`).
  SshKeygenCmd caInToken() => token('-U');

  /// Prints the contents of a certificate (`-L`).
  SshKeygenCmd showCertificate() => token('-L');

  /// Generates a key revocation list (`-k`).
  SshKeygenCmd generateKrl() => token('-k');

  /// Updates an existing revocation list (`-u`).
  SshKeygenCmd updateKrl() => token('-u');

  /// Tests whether a key appears in a revocation list (`-Q`).
  SshKeygenCmd testRevoked() => token('-Q');

  /// Runs a moduli operation: `generate` or `screen` (`-M`).
  SshKeygenCmd moduli(String value) => pair('-M', value);

  /// Runs a signature operation: `sign`, `verify`, `find-principals` and so on (`-Y`).
  SshKeygenCmd signatureOperation(String value) => pair('-Y', value);

  /// Adds a bare argument, a file to sign or a certificate to read.
  SshKeygenCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
SshKeygenCmd get SshKeygen => SshKeygenCmd();
