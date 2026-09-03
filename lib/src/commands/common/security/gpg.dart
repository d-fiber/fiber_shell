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

/// `gpg`, GnuPG's OpenPGP implementation. Where [OpenSSL] handles X.509 and raw
/// symmetric crypto, `gpg` is the tool for the OpenPGP web of trust: signing
/// releases, encrypting to a recipient's public key, and verifying both. Not
/// preinstalled on macOS or Windows; `commandExists` first.
///
/// ```dart
/// await Gpg.batch().yes().armor().localUser(keyId).output_('release.tar.gz.asc').detachSign().file('release.tar.gz').execute();
/// final ShellResult ok = await Gpg.verify().arg('release.tar.gz.asc').arg('release.tar.gz').output();
/// ```
///
/// Three habits matter for a script. **[batch] plus [yes]** is what stops gpg
/// from ever falling back to an interactive prompt; without both, a run
/// blocked on a terminal that does not exist just hangs. **[passphraseFile] or
/// [passphraseFd]**, never [passphrase] inline: an argv passphrase is visible
/// to anyone on the box running `ps`. And **the key material itself lives in
/// `~/.gnupg` by default**, which [homedir] redirects; a CI runner wants its
/// own, disposable one rather than sharing state across builds.
class GpgCmd extends CommandBuilder<GpgCmd> {
  @override
  final String executable = 'gpg';

  /// Makes a signature, combinable with [encrypt] (`-s`, `--sign`).
  GpgCmd sign() => token('--sign');

  /// Makes a human-readable clear text signature (`--clearsign`).
  GpgCmd clearsign() => token('--clearsign');

  /// Makes a detached signature, a separate file alongside the original (`-b`, `--detach-sign`).
  GpgCmd detachSign() => token('--detach-sign');

  /// Encrypts data, combinable with [sign] (`-e`, `--encrypt`).
  GpgCmd encrypt() => token('--encrypt');

  /// Encrypts with a symmetric cipher and a passphrase, no public key involved (`-c`, `--symmetric`).
  GpgCmd symmetric() => token('--symmetric');

  /// Decrypts the given file and writes the result to stdout (`-d`, `--decrypt`).
  GpgCmd decrypt() => token('--decrypt');

  /// Verifies a signed file or a detached signature against the original (`--verify`).
  GpgCmd verify() => token('--verify');

  /// Lists keys from the public keyrings (`-k`, `--list-keys`).
  GpgCmd listKeys() => token('--list-keys');

  /// Lists keys from the secret keyrings (`-K`, `--list-secret-keys`).
  GpgCmd listSecretKeys() => token('--list-secret-keys');

  /// The same as [listKeys], with each key's signatures listed too (`--list-sigs`).
  GpgCmd listSigs() => token('--list-sigs');

  /// The same as [listSigs], but every listed signature is also verified (`--check-sigs`).
  GpgCmd checkSigs() => token('--check-sigs');

  /// Lists every key alongside its fingerprint (`--fingerprint`).
  GpgCmd fingerprint() => token('--fingerprint');

  /// Generates a new key pair (`--gen-key`, `--generate-key`). Interactive unless [batch] drives it from a parameter file.
  GpgCmd genKey() => token('--gen-key');

  /// Generates a revocation certificate for the whole key (`--gen-revoke`, `--generate-revocation`).
  GpgCmd genRevoke() => token('--gen-revoke');

  /// Opens the interactive key-management menu (`--edit-key`). Not for a script: nothing here a pipeline can drive.
  GpgCmd editKey() => token('--edit-key');

  /// Removes a key from the public keyring (`--delete-key`).
  GpgCmd deleteKey() => token('--delete-key');

  /// Removes a key from both the secret and public keyring (`--delete-secret-key`).
  GpgCmd deleteSecretKey() => token('--delete-secret-key');

  /// Exports keys from the keyrings to stdout (`--export`).
  GpgCmd export() => token('--export');

  /// Imports or merges keys from a file into the keyring (`--import`).
  GpgCmd import() => token('--import');

  /// Sends keys to a keyserver, the write side of [recvKeys] (`--send-keys`).
  GpgCmd sendKeys() => token('--send-keys');

  /// Imports keys with the given ids from a keyserver (`--recv-keys`).
  GpgCmd recvKeys() => token('--recv-keys');

  /// Searches a keyserver for keys matching a name (`--search-keys`). Interactive: presents a numbered menu.
  GpgCmd searchKeys() => token('--search-keys');

  /// Signs a public key with your own secret key, extending the web of trust (`--sign-key`).
  GpgCmd signKey() => token('--sign-key');

  /// The same as [signKey], but the resulting signature is marked non-exportable (`--lsign-key`).
  GpgCmd lsignKey() => token('--lsign-key');

  /// Requests updates from a keyserver for every key already on the local keyring (`--refresh-keys`).
  GpgCmd refreshKeys() => token('--refresh-keys');

  /// Runs trust database maintenance over every key (`--update-trustdb`).
  GpgCmd updateTrustdb() => token('--update-trustdb');

  /// The same, without prompting for user interaction (`--check-trustdb`).
  GpgCmd checkTrustdb() => token('--check-trustdb');

  /// Prints the ownertrust values of every key to stdout (`--export-ownertrust`).
  GpgCmd exportOwnertrust() => token('--export-ownertrust');

  /// Updates the trust database from ownertrust values stored in a file (`--import-ownertrust`).
  GpgCmd importOwnertrust() => token('--import-ownertrust');

  /// Prints the message digest of the chosen algorithm for the given files or stdin (`--print-md`).
  GpgCmd printMd(String algorithm) => pair('--print-md', algorithm);

  /// Opens the interactive smartcard menu (`--card-edit`).
  GpgCmd cardEdit() => token('--card-edit');

  /// Shows the contents of the inserted smartcard (`--card-status`).
  GpgCmd cardStatus() => token('--card-status');

  /// Opens the interactive menu to change a smartcard's PIN (`--change-pin`).
  GpgCmd changePin() => token('--change-pin');

  /// Locates the keys given as arguments, fetching them if [autoKeyLocate] allows it (`--locate-keys`).
  GpgCmd locateKeys() => token('--locate-keys');

  /// Lists the raw OpenPGP packet sequence of a file, for debugging (`--list-packets`).
  GpgCmd listPackets() => token('--list-packets');

  /// Wraps input into OpenPGP ASCII armor (`--enarmor`).
  GpgCmd enarmor() => token('--enarmor');

  /// Unwraps OpenPGP ASCII armor back to binary (`--dearmor`).
  GpgCmd dearmor() => token('--dearmor');

  /// Retrieves keys located at the given URIs (`--fetch-keys`).
  GpgCmd fetchKeys() => token('--fetch-keys');

  /// Prints the program version and licensing information (`--version`).
  GpgCmd version() => token('--version');

  /// Prints the usage summary (`-h`, `--help`).
  GpgCmd help() => token('--help');

  /// Prints warranty information (`--warranty`).
  GpgCmd warranty() => token('--warranty');

  /// Prints every available option and command (`--dump-options`).
  GpgCmd dumpOptions() => token('--dump-options');

  /// Produces ASCII-armored output instead of raw binary OpenPGP (`-a`, `--armor`).
  GpgCmd armor() => token('--armor');

  /// The user id to encrypt for (`-r`, `--recipient`). Repeatable.
  GpgCmd recipient(String userId) => pair('--recipient', userId);

  /// Encrypts for this user id, but hides whose key id it is in the output (`-R`, `--hidden-recipient`).
  GpgCmd hiddenRecipient(String userId) => pair('--hidden-recipient', userId);

  /// Writes output to this file instead of stdout (`-o`, `--output`).
  GpgCmd output_(String file) => pair('--output', file);

  /// The key to sign with, when more than one secret key is available (`-u`, `--local-user`).
  GpgCmd localUser(String keyId) => pair('--local-user', keyId);

  /// The default key to sign with, when [localUser] is not given (`--default-key`).
  GpgCmd defaultKey(String keyId) => pair('--default-key', keyId);

  /// The passphrase, given inline (`--passphrase`).
  ///
  /// Lands in argv, where `ps` can read it; prefer [passphraseFile] or [passphraseFd].
  GpgCmd passphrase(String value) => pair('--passphrase', value);

  /// Reads the passphrase from this file (`--passphrase-file`).
  ///
  /// The safe spelling for an unattended run.
  GpgCmd passphraseFile(String path) => pair('--passphrase-file', path);

  /// Reads the passphrase from this open file descriptor (`--passphrase-fd`).
  GpgCmd passphraseFd(int fd) => pair('--passphrase-fd', '$fd');

  /// How many times gpg asks for a new passphrase to be repeated, when generating one (`--passphrase-repeat`).
  GpgCmd passphraseRepeat(int count) => pair('--passphrase-repeat', '$count');

  /// Runs in batch mode: never prompts, refuses anything that would need to (`--batch`).
  ///
  /// Pairs with [yes]; together they are what stop a run from ever blocking on a terminal that is not there.
  GpgCmd batch() => token('--batch');

  /// Turns [batch] back off (`--no-batch`).
  GpgCmd noBatch() => token('--no-batch');

  /// Assumes "yes" on most confirmation prompts (`--yes`).
  GpgCmd yes() => token('--yes');

  /// Assumes "no" on most confirmation prompts (`--no`).
  GpgCmd no() => token('--no');

  /// Keeps output as quiet as possible (`-q`, `--quiet`).
  GpgCmd quiet() => token('--quiet');

  /// Talks more about what it is doing (`-v`, `--verbose`). Repeatable, each use adding detail.
  GpgCmd verbose() => token('--verbose');

  /// Resets verbosity back to its default level (`--no-verbose`).
  GpgCmd noVerbose() => token('--no-verbose');

  /// Ensures the TTY is never used for prompts or status output (`--no-tty`).
  GpgCmd noTty() => token('--no-tty');

  /// The GnuPG home directory to use instead of `~/.gnupg` (`--homedir`).
  ///
  /// What a CI runner wants its own, disposable copy of, rather than sharing keyring state across builds.
  GpgCmd homedir(String dir) => pair('--homedir', dir);

  /// The keyserver to use for key operations (`--keyserver`).
  GpgCmd keyserver(String value) => pair('--keyserver', value);

  /// Options passed to the keyserver helper, `timeout=10` and the like (`--keyserver-options`).
  GpgCmd keyserverOptions(String value) => pair('--keyserver-options', value);

  /// How gpg automatically locates and retrieves keys it does not already have (`--auto-key-locate`).
  GpgCmd autoKeyLocate(String mechanisms) => pair('--auto-key-locate', mechanisms);

  /// Disables [autoKeyLocate] (`--no-auto-key-locate`).
  GpgCmd noAutoKeyLocate() => token('--no-auto-key-locate');

  /// The trust model to use: `pgp`, `classic`, `direct`, `always` or `auto` (`--trust-model`).
  GpgCmd trustModel(String model) => pair('--trust-model', model);

  /// Prints key listings in a stable, colon-delimited machine format (`--with-colons`).
  ///
  /// What a script parses; the human-readable listing's layout is not a contract.
  GpgCmd withColons() => token('--with-colons');

  /// Adds the fingerprint to the output of another listing command (`--with-fingerprint`).
  GpgCmd withFingerprint() => token('--with-fingerprint');

  /// The same as [recipient], meant for an options file rather than the command line (`--encrypt-to`).
  GpgCmd encryptTo(String userId) => pair('--encrypt-to', userId);

  /// The same as [hiddenRecipient], for an options file (`--hidden-encrypt-to`).
  GpgCmd hiddenEncryptTo(String userId) => pair('--hidden-encrypt-to', userId);

  /// Disables every [encryptTo] and [hiddenEncryptTo] configured elsewhere (`--no-encrypt-to`).
  GpgCmd noEncryptTo() => token('--no-encrypt-to');

  /// Defines a named group of recipients, an alias expanded wherever it is used (`--group`).
  GpgCmd group(String value) => pair('--group', value);

  /// The symmetric cipher algorithm to use (`--cipher-algo`).
  GpgCmd cipherAlgo(String name) => pair('--cipher-algo', name);

  /// The message digest algorithm to use (`--digest-algo`).
  GpgCmd digestAlgo(String name) => pair('--digest-algo', name);

  /// The compression algorithm to use (`--compress-algo`).
  GpgCmd compressAlgo(String name) => pair('--compress-algo', name);

  /// The digest algorithm used when certifying a key, distinct from [digestAlgo] (`--cert-digest-algo`).
  GpgCmd certDigestAlgo(String name) => pair('--cert-digest-algo', name);

  /// The default expiration for a data signature, `0` for none (`--default-sig-expire`).
  GpgCmd defaultSigExpire(String value) => pair('--default-sig-expire', value);

  /// The default expiration for a key certification signature (`--default-cert-expire`).
  GpgCmd defaultCertExpire(String value) => pair('--default-cert-expire', value);

  /// The default certification level used when [signKey] is not given one interactively (`--default-cert-level`).
  GpgCmd defaultCertLevel(int level) => pair('--default-cert-level', '$level');

  /// Treats any signature below this certification level as invalid (`--min-cert-level`).
  GpgCmd minCertLevel(int level) => pair('--min-cert-level', '$level');

  /// A key trusted exactly as much as your own secret keys, bypassing the trust calculation (`--trusted-key`). Repeatable.
  GpgCmd trustedKey(String keyId) => pair('--trusted-key', keyId);

  /// Adds a file to the list of public keyrings consulted (`--keyring`). Repeatable.
  GpgCmd keyring(String file) => pair('--keyring', file);

  /// The same as [keyring], for a secret keyring (`--secret-keyring`).
  GpgCmd secretKeyring(String file) => pair('--secret-keyring', file);

  /// Designates this as the primary public keyring, where new keys are written (`--primary-keyring`).
  GpgCmd primaryKeyring(String file) => pair('--primary-keyring', file);

  /// The trust database file to use instead of the default (`--trustdb-name`).
  GpgCmd trustdbName(String file) => pair('--trustdb-name', file);

  /// Reads additional options from this file (`--options`).
  GpgCmd options(String file) => pair('--options', file);

  /// Reads no options file at all, the shortcut for `--options /dev/null` (`--no-options`).
  GpgCmd noOptions() => token('--no-options');

  /// Skips adding the default keyrings to the list gpg consults (`--no-default-keyring`).
  GpgCmd noDefaultKeyring() => token('--no-default-keyring');

  /// Treats input as text, normalising line endings to the OpenPGP canonical form (`-t`, `--textmode`).
  GpgCmd textmode() => token('--textmode');

  /// Turns [textmode] back off (`--no-textmode`).
  GpgCmd noTextmode() => token('--no-textmode');

  /// Forces the older v3 signature format on data signatures (`--force-v3-sigs`). Deprecated.
  GpgCmd forceV3Sigs() => token('--force-v3-sigs');

  /// Always uses v4 key certification signatures, even on a v3 key (`--force-v4-certs`).
  GpgCmd forceV4Certs() => token('--force-v4-certs');

  /// Forces encryption with a modification detection code, refusing to encrypt without one (`--force-mdc`).
  GpgCmd forceMdc() => token('--force-mdc');

  /// Disables MDC integrity protection outright (`--disable-mdc`). Not recommended.
  GpgCmd disableMdc() => token('--disable-mdc');

  /// Omits the recipient's key id from an encrypted message (`--throw-keyids`).
  ///
  /// The message still decrypts, at the cost of the recipient having to try every secret key to find the right one.
  GpgCmd throwKeyids() => token('--throw-keyids');

  /// A comment string embedded in clear text signatures (`--comment`).
  GpgCmd comment(String value) => pair('--comment', value);

  /// Suppresses every comment line in the output (`--no-comments`).
  GpgCmd noComments() => token('--no-comments');

  /// Forces the version string into ASCII-armored output (`--emit-version`).
  GpgCmd emitVersion() => token('--emit-version');

  /// Suppresses the version string in ASCII-armored output (`--no-emit-version`).
  GpgCmd noEmitVersion() => token('--no-emit-version');

  /// Attaches a `name=value` notation to a signature (`--sig-notation`, `--set-notation`). Repeatable.
  GpgCmd sigNotation(String value) => pair('--sig-notation', value);

  /// A policy URL embedded in a data signature (`--sig-policy-url`).
  GpgCmd sigPolicyUrl(String value) => pair('--sig-policy-url', value);

  /// A preferred keyserver URL embedded in a data signature (`--sig-keyserver-url`).
  GpgCmd sigKeyserverUrl(String value) => pair('--sig-keyserver-url', value);

  /// The filename to embed inside the encrypted or signed message (`--set-filename`).
  GpgCmd setFilename(String value) => pair('--set-filename', value);

  /// Marks the message "for your eyes only", suppressing the filename on decrypt (`--for-your-eyes-only`).
  GpgCmd forYourEyesOnly() => token('--for-your-eyes-only');

  /// Tries to recreate a file with the name embedded in the message, on decrypt (`--use-embedded-filename`).
  ///
  /// Trusts the sender's own filename; leave off unless the source is trusted.
  GpgCmd useEmbeddedFilename() => token('--use-embedded-filename');

  /// Caps the number of bytes gpg will write while processing one file (`--max-output`).
  ///
  /// A safety limit against a maliciously crafted decompression bomb.
  GpgCmd maxOutput(String bytes) => pair('--max-output', bytes);

  /// A comma-delimited list of options controlling [import] (`--import-options`).
  GpgCmd importOptions(String value) => pair('--import-options', value);

  /// A comma-delimited list of options controlling [export] (`--export-options`).
  GpgCmd exportOptions(String value) => pair('--export-options', value);

  /// A comma-delimited list of options controlling key listings (`--list-options`).
  GpgCmd listOptions(String value) => pair('--list-options', value);

  /// A comma-delimited list of options controlling [verify] (`--verify-options`).
  GpgCmd verifyOptions(String value) => pair('--verify-options', value);

  /// How a key id is displayed: `none`, `short`, `long`, `0xshort` or `0xlong` (`--keyid-format`).
  GpgCmd keyidFormat(String value) => pair('--keyid-format', value);

  /// The character set command-line arguments are read in (`--display-charset`).
  GpgCmd displayCharset(String value) => pair('--display-charset', value);

  /// Assumes command-line arguments are already UTF-8 (`--utf8-strings`).
  GpgCmd utf8Strings() => token('--utf8-strings');

  /// Requires cross-certification of a signing subkey before trusting it (`--require-cross-certification`).
  GpgCmd requireCrossCertification() => token('--require-cross-certification');

  /// Disables the [requireCrossCertification] check (`--no-require-cross-certification`).
  GpgCmd noRequireCrossCertification() => token('--no-require-cross-certification');

  /// Allows relaxed or potentially incompatible operations a normal run refuses (`--expert`).
  GpgCmd expert() => token('--expert');

  /// Reads user input from this file descriptor instead of a terminal, for a driving process (`--command-fd`).
  GpgCmd commandFd(int fd) => pair('--command-fd', '$fd');

  /// Writes machine-readable status lines to this file descriptor (`--status-fd`).
  ///
  /// The reliable way for a wrapping process to track exactly what gpg did, rather than scraping human output.
  GpgCmd statusFd(int fd) => pair('--status-fd', '$fd');

  /// The same, to a file instead of a descriptor (`--status-file`).
  GpgCmd statusFile(String path) => pair('--status-file', path);

  /// Writes log output to this file descriptor (`--logger-fd`).
  GpgCmd loggerFd(int fd) => pair('--logger-fd', '$fd');

  /// The same, to a file instead of a descriptor (`--log-file`, `--logger-file`).
  GpgCmd logFile(String path) => pair('--log-file', path);

  /// Prompts before overwriting an existing output file (`-i`, `--interactive`). Not for a script.
  GpgCmd interactive() => token('--interactive');

  /// Makes no changes at all, for rehearsing an operation (`-n`, `--dry-run`).
  GpgCmd dryRun() => token('--dry-run');

  /// Skips the actual decryption for certain commands, checking only what they would have done (`--list-only`).
  GpgCmd listOnly() => token('--list-only');

  /// Enables reading input piped from several OpenPGP messages concatenated in one file (`--allow-multiple-messages`).
  GpgCmd allowMultipleMessages() => token('--allow-multiple-messages');

  /// Suppresses the copyright banner gpg prints at startup (`--no-greeting`).
  GpgCmd noGreeting() => token('--no-greeting');

  /// Suppresses the warning about running without secure memory (`--no-secmem-warning`).
  GpgCmd noSecmemWarning() => token('--no-secmem-warning');

  /// Suppresses the warning about unsafe file or directory permissions (`--no-permission-warning`).
  GpgCmd noPermissionWarning() => token('--no-permission-warning');

  /// Suppresses the warning about a missing modification detection code (`--no-mdc-warning`).
  GpgCmd noMdcWarning() => token('--no-mdc-warning');

  /// Displays the session key used for one message, alongside decrypting it (`--show-session-key`).
  GpgCmd showSessionKey() => token('--show-session-key');

  /// Decrypts using this session key instead of the recipient's secret key (`--override-session-key`).
  GpgCmd overrideSessionKey(String value) => pair('--override-session-key', value);

  /// Adds a bare positional argument: a key id, a user id, a filename, whatever the command ahead of it expects next.
  GpgCmd arg(String value) => token(value);

  /// A file to operate on. Repeatable; `-` reads stdin.
  GpgCmd file(String path) => token(path);
}

/// `gpg`, ready to take its first command.
// ignore: non_constant_identifier_names
GpgCmd get Gpg => GpgCmd();
