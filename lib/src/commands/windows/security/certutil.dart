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

/// `certutil`, Microsoft's certificate-services command line — and,
/// unofficially, the base64/hex/hash utility every Windows admin reaches for
/// because it ships on every machine with nothing to install. Windows only.
///
/// ```dart
/// final ShellResult sum = await Certutil.hashFile().arg(path).arg('SHA256').output();
///
/// final ShellResult added = await Certutil
///     .addStore()
///     .force()
///     .arg('Root')
///     .arg('ca.cer')
///     .output();
/// ```
///
/// Microsoft's own documentation calls out that `certutil` "isn't recommended
/// for use in production code" and carries no compatibility guarantee; it is
/// an admin and diagnostic tool first.
///
/// **The full command has well over a hundred verbs**, because it doubles as
/// the administration surface for an actual Active Directory Certificate
/// Services role — schema, database backup/restore, enterprise templates,
/// smart cards, TPM attestation, Certificate Transparency logs, SMTP exit
/// module settings, and more. This wrapper names every verb (so [arg] is
/// never needed just to reach a verb this class doesn't know by name), but
/// only fleshes out real parameter methods for the verbs a general
/// automation script plausibly reaches for: encoding, hashing, and
/// certificate-store CRUD. For a CA-administration verb's own arguments —
/// [revoke]'s reason codes, [setExtension]'s `{Long|Date|String|@File}`
/// grammar, [repairStore]'s property INF — pass them positionally through
/// [arg], in the order `certutil <verb> -?` shows.
///
/// [addStore] and [delStore] write to a certificate store directly, and
/// there is no dry run; get the store name wrong ([store], `CA`, `Root`,
/// `TrustedPeople`, an LDAP path, …) and the certificate lands somewhere
/// unintended.
///
/// Every documented verb is named below, grouped to match Microsoft's own
/// reference page. Shared options that apply across most verbs: `-f`,
/// `-Silent`, `-v`, `-user`, `-split`, `-p`, `-csp`, `-config`,
/// `-Enterprise`, `-GroupPolicy`, `-dc`.
class CertutilCmd extends CommandBuilder<CertutilCmd> {
  @override
  final String executable = 'certutil';

  // --- Encoding, hashing and raw file inspection --------------------------

  /// Dumps configuration information, or a file's contents (`-dump`).
  CertutilCmd dump() => token('-dump');

  /// Dumps a PFX (`.pfx`/`.p12`) structure (`-dumpPFX`).
  CertutilCmd dumpPfx() => token('-dumpPFX');

  /// Parses and prints a file's ASN.1 structure: `.cer`, `.der` or PKCS #7
  /// (`-asn`).
  CertutilCmd asn() => token('-asn');

  /// Decodes a hexadecimal-encoded file (`-decodehex`). Takes `InFile`,
  /// `OutFile` and, optionally, a numeric decoding type through [arg].
  CertutilCmd decodeHex() => token('-decodehex');

  /// Encodes a file in hexadecimal (`-encodehex`). Takes `InFile`, `OutFile`
  /// and, optionally, a numeric encoding type through [arg].
  CertutilCmd encodeHex() => token('-encodehex');

  /// Decodes a Base64-encoded file (`-decode`). Takes `InFile` and `OutFile`
  /// through [arg].
  CertutilCmd decode() => token('-decode');

  /// Encodes a file to Base64 (`-encode`). Takes `InFile` and `OutFile`
  /// through [arg].
  CertutilCmd encode() => token('-encode');

  /// Hashes a file (`-hashfile`). Takes the path and, optionally, the
  /// algorithm (`MD5`, `SHA1`, `SHA256`, `SHA384`, `SHA512`) through [arg].
  CertutilCmd hashFile() => token('-hashfile');

  // --- Certificate stores ---------------------------------------------------

  /// Dumps a certificate store, or one matching certificate (`-store`).
  /// Takes `CertificateStoreName`, `CertId` and `OutputFile` through [arg].
  CertutilCmd store() => token('-store');

  /// Lists the certificate stores (`-enumstore`).
  CertutilCmd enumStore() => token('-enumstore');

  /// Adds a certificate or CRL to a store (`-addstore`). Takes
  /// `CertificateStoreName` and `InFile` through [arg].
  CertutilCmd addStore() => token('-addstore');

  /// Removes a certificate or CRL from a store (`-delstore`). Takes
  /// `CertificateStoreName` and `CertId` through [arg].
  CertutilCmd delStore() => token('-delstore');

  /// Verifies a certificate already in a store (`-verifystore`).
  CertutilCmd verifyStore() => token('-verifystore');

  /// Repairs a key association, or a certificate's stored properties or key
  /// security descriptor (`-repairstore`).
  CertutilCmd repairStore() => token('-repairstore');

  /// Dumps a store the same way [store] does (`-viewstore`).
  CertutilCmd viewStore() => token('-viewstore');

  /// Dumps a store and deletes what it shows (`-viewdelstore`).
  CertutilCmd viewDelStore() => token('-viewdelstore');

  /// The certificate store to act on: `My`, `CA`, `Root`, `TrustedPeople`,
  /// an `ldap:///…` path, or similar. First positional argument for the
  /// store verbs above.
  CertutilCmd storeName(String name) => token(name);

  /// A certificate/CRL match token: serial number, SHA-1 thumbprint, numeric
  /// index, subject common name, e-mail, UPN, template name, and more.
  CertutilCmd certId(String value) => token(value);

  // --- Certificate and key inspection ---------------------------------------

  /// Displays a certificate, serial number or hash's revocation and validity
  /// disposition (`-isvalid`).
  CertutilCmd isValid() => token('-isvalid');

  /// Verifies a certificate, chain, CRL or CTL (`-verify`).
  CertutilCmd verify() => token('-verify');

  /// Verifies a Certificate Trust List (`-verifyCTL`).
  CertutilCmd verifyCtl() => token('-verifyCTL');

  /// Verifies the key pairs in a store or file match (`-verifykeys`).
  CertutilCmd verifyKeys() => token('-verifykeys');

  /// Exports a certificate and its private key to a PFX file (`-exportPFX`).
  CertutilCmd exportPfx() => token('-exportPFX');

  /// Imports a PFX file into a store (`-importPFX`).
  CertutilCmd importPfx() => token('-importPFX');

  /// Merges the newer of two PFX files' contents (`-mergePFX`).
  CertutilCmd mergePfx() => token('-mergePFX');

  /// Imports a plain certificate file into a store (`-ImportCert`).
  CertutilCmd importCert() => token('-ImportCert');

  /// Lists or deletes a private key by container name (`-key`).
  CertutilCmd key() => token('-key');

  /// Deletes a private key by container name (`-delkey`).
  CertutilCmd delKey() => token('-delkey');

  /// Deletes a Windows Hello container (`-DeleteHelloContainer`).
  CertutilCmd deleteHelloContainer() => token('-DeleteHelloContainer');

  /// Recovers an archived private key from a CA database (`-RecoverKey`).
  CertutilCmd recoverKey() => token('-RecoverKey');

  /// Retrieves a certificate through Key Based Renewal (`-GetKey`).
  CertutilCmd getKey() => token('-GetKey');

  /// Imports a KMS-recovered key (`-importKMS`).
  CertutilCmd importKms() => token('-importKMS');

  // --- Connectivity and cache -----------------------------------------------

  /// Pings a CA, checking that it answers RPC requests (`-ping`).
  CertutilCmd ping() => token('-ping');

  /// Pings a CA's administrative RPC interface (`-pingadmin`).
  CertutilCmd pingAdmin() => token('-pingadmin');

  /// Lists, or fetches, an object's URLs — AIA, CDP and OCSP among them
  /// (`-URL`).
  CertutilCmd url() => token('-URL');

  /// Lists or flushes the cross-certificate, CRL and OCSP URL cache
  /// (`-URLCache`).
  CertutilCmd urlCache() => token('-URLCache');

  /// Downloads and prints an OCSP response for a certificate (`-downloadOcsp`).
  CertutilCmd downloadOcsp() => token('-downloadOcsp');

  /// Flushes cached CRLs and certificates (`-flushCache`).
  CertutilCmd flushCache() => token('-flushCache');

  /// Synchronizes root and disallowed certificates with Windows Update
  /// (`-syncWithWU`).
  CertutilCmd syncWithWindowsUpdate() => token('-syncWithWU');

  /// Generates a self-contained Certificate Trust List from the current
  /// Windows Update root list (`-generateSSTFromWU`).
  CertutilCmd generateSstFromWindowsUpdate() => token('-generateSSTFromWU');

  /// Generates a Certificate Trust List of public-key-pinning rules
  /// (`-generatePinRulesCTL`).
  CertutilCmd generatePinRulesCtl() => token('-generatePinRulesCTL');

  /// Generates an HTTP Public Key Pinning header for a certificate
  /// (`-generateHpkpHeader`).
  CertutilCmd generateHpkpHeader() => token('-generateHpkpHeader');

  // --- CA server administration (needs an installed AD CS role) ------------

  /// Denies a pending certificate request (`-deny`).
  CertutilCmd deny() => token('-deny');

  /// Resubmits a pending certificate request (`-resubmit`).
  CertutilCmd resubmit() => token('-resubmit');

  /// Sets attributes on a pending certificate request (`-setattributes`).
  CertutilCmd setAttributes() => token('-setattributes');

  /// Sets an extension on a pending certificate request (`-setextension`).
  CertutilCmd setExtension() => token('-setextension');

  /// Revokes an issued certificate (`-revoke`).
  CertutilCmd revoke() => token('-revoke');

  /// Prints the CA's configuration string(s) (`-getconfig`).
  CertutilCmd getConfig() => token('-getconfig');

  /// Prints the CA's configuration, a second form (`-getconfig2`).
  CertutilCmd getConfig2() => token('-getconfig2');

  /// Prints the CA's configuration, a third form (`-getconfig3`).
  CertutilCmd getConfig3() => token('-getconfig3');

  /// Prints general CA information (`-CAInfo`).
  CertutilCmd caInfo() => token('-CAInfo');

  /// Prints CA property information (`-CAPropInfo`).
  CertutilCmd caPropInfo() => token('-CAPropInfo');

  /// Retrieves the CA's own certificate (`-ca.cert`).
  CertutilCmd caCert() => token('-ca.cert');

  /// Retrieves the CA's certificate chain (`-ca.chain`).
  CertutilCmd caChain() => token('-ca.chain');

  /// Retrieves the current CRL (`-GetCRL`).
  CertutilCmd getCrl() => token('-GetCRL');

  /// Publishes or republishes a CRL (`-CRL`).
  CertutilCmd crl() => token('-CRL');

  /// Shuts the CA service down (`-shutdown`).
  CertutilCmd caShutdown() => token('-shutdown');

  /// Installs a CA certificate or chain (`-installCert`).
  CertutilCmd installCert() => token('-installCert');

  /// Renews the CA's own certificate (`-renewCert`).
  CertutilCmd renewCert() => token('-renewCert');

  /// Prints or updates the CA database schema (`-schema`).
  CertutilCmd schema() => token('-schema');

  /// Views rows in the CA database (`-view`).
  CertutilCmd view() => token('-view');

  /// Prints raw CA database column names (`-db`).
  CertutilCmd db() => token('-db');

  /// Deletes a row from the CA database (`-deleterow`).
  CertutilCmd deleteRow() => token('-deleterow');

  /// Backs the CA up (`-backup`).
  CertutilCmd backup() => token('-backup');

  /// Backs up only the CA database (`-backupDB`).
  CertutilCmd backupDb() => token('-backupDB');

  /// Backs up only the CA's private key and certificate (`-backupkey`).
  CertutilCmd backupKey() => token('-backupkey');

  /// Restores a CA backup (`-restore`).
  CertutilCmd restore() => token('-restore');

  /// Restores only the CA database (`-restoredb`).
  CertutilCmd restoreDb() => token('-restoredb');

  /// Restores only the CA's private key and certificate (`-restorekey`).
  CertutilCmd restoreKey() => token('-restorekey');

  /// Lists the CA database's dynamic file names, for backup tooling
  /// (`-dynamicfilelist`).
  CertutilCmd dynamicFileList() => token('-dynamicfilelist');

  /// Prints the CA database's file locations (`-databaselocations`).
  CertutilCmd databaseLocations() => token('-databaselocations');

  // --- Directory service and enterprise templates ---------------------------

  /// Operates on directory-service certificate objects (`-ds`).
  CertutilCmd ds() => token('-ds');

  /// Deletes a directory-service object (`-dsDel`).
  CertutilCmd dsDel() => token('-dsDel');

  /// Publishes to the directory service (`-dsPublish`).
  CertutilCmd dsPublish() => token('-dsPublish');

  /// Prints a CA's directory-service certificate object (`-dsCert`).
  CertutilCmd dsCert() => token('-dsCert');

  /// Prints a CA's directory-service CRL object (`-dsCRL`).
  CertutilCmd dsCrl() => token('-dsCRL');

  /// Prints a CA's directory-service delta-CRL object (`-dsDeltaCRL`).
  CertutilCmd dsDeltaCrl() => token('-dsDeltaCRL');

  /// Prints a directory-service certificate template object (`-dsTemplate`).
  CertutilCmd dsTemplate() => token('-dsTemplate');

  /// Adds a certificate template to the directory service (`-dsAddTemplate`).
  CertutilCmd dsAddTemplate() => token('-dsAddTemplate');

  /// Prints Active Directory template information (`-ADTemplate`).
  CertutilCmd adTemplate() => token('-ADTemplate');

  /// Prints or edits a local certificate template cache entry (`-Template`).
  CertutilCmd template() => token('-Template');

  /// Lists the CAs offering a template (`-TemplateCAs`).
  CertutilCmd templateCas() => token('-TemplateCAs');

  /// Lists the templates a CA offers (`-CATemplates`).
  CertutilCmd caTemplates() => token('-CATemplates');

  /// Sets the templates a CA offers (`-SetCATemplates`).
  CertutilCmd setCaTemplates() => token('-SetCATemplates');

  /// Sets a CA's AD sites (`-SetCASites`).
  CertutilCmd setCaSites() => token('-SetCASites');

  /// Prints or sets a CA's enrollment-server URL (`-enrollmentServerURL`).
  CertutilCmd enrollmentServerUrl() => token('-enrollmentServerURL');

  /// Adds a certificate-enrollment server (`-addEnrollmentServer`).
  CertutilCmd addEnrollmentServer() => token('-addEnrollmentServer');

  /// Removes one (`-deleteEnrollmentServer`).
  CertutilCmd deleteEnrollmentServer() => token('-deleteEnrollmentServer');

  /// Adds a certificate-enrollment policy server (`-addPolicyServer`).
  CertutilCmd addPolicyServer() => token('-addPolicyServer');

  /// Removes one (`-deletePolicyServer`).
  CertutilCmd deletePolicyServer() => token('-deletePolicyServer');

  /// Lists AD CA objects (`-ADCA`).
  CertutilCmd adCa() => token('-ADCA');

  /// Lists CA objects (`-CA`).
  CertutilCmd ca() => token('-CA');

  /// Prints or edits enterprise policy settings (`-Policy`).
  CertutilCmd policy() => token('-Policy');

  /// Prints or clears the local policy cache (`-PolicyCache`).
  CertutilCmd policyCache() => token('-PolicyCache');

  /// Lists or edits cached enrollment credentials (`-CredStore`).
  CertutilCmd credStore() => token('-CredStore');

  /// Installs the default certificate templates (`-InstallDefaultTemplates`).
  CertutilCmd installDefaultTemplates() => token('-InstallDefaultTemplates');

  // --- Smart cards, TPM and Windows Hello ------------------------------------

  /// Shows the certutil UI test dialog (`-UI`).
  CertutilCmd ui() => token('-UI');

  /// Prints TPM information (`-TPMInfo`).
  CertutilCmd tpmInfo() => token('-TPMInfo');

  /// Performs TPM key attestation (`-attest`).
  CertutilCmd attest() => token('-attest');

  /// Retrieves a certificate for the current user or machine (`-getcert`).
  CertutilCmd getCert() => token('-getcert');

  /// Prints information about the local machine's CSPs and stores
  /// (`-MachineInfo`).
  CertutilCmd machineInfo() => token('-MachineInfo');

  /// Prints domain controller information (`-DCInfo`).
  CertutilCmd dcInfo() => token('-DCInfo');

  /// Prints enterprise information (`-EntInfo`).
  CertutilCmd entInfo() => token('-EntInfo');

  /// Prints trusted CA information (`-TCAInfo`).
  CertutilCmd tcaInfo() => token('-TCAInfo');

  /// Prints smart card reader and card information (`-SCInfo`).
  CertutilCmd scInfo() => token('-SCInfo');

  /// Lists a smart card's root certificates (`-SCRoots`).
  CertutilCmd scRoots() => token('-SCRoots');

  /// Sends a heartbeat pulse to a smart card (`-pulse`).
  CertutilCmd pulse() => token('-pulse');

  // --- Cryptographic providers and low-level signing -------------------------

  /// Adds a named elliptic curve (`-addEccCurve`).
  CertutilCmd addEccCurve() => token('-addEccCurve');

  /// Removes one (`-deleteEccCurve`).
  CertutilCmd deleteEccCurve() => token('-deleteEccCurve');

  /// Prints a named elliptic curve's parameters (`-displayEccCurve`).
  CertutilCmd displayEccCurve() => token('-displayEccCurve');

  /// Lists the installed Cryptographic Service Providers (`-csplist`).
  CertutilCmd cspList() => token('-csplist');

  /// Exercises a CSP with a self-test (`-csptest`).
  CertutilCmd cspTest() => token('-csptest');

  /// Prints or edits CNG configuration (`-CNGConfig`).
  CertutilCmd cngConfig() => token('-CNGConfig');

  /// Signs a file or hash with a certificate (`-sign`).
  CertutilCmd sign() => token('-sign');

  /// Prints or sets the trusted-roots virtual root (`-vroot`).
  CertutilCmd vroot() => token('-vroot');

  /// Prints or sets the OCSP virtual root (`-vocsproot`).
  CertutilCmd vocsproot() => token('-vocsproot');

  /// Prints or edits a certificate class mapping (`-Class`).
  CertutilCmd caClass() => token('-Class');

  /// Displays a PKCS #7 file's contents (`-7f`).
  CertutilCmd pkcs7() => token('-7f');

  /// Looks up an ObjectId by name or number (`-oid`).
  CertutilCmd oid() => token('-oid');

  /// Explains an error code in words (`-error`). Genuinely useful when one
  /// turns up.
  CertutilCmd error() => token('-error');

  // --- Exit-module SMTP settings and registry access -------------------------

  /// Prints the CA exit module's SMTP notification settings
  /// (`-getsmtpinfo`).
  CertutilCmd getSmtpInfo() => token('-getsmtpinfo');

  /// Sets them (`-setsmtpinfo`).
  CertutilCmd setSmtpInfo() => token('-setsmtpinfo');

  /// Prints a CA registry value (`-getreg`).
  CertutilCmd getReg() => token('-getreg');

  /// Sets one (`-setreg`).
  CertutilCmd setReg() => token('-setreg');

  /// Deletes one (`-delreg`).
  CertutilCmd delReg() => token('-delreg');

  // --- Certificate Transparency ----------------------------------------------

  /// Submits a certificate chain to a CT log (`-add-chain`).
  CertutilCmd ctAddChain() => token('-add-chain');

  /// Submits a pre-certificate chain (`-add-pre-chain`).
  CertutilCmd ctAddPreChain() => token('-add-pre-chain');

  /// Retrieves a CT log's signed tree head (`-get-sth`).
  CertutilCmd ctGetSth() => token('-get-sth');

  /// Retrieves a consistency proof between two tree heads
  /// (`-get-sth-consistency`).
  CertutilCmd ctGetSthConsistency() => token('-get-sth-consistency');

  /// Retrieves an audit proof for a leaf hash (`-get-proof-by-hash`).
  CertutilCmd ctGetProofByHash() => token('-get-proof-by-hash');

  /// Retrieves a range of log entries (`-get-entries`).
  CertutilCmd ctGetEntries() => token('-get-entries');

  /// Retrieves a CT log's accepted root certificates (`-get-roots`).
  CertutilCmd ctGetRoots() => token('-get-roots');

  /// Retrieves an entry and its audit proof together
  /// (`-get-entry-and-proof`).
  CertutilCmd ctGetEntryAndProof() => token('-get-entry-and-proof');

  /// Verifies a certificate's embedded CT proof (`-VerifyCT`).
  CertutilCmd verifyCt() => token('-VerifyCT');

  // --- Shared options ----------------------------------------------------

  /// Forces the operation, overwriting an existing output file or store
  /// entry without asking (`-f`).
  CertutilCmd force() => token('-f');

  /// Suppresses UI prompts (`-Silent`).
  CertutilCmd silent() => token('-Silent');

  /// Talks more; repeat for more detail, e.g. through repeated calls (`-v`).
  CertutilCmd verbose() => token('-v');

  /// Operates on the current user's store or context rather than the
  /// machine's (`-user`).
  CertutilCmd user() => token('-user');

  /// Operates on a machine enterprise store (`-Enterprise`).
  CertutilCmd enterprise() => token('-Enterprise');

  /// Operates on a machine group-policy store (`-GroupPolicy`).
  CertutilCmd groupPolicy() => token('-GroupPolicy');

  /// The domain controller to target (`-dc`).
  CertutilCmd domainController(String name) => pair('-dc', name);

  /// Splits multi-certificate output into separate files (`-split`).
  CertutilCmd split() => token('-split');

  /// The password for an operation that needs one, e.g. [dumpPfx] or
  /// [importPfx] (`-p`).
  CertutilCmd password(String value) => pair('-p', value);

  /// The Cryptographic Service Provider to use (`-csp`).
  CertutilCmd provider(String name) => pair('-csp', name);

  /// The CA to target, `Machine\\CAName`, for the CA-administration verbs
  /// (`-config`).
  CertutilCmd config(String value) => pair('-config', value);

  /// The operation timeout in seconds (`-t`).
  CertutilCmd timeout(String seconds) => pair('-t', seconds);

  /// Adds a bare positional argument, in the order the chosen verb's own
  /// `certutil <verb> -?` help expects it: a file path, store name,
  /// algorithm name, request id, or any other value not covered by a named
  /// method above.
  CertutilCmd arg(String value) => token(value);
}

/// `certutil`, ready to take its first option.
// ignore: non_constant_identifier_names
CertutilCmd get Certutil => CertutilCmd();
