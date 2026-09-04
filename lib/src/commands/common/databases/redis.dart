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

/// `redis-cli`, the command-line client for Redis and Redis-compatible servers:
/// one-shot commands, an interactive shell when none is given, and a pile of
/// diagnostic modes (`--bigkeys`, `--latency`, `--stat`) that a plain client
/// library does not offer.
///
/// ```dart
/// final ShellResult value = await Redis.host('cache.internal').auth(password).cmd(['get', 'session:42']).output();
///
/// await Redis.url('redis://default:$password@cache.internal:6379/0').cmd(['ping']).execute();
/// ```
///
/// [auth] and the raw `-a` flag put the password on the process argument list,
/// where anyone running `ps` on the same host can read it; prefer
/// `REDISCLI_AUTH` in [CommandBuilder.execute]'s `env` when that matters, or
/// [askpass] to prompt instead. [cmd] is the one non-flag method: everything
/// after it becomes the Redis command and its arguments, so add it last. With
/// no [cmd] at all, `redis-cli` starts its interactive shell, which is useless
/// under [CommandBuilder.output] — that mode is for a human at a terminal.
class RedisCmd extends CommandBuilder<RedisCmd> {
  @override
  final String executable = 'redis-cli';

  /// The server hostname; default `127.0.0.1` (`-h`).
  RedisCmd host(String value) => pair('-h', value);

  /// The server port; default `6379` (`-p`).
  RedisCmd port(int value) => pair('-p', '$value');

  /// The connection timeout in seconds, decimals allowed; `0` means no limit (`-t`).
  RedisCmd timeout(num seconds) => pair('-t', '$seconds');

  /// Connects through a Unix socket instead of host/port (`-s`).
  RedisCmd socket(String path) => pair('-s', path);

  /// The password to authenticate with (`-a`). Visible on the process list; prefer `REDISCLI_AUTH` in `env`.
  RedisCmd auth(String password) => pair('-a', password);

  /// Sends `AUTH username pass`, ACL-style. Needs [auth] alongside it (`--user`).
  RedisCmd user(String name) => pair('--user', name);

  /// Alias of [auth], for symmetry with [user] (`--pass`).
  RedisCmd pass(String password) => pair('--pass', password);

  /// Prompts for the password on stdin with the input masked, instead of taking it as an argument (`--askpass`).
  RedisCmd askpass() => token('--askpass');

  /// Connects using a `redis://`/`rediss://` URI, which folds in user, password, host, port and db (`-u`).
  RedisCmd url(String uri) => pair('-u', uri);

  /// Runs the command this many times in a row (`-r`).
  RedisCmd repeat(int count) => pair('-r', '$count');

  /// The delay between repeats, in seconds, decimals allowed; used with [repeat] and the sampling modes (`-i`).
  RedisCmd interval(num seconds) => pair('-i', '$seconds');

  /// The database number to select after connecting (`-n`).
  RedisCmd db(int number) => pair('-n', '$number');

  /// Sets the connection's client name (`--name`).
  RedisCmd name(String value) => pair('--name', value);

  /// Speaks RESP2 to the server explicitly (`-2`).
  RedisCmd resp2() => token('-2');

  /// Speaks RESP3 to the server explicitly (`-3`).
  RedisCmd resp3() => token('-3');

  /// Reads the command's last argument from stdin (`-x`).
  RedisCmd stdinLastArg() => token('-x');

  /// Reads the argument tagged `<tag>` from stdin (`-X`).
  RedisCmd stdinTaggedArg(String tag) => pair('-X', tag);

  /// The delimiter between reply bulks in raw output; default `\n` (`-d`).
  RedisCmd delimiter(String value) => pair('-d', value);

  /// The delimiter between whole responses in raw output; default `\n` (`-D`).
  RedisCmd responseDelimiter(String value) => pair('-D', value);

  /// Enables cluster mode: follows `-ASK`/`-MOVED` redirections automatically (`-c`).
  RedisCmd cluster() => token('-c');

  /// Returns a non-zero exit code when the command itself fails, not just on a connection error (`-e`).
  RedisCmd exitOnError() => token('-e');

  /// Prefers IPv4 when both are returned by DNS (`-4`).
  RedisCmd preferIpv4() => token('-4');

  /// Prefers IPv6 when both are returned by DNS (`-6`).
  RedisCmd preferIpv6() => token('-6');

  /// Establishes the connection over TLS (`--tls`).
  RedisCmd tls() => token('--tls');

  /// Sets the TLS server name indication (`--sni`).
  RedisCmd sni(String host) => pair('--sni', host);

  /// The CA certificate file to verify the server against (`--cacert`).
  RedisCmd cacert(String path) => pair('--cacert', path);

  /// A directory of trusted CA certificates, as an alternative to [cacert] (`--cacertdir`).
  RedisCmd cacertdir(String path) => pair('--cacertdir', path);

  /// Skips TLS certificate validation — for a trusted network only (`--insecure`).
  RedisCmd insecure() => token('--insecure');

  /// The client certificate to authenticate the TLS connection with (`--cert`).
  RedisCmd cert(String path) => pair('--cert', path);

  /// The private key matching [cert] (`--key`).
  RedisCmd tlsKey(String path) => pair('--key', path);

  /// Preferred TLS 1.2-and-below cipher list, colon-separated, most to least preferred (`--tls-ciphers`).
  RedisCmd tlsCiphers(String list) => pair('--tls-ciphers', list);

  /// Preferred TLS 1.3 ciphersuite list, colon-separated (`--tls-ciphersuites`).
  RedisCmd tlsCiphersuites(String list) => pair('--tls-ciphersuites', list);

  /// Uses raw formatting for replies; the default once stdout is not a TTY (`--raw`).
  RedisCmd raw() => token('--raw');

  /// Forces the normal formatted output even when stdout is not a TTY (`--no-raw`).
  RedisCmd noRaw() => token('--no-raw');

  /// Treats the command's own arguments as quoted strings, so escapes like `\x00` are interpreted (`--quoted-input`).
  RedisCmd quotedInput() => token('--quoted-input');

  /// Formats output as CSV (`--csv`).
  RedisCmd csv() => token('--csv');

  /// Formats output as JSON; RESP3 by default, add [resp2] to use it over RESP2 (`--json`).
  RedisCmd json() => token('--json');

  /// Like [json], but with ASCII-safe quoted strings instead of raw Unicode (`--quoted-json`).
  RedisCmd quotedJson() => token('--quoted-json');

  /// Whether to print RESP3 push messages: `yes` or `no`; on by default on a TTY (`--show-pushes`).
  RedisCmd showPushes(String yn) => pair('--show-pushes', yn);

  /// Prints rolling server stats — memory, clients, and so on (`--stat`).
  RedisCmd stat() => token('--stat');

  /// Enters latency-sampling mode, continuous on a TTY or one sample otherwise (`--latency`).
  RedisCmd latency() => token('--latency');

  /// Like [latency] but tracks how it changes over time; default interval 15s, change with [interval] (`--latency-history`).
  RedisCmd latencyHistory() => token('--latency-history');

  /// Shows latency as a spectrum; needs a 256-colour terminal (`--latency-dist`).
  RedisCmd latencyDist() => token('--latency-dist');

  /// Enters VSIM recall test mode against the vector set named by [key] (`--vset-recall`).
  RedisCmd vsetRecall(String key) => pair('--vset-recall', key);

  /// The number of top elements to fetch per query in [vsetRecall] (`--vset-recall-count`).
  RedisCmd vsetRecallCount(int count) => pair('--vset-recall-count', '$count');

  /// The HNSW search-effort parameter for [vsetRecall]; default 500 (`--vset-recall-ef`).
  RedisCmd vsetRecallEf(int ef) => pair('--vset-recall-ef', '$ef');

  /// The number of elements used to compose query vectors in [vsetRecall]; default 1 (`--vset-recall-ele`).
  RedisCmd vsetRecallEle(int count) => pair('--vset-recall-ele', '$count');

  /// Simulates a cache workload with an 80/20 key-access distribution, over this many keys (`--lru-test`).
  RedisCmd lruTest(int keys) => pair('--lru-test', '$keys');

  /// Connects as a replica and prints the commands the master streams to it (`--replica`).
  RedisCmd replica() => token('--replica');

  /// Transfers an RDB dump from the remote server to a local file; `-` writes to stdout (`--rdb`).
  RedisCmd rdb(String path) => pair('--rdb', path);

  /// Like [rdb] but only the functions, not the keys (`--functions-rdb`).
  RedisCmd functionsRdb(String path) => pair('--functions-rdb', path);

  /// Streams raw RESP protocol from stdin straight to the server, for bulk-loading commands (`--pipe`).
  RedisCmd pipeMode() => token('--pipe');

  /// In [pipeMode], aborts if no reply arrives within this many seconds after all data is sent; `0` waits forever (`--pipe-timeout`).
  RedisCmd pipeTimeout(int seconds) => pair('--pipe-timeout', '$seconds');

  /// Samples keys for ones with many elements — lists, hashes, sets, sorted sets, streams (`--bigkeys`).
  RedisCmd bigkeys() => token('--bigkeys');

  /// Samples keys for ones consuming the most memory (`--memkeys`).
  RedisCmd memkeys() => token('--memkeys');

  /// The number of elements to sample per key when using [memkeys] (`--memkeys-samples`).
  RedisCmd memkeysSamples(int count) => pair('--memkeys-samples', '$count');

  /// Samples keys for both size and memory footprint at once — combines [bigkeys] and [memkeys] (`--keystats`).
  RedisCmd keystats() => token('--keystats');

  /// The number of elements to sample per key for [keystats] memory usage (`--keystats-samples`).
  RedisCmd keystatsSamples(int count) => pair('--keystats-samples', '$count');

  /// Resumes a [bigkeys]/[memkeys]/[keystats] scan from this cursor, typically after a Ctrl-C (`--cursor`).
  RedisCmd cursor(int value) => pair('--cursor', '$value');

  /// The number of top key sizes to display for [keystats]; default 10 (`--top`).
  RedisCmd top(int n) => pair('--top', '$n');

  /// Samples keys for the ones being accessed most, when `maxmemory-policy` is an LFU policy (`--hotkeys`).
  RedisCmd hotkeys() => token('--hotkeys');

  /// Lists every key using the `SCAN` command instead of the (blocking) `KEYS` (`--scan`).
  RedisCmd scan() => token('--scan');

  /// The glob pattern used by [scan], [bigkeys], [memkeys], [keystats] and [hotkeys]; default `*` (`--pattern`).
  RedisCmd pattern(String glob) => pair('--pattern', glob);

  /// The count hint used by [scan], [bigkeys], [memkeys], [keystats] and [hotkeys]; default 10 (`--count`).
  RedisCmd count(int value) => pair('--count', '$value');

  /// Like [pattern], but the pattern may itself be quoted for a binary-unsafe string (`--quoted-pattern`).
  RedisCmd quotedPattern(String pattern) => pair('--quoted-pattern', pattern);

  /// Measures intrinsic system latency for this many seconds, independent of Redis (`--intrinsic-latency`).
  RedisCmd intrinsicLatency(int seconds) => pair('--intrinsic-latency', '$seconds');

  /// Sends an `EVAL` command using the Lua script at this path (`--eval`).
  RedisCmd eval(String path) => pair('--eval', path);

  /// Enables the Redis Lua debugger, used with [eval] (`--ldb`).
  RedisCmd ldb() => token('--ldb');

  /// Like [ldb] but synchronous: the server blocks and script changes are not rolled back (`--ldb-sync-mode`).
  RedisCmd ldbSyncMode() => token('--ldb-sync-mode');

  /// Runs a Redis Cluster management subcommand and its own arguments (`--cluster`).
  ///
  /// Use `--cluster help` to list the available subcommands; add each token of that subcommand's
  /// own arguments with [CommandBuilder.token].
  RedisCmd clusterCommand(String subcommand) => pair('--cluster', subcommand);

  /// Prints extra diagnostic detail (`--verbose`).
  RedisCmd verboseFlag() => token('--verbose');

  /// Suppresses the warning shown when a password is passed on the command line (`--no-auth-warning`).
  RedisCmd noAuthWarning() => token('--no-auth-warning');

  /// Prints the help and exits (`--help`).
  RedisCmd help() => token('--help');

  /// Prints the version and exits (`--version`).
  RedisCmd version() => token('--version');

  /// The Redis command to run, as its name followed by its arguments, e.g. `['set', 'key', 'value']`.
  ///
  /// Add last: everything after it is sent to the server verbatim rather than parsed as a `redis-cli` flag.
  RedisCmd cmd(List<String> commandAndArgs) {
    for (final String part in commandAndArgs) {
      token(part);
    }
    return self;
  }
}

/// `redis-cli`, ready to take its first option.
// ignore: non_constant_identifier_names
RedisCmd get Redis => RedisCmd();
