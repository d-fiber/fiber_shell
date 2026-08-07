// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

/// `ip`, the iproute2 networking tool. Linux only, and the replacement for
/// `ifconfig` and `route`, which still exist on many machines but have not been
/// told about anything added to the kernel in twenty years.
///
/// ```dart
/// final ShellResult addresses = await Ip.json().address().show().output();
/// ```
///
/// The grammar is object then command: `ip address show`, `ip link set`, `ip
/// route add`. This wrapper keeps that order, and the global options come first.
///
/// [json] is the reason to prefer this over the alternatives in a script: the
/// human output is columns that shift between versions, and `-j` gives the same
/// information as parseable JSON. [brief] is the readable middle ground.
///
/// Reading is unprivileged; anything that changes the configuration wants
/// `asRoot()`.
class IpCmd extends CommandBuilder<IpCmd> {
  @override
  final String executable = 'ip';

  /// Prints the version (`-V`).
  IpCmd version() => token('-V');

  /// Adds the statistics, twice over for more (`-statistics`).
  IpCmd statistics() => token('-statistics');

  /// Adds the details a summary leaves out (`-details`).
  IpCmd details() => token('-details');

  /// Prints JSON instead of columns (`-json`).
  IpCmd json() => token('-json');

  /// Indents the JSON (`-pretty`).
  IpCmd pretty() => token('-pretty');

  /// Resolves the addresses to names (`-resolve`).
  IpCmd resolve() => token('-resolve');

  /// The protocol family to work in (`-family`).
  IpCmd family(String value) => pair('-family', value);

  /// IPv4 only (`-4`).
  IpCmd ipv4() => token('-4');

  /// IPv6 only (`-6`).
  IpCmd ipv6() => token('-6');

  /// One record per line, however long (`-oneline`).
  ///
  /// What makes the output survive a `grep`, since a record normally spans
  /// several lines.
  IpCmd oneline() => token('-oneline');

  /// The short tabular form (`-brief`).
  IpCmd brief() => token('-brief');

  /// Runs inside this network namespace (`-netns`).
  IpCmd netnsOption(String name) => pair('-netns', name);

  /// Runs the command over every object (`-all`).
  IpCmd all() => token('-all');

  /// When to colour: `always`, `auto`, `never` (`-color`).
  IpCmd color(String value) => joined('-color', value);

  /// Prints the statistics in human-readable units (`-human`).
  IpCmd human() => token('-human');

  /// Timestamps the lines that `monitor` prints (`-timestamp`).
  IpCmd timestamp() => token('-timestamp');

  /// Keeps going after an error in batch mode (`-force`).
  IpCmd force() => token('-force');

  /// Reads the commands from a file, or from stdin (`-batch`).
  IpCmd batch(String path) => pair('-batch', path);

  /// Network devices (`link`).
  IpCmd link() => token('link');

  /// Addresses on a device (`address`).
  IpCmd address() => token('address');

  /// The label configuration for address selection (`addrlabel`).
  IpCmd addrLabel() => token('addrlabel');

  /// The routing table (`route`).
  IpCmd route() => token('route');

  /// The routing policy database (`rule`).
  IpCmd rule() => token('rule');

  /// The ARP and NDISC caches (`neigh`).
  IpCmd neighbour() => token('neigh');

  /// How the neighbour cache behaves (`ntable`).
  IpCmd neighbourTable() => token('ntable');

  /// Tunnels over IP (`tunnel`).
  IpCmd tunnel() => token('tunnel');

  /// TUN and TAP devices (`tuntap`).
  ///
  /// Where a WireGuard or OpenVPN interface comes from.
  IpCmd tuntap() => token('tuntap');

  /// Multicast addresses (`maddress`).
  IpCmd multicastAddress() => token('maddress');

  /// The multicast routing cache (`mroute`).
  IpCmd multicastRoute() => token('mroute');

  /// The multicast routing policy database (`mrule`).
  IpCmd multicastRule() => token('mrule');

  /// Watches for netlink messages (`monitor`).
  IpCmd monitor() => token('monitor');

  /// IPsec policies (`xfrm`).
  IpCmd xfrm() => token('xfrm');

  /// Network namespaces (`netns`).
  IpCmd netns() => token('netns');

  /// L2TPv3 tunnels (`l2tp`).
  IpCmd l2tp() => token('l2tp');

  /// The cached TCP metrics per destination (`tcp_metrics`).
  IpCmd tcpMetrics() => token('tcp_metrics');

  /// Tokenized interface identifiers (`token`).
  IpCmd tokenObject() => token('token');

  /// MACsec devices (`macsec`).
  IpCmd macsec() => token('macsec');

  /// Virtual routing and forwarding devices (`vrf`).
  IpCmd vrf() => token('vrf');

  /// IPv6 segment routing (`sr`).
  IpCmd segmentRouting() => token('sr');

  /// Nexthop objects (`nexthop`).
  IpCmd nexthop() => token('nexthop');

  /// The MPTCP path manager (`mptcp`).
  IpCmd mptcp() => token('mptcp');

  /// IOAM namespaces and schemas (`ioam`).
  IpCmd ioam() => token('ioam');

  /// Interface statistics (`stats`).
  IpCmd stats() => token('stats');

  /// Shows the objects (`show`).
  IpCmd show() => token('show');

  /// Adds an object (`add`).
  IpCmd add() => token('add');

  /// Deletes an object (`del`).
  IpCmd del() => token('del');

  /// Changes an object, failing when it does not exist (`change`).
  IpCmd change() => token('change');

  /// Adds or changes, whichever applies (`replace`).
  ///
  /// The idempotent one: safe to run on a machine that is already configured.
  IpCmd replace() => token('replace');

  /// Changes the state of a device (`set`).
  IpCmd set() => token('set');

  /// Empties a table (`flush`).
  IpCmd flush() => token('flush');

  /// Asks which route a destination would take (`get`).
  IpCmd getRoute() => token('get');

  /// Brings a device up (`up`).
  IpCmd up() => token('up');

  /// Takes a device down (`down`).
  IpCmd down() => token('down');

  /// Names the device the command applies to (`dev`).
  IpCmd dev(String name) => pair('dev', name);

  /// The gateway of a route (`via`).
  IpCmd via(String value) => pair('via', value);

  /// The source address of a route (`src`).
  IpCmd src(String value) => pair('src', value);

  /// The routing table to work in (`table`).
  IpCmd table(String value) => pair('table', value);

  /// The scope of an address or a route (`scope`).
  IpCmd scope(String value) => pair('scope', value);

  /// The metric of a route (`metric`).
  IpCmd metric(String value) => pair('metric', value);

  /// The MTU of a device (`mtu`).
  IpCmd mtu(String value) => pair('mtu', value);

  /// The device type, for `link add`: `wireguard`, `bridge`, `veth` (`type`).
  IpCmd type(String value) => pair('type', value);

  /// The device name, for `link add` (`name`).
  IpCmd name(String value) => pair('name', value);

  /// Adds a bare argument: an address, a prefix, an object name.
  IpCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
IpCmd get Ip => IpCmd();
