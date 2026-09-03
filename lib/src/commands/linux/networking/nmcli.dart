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

/// `nmcli`, the NetworkManager command-line client. Linux only, and only on
/// the (large majority of) distributions that run NetworkManager rather than
/// `systemd-networkd` or a hand-rolled `ip`/`wpa_supplicant` setup.
///
/// ```dart
/// final ShellResult wifi = await Nmcli.terse().fields(['SSID', 'SIGNAL']).device().wifi().list().output();
/// await Nmcli.connection().up().arg('office-vpn').asRoot().output();
/// ```
///
/// The grammar is object then command, same shape as `IpCmd`: `nmcli device
/// wifi list`, `nmcli connection up id office-vpn`. This wrapper names the
/// seven objects (`general`, `networking`, `radio`, `connection`, `device`,
/// `agent`, `monitor`) and their common commands as methods; [arg] carries
/// anything else — identifiers, property names, `key value` pairs.
///
/// [terse] is the flag that turns this into something parseable: without it,
/// `nmcli` writes a column layout meant for a terminal and will even wrap
/// long values. Pair it with [fields] to pin the column order, since the
/// default set is not guaranteed to stay the same across versions.
///
/// Reading is unprivileged; bringing connections or devices up or down, and
/// anything under `connection modify`, wants `asRoot()`.
class NmcliCmd extends CommandBuilder<NmcliCmd> {
  @override
  final String executable = 'nmcli';

  /// Terse, script-friendly output: one value per line, colon separated
  /// (`-t`, `--terse`). The flag that makes [fields] worth setting.
  NmcliCmd terse() => token('--terse');

  /// Pretty, human-friendly output with headers and borders, the default in a
  /// terminal (`-p`, `--pretty`).
  NmcliCmd pretty() => token('--pretty');

  /// The output layout: `tabular` or `multiline` (`-m`, `--mode`).
  NmcliCmd mode(String value) => pair('--mode', value);

  /// Restricts the output to these fields, comma separated, and fixes their
  /// order; `all` and `common` are also accepted (`-f`, `--fields`).
  NmcliCmd fields(List<String> names) => joinedAll('--fields', names);

  /// Under [terse], prints only the value of each field, dropping the
  /// `FIELD:` prefix (`-g`, `--get-values`).
  NmcliCmd getValues(List<String> names) => joinedAll('--get-values', names);

  /// Whether to backslash-escape `:` and `\` under [terse]: `yes` or `no`
  /// (`-e`, `--escape`).
  NmcliCmd escape(String value) => pair('--escape', value);

  /// Whether to colourise the output: `auto`, `yes` or `no` (`-c`, `--colors`).
  NmcliCmd colors(String value) => pair('--colors', value);

  /// Prompts for any missing argument instead of failing (`-a`, `--ask`).
  /// Interactive, not for a script.
  NmcliCmd ask() => token('--ask');

  /// Includes secrets, such as a Wi-Fi password, in the output (`-s`,
  /// `--show-secrets`).
  NmcliCmd showSecrets() => token('--show-secrets');

  /// Waits up to this many seconds for the operation to finish before
  /// returning; `0` waits forever (`-w`, `--wait`).
  NmcliCmd wait(int seconds) => pair('--wait', '$seconds');

  /// Works without the NetworkManager daemon, reading and writing connection
  /// data through stdin and stdout (`--offline`).
  NmcliCmd offline() => token('--offline');

  /// Lists the completions for the last argument, for shell integration
  /// (`--complete-args`).
  NmcliCmd completeArgs() => token('--complete-args');

  /// NetworkManager status and system-level settings (`general`): [status],
  /// [hostname], [permissions], [logging], [reload].
  NmcliCmd general() => token('general');

  /// Overall networking control (`networking`): [on_], [off], [connectivity].
  NmcliCmd networking() => token('networking');

  /// The Wi-Fi and WWAN radio switches (`radio`): [all], [wifi], [wwan].
  NmcliCmd radio() => token('radio');

  /// Connection profiles (`connection`): [show], [up], [down], [add],
  /// [modify], [edit], [clone], [delete], [monitor], [reload], [load],
  /// [import_], [export_], [migrate].
  NmcliCmd connection() => token('connection');

  /// Devices managed by NetworkManager (`device`): [status], [show], [set],
  /// [up], [connect], [reapply], [modify], [down], [disconnect], [delete],
  /// [monitor], [wifi], [lldp].
  NmcliCmd device() => token('device');

  /// Runs as a secret or PolicyKit agent (`agent`): [secret], [polkit],
  /// [all].
  NmcliCmd agent() => token('agent');

  /// Watches for changes in connectivity, devices or connection profiles
  /// (`monitor`). Takes no further command; add a [device] or [connection]
  /// name to narrow it.
  NmcliCmd monitor() => token('monitor');

  /// Prints the overall status (`general status`, `device status`).
  NmcliCmd status() => token('status');

  /// Gets, or with an argument sets, the system hostname (`general
  /// hostname`).
  NmcliCmd hostname() => token('hostname');

  /// Prints the caller's authorization for NetworkManager operations
  /// (`general permissions`).
  NmcliCmd permissions() => token('permissions');

  /// Gets, or sets, the logging level and domains (`general logging`).
  NmcliCmd logging() => token('logging');

  /// Reloads NetworkManager's configuration (`general reload`, `connection
  /// reload`).
  NmcliCmd reload() => token('reload');

  /// Turns networking on (`networking on`, `radio wifi on`, `radio wwan on`,
  /// `radio all on`).
  NmcliCmd on_() => token('on');

  /// Turns networking off, the counterpart to [on_] (`networking off`, and
  /// the same for [radio]'s objects).
  NmcliCmd off() => token('off');

  /// Prints, or with `check` re-probes, the connectivity state: `none`,
  /// `portal`, `limited`, `full`, `unknown` (`networking connectivity`).
  NmcliCmd connectivity() => token('connectivity');

  /// Every radio switch at once, as the object for [on_] and [off]
  /// (`radio all`).
  NmcliCmd all() => token('all');

  /// The Wi-Fi radio switch, or Wi-Fi access points under [device]
  /// (`radio wifi`, `device wifi`).
  NmcliCmd wifi() => token('wifi');

  /// The WWAN (mobile broadband) radio switch (`radio wwan`).
  NmcliCmd wwan() => token('wwan');

  /// Lists or shows connection profiles or devices (`connection show`,
  /// `device show`).
  NmcliCmd show() => token('show');

  /// Activates a connection, or brings a device up with a suitable one
  /// (`connection up`, `device up`).
  NmcliCmd up() => token('up');

  /// Deactivates a connection, or takes a device down and prevents
  /// auto-activation (`connection down`, `device down`).
  NmcliCmd down() => token('down');

  /// Creates a new connection profile (`connection add`).
  NmcliCmd add() => token('add');

  /// Changes properties of an existing connection profile (`connection
  /// modify`), or makes a temporary, unsaved change to a device (`device
  /// modify`).
  NmcliCmd modify() => token('modify');

  /// Opens the interactive connection editor (`connection edit`).
  /// Interactive, not for a script.
  NmcliCmd edit() => token('edit');

  /// Duplicates an existing connection profile under a new name (`connection
  /// clone`).
  NmcliCmd clone() => token('clone');

  /// Removes a connection profile, or a software device such as a bond or
  /// bridge (`connection delete`, `device delete`).
  NmcliCmd delete() => token('delete');

  /// Loads specific connection profile files from disk (`connection load`).
  NmcliCmd load() => token('load');

  /// Imports a foreign configuration, such as an OpenVPN or WireGuard file,
  /// as a new connection profile (`connection import`). Takes a VPN `type`
  /// and a `file` through [arg].
  NmcliCmd import_() => token('import');

  /// Exports a connection profile to an external format (`connection
  /// export`). Takes the profile identifier through [arg].
  NmcliCmd export_() => token('export');

  /// Converts connection profiles between storage plugins, such as keyfile
  /// and ifcfg-rh (`connection migrate`).
  NmcliCmd migrate() => token('migrate');

  /// Prints or changes a device's autoconnect and managed-state properties
  /// (`device set`).
  NmcliCmd set() => token('set');

  /// The same as [up], phrased as a verb rather than a state (`device
  /// connect`).
  NmcliCmd connect() => token('connect');

  /// Applies a connection profile's current settings to an already-active
  /// device, without a full reactivation (`device reapply`).
  NmcliCmd reapply() => token('reapply');

  /// The same as [down], phrased as a verb (`device disconnect`).
  NmcliCmd disconnect() => token('disconnect');

  /// Lists visible LLDP neighbours for a device (`device lldp`).
  NmcliCmd lldp() => token('lldp');

  /// Lists visible Wi-Fi access points (`device wifi list`).
  NmcliCmd list() => token('list');

  /// Creates and activates a Wi-Fi hotspot profile (`device wifi hotspot`).
  NmcliCmd hotspot() => token('hotspot');

  /// Triggers a manual Wi-Fi scan (`device wifi rescan`).
  NmcliCmd rescan() => token('rescan');

  /// Reveals the password of the currently active Wi-Fi network (`device
  /// wifi show-password`).
  NmcliCmd showPassword() => token('show-password');

  /// Runs as NetworkManager's secret agent, supplying stored secrets on
  /// request (`agent secret`).
  NmcliCmd secret() => token('secret');

  /// Runs as a PolicyKit authorization agent (`agent polkit`).
  NmcliCmd polkit() => token('polkit');

  /// Adds a bare argument: an identifier (`id`, `uuid`, `path`, `ifname`), a
  /// property name, a `key value` pair, or a connection/device name.
  NmcliCmd arg(String value) => token(value);

  /// Prints the version (`-v`, `--version`).
  NmcliCmd version() => token('--version');

  /// Prints the usage summary (`-h`, `--help`).
  NmcliCmd help() => token('--help');
}

/// `nmcli`, ready to take its first option or object.
// ignore: non_constant_identifier_names
NmcliCmd get Nmcli => NmcliCmd();
