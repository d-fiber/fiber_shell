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

/// `mysql`, the MySQL command-line client. Part of the client package rather
/// than the server, so it exists on all three platforms but is installed
/// separately; a machine running MySQL in a container often has no client at
/// all, which is why the stack usually reaches it through `docker compose
/// exec`. The same binary also answers for MariaDB servers, close enough to be
/// compatible for everything this wrapper covers.
///
/// ```dart
/// final ShellResult version = await Mysql
///     .batch()
///     .skipColumnNames()
///     .execute_('select version()')
///     .user('root')
///     .database('information_schema')
///     .output();
/// ```
///
/// Four flags belong on every scripted call. [batch] turns off the interactive
/// history and pager, [skipColumnNames] and [raw] strip the header and any
/// escape-sequence conversion, and [force] keeps a multi-statement script
/// running past an error instead of aborting the whole batch on the first one.
///
/// The password never belongs on the command line as `-pSECRET`: it lands in
/// argv, where `ps` can read it. Pass it through the `env` argument of
/// [execute] or [output] as `MYSQL_PWD`, or reach for [password] with no value
/// to force an interactive prompt instead.
class MysqlCmd extends CommandBuilder<MysqlCmd> {
  @override
  final String executable = 'mysql';

  /// Prints the usage summary (`-?`, `--help`).
  MysqlCmd help() => token('--help');

  /// Prints the version and exits (`--version`).
  MysqlCmd version() => token('--version');

  /// Reads no option files at all (`--no-defaults`).
  MysqlCmd noDefaults() => token('--no-defaults');

  /// Reads only this option file, ignoring the usual search path (`--defaults-file`).
  MysqlCmd defaultsFile(String path) => pair('--defaults-file', path);

  /// Reads this option file in addition to the usual ones (`--defaults-extra-file`).
  MysqlCmd defaultsExtraFile(String path) => pair('--defaults-extra-file', path);

  /// The suffix appended to option group names read from option files (`--defaults-group-suffix`).
  MysqlCmd defaultsGroupSuffix(String value) => pair('--defaults-group-suffix', value);

  /// Prints the options that would be read from option files, then exits (`--print-defaults`).
  MysqlCmd printDefaults() => token('--print-defaults');

  /// Reads connection options from this entry of `.mylogin.cnf` instead of a plain option file (`--login-path`).
  MysqlCmd loginPath(String value) => pair('--login-path', value);

  /// Skips reading login paths from `.mylogin.cnf` (`--no-login-paths`).
  MysqlCmd noLoginPaths() => token('--no-login-paths');

  /// The host the server is on (`-h`, `--host`).
  MysqlCmd host(String value) => pair('--host', value);

  /// The TCP/IP port to connect on (`-P`, `--port`).
  MysqlCmd port(int value) => pair('--port', '$value');

  /// The Unix socket, or Windows named pipe, to connect through (`-S`, `--socket`).
  MysqlCmd socket(String path) => pair('--socket', path);

  /// Connects through a named pipe rather than TCP/IP, on Windows (`-W`, `--pipe`).
  MysqlCmd pipe() => token('--pipe');

  /// The network namespace to use for the connection (`--network-namespace`).
  MysqlCmd networkNamespace(String value) => pair('--network-namespace', value);

  /// The local network interface to connect from (`--bind-address`).
  MysqlCmd bindAddress(String value) => pair('--bind-address', value);

  /// The transport protocol to use: `tcp`, `socket`, `pipe` or `memory` (`--protocol`).
  MysqlCmd protocol(String value) => pair('--protocol', value);

  /// Uses DNS SRV records to determine the host and port, instead of [host]/[port] (`--dns-srv-name`).
  MysqlCmd dnsSrvName(String value) => pair('--dns-srv-name', value);

  /// The account username (`-u`, `--user`).
  MysqlCmd user(String value) => pair('--user', value);

  /// Prompts for the password interactively (`-p`, `--password`, no value).
  MysqlCmd askPassword() => token('--password');

  /// The account password, given inline (`-p`, `--password=value`).
  ///
  /// Lands in argv, where `ps` can read it. Prefer the `MYSQL_PWD` environment variable via `execute`/`output`'s `env` argument, or `--password` with no value for an interactive prompt.
  MysqlCmd password(String value) => joined('--password', value);

  /// The first of up to three multi-factor authentication passwords (`--password1`).
  MysqlCmd password1(String value) => pair('--password1', value);

  /// The second multi-factor authentication password (`--password2`).
  MysqlCmd password2(String value) => pair('--password2', value);

  /// The third multi-factor authentication password (`--password3`).
  MysqlCmd password3(String value) => pair('--password3', value);

  /// Which authentication factors must be registered during this connection (`--register-factor`).
  MysqlCmd registerFactor(String value) => pair('--register-factor', value);

  /// The authentication plugin to use (`--default-auth`).
  MysqlCmd defaultAuth(String plugin) => pair('--default-auth', plugin);

  /// Permits the cleartext authentication plugin, needed for some non-TLS setups (`--enable-cleartext-plugin`).
  MysqlCmd enableCleartextPlugin() => token('--enable-cleartext-plugin');

  /// Tells the server this client can handle the expired-password sandbox mode (`--connect-expired-password`).
  MysqlCmd connectExpiredPassword() => token('--connect-expired-password');

  /// The directory plugins are loaded from (`--plugin-dir`).
  MysqlCmd pluginDir(String path) => pair('--plugin-dir', path);

  /// Requests the server's RSA public key for authentication (`--get-server-public-key`).
  MysqlCmd getServerPublicKey() => token('--get-server-public-key');

  /// The file holding the server's RSA public key, instead of requesting it (`--server-public-key-path`).
  MysqlCmd serverPublicKeyPath(String path) => pair('--server-public-key-path', path);

  /// The database to use once connected (`-D`, `--database`).
  MysqlCmd database(String name) => pair('--database', name);

  /// One SQL statement to run before every reconnect, in addition to [initCommand] (`--init-command-add`).
  MysqlCmd initCommandAdd(String sql) => pair('--init-command-add', sql);

  /// One SQL statement to run immediately after connecting (`--init-command`).
  MysqlCmd initCommand(String sql) => pair('--init-command', sql);

  /// Executes this statement and exits, without an interactive session (`-e`, `--execute`).
  MysqlCmd execute_(String sql) => pair('--execute', sql);

  /// Ignores every statement except those for the database named on the command line (`-o`, `--one-database`).
  MysqlCmd oneDatabase() => token('--one-database');

  /// Restricts SQL statements to `UPDATE` and `DELETE` with key values given, guarding against a forgotten `WHERE` (`-U`, `--safe-updates`, `--i-am-a-dummy`).
  MysqlCmd safeUpdates() => token('--safe-updates');

  /// Under [safeUpdates], the row limit automatically applied to a `SELECT` (`--select-limit`).
  MysqlCmd selectLimit(int rows) => pair('--select-limit', '$rows');

  /// Under [safeUpdates], the row limit automatically applied to a join (`--max-join-size`).
  MysqlCmd maxJoinSize(int rows) => pair('--max-join-size', '$rows');

  /// Continues past an SQL error in a batch instead of aborting (`-f`, `--force`).
  ///
  /// What keeps a multi-statement script running to the end even when one statement fails.
  MysqlCmd force() => token('--force');

  /// Runs non-interactively, no history file and no pager (`-B`, `--batch`).
  MysqlCmd batch() => token('--batch');

  /// The statement delimiter, `;` by default (`--delimiter`).
  MysqlCmd delimiter(String value) => pair('--delimiter', value);

  /// Whether backslash-escaped mysql client commands are recognised (`--commands`).
  MysqlCmd commands(bool value) => joined('--commands', value ? 'ON' : 'OFF');

  /// Enables named mysql client commands, `\help` style (`-G`, `--named-commands`).
  MysqlCmd namedCommands() => token('--named-commands');

  /// Disables named mysql client commands (`--skip-named-commands`).
  MysqlCmd skipNamedCommands() => token('--skip-named-commands');

  /// Disables the `\!` system-shell escape command (`--skip-system-command`).
  MysqlCmd skipSystemCommand() => token('--skip-system-command');

  /// Whether the system-shell escape command is enabled (`--system-command`).
  MysqlCmd systemCommand(bool value) => joined('--system-command', value ? 'ON' : 'OFF');

  /// Ignores spaces after a function name before its `(` (`-i`, `--ignore-spaces`).
  MysqlCmd ignoreSpaces() => token('--ignore-spaces');

  /// Reconnects automatically if the connection is lost (`--reconnect`).
  MysqlCmd reconnect() => token('--reconnect');

  /// Disables automatic reconnection (`--skip-reconnect`).
  MysqlCmd skipReconnect() => token('--skip-reconnect');

  /// Waits and retries instead of aborting when the initial connection fails (`--wait`).
  MysqlCmd wait() => token('--wait');

  /// The connection timeout, in seconds (`--connect-timeout`).
  MysqlCmd connectTimeout(int seconds) => pair('--connect-timeout', '$seconds');

  /// The maximum packet size to send or receive (`--max-allowed-packet`).
  MysqlCmd maxAllowedPacket(String value) => pair('--max-allowed-packet', value);

  /// The buffer size for TCP/IP and socket communication (`--net-buffer-length`).
  MysqlCmd netBufferLength(String value) => pair('--net-buffer-length', value);

  /// Compresses traffic between client and server (`-C`, `--compress`).
  MysqlCmd compress() => token('--compress');

  /// The compression algorithms permitted for the connection (`--compression-algorithms`).
  MysqlCmd compressionAlgorithms(String value) => pair('--compression-algorithms', value);

  /// The zstd compression level, when zstd compression is negotiated (`--zstd-compression-level`).
  MysqlCmd zstdCompressionLevel(int level) => pair('--zstd-compression-level', '$level');

  /// The desired TLS security state of the connection: `DISABLED`, `PREFERRED`, `REQUIRED`, `VERIFY_CA` or `VERIFY_IDENTITY` (`--ssl-mode`).
  MysqlCmd sslMode(String mode) => pair('--ssl-mode', mode);

  /// The CA bundle of trusted certificate authorities (`--ssl-ca`).
  MysqlCmd sslCa(String path) => pair('--ssl-ca', path);

  /// A directory of trusted CA certificate files (`--ssl-capath`).
  MysqlCmd sslCapath(String path) => pair('--ssl-capath', path);

  /// The client's X.509 certificate (`--ssl-cert`).
  MysqlCmd sslCert(String path) => pair('--ssl-cert', path);

  /// The client's private key (`--ssl-key`).
  MysqlCmd sslKey(String path) => pair('--ssl-key', path);

  /// The permitted TLS ciphers for the connection (`--ssl-cipher`).
  MysqlCmd sslCipher(String list) => pair('--ssl-cipher', list);

  /// The permitted TLSv1.3 ciphersuites (`--tls-ciphersuites`).
  MysqlCmd tlsCiphersuites(String list) => pair('--tls-ciphersuites', list);

  /// The permitted TLS protocol versions (`--tls-version`).
  MysqlCmd tlsVersion(String value) => pair('--tls-version', value);

  /// A file of certificate revocation lists (`--ssl-crl`).
  MysqlCmd sslCrl(String path) => pair('--ssl-crl', path);

  /// A directory of certificate revocation list files (`--ssl-crlpath`).
  MysqlCmd sslCrlpath(String path) => pair('--ssl-crlpath', path);

  /// Whether FIPS mode is enabled on the client side (`--ssl-fips-mode`).
  MysqlCmd sslFipsMode(String value) => pair('--ssl-fips-mode', value);

  /// A file of cached TLS session data, for faster reconnection (`--ssl-session-data`).
  MysqlCmd sslSessionData(String path) => pair('--ssl-session-data', path);

  /// Whether to connect anyway when [sslSessionData] reuse fails (`--ssl-session-data-continue-on-failed-reuse`).
  MysqlCmd sslSessionDataContinueOnFailedReuse() => token('--ssl-session-data-continue-on-failed-reuse');

  /// The server name presented for TLS SNI (`--tls-sni-servername`).
  MysqlCmd tlsSniServername(String value) => pair('--tls-sni-servername', value);

  /// The OCI CLI configuration file, for OCI authentication (`--oci-config-file`).
  MysqlCmd ociConfigFile(String path) => pair('--oci-config-file', path);

  /// The OCI config profile to use, under [ociConfigFile] (`--authentication-oci-client-config-profile`).
  MysqlCmd authenticationOciClientConfigProfile(String value) =>
      pair('--authentication-oci-client-config-profile', value);

  /// Permits GSSAPI authentication through the MIT Kerberos library, Windows only (`--plugin-authentication-kerberos-client-mode`).
  MysqlCmd pluginAuthenticationKerberosClientMode(String value) =>
      pair('--plugin-authentication-kerberos-client-mode', value);

  /// Lets the user choose which WebAuthn key to use for assertion (`--plugin-authentication-webauthn-client-preserve-privacy`).
  MysqlCmd pluginAuthenticationWebauthnClientPreservePrivacy(bool value) =>
      joined('--plugin-authentication-webauthn-client-preserve-privacy', value ? 'ON' : 'OFF');

  /// The character set directory (`--character-sets-dir`).
  MysqlCmd characterSetsDir(String path) => pair('--character-sets-dir', path);

  /// The default character set for the connection (`--default-character-set`).
  MysqlCmd defaultCharacterSet(String value) => pair('--default-character-set', value);

  /// Whether local files can be read for `LOAD DATA LOCAL` (`--local-infile`).
  MysqlCmd localInfile(bool value) => joined('--local-infile', value ? 'ON' : 'OFF');

  /// The directory `LOAD DATA LOCAL` is allowed to read files from (`--load-data-local-dir`).
  MysqlCmd loadDataLocalDir(String path) => pair('--load-data-local-dir', path);

  /// Reads and writes with no `\r\n`-to-`\n` translation, and no `\0` end-of-query handling (`--binary-mode`).
  MysqlCmd binaryMode() => token('--binary-mode');

  /// Prints binary column values as hexadecimal instead of raw bytes (`--binary-as-hex`).
  MysqlCmd binaryAsHex() => token('--binary-as-hex');

  /// Suppresses the beep on error (`-b`, `--no-beep`).
  MysqlCmd noBeep() => token('--no-beep');

  /// Runs quietly: only errors, no banner or prompts (`-s`, `--silent`).
  MysqlCmd silent() => token('--silent');

  /// Talks more about what it is doing (`--verbose`). Repeatable.
  MysqlCmd verbose() => token('--verbose');

  /// Suppresses column names in query output (`-N`, `--skip-column-names`).
  MysqlCmd skipColumnNames() => token('--skip-column-names');

  /// Writes column names in results, the default (`--column-names`).
  MysqlCmd columnNames() => token('--column-names');

  /// Displays result set metadata: `full`, `auto` or `never` (`--column-type-info`).
  MysqlCmd columnTypeInfo() => token('--column-type-info');

  /// Automatically rehashes table and column names for completion after connecting (`--auto-rehash`).
  MysqlCmd autoRehash() => token('--auto-rehash');

  /// Disables [autoRehash] (`-A`, `--no-auto-rehash`, `--skip-auto-rehash`).
  MysqlCmd noAutoRehash() => token('--no-auto-rehash');

  /// Automatically switches between horizontal and vertical result display (`--auto-vertical-output`).
  MysqlCmd autoVerticalOutput() => token('--auto-vertical-output');

  /// Prints each result row vertically, one line per column (`--vertical`).
  MysqlCmd vertical() => token('--vertical');

  /// Displays output as an ASCII table, the interactive default (`-t`, `--table`).
  MysqlCmd table() => token('--table');

  /// Produces HTML output (`-H`, `--html`).
  MysqlCmd html() => token('--html');

  /// Produces XML output (`--xml`).
  MysqlCmd xml() => token('--xml');

  /// Writes column values with no escape-sequence conversion (`-r`, `--raw`).
  MysqlCmd raw() => token('--raw');

  /// Flushes the output buffer after each statement rather than buffering it (`-n`, `--unbuffered`).
  MysqlCmd unbuffered() => token('--unbuffered');

  /// Whether to retain or strip SQL comments (`-c`, `--comments`).
  MysqlCmd comments(bool value) => joined('--comments', value ? 'ON' : 'OFF');

  /// Prefixes error messages with the line number they occurred on (`--line-numbers`).
  MysqlCmd lineNumbers() => token('--line-numbers');

  /// Suppresses line numbers on error messages (`-L`, `--skip-line-numbers`).
  MysqlCmd skipLineNumbers() => token('--skip-line-numbers');

  /// Shows warnings after a statement, when there are any (`--show-warnings`).
  MysqlCmd showWarnings() => token('--show-warnings');

  /// The prompt format string for interactive sessions (`--prompt`). Meaningless under [batch].
  MysqlCmd prompt(String format) => pair('--prompt', format);

  /// The pager command query output is piped through (`--pager`).
  MysqlCmd pager(String command) => pair('--pager', command);

  /// Disables the pager (`--skip-pager`).
  MysqlCmd skipPager() => token('--skip-pager');

  /// Appends a copy of the session's output to this file (`--tee`).
  MysqlCmd tee(String path) => pair('--tee', path);

  /// Disables [tee] output (`--skip-tee`).
  MysqlCmd skipTee() => token('--skip-tee');

  /// Logs interactive statements to syslog (`-j`, `--syslog`).
  MysqlCmd syslog() => token('--syslog');

  /// Ignores SIGINT (typically Ctrl+C) instead of interrupting the current statement (`--sigint-ignore`).
  MysqlCmd sigintIgnore() => token('--sigint-ignore');

  /// Statement patterns to exclude from history logging, `:`-separated (`--histignore`).
  MysqlCmd histignore(String patterns) => pair('--histignore', patterns);

  /// The shared-memory name for shared-memory connections, Windows only (`--shared-memory-base-name`).
  MysqlCmd sharedMemoryBaseName(String value) => pair('--shared-memory-base-name', value);

  /// Writes a debug log; the trace-flag string follows the `d:t:o,file` convention (`-#`, `--debug`).
  MysqlCmd debug(String traceFlags) => pair('--debug', traceFlags);

  /// Checks and prints debugging information on exit (`--debug-check`).
  MysqlCmd debugCheck() => token('--debug-check');

  /// Prints memory and CPU usage debugging information on exit (`-T`, `--debug-info`).
  MysqlCmd debugInfo() => token('--debug-info');

  /// Enables the telemetry client (`--telemetry_client`).
  MysqlCmd telemetryClient() => token('--telemetry_client');

  /// The OTLP trace export endpoint, under [telemetryClient] (`--otel_exporter_otlp_traces_endpoint`).
  MysqlCmd otelExporterOtlpTracesEndpoint(String url) => pair('--otel_exporter_otlp_traces_endpoint', url);

  /// Adds a bare positional argument: the database name, when given rather than through [database].
  MysqlCmd arg(String value) => token(value);
}

/// `mysql`, ready to take its first option.
// ignore: non_constant_identifier_names
MysqlCmd get Mysql => MysqlCmd();
