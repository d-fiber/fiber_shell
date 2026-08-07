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

/// `ufw`, the uncomplicated firewall, a front end to netfilter shipped by
/// Debian and Ubuntu, installable elsewhere. Linux only, and it manages the same
/// tables [IptablesCmd] does, so driving both at once is how you end up with a
/// ruleset nobody can read.
///
/// ```dart
/// await Ufw.allow().arg('22/tcp').asRoot().execute();
/// await Ufw.defaultPolicy().deny().incoming().asRoot().execute();
/// await Ufw.enable().force().asRoot().execute();
/// ```
///
/// **[enable] on a remote machine will lock you out** unless SSH is allowed
/// first. The order in the example above is not an accident.
///
/// [enable] and [reset] ask for confirmation; [force] is what an unattended run
/// needs. Every command wants `asRoot()`.
///
/// The rule grammar reads as English, `allow from 10.0.0.0/8 to any port 5432
/// proto tcp`, so the methods here mirror those words rather than inventing
/// flags.
class UfwCmd extends CommandBuilder<UfwCmd> {
  @override
  final String executable = 'ufw';

  /// Loads the rules and turns the firewall on at boot (`enable`).
  UfwCmd enable() => token('enable');

  /// Unloads the rules and stops it starting at boot (`disable`).
  UfwCmd disable() => token('disable');

  /// Reloads the rules (`reload`).
  UfwCmd reload() => token('reload');

  /// Disables the firewall and throws every rule away (`reset`).
  UfwCmd reset() => token('reset');

  /// Prints the state and the rules (`status`).
  UfwCmd status() => token('status');

  /// Prints a report: `raw`, `added`, `listening`, `logging-raw` (`show`).
  UfwCmd show() => token('show');

  /// Allows the traffic that follows (`allow`).
  UfwCmd allow() => token('allow');

  /// Drops the traffic silently (`deny`).
  UfwCmd deny() => token('deny');

  /// Refuses the traffic and tells the sender (`reject`).
  UfwCmd reject() => token('reject');

  /// Allows the traffic but rate-limits repeat connections (`limit`).
  ///
  /// Six connections in thirty seconds and the source is dropped, the usual
  /// answer to SSH brute forcing.
  UfwCmd limit() => token('limit');

  /// Deletes a rule, by number or by repeating it (`delete`).
  UfwCmd delete() => token('delete');

  /// Inserts a rule at this position (`insert`).
  UfwCmd insert(String number) => pair('insert', number);

  /// Puts a rule before the existing ones (`prepend`).
  UfwCmd prepend() => token('prepend');

  /// Sets a default policy (`default`).
  UfwCmd defaultPolicy() => token('default');

  /// Turns logging on or off, or sets its level (`logging`).
  UfwCmd logging() => token('logging');

  /// Manages the application profiles: `list`, `info`, `default`, `update` (`app`).
  UfwCmd app() => token('app');

  /// Adds the rule numbers to [status], which [delete] then takes (`numbered`).
  UfwCmd numbered() => token('numbered');

  /// Makes [status] show the defaults and the logging level too (`verbose`).
  UfwCmd verbose() => token('verbose');

  /// Prints the rules that would be applied and changes nothing (`--dry-run`).
  UfwCmd dryRun() => token('--dry-run');

  /// Skips the confirmation prompt (`--force`).
  UfwCmd force() => token('--force');

  /// The rule applies to incoming traffic (`in`).
  UfwCmd inbound() => token('in');

  /// The rule applies to outgoing traffic (`out`).
  UfwCmd outbound() => token('out');

  /// The rule applies to this interface (`on`).
  UfwCmd onInterface(String name) => pair('on', name);

  /// The source address or network (`from`). `any` for everywhere.
  UfwCmd from(String value) => pair('from', value);

  /// The destination address or network (`to`).
  UfwCmd to(String value) => pair('to', value);

  /// The port, or a range written `6000:6007` (`port`).
  UfwCmd port(String value) => pair('port', value);

  /// The protocol: `tcp`, `udp` (`proto`).
  UfwCmd proto(String value) => pair('proto', value);

  /// A note kept with the rule (`comment`).
  ///
  /// Cheap, and the difference between a readable ruleset and archaeology.
  UfwCmd comment(String value) => pair('comment', value);

  /// The default policy applies to incoming traffic (`incoming`).
  UfwCmd incoming() => token('incoming');

  /// The default policy applies to outgoing traffic (`outgoing`).
  UfwCmd outgoing() => token('outgoing');

  /// The default policy applies to forwarded traffic (`routed`).
  UfwCmd routed() => token('routed');

  /// Adds a bare argument: a port, a service name, an application profile.
  UfwCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
UfwCmd get Ufw => UfwCmd();
