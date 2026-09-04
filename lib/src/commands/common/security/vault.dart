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

/// `vault`, HashiCorp Vault's CLI: secrets storage, dynamic credentials and
/// encryption as a service, alongside [GpgCmd], [OpenSSLCmd] and [AgeCmd] in
/// this catalogue's `security/` family — the odd one out, since those three
/// operate on local files and Vault operates against a running server.
///
/// **This wrapper is a vocabulary, not a grammar**, the way [GhCmd] is for the
/// GitHub CLI: every subcommand is a method, and a flag shared across several
/// of them ([format], [namespace], [tlsSkipVerify]) is one method reused
/// wherever `vault` accepts it.
///
/// ```dart
/// final ShellResult secret = await Vault.kv().read().format('json').arg('secret/data/app').output();
///
/// await Vault.login().method('aws').execute();
/// ```
///
/// This wrapper only builds argv — it never reads, sets or clears
/// `VAULT_TOKEN` or any other credential. [address] and [namespace] are the
/// flag forms of `VAULT_ADDR`/`VAULT_NAMESPACE`; when a script already sets
/// those in the environment, [CommandBuilder.execute]'s `env` parameter is the
/// place, not a flag repeated on every call. [format]`('json')` is what makes
/// output worth parsing; the default `table` format is for a human.
class VaultCmd extends CommandBuilder<VaultCmd> {
  @override
  final String executable = 'vault';

  // Subcommands.

  /// Authenticates against Vault, storing the resulting token locally (`login`).
  VaultCmd login() => token('login');

  /// Reads a secret or configuration value — a generic `GET` (`read`).
  VaultCmd read() => token('read');

  /// Writes data — a generic `PUT`/`POST` (`write`).
  VaultCmd write() => token('write');

  /// Deletes a secret or configuration value (`delete`).
  VaultCmd delete() => token('delete');

  /// Lists the keys at a path (`list`).
  VaultCmd list() => token('list');

  /// Manages the KV secrets engine's convenience commands (`kv`).
  VaultCmd kv() => token('kv');

  /// Lists, enables, disables and tunes secrets engines (`secrets`).
  VaultCmd secrets() => token('secrets');

  /// Lists, enables, disables and tunes auth methods (`auth`).
  VaultCmd authCommand() => token('auth');

  /// Manages ACL policies (`policy`).
  VaultCmd policy() => token('policy');

  /// Manages tokens: create, lookup, renew, revoke (`token`).
  ///
  /// Named to avoid colliding with [CommandBuilder.token].
  VaultCmd tokenCommand() => token('token');

  /// Manages audit devices (`audit`).
  VaultCmd audit() => token('audit');

  /// Prints server health and seal status (`status`).
  VaultCmd status() => token('status');

  /// Runs server-operator tasks: seal, unseal, raft, rekey, generate-root, step-down (`operator`).
  VaultCmd operatorCommand() => token('operator');

  /// Starts a Vault server (`server`).
  VaultCmd server() => token('server');

  /// Works with the Transit secrets engine's encryption-as-a-service operations (`transit`).
  VaultCmd transit() => token('transit');

  /// Works with the Transform secrets engine's tokenization/FPE operations (`transform`).
  VaultCmd transform() => token('transform');

  /// Manages leases: lookup, renew, revoke (`lease`).
  VaultCmd lease() => token('lease');

  /// Manages namespaces on a Vault Enterprise cluster (`namespace`).
  VaultCmd namespaceCommand() => token('namespace');

  /// Establishes an SSH session through Vault's SSH secrets engine (`ssh`).
  VaultCmd sshCommand() => token('ssh');

  /// Works with the PKI secrets engine's certificate operations (`pki`).
  VaultCmd pki() => token('pki');

  /// Manages Vault plugins (`plugin`).
  VaultCmd plugin() => token('plugin');

  /// Integrates with HCP (HashiCorp Cloud Platform) (`hcp`).
  VaultCmd hcp() => token('hcp');

  /// Manages Vault Enterprise license (`license`).
  VaultCmd license() => token('license');

  /// Streams server telemetry/events for live monitoring (`monitor`).
  VaultCmd monitor() => token('monitor');

  /// Captures a debug bundle of server state for support (`debug`).
  VaultCmd debug() => token('debug');

  /// Subscribes to and prints Vault events (`events`).
  VaultCmd events() => token('events');

  /// Formats and prints structured data already on hand, without a server round-trip (`print`).
  VaultCmd printCommand() => token('print');

  /// Prints the help text for a Vault API path (`path-help`).
  VaultCmd pathHelp() => token('path-help');

  /// Prints the Vault version (`version`).
  VaultCmd version() => token('version');

  /// Prints detailed version history of the running server (`version-history`).
  VaultCmd versionHistory() => token('version-history');

  /// Starts a Vault Agent/Proxy process (`proxy`).
  VaultCmd proxy() => token('proxy');

  /// Attempts cluster recovery from an outage (`recover`).
  VaultCmd recover() => token('recover');

  /// Unwraps a wrapped response token into the value it wraps (`unwrap`).
  VaultCmd unwrap() => token('unwrap');

  // Common flags, shared across subcommands.

  /// The Vault server address; overrides `VAULT_ADDR` (`-address`).
  VaultCmd address(String url) => joined('-address', url);

  /// The Vault Agent address to talk to instead of the server directly (`-agent-address`).
  VaultCmd agentAddress(String url) => joined('-agent-address', url);

  /// A CA certificate file to verify the server's certificate with (`-ca-cert`).
  VaultCmd caCert(String path) => joined('-ca-cert', path);

  /// A directory of CA certificates to verify the server's certificate with (`-ca-path`).
  VaultCmd caPath(String path) => joined('-ca-path', path);

  /// A client certificate file for TLS client authentication (`-client-cert`).
  VaultCmd clientCert(String path) => joined('-client-cert', path);

  /// The private key matching [clientCert] (`-client-key`).
  VaultCmd clientKey(String path) => joined('-client-key', path);

  /// Disables the client from following redirects automatically (`-disable-redirects`).
  VaultCmd disableRedirects() => token('-disable-redirects');

  /// The output format: `table`, `json`, `yaml` or `raw` (`-format`).
  VaultCmd format(String value) => joined('-format', value);

  /// The log output format: `standard` or `json` (`-log-format`).
  VaultCmd logFormat(String value) => joined('-log-format', value);

  /// The log verbosity: `trace`, `debug`, `info`, `warn` or `error` (`-log-level`).
  VaultCmd logLevel(String value) => joined('-log-level', value);

  /// Supplies an MFA credential for a request requiring step-up authentication (`-mfa`).
  VaultCmd mfa(String credential) => joined('-mfa', credential);

  /// The namespace to operate in, on a Vault Enterprise cluster; also `-ns` (`-namespace`).
  VaultCmd namespace(String value) => joined('-namespace', value);

  /// The TLS server name to expect in the server's certificate, overriding the hostname in [address] (`-tls-server-name`).
  VaultCmd tlsServerName(String name) => joined('-tls-server-name', name);

  /// Skips TLS certificate verification — for a trusted network only (`-tls-skip-verify`).
  VaultCmd tlsSkipVerify() => token('-tls-skip-verify');

  /// Wraps the response in a single-use, time-limited token valid for this duration (`-wrap-ttl`).
  VaultCmd wrapTtl(String duration) => joined('-wrap-ttl', duration);

  /// Prints the help text for the command it follows (`-help`, `-h`).
  VaultCmd helpFlag() => token('-help');

  /// The auth method to use with [login]: `userpass`, `aws`, `ldap`, `oidc`, and so on (a positional argument, not a flag).
  VaultCmd method(String name) => token(name);

  // Positional / escape hatch.

  /// A bare positional argument: a secret path, a `key=value` pair for [write], or a flag this wrapper
  /// has no named method for.
  VaultCmd arg(String value) => token(value);
}

/// `vault`, ready to take its first subcommand.
// ignore: non_constant_identifier_names
VaultCmd get Vault => VaultCmd();
