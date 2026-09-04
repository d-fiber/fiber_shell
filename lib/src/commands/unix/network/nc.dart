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

/// `nc` (netcat): opens or listens on arbitrary TCP and UDP connections, on
/// every Unix. This wrapper follows BSD `nc` — the version macOS and most BSDs
/// ship as `/usr/bin/nc` — rather than GNU `netcat`/`ncat`, which use a
/// different flag set entirely (GNU netcat answers `-e` to exec a program on
/// connect, something BSD `nc` deliberately never grew). Check which `nc` a
/// Linux box actually has before assuming these flags apply there.
///
/// ```dart
/// // Port scan: which of 20-30 are open on host.example.com.
/// final ShellResult scan = await Nc.scan().timeout(2).host('host.example.com').port('20-30').output();
///
/// // Minimal client/server: connect() on one machine, listen() on another.
/// await Nc.listen().port('1234').writeTo(File('incoming.bin'));
/// ```
///
/// [listen] conflicts with [sourcePort], [sourceAddress] and [scan] — `nc`
/// refuses those combinations outright. A handful of Apple-private long flags
/// (`--apple-delegate-pid` and siblings) exist on macOS's `nc` and are
/// deliberately left out here: they are undocumented outside Apple's own
/// source and unlikely to matter in a portable script.
class NcCmd extends CommandBuilder<NcCmd> {
  @override
  final String executable = 'nc';

  /// Forces IPv4 addresses only (`-4`).
  NcCmd ipv4Only() => token('-4');

  /// Forces IPv6 addresses only (`-6`).
  NcCmd ipv6Only() => token('-6');

  /// Sets `SO_RECV_ANYIF` on the socket, so it can receive on an interface
  /// other than the one routing would pick (`-A`).
  NcCmd receiveAnyIf() => token('-A');

  /// Binds the socket to this interface (`-b`).
  NcCmd boundInterface(String iface) => pair('-b', iface);

  /// Sends CRLF as the line ending instead of a bare LF (`-c`).
  NcCmd crlf() => token('-c');

  /// Enables `SO_DEBUG` on the socket (`-D`).
  NcCmd debug() => token('-D');

  /// Refuses to use the cellular data path (`-C`).
  NcCmd noCellular() => token('-C');

  /// Never reads from stdin (`-d`).
  NcCmd noStdin() => token('-d');

  /// Prints the usage summary and exits (`-h`).
  NcCmd help() => token('-h');

  /// Delays this many seconds between lines sent/received, and between
  /// connecting to successive ports (`-i`).
  NcCmd interval(int seconds) => pair('-i', '$seconds');

  /// Sets the TCP connection timeout, in seconds (`-G`).
  NcCmd connectTimeout(int seconds) => pair('-G', '$seconds');

  /// Sets the initial TCP keepalive idle timeout, in seconds (`-H`).
  NcCmd keepAliveIdle(int seconds) => pair('-H', '$seconds');

  /// Sets the interval between repeated TCP keepalive probes, in seconds
  /// (`-I`).
  NcCmd keepAliveInterval(int seconds) => pair('-I', '$seconds');

  /// Sets how many TCP keepalive probes to send before giving up (`-J`).
  NcCmd keepAliveCount(int count) => pair('-J', '$count');

  /// Keeps [listen]ing for another connection once the current one ends;
  /// invalid without [listen] (`-k`).
  NcCmd keepListening() => token('-k');

  /// Listens for an incoming connection instead of initiating one. Conflicts
  /// with [sourcePort], [sourceAddress] and [scan] (`-l`).
  NcCmd listen() => token('-l');

  /// Sends this many reachability probes before declaring the peer
  /// unreachable (`-L`).
  NcCmd probeCount(int count) => pair('-L', '$count');

  /// Skips DNS and service-name lookups on every host and port given (`-n`).
  NcCmd noDns() => token('-n');

  /// Uses this source port, subject to privilege and availability. Conflicts
  /// with [listen] (`-p`).
  NcCmd sourcePort(int port) => pair('-p', '$port');

  /// Picks source and destination ports at random rather than sequentially
  /// (`-r`).
  NcCmd randomPorts() => token('-r');

  /// Sends from this local interface address. Conflicts with [listen] (`-s`).
  NcCmd sourceAddress(String ip) => pair('-s', ip);

  /// Answers RFC 854 DON'T/WON'T to DO/WILL requests, enough to script a
  /// `telnet` session (`-t`).
  NcCmd telnet() => token('-t');

  /// Uses a Unix domain socket instead of TCP/UDP (`-U`).
  NcCmd unixSocket() => token('-U');

  /// Uses UDP instead of the default TCP (`-u`).
  NcCmd udp() => token('-u');

  /// Prints more about what `nc` is doing (`-v`).
  NcCmd verbose() => token('-v');

  /// Closes the connection after this many idle seconds; ignored under
  /// [listen], which waits forever regardless (`-w`).
  NcCmd timeout(int seconds) => pair('-w', '$seconds');

  /// Selects the proxy protocol to speak: `4` (SOCKS4), `5` (SOCKS5, the
  /// default) or `connect` (HTTPS CONNECT) (`-X`).
  NcCmd proxyVersion(String version) => pair('-X', version);

  /// Routes the connection through a proxy at `address[:port]` (`-x`).
  NcCmd proxy(String addressPort) => pair('-x', addressPort);

  /// Scans for listening daemons without sending any data. Conflicts with
  /// [listen] (`-z`).
  NcCmd scan() => token('-z');

  /// The host to connect to, or to bind on under [listen]. Numeric or a
  /// symbolic name, unless [noDns] is set.
  NcCmd host(String value) => token(value);

  /// The port, or port range (`nn-mm`), to connect to or scan.
  NcCmd port(String value) => token(value);
}

/// `nc`, ready to take its first option.
// ignore: non_constant_identifier_names
NcCmd get Nc => NcCmd();
