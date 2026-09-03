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

/// `openssl`. **The name does not identify the program.** It resolves to OpenSSL
/// on some systems and to LibreSSL on others, and a machine often carries both,
/// so which one answers depends on `PATH`. They diverge on defaults, on option
/// spellings and on which algorithms exist at all, enough that a command proven
/// in a terminal can behave differently under a service manager or a CI runner
/// that builds its own `PATH`. `openssl version` says which one you got.
///
/// ```dart
/// await OpenSSL.enc().aes256cbc().pbkdf2().salt()
///     .inFile(plain.path).out(cipher.path).passFile(keyFile.path).execute();
/// ```
///
/// [pbkdf2] on every `enc` call is not decoration: without it the key is derived
/// with a single MD5 round, which stopped being acceptable a long time ago. Both
/// flavours have supported the flag for years, so there is no reason to omit it.
///
/// The subcommand comes first, then its options, and each subcommand has its own
/// option set: `-in` means one thing to `pkey` and another to `enc`. Passwords are
/// better read from a file with [passFile] than handed over on the command line,
/// where `ps` can see them.
class OpenSSLCmd extends CommandBuilder<OpenSSLCmd> {
  @override
  final String executable = 'openssl';

  /// Parses and prints an ASN.1 structure (`asn1parse`).
  OpenSSLCmd asn1parse() => token('asn1parse');

  /// Runs the minimal certificate authority (`ca`).
  OpenSSLCmd ca() => token('ca');

  /// Lists the TLS cipher suites (`ciphers`).
  OpenSSLCmd ciphersCommand() => token('ciphers');

  /// Speaks the certificate management protocol (`cmp`).
  OpenSSLCmd cmp() => token('cmp');

  /// Handles CMS, so signed and enveloped messages (`cms`).
  OpenSSLCmd cms() => token('cms');

  /// Reads and writes certificate revocation lists (`crl`).
  OpenSSLCmd crl() => token('crl');

  /// Wraps a CRL into a PKCS#7 structure (`crl2pkcs7`).
  OpenSSLCmd crl2pkcs7() => token('crl2pkcs7');

  /// Computes a digest, or signs and verifies one (`dgst`).
  OpenSSLCmd dgst() => token('dgst');

  /// Generates or inspects Diffie-Hellman parameters (`dhparam`).
  OpenSSLCmd dhparam() => token('dhparam');

  /// Handles DSA keys (`dsa`).
  OpenSSLCmd dsa() => token('dsa');

  /// Handles DSA parameters (`dsaparam`).
  OpenSSLCmd dsaparam() => token('dsaparam');

  /// Handles elliptic curve keys (`ec`).
  OpenSSLCmd ec() => token('ec');

  /// Handles elliptic curve parameters (`ecparam`).
  OpenSSLCmd ecparam() => token('ecparam');

  /// Encrypts and decrypts with a symmetric cipher (`enc`).
  OpenSSLCmd enc() => token('enc');

  /// Inspects the engines (`engine`). Deprecated in OpenSSL 3 in favour of providers.
  OpenSSLCmd engineCommand() => token('engine');

  /// Turns an error code into words (`errstr`).
  OpenSSLCmd errstr() => token('errstr');

  /// Installs the FIPS provider configuration (`fipsinstall`).
  OpenSSLCmd fipsinstall() => token('fipsinstall');

  /// Generates a DSA key (`gendsa`).
  OpenSSLCmd gendsa() => token('gendsa');

  /// Generates a private key of any algorithm (`genpkey`).
  OpenSSLCmd genpkey() => token('genpkey');

  /// Generates an RSA key (`genrsa`).
  OpenSSLCmd genrsa() => token('genrsa');

  /// Lists the subcommands (`help`).
  OpenSSLCmd help() => token('help');

  /// Prints build and configuration information (`info`).
  OpenSSLCmd info() => token('info');

  /// Runs a key derivation function (`kdf`).
  OpenSSLCmd kdf() => token('kdf');

  /// Lists algorithms, providers and the rest (`list`).
  OpenSSLCmd listCommand() => token('list');

  /// Computes a message authentication code (`mac`).
  OpenSSLCmd mac() => token('mac');

  /// Handles a Netscape certificate sequence (`nseq`).
  OpenSSLCmd nseq() => token('nseq');

  /// Speaks OCSP (`ocsp`).
  OpenSSLCmd ocsp() => token('ocsp');

  /// Hashes a password the way `crypt` does (`passwd`).
  OpenSSLCmd passwd() => token('passwd');

  /// Reads and writes PKCS#12 bundles (`pkcs12`).
  OpenSSLCmd pkcs12() => token('pkcs12');

  /// Reads and writes PKCS#7 structures (`pkcs7`).
  OpenSSLCmd pkcs7() => token('pkcs7');

  /// Reads and writes PKCS#8 private keys (`pkcs8`).
  OpenSSLCmd pkcs8() => token('pkcs8');

  /// Reads, converts and prints a private or public key (`pkey`).
  OpenSSLCmd pkey() => token('pkey');

  /// Handles algorithm parameters (`pkeyparam`).
  OpenSSLCmd pkeyparam() => token('pkeyparam');

  /// Signs, verifies, encrypts and derives with a key (`pkeyutl`).
  OpenSSLCmd pkeyutl() => token('pkeyutl');

  /// Tests or generates primes (`prime`).
  OpenSSLCmd prime() => token('prime');

  /// Emits cryptographically secure random bytes (`rand`).
  OpenSSLCmd rand() => token('rand');

  /// Rebuilds the symlink hashes of a certificate directory (`rehash`).
  OpenSSLCmd rehash() => token('rehash');

  /// Creates and inspects certificate signing requests (`req`).
  OpenSSLCmd req() => token('req');

  /// Handles RSA keys (`rsa`).
  OpenSSLCmd rsa() => token('rsa');

  /// The old RSA sign and encrypt tool (`rsautl`). Superseded by [pkeyutl].
  OpenSSLCmd rsautl() => token('rsautl');

  /// Opens a TLS client connection, for poking at a server (`s_client`).
  OpenSSLCmd sClient() => token('s_client');

  /// Runs a TLS test server (`s_server`).
  OpenSSLCmd sServer() => token('s_server');

  /// Benchmarks TLS connections (`s_time`).
  OpenSSLCmd sTime() => token('s_time');

  /// Reads and writes TLS session data (`sess_id`).
  OpenSSLCmd sessId() => token('sess_id');

  /// Handles S/MIME messages (`smime`).
  OpenSSLCmd smime() => token('smime');

  /// Benchmarks the algorithms (`speed`).
  OpenSSLCmd speed() => token('speed');

  /// Handles a Netscape SPKAC (`spkac`).
  OpenSSLCmd spkac() => token('spkac');

  /// Manages an SRP verifier file (`srp`).
  OpenSSLCmd srp() => token('srp');

  /// Reads from a store URI (`storeutl`).
  OpenSSLCmd storeutl() => token('storeutl');

  /// Speaks the time stamp protocol (`ts`).
  OpenSSLCmd ts() => token('ts');

  /// Verifies a certificate chain (`verify`).
  OpenSSLCmd verify() => token('verify');

  /// Prints the version (`version`). Worth calling to find out which flavour answered.
  OpenSSLCmd version() => token('version');

  /// Reads, writes and signs X.509 certificates (`x509`).
  OpenSSLCmd x509() => token('x509');

  /// Prints the summary of the current subcommand (`-help`).
  OpenSSLCmd helpFlag() => token('-help');

  /// Uses an engine, so a hardware device (`-engine`).
  OpenSSLCmd engine(String name) => pair('-engine', name);

  /// Reads the algorithm parameters from this file (`-paramfile`).
  OpenSSLCmd paramFile(String path) => pair('-paramfile', path);

  /// The public key algorithm, `X25519`, `RSA`, `EC` and so on (`-algorithm`).
  OpenSSLCmd algorithm(String name) => pair('-algorithm', name);

  /// Reports progress while it works (`-verbose`).
  OpenSSLCmd verbose() => token('-verbose');

  /// Says nothing while it works (`-quiet`).
  OpenSSLCmd quiet() => token('-quiet');

  /// Sets an algorithm option, `opt:value` (`-pkeyopt`).
  OpenSSLCmd pkeyopt(String value) => pair('-pkeyopt', value);

  /// Sets a signature parameter, `n:v` (`-sigopt`).
  OpenSSLCmd sigopt(String value) => pair('-sigopt', value);

  /// Sets a verification parameter, `n:v` (`-vfyopt`).
  OpenSSLCmd vfyopt(String value) => pair('-vfyopt', value);

  /// Loads this configuration file, modules included (`-config`).
  OpenSSLCmd config(String path) => pair('-config', path);

  /// The config section to read (`-section`).
  OpenSSLCmd section(String name) => pair('-section', name);

  /// The output file (`-out`). Without it everything goes to stdout.
  OpenSSLCmd out(String path) => pair('-out', path);

  /// Writes the public key here as well (`-outpubkey`).
  OpenSSLCmd outPubKey(String path) => pair('-outpubkey', path);

  /// The output encoding, `PEM` or `DER` (`-outform`).
  OpenSSLCmd outform(String format) => pair('-outform', format);

  /// The input file (`-in`).
  OpenSSLCmd inFile(String path) => pair('-in', path);

  /// The input encoding (`-inform`).
  OpenSSLCmd inform(String format) => pair('-inform', format);

  /// The key file format (`-keyform`).
  OpenSSLCmd keyform(String format) => pair('-keyform', format);

  /// Generates parameters rather than a key (`-genparam`).
  OpenSSLCmd genparam() => token('-genparam');

  /// Prints the object in readable form alongside the encoding (`-text`).
  OpenSSLCmd text() => token('-text');

  /// Prints only the public components in readable form (`-text_pub`).
  OpenSSLCmd textPub() => token('-text_pub');

  /// Skips the encoded output, leaving only what [text] printed (`-noout`).
  OpenSSLCmd noout() => token('-noout');

  /// Reads a public key rather than a private one (`-pubin`).
  OpenSSLCmd pubin() => token('-pubin');

  /// Writes the public half of the key (`-pubout`).
  OpenSSLCmd pubout() => token('-pubout');

  /// Adds the public key to the output (`-pubkey`).
  OpenSSLCmd pubkey() => token('-pubkey');

  /// Checks the key is internally consistent (`-check`).
  OpenSSLCmd check() => token('-check');

  /// Checks the public key is consistent (`-pubcheck`).
  OpenSSLCmd pubcheck() => token('-pubcheck');

  /// Writes the private key in the old PEM form (`-traditional`).
  OpenSSLCmd traditional() => token('-traditional');

  /// The EC point conversion form (`-ec_conv_form`).
  OpenSSLCmd ecConvForm(String value) => pair('-ec_conv_form', value);

  /// How the EC parameters are encoded (`-ec_param_enc`).
  OpenSSLCmd ecParamEnc(String value) => pair('-ec_param_enc', value);

  /// The passphrase source, in openssl syntax (`-pass`).
  OpenSSLCmd pass(String source) => pair('-pass', source);

  /// Reads the passphrase from a file (`-pass file:PATH`).
  ///
  /// The safe spelling: a passphrase given inline shows up in `ps` for everyone on the box.
  OpenSSLCmd passFile(String path) => pair('-pass', 'file:$path');

  /// Reads the passphrase from stdin (`-pass stdin`).
  OpenSSLCmd passStdin() => pair('-pass', 'stdin');

  /// Reads the passphrase from an environment variable (`-pass env:NAME`).
  OpenSSLCmd passEnv(String name) => pair('-pass', 'env:$name');

  /// The passphrase source for the input key (`-passin`).
  OpenSSLCmd passIn(String source) => pair('-passin', source);

  /// The passphrase source for the output key (`-passout`).
  OpenSSLCmd passOut(String source) => pair('-passout', source);

  /// Encrypts (`-e`). Already the default for `enc`.
  OpenSSLCmd encrypt() => token('-e');

  /// Decrypts instead (`-d`).
  OpenSSLCmd dec() => token('-d');

  /// Prints the derived key and IV alongside the output (`-p`).
  OpenSSLCmd printKey() => token('-p');

  /// Prints them and stops there (`-P`).
  OpenSSLCmd printKeyAndExit() => token('-P');

  /// Lists the ciphers `enc` understands (`-list`).
  OpenSSLCmd listCiphers() => token('-list');

  /// The passphrase, inline (`-k`). Visible in `ps`; prefer [passFile].
  OpenSSLCmd passphrase(String value) => pair('-k', value);

  /// Reads the passphrase from a file (`-kfile`).
  OpenSSLCmd passphraseFile(String path) => pair('-kfile', path);

  /// Base64-encodes on the way out, decodes on the way in (`-a`).
  OpenSSLCmd base64() => token('-a');

  /// The same under its long name (`-base64`).
  OpenSSLCmd base64Long() => token('-base64');

  /// Treats the base64 as one long line rather than wrapped (`-A`).
  OpenSSLCmd singleLine() => token('-A');

  /// Turns the standard block padding off (`-nopad`).
  OpenSSLCmd nopad() => token('-nopad');

  /// Salts the key derivation (`-salt`). The default, and worth stating anyway.
  OpenSSLCmd salt() => token('-salt');

  /// Derives the key without a salt (`-nosalt`). Two identical inputs then encrypt identically.
  OpenSSLCmd nosalt() => token('-nosalt');

  /// Prints debug information (`-debug`).
  OpenSSLCmd debug() => token('-debug');

  /// The read and write buffer size (`-bufsize`).
  OpenSSLCmd bufsize(String value) => pair('-bufsize', value);

  /// The key itself, in hex, no derivation (`-K`).
  OpenSSLCmd rawKey(String hex) => pair('-K', hex);

  /// The salt, in hex (`-S`).
  OpenSSLCmd saltHex(String hex) => pair('-S', hex);

  /// The initialisation vector, in hex (`-iv`).
  OpenSSLCmd iv(String hex) => pair('-iv', hex);

  /// The digest used to derive the key from the passphrase (`-md`).
  OpenSSLCmd md(String digest) => pair('-md', digest);

  /// The PBKDF2 iteration count (`-iter`). Implies [pbkdf2]; the default is 10000.
  OpenSSLCmd iter(int count) => pair('-iter', '$count');

  /// Derives the key with PBKDF2 (`-pbkdf2`).
  ///
  /// Without it `enc` still derives the key with one round of MD5, so it belongs on every call.
  OpenSSLCmd pbkdf2() => token('-pbkdf2');

  /// The PBKDF2 salt length in bytes (`-saltlen`). Defaults to 16.
  OpenSSLCmd saltlen(int bytes) => pair('-saltlen', '$bytes');

  /// Does not encrypt at all (`-none`).
  OpenSSLCmd none() => token('-none');

  /// An option for opaque symmetric key handling, `opt:value` (`-skeyopt`).
  OpenSSLCmd skeyopt(String value) => pair('-skeyopt', value);

  /// The symmetric key management name (`-skeymgmt`).
  OpenSSLCmd skeymgmt(String value) => pair('-skeymgmt', value);

  /// Seeds the RNG from these files (`-rand`).
  OpenSSLCmd randSource(String files) => pair('-rand', files);

  /// Writes random data back to this file (`-writerand`).
  OpenSSLCmd writerand(String path) => pair('-writerand', path);

  /// Loads a provider (`-provider`). Repeatable. OpenSSL 3 only.
  OpenSSLCmd provider(String name) => pair('-provider', name);

  /// Where to look for providers (`-provider-path`). Must come before [provider].
  OpenSSLCmd providerPath(String path) => pair('-provider-path', path);

  /// Sets a provider key-value parameter (`-provparam`).
  OpenSSLCmd provparam(String value) => pair('-provparam', value);

  /// The property query used when fetching algorithms (`-propquery`).
  OpenSSLCmd propquery(String value) => pair('-propquery', value);

  /// Hex-encodes the output (`-hex`).
  OpenSSLCmd hex() => token('-hex');

  /// Creates a new request (`-new`).
  OpenSSLCmd newRequest() => token('-new');

  /// Generates a new key alongside, `alg:bits` or `alg:file` (`-newkey`).
  OpenSSLCmd newkey(String spec) => pair('-newkey', spec);

  /// The key to sign with (`-key`).
  OpenSSLCmd key(String value) => pair('-key', value);

  /// Where to write the generated private key (`-keyout`).
  OpenSSLCmd keyout(String path) => pair('-keyout', path);

  /// The key to self-sign a certificate with (`-signkey`).
  OpenSSLCmd signkey(String path) => pair('-signkey', path);

  /// Sets the subject, `/CN=example.com` style (`-subj`).
  ///
  /// What keeps `req` from turning interactive; pair it with [batch].
  OpenSSLCmd subj(String value) => pair('-subj', value);

  /// Prints the subject of the output (`-subject`).
  OpenSSLCmd subject() => token('-subject');

  /// Adds one certificate extension, `key=value` (`-addext`). Repeatable.
  OpenSSLCmd addext(String value) => pair('-addext', value);

  /// The config section holding the extensions (`-extensions`).
  OpenSSLCmd extensions(String section) => pair('-extensions', section);

  /// The same under its older name (`-reqexts`).
  OpenSSLCmd reqexts(String section) => pair('-reqexts', section);

  /// Whether to copy the extensions of a request when signing (`-copy_extensions`).
  OpenSSLCmd copyExtensions(String value) => pair('-copy_extensions', value);

  /// How many days the certificate stays valid (`-days`).
  OpenSSLCmd days(int value) => pair('-days', '$value');

  /// The serial number to use (`-set_serial`).
  OpenSSLCmd setSerial(String value) => pair('-set_serial', value);

  /// The notBefore field, `[CC]YYMMDDHHMMSSZ` (`-not_before`).
  OpenSSLCmd notBefore(String value) => pair('-not_before', value);

  /// The notAfter field, which overrides [days] (`-not_after`).
  OpenSSLCmd notAfter(String value) => pair('-not_after', value);

  /// Emits a certificate rather than a request (`-x509`).
  OpenSSLCmd x509Flag() => token('-x509');

  /// Emits an X.509 version 1 certificate (`-x509v1`).
  OpenSSLCmd x509v1() => token('-x509v1');

  /// The issuer certificate to sign with (`-CA`). Implies [x509Flag].
  OpenSSLCmd certificateAuthority(String path) => pair('-CA', path);

  /// The issuer private key (`-CAkey`). Defaults to the `-CA` file.
  OpenSSLCmd certificateAuthorityKey(String path) => pair('-CAkey', path);

  /// Creates the serial number file if it is missing (`-CAcreateserial`).
  OpenSSLCmd createSerial() => token('-CAcreateserial');

  /// Reads the input as UTF-8 rather than ASCII (`-utf8`).
  OpenSSLCmd utf8() => token('-utf8');

  /// How to print subject and issuer names (`-nameopt`).
  OpenSSLCmd nameopt(String value) => pair('-nameopt', value);

  /// How to print the request (`-reqopt`).
  OpenSSLCmd reqopt(String value) => pair('-reqopt', value);

  /// Asks nothing (`-batch`). Required for anything unattended.
  OpenSSLCmd batch() => token('-batch');

  /// Leaves the generated private key unencrypted (`-noenc`).
  OpenSSLCmd noenc() => token('-noenc');

  /// The old spelling of [noenc] (`-nodes`). Deprecated.
  OpenSSLCmd nodes() => token('-nodes');

  /// Puts `NEW` in the PEM header lines (`-newhdr`).
  OpenSSLCmd newhdr() => token('-newhdr');

  /// Adds a poison extension, making a precertificate (`-precert`).
  OpenSSLCmd precert() => token('-precert');

  /// Deprecated and ignored: multi-valued RDNs are always on (`-multivalue-rdn`).
  OpenSSLCmd multivalueRdn() => token('-multivalue-rdn');

  /// Verifies the self-signature on a request (`-verify`).
  OpenSSLCmd verifySelfSignature() => token('-verify');

  /// The engine to generate keys with (`-keygen_engine`).
  OpenSSLCmd keygenEngine(String name) => pair('-keygen_engine', name);

  /// The cipher to encrypt a private key with, by name (`-cipher`).
  OpenSSLCmd cipher(String name) => pair('-cipher', name);

  /// AES-128 in CBC mode (`-aes-128-cbc`).
  OpenSSLCmd aes128cbc() => token('-aes-128-cbc');

  /// AES-192 in CBC mode (`-aes-192-cbc`).
  OpenSSLCmd aes192cbc() => token('-aes-192-cbc');

  /// AES-256 in CBC mode (`-aes-256-cbc`).
  OpenSSLCmd aes256cbc() => token('-aes-256-cbc');

  /// AES-128 in ECB mode (`-aes-128-ecb`). ECB leaks patterns; use CBC.
  OpenSSLCmd aes128ecb() => token('-aes-128-ecb');

  /// AES-192 in ECB mode (`-aes-192-ecb`).
  OpenSSLCmd aes192ecb() => token('-aes-192-ecb');

  /// AES-256 in ECB mode (`-aes-256-ecb`).
  OpenSSLCmd aes256ecb() => token('-aes-256-ecb');

  /// The ChaCha20 stream cipher (`-chacha20`).
  OpenSSLCmd chacha20() => token('-chacha20');

  /// Triple DES (`-des3`). Only for reading something old.
  OpenSSLCmd des3() => token('-des3');

  /// The MD5 digest (`-md5`). Broken for signatures, fine for a checksum.
  OpenSSLCmd md5() => token('-md5');

  /// The SHA-1 digest (`-sha1`). Broken for signatures.
  OpenSSLCmd sha1() => token('-sha1');

  /// The SHA-256 digest (`-sha256`).
  OpenSSLCmd sha256() => token('-sha256');

  /// The SHA-384 digest (`-sha384`).
  OpenSSLCmd sha384() => token('-sha384');

  /// The SHA-512 digest (`-sha512`).
  OpenSSLCmd sha512() => token('-sha512');

  /// Writes the output as raw bytes rather than text (`-binary`).
  OpenSSLCmd binary() => token('-binary');

  /// Computes an HMAC with this key (`-hmac`).
  OpenSSLCmd hmac(String key) => pair('-hmac', key);

  /// Signs with the private key in this file (`-sign`).
  OpenSSLCmd sign(String path) => pair('-sign', path);

  /// The signature file to check against (`-signature`).
  OpenSSLCmd verifySignature(String path) => pair('-signature', path);

  /// Adds a bare argument, a byte count for `rand` or a file for `dgst`.
  OpenSSLCmd arg(String value) => token(value);
}

/// `openssl`, ready to take its subcommand.
// ignore: non_constant_identifier_names
OpenSSLCmd get OpenSSL => OpenSSLCmd();
