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

/// `netstat`, the connection and listening-port lister, the counterpart of
/// `ss` on Linux. Windows only, and only present when TCP/IP is installed on
/// a network adapter.
///
/// ```dart
/// final ShellResult listening = await Netstat.all().numeric().withProcess().output();
/// ```
///
/// PowerShell's `Get-NetTCPConnection` is the modern, structured replacement,
/// but `netstat` stays the portable choice: it exists on every Windows box
/// back to versions that module never shipped on.
///
/// [withProcess] (`-o`, the owning process id) and [withExecutable] (`-b`,
/// the executable name) both need an elevated prompt to resolve every row;
/// run without elevation and [withExecutable] in particular can fail
/// outright rather than leaving a blank column. [withExecutable] is also the
/// slowest form — resolving every listening port's executable chain adds up.
///
/// [interval] redisplays the same listing every so many seconds until
/// interrupted, which is not a shape [output] or [execute] handle well since
/// both wait for the process to exit; reach for [background] and read the
/// output as it streams instead.
///
/// Every documented switch: `-a`, `-b`, `-e`, `-n`, `-o`, `-p`, `-r`, `-s`,
/// `<interval>`.
class NetstatCmd extends CommandBuilder<NetstatCmd> {
  @override
  final String executable = 'netstat';

  /// Shows every connection and listening port (`-a`). Without it, only
  /// established connections show.
  NetstatCmd all() => token('-a');

  /// Adds the executable behind each connection (`-b`). Needs elevation, and
  /// is the slowest option here.
  NetstatCmd withExecutable() => token('-b');

  /// Shows Ethernet statistics: bytes and packets sent and received (`-e`).
  /// Combinable with [statistics].
  NetstatCmd ethernetStatistics() => token('-e');

  /// Prints addresses and ports as numbers, skipping the DNS and service-name
  /// lookups that slow the plain form down (`-n`).
  NetstatCmd numeric() => token('-n');

  /// Adds the owning process id to each connection (`-o`). Combinable with
  /// [all], [numeric] and [protocol]. Needs elevation to resolve every row.
  NetstatCmd withProcess() => token('-o');

  /// Restricts the listing to this protocol. For the connection table:
  /// `tcp`, `udp`, `tcpv6`, `udpv6`. Together with [statistics]: also `icmp`,
  /// `ip`, `icmpv6`, `ipv6` (`-p`).
  NetstatCmd protocol(String value) => pair('-p', value);

  /// Shows the IP routing table, equivalent to `route print` (`-r`).
  NetstatCmd routingTable() => token('-r');

  /// Shows the per-protocol statistics instead of the connection table
  /// (`-s`). Defaults to TCP, UDP, ICMP and IP (plus their IPv6 counterparts
  /// if installed); narrow it with [protocol].
  NetstatCmd statistics() => token('-s');

  /// Redisplays the chosen listing every this many seconds until
  /// interrupted. Not useful under [output]/[execute], which wait for the
  /// process to exit; reach for [background] instead when this is set.
  NetstatCmd interval(int seconds) => token('$seconds');
}

/// `netstat`, ready to take its first option.
// ignore: non_constant_identifier_names
NetstatCmd get Netstat => NetstatCmd();
