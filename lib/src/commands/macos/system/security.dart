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

/// `security`, the command-line front end to the macOS Keychain, shipped at
/// `/usr/bin/security` on every Mac. Nothing to install, and nothing like it
/// elsewhere: this is the macOS branch of `Keyring`, with `secret-tool` on Linux
/// and DPAPI through PowerShell on Windows.
///
/// ```dart
/// final ShellResult stored = await Security
///     .findGenericPassword()
///     .account('keystore')
///     .service('koko-cli')
///     .passwordOnly()
///     .output();
/// ```
///
/// Two habits worth keeping. [passwordOnly] prints the secret and nothing else,
/// which is what a script wants; plain [showPassword] buries it in the attribute
/// dump. And an `add-generic-password` without [updateIfExists] fails outright when
/// the item is already there rather than replacing it.
///
/// The subcommand comes first, then its options. `security` is old enough that the
/// flag letters are reused across subcommands with different meanings (`-p` is a
/// password here and a path there), so read the summary of the one you are calling
/// (`security help`, or `security <subcommand> -h`) before reaching for a letter.
class SecurityCmd extends CommandBuilder<SecurityCmd> {
  @override
  final String executable = 'security';

  /// Runs the interactive prompt (`-i`). Not for a script.
  SecurityCmd interactive() => token('-i');

  /// Talks more, before the subcommand (`-v`).
  SecurityCmd verboseGlobal() => token('-v');

  /// Talks less, before the subcommand (`-q`).
  SecurityCmd quiet() => token('-q');

  /// Lists the subcommands, or explains the one named after it (`help`).
  SecurityCmd help() => token('help');

  /// Shows the keychain search list, or rewrites it (`list-keychains`).
  SecurityCmd listKeychains() => token('list-keychains');

  /// Lists the smartcards the system can see (`list-smartcards`).
  SecurityCmd listSmartcards() => token('list-smartcards');

  /// Shows or sets the default keychain (`default-keychain`).
  SecurityCmd defaultKeychain() => token('default-keychain');

  /// Shows or sets the login keychain (`login-keychain`).
  SecurityCmd loginKeychain() => token('login-keychain');

  /// Creates a keychain and adds it to the search list (`create-keychain`).
  SecurityCmd createKeychain() => token('create-keychain');

  /// Deletes a keychain and drops it from the search list (`delete-keychain`).
  SecurityCmd deleteKeychain() => token('delete-keychain');

  /// Locks a keychain (`lock-keychain`).
  SecurityCmd lockKeychain() => token('lock-keychain');

  /// Unlocks a keychain (`unlock-keychain`).
  SecurityCmd unlockKeychain() => token('unlock-keychain');

  /// Sets a keychain's lock timeout and sleep behaviour (`set-keychain-settings`).
  SecurityCmd setKeychainSettings() => token('set-keychain-settings');

  /// Changes a keychain's password (`set-keychain-password`).
  SecurityCmd setKeychainPassword() => token('set-keychain-password');

  /// Prints a keychain's settings (`show-keychain-info`).
  SecurityCmd showKeychainInfo() => token('show-keychain-info');

  /// Dumps a keychain's contents (`dump-keychain`).
  SecurityCmd dumpKeychain() => token('dump-keychain');

  /// Creates an asymmetric key pair (`create-keypair`).
  SecurityCmd createKeypair() => token('create-keypair');

  /// Stores a generic password item (`add-generic-password`).
  ///
  /// Fails on an existing item unless [updateIfExists] is set.
  SecurityCmd addGenericPassword() => token('add-generic-password');

  /// Stores an internet password item (`add-internet-password`).
  SecurityCmd addInternetPassword() => token('add-internet-password');

  /// Imports certificates into a keychain (`add-certificates`).
  SecurityCmd addCertificates() => token('add-certificates');

  /// Looks a generic password item up (`find-generic-password`).
  SecurityCmd findGenericPassword() => token('find-generic-password');

  /// Removes a generic password item (`delete-generic-password`).
  SecurityCmd deleteGenericPassword() => token('delete-generic-password');

  /// Rewrites the partition list of a generic password item (`set-generic-password-partition-list`).
  ///
  /// The knob that decides which signed applications may read the item without a prompt.
  SecurityCmd setGenericPasswordPartitionList() => token('set-generic-password-partition-list');

  /// Looks an internet password item up (`find-internet-password`).
  SecurityCmd findInternetPassword() => token('find-internet-password');

  /// Removes an internet password item (`delete-internet-password`).
  SecurityCmd deleteInternetPassword() => token('delete-internet-password');

  /// Rewrites the partition list of an internet password item (`set-internet-password-partition-list`).
  SecurityCmd setInternetPasswordPartitionList() => token('set-internet-password-partition-list');

  /// Finds keys in a keychain (`find-key`).
  SecurityCmd findKey() => token('find-key');

  /// Rewrites the partition list of a key (`set-key-partition-list`).
  SecurityCmd setKeyPartitionList() => token('set-key-partition-list');

  /// Finds a certificate (`find-certificate`).
  SecurityCmd findCertificate() => token('find-certificate');

  /// Finds an identity, so a certificate with its private key (`find-identity`).
  SecurityCmd findIdentity() => token('find-identity');

  /// Removes a certificate (`delete-certificate`).
  SecurityCmd deleteCertificate() => token('delete-certificate');

  /// Removes an identity (`delete-identity`).
  SecurityCmd deleteIdentity() => token('delete-identity');

  /// Pins the identity to use for a service (`set-identity-preference`).
  SecurityCmd setIdentityPreference() => token('set-identity-preference');

  /// Reads back what [setIdentityPreference] pinned (`get-identity-preference`).
  SecurityCmd getIdentityPreference() => token('get-identity-preference');

  /// Creates a database through the DL layer (`create-db`).
  SecurityCmd createDb() => token('create-db');

  /// Exports items out of a keychain (`export`).
  SecurityCmd exportItems() => token('export');

  /// Imports items into a keychain (`import`).
  SecurityCmd importItems() => token('import');

  /// Exports items off a smartcard (`export-smartcard`).
  SecurityCmd exportSmartcard() => token('export-smartcard');

  /// Encodes or decodes a CMS message (`cms`).
  SecurityCmd cms() => token('cms');

  /// Installs, or reinstalls, the MDS database (`install-mds`).
  SecurityCmd installMds() => token('install-mds');

  /// Trusts a certificate (`add-trusted-cert`).
  SecurityCmd addTrustedCert() => token('add-trusted-cert');

  /// Stops trusting a certificate (`remove-trusted-cert`).
  SecurityCmd removeTrustedCert() => token('remove-trusted-cert');

  /// Prints the trust settings (`dump-trust-settings`).
  SecurityCmd dumpTrustSettings() => token('dump-trust-settings');

  /// Shows or flips the user-level trust settings (`user-trust-settings-enable`).
  SecurityCmd userTrustSettingsEnable() => token('user-trust-settings-enable');

  /// Exports the trust settings (`trust-settings-export`).
  SecurityCmd trustSettingsExport() => token('trust-settings-export');

  /// Imports trust settings (`trust-settings-import`).
  SecurityCmd trustSettingsImport() => token('trust-settings-import');

  /// Verifies a certificate (`verify-cert`).
  SecurityCmd verifyCert() => token('verify-cert');

  /// Runs an authorization operation (`authorize`).
  SecurityCmd authorize() => token('authorize');

  /// Edits the authorization policy database (`authorizationdb`).
  SecurityCmd authorizationdb() => token('authorizationdb');

  /// Runs a tool with privileges (`execute-with-privileges`).
  SecurityCmd executeWithPrivileges() => token('execute-with-privileges');

  /// Runs `/usr/bin/leaks` against this process (`leaks`).
  SecurityCmd leaks() => token('leaks');

  /// Explains an OSStatus error code in words (`error`). Genuinely useful when one turns up.
  SecurityCmd error() => token('error');

  /// Creates a FileVault recovery keychain (`create-filevaultmaster-keychain`).
  SecurityCmd createFilevaultmasterKeychain() => token('create-filevaultmaster-keychain');

  /// Enables, disables or lists the disabled smartcard tokens (`smartcards`).
  SecurityCmd smartcards() => token('smartcards');

  /// Says whether a path would be translocated (`translocate-policy-check`).
  SecurityCmd translocatePolicyCheck() => token('translocate-policy-check');

  /// Says whether a path is translocated (`translocate-status-check`).
  SecurityCmd translocateStatusCheck() => token('translocate-status-check');

  /// Resolves a translocated path back to the original (`translocate-original-path`).
  SecurityCmd translocateOriginalPath() => token('translocate-original-path');

  /// Evaluates a code requirement against a certificate chain (`requirement-evaluate`).
  SecurityCmd requirementEvaluate() => token('requirement-evaluate');

  /// Reads and writes FileVault settings and overrides (`filevault`).
  SecurityCmd filevault() => token('filevault');

  /// Reads and writes Platform SSO settings and overrides (`platformsso`).
  SecurityCmd platformsso() => token('platformsso');

  /// Matches, or sets, the account name (`-a`). Required by `add-generic-password`.
  SecurityCmd account(String value) => pair('-a', value);

  /// Matches, or sets, the creator, a four-character code (`-c`).
  SecurityCmd creator(String value) => pair('-c', value);

  /// Matches, or sets, the item type, a four-character code (`-C`).
  SecurityCmd itemType(String value) => pair('-C', value);

  /// Matches, or sets, the kind (`-D`). Defaults to `application password`.
  SecurityCmd kind(String value) => pair('-D', value);

  /// Matches, or sets, the generic attribute (`-G`).
  SecurityCmd genericAttribute(String value) => pair('-G', value);

  /// Matches, or sets, the comment (`-j`).
  SecurityCmd comment(String value) => pair('-j', value);

  /// Matches, or sets, the label (`-l`). Falls back to the service name.
  SecurityCmd label(String value) => pair('-l', value);

  /// Matches, or sets, the service name (`-s`). Required by `add-generic-password`.
  SecurityCmd service(String value) => pair('-s', value);

  /// The server of an internet password item (`-s`), the same letter in another subcommand.
  SecurityCmd server(String value) => pair('-s', value);

  /// The security domain of an internet password item (`-d`).
  SecurityCmd securityDomain(String value) => pair('-d', value);

  /// The path of an internet password item (`-p`).
  SecurityCmd path(String value) => pair('-p', value);

  /// The port of an internet password item (`-P`).
  SecurityCmd port(String value) => pair('-P', value);

  /// The protocol of an internet password item (`-r`).
  SecurityCmd protocol(String value) => pair('-r', value);

  /// The authentication type of an internet password item (`-t`).
  SecurityCmd authenticationType(String value) => pair('-t', value);

  /// Adds the password to the attribute dump (`-g`).
  ///
  /// It goes to stderr, mixed in with the rest; [passwordOnly] is what a script wants.
  SecurityCmd showPassword() => token('-g');

  /// Prints the password alone, on stdout, nothing else (`-w`).
  SecurityCmd passwordOnly() => token('-w');

  /// The password to store (`-w` with a value).
  ///
  /// It lands in the process arguments, where anyone running `ps` can read it. Unavoidable with this tool: `security` has no stdin path, unlike `secret-tool`.
  SecurityCmd withPassword(String value) => pair('-w', value);

  /// The password to store, as a hex string (`-X`).
  SecurityCmd passwordHex(String value) => pair('-X', value);

  /// Lets any application read the item without a prompt (`-A`). Rarely a good idea.
  SecurityCmd allowAnyApplication() => token('-A');

  /// Lets this application read the item without a prompt (`-T`). Repeatable.
  ///
  /// An empty path removes the default trust granted to the creating application.
  SecurityCmd trustedApplication(String path) => pair('-T', path);

  /// Replaces the item when it is already there instead of failing (`-U`).
  SecurityCmd updateIfExists() => token('-U');

  /// The keychain to work in. Comes last; the search list is used when it is left out.
  SecurityCmd keychain(String path) => token(path);

  /// Adds a bare argument, for the subcommands this wrapper has no named option for.
  SecurityCmd arg(String value) => token(value);
}

/// `security`, ready to take its subcommand.
// ignore: non_constant_identifier_names
SecurityCmd get Security => SecurityCmd();
