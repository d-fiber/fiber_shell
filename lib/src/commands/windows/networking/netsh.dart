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

/// `netsh`, the network shell: firewall, interfaces, proxies, port forwarding.
/// Windows only, and the counterpart of `ufw`, `iptables` and `networksetup`
/// rolled into one.
///
/// ```dart
/// await Netsh.advfirewall().arg('firewall').arg('add').arg('rule')
///     .arg('name=koko-api').arg('dir=in').arg('action=allow')
///     .arg('protocol=TCP').arg('localport=8080')
///     .execute();
/// ```
///
/// The grammar is a **context path followed by named arguments**, as in `netsh
/// advfirewall firewall add rule name=… dir=in`, where each context is a
/// separate command set. This wrapper gives the contexts as methods and leaves
/// the rest to [arg], because there is no shared option vocabulary to model: the
/// arguments of `advfirewall firewall` have nothing in common with those of
/// `interface portproxy`.
///
/// Microsoft's own guidance is to prefer the PowerShell modules,
/// `New-NetFirewallRule` and friends, and to treat netsh as the compatibility
/// path. It is still the only way to reach a few things, and it is still what
/// every existing script uses.
///
/// The firewall and interface contexts need an elevated prompt.
class NetshCmd extends CommandBuilder<NetshCmd> {
  @override
  final String executable = 'netsh';

  /// Runs an alias file and stays in the shell (`-a`).
  NetshCmd aliasFile(String path) => pair('-a', path);

  /// Enters a context before running the command (`-c`).
  NetshCmd context(String name) => pair('-c', name);

  /// Runs against a remote machine (`-r`). Needs its Remote Registry service up.
  NetshCmd remote(String machine) => pair('-r', machine);

  /// The account to run as, `DOMAIN\\user` (`-u`).
  NetshCmd user(String value) => pair('-u', value);

  /// Its password, or `*` to be prompted (`-p`).
  NetshCmd password(String value) => pair('-p', value);

  /// Runs the commands in a script file and exits (`-f`).
  NetshCmd scriptFile(String path) => pair('-f', path);

  /// The modern firewall context (`advfirewall`).
  NetshCmd advfirewall() => token('advfirewall');

  /// The old firewall context (`firewall`). Deprecated, and still everywhere.
  NetshCmd firewall() => token('firewall');

  /// Interfaces, addresses, routes and port proxies (`interface`).
  NetshCmd interfaceContext() => token('interface');

  /// The HTTP server API: URL reservations, certificate bindings (`http`).
  ///
  /// Where a service that is not running as administrator gets permission to
  /// listen on a port.
  NetshCmd http() => token('http');

  /// Wireless profiles and connections (`wlan`).
  NetshCmd wlan() => token('wlan');

  /// Wired 802.1X profiles (`lan`).
  NetshCmd lan() => token('lan');

  /// The system-wide WinHTTP proxy (`winhttp`).
  ///
  /// Not the same proxy as the browser's: a service that fails to reach the
  /// network while the browser works is usually looking at this one.
  NetshCmd winhttp() => token('winhttp');

  /// Winsock catalog and reset (`winsock`).
  NetshCmd winsock() => token('winsock');

  /// The DNS client configuration (`dnsclient`).
  NetshCmd dnsclient() => token('dnsclient');

  /// The DHCP client configuration (`dhcpclient`).
  NetshCmd dhcpclient() => token('dhcpclient');

  /// IPsec policies (`ipsec`).
  NetshCmd ipsec() => token('ipsec');

  /// BranchCache (`branchcache`).
  NetshCmd branchcache() => token('branchcache');

  /// Network tracing and packet capture (`trace`).
  NetshCmd trace() => token('trace');

  /// RPC filters (`rpc`).
  NetshCmd rpc() => token('rpc');

  /// Network bridges (`bridge`).
  NetshCmd bridge() => token('bridge');

  /// The DNS namespace policy table (`namespace`).
  NetshCmd namespace() => token('namespace');

  /// Network layer bindings (`netio`).
  NetshCmd netio() => token('netio');

  /// Remote access (`ras`).
  NetshCmd ras() => token('ras');

  /// Windows Connect Now (`wcn`).
  NetshCmd wcn() => token('wcn');

  /// The Windows Filtering Platform (`wfp`).
  NetshCmd wfp() => token('wfp');

  /// Prints the configuration as a script (`dump`).
  ///
  /// The way to capture a working configuration before changing it.
  NetshCmd dump() => token('dump');

  /// Adds an entry (`add`).
  NetshCmd add() => token('add');

  /// Removes one (`delete`).
  NetshCmd delete() => token('delete');

  /// Changes settings (`set`).
  NetshCmd set() => token('set');

  /// Prints information (`show`).
  NetshCmd show() => token('show');

  /// Resets a context to its defaults (`reset`).
  NetshCmd reset() => token('reset');

  /// Adds a bare argument: a subcontext, a verb, a `name=value` pair.
  NetshCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
NetshCmd get Netsh => NetshCmd();
