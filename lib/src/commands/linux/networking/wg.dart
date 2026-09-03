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

/// `wg`, the WireGuard configuration tool. The kernel module is Linux, so this
/// is Linux; the userspace implementations elsewhere ship their own tooling.
/// `wg-quick` is the script that brings an interface up from a config file; this
/// is the low-level tool underneath it.
///
/// ```dart
/// final ShellResult key = await Wg.genkey().output();
/// final ShellResult pub = await Wg.pubkey().output(input: key.text);
/// ```
///
/// That pair is the whole key ceremony: [genkey] writes a private key to stdout,
/// [pubkey] reads one from **stdin** and writes the public half. Nothing is
/// stored, so whatever you do not capture is gone.
///
/// **[showAll] and [showConf] print private keys.** A log that captures the
/// output of a `wg show` is a log that contains the server's identity. [dump] is
/// the parseable form, and it holds the private key too.
///
/// [setConf] replaces the whole configuration and drops every live session;
/// [syncConf] applies the difference and leaves the connected peers alone. On a
/// running VPN that distinction is the one users notice.
///
/// Everything but [genkey], [genpsk] and [pubkey] wants `asRoot()`.
class WgCmd extends CommandBuilder<WgCmd> {
  @override
  final String executable = 'wg';

  /// Prints the configuration and the runtime state (`show`).
  WgCmd show() => token('show');

  /// Prints the configuration in the `.conf` format (`showconf`).
  WgCmd showConf() => token('showconf');

  /// Changes the configuration of an interface (`set`).
  WgCmd set() => token('set');

  /// Replaces the whole configuration from a file (`setconf`).
  WgCmd setConf() => token('setconf');

  /// Adds the contents of a file to the configuration (`addconf`).
  WgCmd addConf() => token('addconf');

  /// Applies the difference, keeping the live sessions (`syncconf`).
  WgCmd syncConf() => token('syncconf');

  /// Writes a new private key to stdout (`genkey`).
  WgCmd genkey() => token('genkey');

  /// Writes a new preshared key to stdout (`genpsk`).
  WgCmd genpsk() => token('genpsk');

  /// Reads a private key on stdin and writes its public key (`pubkey`).
  WgCmd pubkey() => token('pubkey');

  /// Lists the WireGuard interfaces (`interfaces`).
  WgCmd interfaces() => token('interfaces');

  /// Every interface (`all`).
  WgCmd showAll() => token('all');

  /// The tab-separated form, meant for a script (`dump`).
  WgCmd dump() => token('dump');

  /// The public key of the interface (`public-key`).
  WgCmd publicKeyField() => token('public-key');

  /// The private key of the interface (`private-key`).
  WgCmd privateKeyField() => token('private-key');

  /// The UDP port the interface listens on (`listen-port`).
  WgCmd listenPortField() => token('listen-port');

  /// The firewall mark of the outgoing packets (`fwmark`).
  WgCmd fwmarkField() => token('fwmark');

  /// The public keys of the peers (`peers`).
  WgCmd peersField() => token('peers');

  /// Which peers have a preshared key (`preshared-keys`).
  WgCmd presharedKeysField() => token('preshared-keys');

  /// The endpoint of each peer (`endpoints`).
  WgCmd endpointsField() => token('endpoints');

  /// The allowed ranges of each peer (`allowed-ips`).
  WgCmd allowedIpsField() => token('allowed-ips');

  /// When each peer last completed a handshake (`latest-handshakes`).
  ///
  /// The honest readiness check for a tunnel: a peer configured but never seen
  /// reports zero.
  WgCmd latestHandshakesField() => token('latest-handshakes');

  /// The keepalive interval of each peer (`persistent-keepalive`).
  WgCmd persistentKeepaliveField() => token('persistent-keepalive');

  /// The bytes sent and received per peer (`transfer`).
  WgCmd transferField() => token('transfer');

  /// The UDP port to listen on (`listen-port`, with a value).
  WgCmd listenPort(String value) => pair('listen-port', value);

  /// The firewall mark to stamp on outgoing packets (`fwmark`, with a value).
  WgCmd fwmark(String value) => pair('fwmark', value);

  /// The file holding the private key (`private-key`, with a path).
  ///
  /// A path, not the key: it never reaches the process arguments that way.
  WgCmd privateKey(String path) => pair('private-key', path);

  /// The peer the options that follow apply to, by public key (`peer`).
  WgCmd peer(String publicKey) => pair('peer', publicKey);

  /// Deletes the peer named by [peer] rather than configuring it (`remove`).
  WgCmd remove() => token('remove');

  /// The file holding the preshared key for this peer (`preshared-key`).
  WgCmd presharedKey(String path) => pair('preshared-key', path);

  /// The address and port to reach this peer at (`endpoint`).
  WgCmd endpoint(String value) => pair('endpoint', value);

  /// How often to send a keepalive, in seconds (`persistent-keepalive`, with a value).
  ///
  /// What keeps a peer behind NAT reachable; `25` is the usual answer.
  WgCmd persistentKeepalive(String seconds) => pair('persistent-keepalive', seconds);

  /// The ranges routed to this peer, comma separated (`allowed-ips`).
  ///
  /// It is the routing table and the access control list at once: a packet from a
  /// peer is dropped unless its source falls inside this list.
  WgCmd allowedIps(String value) => pair('allowed-ips', value);

  /// The interface name, or another bare argument.
  WgCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
WgCmd get Wg => WgCmd();
