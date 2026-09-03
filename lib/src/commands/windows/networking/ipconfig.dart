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

/// `ipconfig`, the network configuration viewer, the counterpart of `ip` on
/// Linux and `ifconfig` on macOS. Windows only.
///
/// ```dart
/// final ShellResult renewed = await Ipconfig.release().and(Ipconfig.renew()).output();
/// ```
///
/// Plain `ipconfig` with no flag prints the short summary; [all] is what a
/// script parses, since it is the only form that includes the adapter's
/// physical address and DHCP/DNS server list.
///
/// [release] and [renew] touch every adapter unless an adapter name is passed
/// with [adapter]; on a machine with several NICs that means a moment with no
/// network at all on any of them, not just the one intended.
///
/// Every documented switch: `/allcompartments`, `/all`, `/renew`, `/release`,
/// `/renew6`, `/release6`, `/flushdns`, `/displaydns`, `/registerdns`,
/// `/showclassid`, `/setclassid`.
class IpconfigCmd extends CommandBuilder<IpconfigCmd> {
  @override
  final String executable = 'ipconfig';

  /// Shows every routing compartment, not only the current one
  /// (`/allcompartments`). Server SKUs with the NAT role only.
  IpconfigCmd allCompartments() => token('/allcompartments');

  /// The full, verbose listing, DHCP and DNS servers included (`/all`).
  IpconfigCmd all() => token('/all');

  /// Restricts the command to one adapter, by its friendly name. Comes after
  /// the subcommand, wildcards allowed.
  IpconfigCmd adapter(String name) => token(name);

  /// Releases the DHCP lease on IPv4 adapters (`/release`).
  IpconfigCmd release() => token('/release');

  /// The IPv6 counterpart (`/release6`).
  IpconfigCmd release6() => token('/release6');

  /// Renews the DHCP lease on IPv4 adapters (`/renew`).
  IpconfigCmd renew() => token('/renew');

  /// The IPv6 counterpart (`/renew6`).
  IpconfigCmd renew6() => token('/renew6');

  /// Flushes the DNS resolver cache (`/flushdns`).
  IpconfigCmd flushDns() => token('/flushdns');

  /// Prints the DNS resolver cache (`/displaydns`).
  IpconfigCmd displayDns() => token('/displaydns');

  /// Re-registers the machine's name and addresses with DNS (`/registerdns`).
  IpconfigCmd registerDns() => token('/registerdns');

  /// Prints the DHCP class ID of an adapter (`/showclassid`).
  IpconfigCmd showClassId() => token('/showclassid');

  /// Sets it; an empty [value] removes it (`/setclassid`).
  IpconfigCmd setClassId(String value) => pair('/setclassid', value);
}

/// `ipconfig`, ready to take its first option.
// ignore: non_constant_identifier_names
IpconfigCmd get Ipconfig => IpconfigCmd();
