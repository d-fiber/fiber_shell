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

/// `iptables`, the netfilter rule tool. Linux only. `ip6tables` is the same
/// program under another name for IPv6, and `nftables` is what replaces both on
/// current distributions, where `iptables` is often a compatibility shim over
/// it rather than the real thing.
///
/// ```dart
/// await Iptables
///     .table('nat')
///     .append('POSTROUTING')
///     .outInterface('eth0')
///     .source('10.8.0.0/24')
///     .jump('MASQUERADE')
///     .asRoot()
///     .execute();
/// ```
///
/// **A rule set this way disappears at the next reboot.** Persisting it means
/// `iptables-save` into a file the distribution reloads at boot, which is a
/// separate step nobody remembers until the machine restarts.
///
/// [check] is the one worth knowing: same arguments as [append], but it only
/// asks whether the rule is already there and answers through the exit status.
/// It is how you write a provisioning step that can run twice.
///
/// [wait] matters as soon as two things touch the firewall at once; without it
/// a concurrent run fails on the lock instead of queueing behind it.
///
/// Everything here wants `asRoot()`.
class IptablesCmd extends CommandBuilder<IptablesCmd> {
  @override
  final String executable = 'iptables';

  /// Adds a rule at the end of a chain (`--append`).
  IptablesCmd append(String chain) => pair('--append', chain);

  /// Asks whether a rule exists, answering through the status (`--check`).
  IptablesCmd check(String chain) => pair('--check', chain);

  /// Removes a rule, by specification or by number (`--delete`).
  IptablesCmd delete(String chain) => pair('--delete', chain);

  /// Inserts a rule at the top of a chain, or at a position (`--insert`).
  IptablesCmd insert(String chain) => pair('--insert', chain);

  /// Replaces the rule at a position (`--replace`).
  IptablesCmd replace(String chain) => pair('--replace', chain);

  /// Lists the rules of a chain, or of every chain (`--list`).
  IptablesCmd list() => token('--list');

  /// Lists the rules as the commands that would recreate them (`--list-rules`).
  ///
  /// The form to compare or store; [list] is laid out for reading.
  IptablesCmd listRules() => token('--list-rules');

  /// Empties a chain (`--flush`).
  IptablesCmd flush() => token('--flush');

  /// Resets the packet and byte counters (`--zero`).
  IptablesCmd zero() => token('--zero');

  /// Creates a chain of your own (`--new-chain`).
  IptablesCmd newChain(String name) => pair('--new-chain', name);

  /// Deletes an empty chain of your own (`--delete-chain`).
  IptablesCmd deleteChain(String name) => pair('--delete-chain', name);

  /// Sets the default action of a built-in chain (`--policy`).
  IptablesCmd policy(String chain) => pair('--policy', chain);

  /// Renames a chain (`--rename-chain`).
  IptablesCmd renameChain(String name) => pair('--rename-chain', name);

  /// Which table: `filter`, `nat`, `mangle`, `raw`, `security` (`--table`).
  ///
  /// Comes first. Left out it means `filter`, which is why a NAT rule written
  /// without it silently lands in the wrong place.
  IptablesCmd table(String name) => pair('--table', name);

  /// Matches this protocol: `tcp`, `udp`, `icmp`, `all` (`--protocol`).
  IptablesCmd protocol(String value) => pair('--protocol', value);

  /// Matches this source address or network (`--source`).
  IptablesCmd source(String value) => pair('--source', value);

  /// Matches this destination address or network (`--destination`).
  IptablesCmd destination(String value) => pair('--destination', value);

  /// What to do with a matching packet: `ACCEPT`, `DROP`, `MASQUERADE`… (`--jump`).
  IptablesCmd jump(String target) => pair('--jump', target);

  /// Continues in a chain of your own without coming back (`--goto`).
  IptablesCmd gotoChain(String name) => pair('--goto', name);

  /// Matches packets arriving on this interface (`--in-interface`).
  IptablesCmd inInterface(String name) => pair('--in-interface', name);

  /// Matches packets leaving on this interface (`--out-interface`).
  IptablesCmd outInterface(String name) => pair('--out-interface', name);

  /// Matches the fragments after the first (`--fragment`).
  IptablesCmd fragment() => token('--fragment');

  /// Presets the packet and byte counters (`--set-counters`).
  IptablesCmd setCounters(String value) => pair('--set-counters', value);

  /// Loads a match extension: `state`, `conntrack`, `multiport`… (`--match`).
  IptablesCmd match(String name) => pair('--match', name);

  /// The destination port, once a protocol is set (`--dport`).
  IptablesCmd destinationPort(String value) => pair('--dport', value);

  /// The source port (`--sport`).
  IptablesCmd sourcePort(String value) => pair('--sport', value);

  /// The connection states to match, with `--match state` (`--state`).
  IptablesCmd state(String value) => pair('--state', value);

  /// The connection states to match, with `--match conntrack` (`--ctstate`).
  IptablesCmd ctState(String value) => pair('--ctstate', value);

  /// Where a `DNAT` target should send the packet (`--to-destination`).
  IptablesCmd toDestination(String value) => pair('--to-destination', value);

  /// What a `SNAT` target should rewrite the source to (`--to-source`).
  IptablesCmd toSource(String value) => pair('--to-source', value);

  /// The ports a `REDIRECT` or `MASQUERADE` target should use (`--to-ports`).
  IptablesCmd toPorts(String value) => pair('--to-ports', value);

  /// Prints more about each rule, counters included (`--verbose`).
  IptablesCmd verbose() => token('--verbose');

  /// Prints addresses and ports as numbers, skipping every lookup (`--numeric`).
  ///
  /// Also makes listing fast: without it iptables does a reverse DNS lookup per
  /// address.
  IptablesCmd numeric() => token('--numeric');

  /// Prints the counters exactly rather than rounded (`--exact`).
  IptablesCmd exact() => token('--exact');

  /// Waits for the netfilter lock instead of failing (`--wait`).
  IptablesCmd wait() => token('--wait');

  /// Numbers the rules when listing (`--line-numbers`).
  IptablesCmd lineNumbers() => token('--line-numbers');

  /// The command to load kernel modules with (`--modprobe`).
  IptablesCmd modprobe(String path) => pair('--modprobe', path);

  /// Adds a bare argument: a rule number, a match option, a target option.
  IptablesCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
IptablesCmd get Iptables => IptablesCmd();
