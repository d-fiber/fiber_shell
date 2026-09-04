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

/// `ethtool`, the Linux NIC configuration and diagnostics tool. Linux only —
/// it talks to the kernel's ethtool ioctl/netlink interface, which has no
/// equivalent elsewhere.
///
/// ```dart
/// final ShellResult link = await Ethtool.device('eth0').output();
/// await Ethtool.change().device('eth0').param('speed', '1000').param('duplex', 'full').param('autoneg', 'off').asRoot().execute();
/// ```
///
/// Almost every sub-mode (`-s`/[change], `-K`/[features], `-C`/[coalesce], and
/// the rest) takes its own open-ended list of `key value` pairs after the
/// device name — dozens across the tool as a whole, and new ones ship with
/// every kernel release. Rather than one method per sub-key, this wrapper
/// gives each mode its own selector method and [param]/[flag] as the generic
/// way to add the pairs that follow it: `Ethtool.change().device('eth0')
/// .param('speed', '1000').param('autoneg', 'off')`. Reading link state needs
/// no privilege; anything that changes settings, flashes firmware, or resets
/// hardware wants root.
class EthtoolCmd extends CommandBuilder<EthtoolCmd> {
  @override
  final String executable = 'ethtool';

  /// Prints the usage summary (`-h`, `--help`).
  EthtoolCmd help() => token('--help');

  /// Prints the version (`--version`).
  EthtoolCmd version() => token('--version');

  /// Sets the debug mask, a bitmask from 0x01 to 0x10 (`--debug`).
  EthtoolCmd debug(String mask) => pair('--debug', mask);

  /// Talks to the kernel through the legacy ioctl interface instead of netlink (`--disable-netlink`).
  EthtoolCmd disableNetlink() => token('--disable-netlink');

  /// Renders output as JSON instead of text (`--json`).
  EthtoolCmd json() => token('--json');

  /// Includes statistics alongside the requested information (`-I`, `--include-statistics`).
  EthtoolCmd includeStatistics() => token('--include-statistics');

  /// Targets this specific PHY device instead of the default (`--phy`).
  EthtoolCmd phy(int index) => pair('--phy', '$index');

  /// Queries driver information: driver name, version, firmware version, bus info (`-i`, `--driver`).
  EthtoolCmd driver() => token('--driver');

  /// Shows the permanent hardware address, unaffected by a locally set one (`-P`, `--show-permaddr`).
  EthtoolCmd showPermaddr() => token('--show-permaddr');

  /// Retrieves the register dump (`-d`, `--register-dump`).
  EthtoolCmd registerDump() => token('--register-dump');

  /// Retrieves EEPROM contents (`-e`, `--eeprom-dump`).
  EthtoolCmd eepromDump() => token('--eeprom-dump');

  /// Changes EEPROM bytes; use [param] for `magic`, `offset`, `length`, `value` (`-E`, `--change-eeprom`).
  EthtoolCmd changeEeprom() => token('--change-eeprom');

  /// Decodes a transceiver module's EEPROM (`-m`, `--dump-module-eeprom`).
  EthtoolCmd dumpModuleEeprom() => token('--dump-module-eeprom');

  /// Changes link settings; use [param] for `speed`, `duplex`, `port`, `autoneg`, `mdix`, `advertise`, `wol` and the rest (`-s`, `--change`).
  EthtoolCmd change() => token('--change');

  /// Queries pause parameters (`-a`, `--show-pause`).
  EthtoolCmd showPause() => token('--show-pause');

  /// Changes pause parameters; use [param] for `autoneg`, `rx`, `tx` (`-A`, `--pause`).
  EthtoolCmd pause() => token('--pause');

  /// Queries interrupt coalescing settings (`-c`, `--show-coalesce`).
  EthtoolCmd showCoalesce() => token('--show-coalesce');

  /// Changes interrupt coalescing settings; use [param] for `rx-usecs`, `tx-usecs`, `adaptive-rx` and the rest (`-C`, `--coalesce`).
  EthtoolCmd coalesce() => token('--coalesce');

  /// Queries ring buffer sizes (`-g`, `--show-ring`).
  EthtoolCmd showRing() => token('--show-ring');

  /// Changes ring buffer sizes; use [param] for `rx`, `tx`, `rx-mini`, `rx-jumbo` (`-G`, `--set-ring`).
  EthtoolCmd setRing() => token('--set-ring');

  /// Queries protocol offload and feature state (`-k`, `--show-features`).
  EthtoolCmd showFeatures() => token('--show-features');

  /// Changes offload features; use [param] for `tso`, `gso`, `gro`, `rx`, `tx`, `sg` and the rest, each `on`/`off` (`-K`, `--features`).
  EthtoolCmd features() => token('--features');

  /// Queries device statistics; [param] `--all-groups` or `--groups` narrows which (`-S`, `--statistics`).
  EthtoolCmd statistics() => token('--statistics');

  /// Queries PHY-specific statistics (`--phy-statistics`).
  EthtoolCmd phyStatistics() => token('--phy-statistics');

  /// Runs the adapter self-test; [param] `offline`, `online` or `external_lb` picks the kind (`-t`, `--test`).
  EthtoolCmd test() => token('--test');

  /// Shows flow classification (RX hash / N-tuple) rules (`-n`, `-u`, `--show-nfc`).
  EthtoolCmd showNfc() => token('--show-nfc');

  /// Configures flow classification rules; use [param] for `flow-type`, `src-ip`, `dst-port`, `action` and the rest (`-N`, `-U`, `--config-nfc`).
  EthtoolCmd configNfc() => token('--config-nfc');

  /// Shows the RX flow hash indirection table and key (`-x`, `--show-rxfh`).
  EthtoolCmd showRxfh() => token('--show-rxfh');

  /// Configures the RX flow hash indirection table; use [param] for `equal`, `weight`, `hkey`, `hfunc`, `context` (`-X`, `--set-rxfh`).
  EthtoolCmd setRxfh() => token('--set-rxfh');

  /// Blinks the adapter's identification LEDs; an optional [param] gives the duration in seconds (`-p`, `--identify`).
  EthtoolCmd identify() => token('--identify');

  /// Restarts autonegotiation on the link (`-r`, `--negotiate`).
  EthtoolCmd negotiate() => token('--negotiate');

  /// Retrieves a firmware dump; [param] `data` names the output file (`-w`, `--get-dump`).
  EthtoolCmd getDump() => token('--get-dump');

  /// Sets the firmware dump flag to this value (`-W`, `--set-dump`).
  EthtoolCmd setDump(String value) => pair('--set-dump', value);

  /// Flashes a firmware image file onto the device; an optional region number follows (`-f`, `--flash`).
  EthtoolCmd flash(String file) => pair('--flash', file);

  /// Queries channel (queue) counts (`-l`, `--show-channels`).
  EthtoolCmd showChannels() => token('--show-channels');

  /// Changes channel counts; use [param] for `rx`, `tx`, `other`, `combined` (`-L`, `--set-channels`).
  EthtoolCmd setChannels() => token('--set-channels');

  /// Shows PTP hardware timestamping capabilities (`-T`, `--show-time-stamping`).
  EthtoolCmd showTimeStamping() => token('--show-time-stamping');

  /// Shows the hardware timestamping configuration (`--get-hwtimestamp-cfg`).
  EthtoolCmd getHwtimestampCfg() => token('--get-hwtimestamp-cfg');

  /// Sets the hardware timestamping configuration; use [param] for `tx`, `rx-filter` (`--set-hwtimestamp-cfg`).
  EthtoolCmd setHwtimestampCfg() => token('--set-hwtimestamp-cfg');

  /// Shows driver-private flags (`--show-priv-flags`).
  EthtoolCmd showPrivFlags() => token('--show-priv-flags');

  /// Sets a driver-private flag; use [param] for the flag name and `on`/`off` (`--set-priv-flags`).
  EthtoolCmd setPrivFlags() => token('--set-priv-flags');

  /// Shows Energy Efficient Ethernet settings (`--show-eee`).
  EthtoolCmd showEee() => token('--show-eee');

  /// Changes Energy Efficient Ethernet settings; use [param] for `eee`, `tx-lpi`, `tx-timer`, `advertise` (`--set-eee`).
  EthtoolCmd setEee() => token('--set-eee');

  /// Sets a PHY tunable; use [param] for `downshift`, `fast-link-down`, `energy-detect-power-down` (`--set-phy-tunable`).
  EthtoolCmd setPhyTunable() => token('--set-phy-tunable');

  /// Queries a PHY tunable by [param] name (`--get-phy-tunable`).
  EthtoolCmd getPhyTunable() => token('--get-phy-tunable');

  /// Queries a driver tunable by [param] name, e.g. `rx-copybreak` (`--get-tunable`).
  EthtoolCmd getTunable() => token('--get-tunable');

  /// Sets a driver tunable; use [param] for the name and value (`--set-tunable`).
  EthtoolCmd setTunable() => token('--set-tunable');

  /// Resets hardware components; use [flag] for named components (`mgmt`, `irq`, `dma`, `all`, ...) or [param] for a raw `flags` mask (`--reset`).
  EthtoolCmd reset() => token('--reset');

  /// Shows Forward Error Correction support and state (`--show-fec`).
  EthtoolCmd showFec() => token('--show-fec');

  /// Sets the FEC encoding; use [param] `encoding` with `auto`, `off`, `rs`, `baser` or `llrs` (`--set-fec`).
  EthtoolCmd setFec() => token('--set-fec');

  /// Restricts a following show/set-coalesce call to specific queues; use [param] `queue_mask` (`-Q`, `--per-queue`).
  EthtoolCmd perQueue() => token('--per-queue');

  /// Runs a basic cable test (`--cable-test`).
  EthtoolCmd cableTest() => token('--cable-test');

  /// Runs a Time Domain Reflectometer cable test; use [param] for `first`, `last`, `step`, `pair` (`--cable-test-tdr`).
  EthtoolCmd cableTestTdr() => token('--cable-test-tdr');

  /// Listens to netlink notifications for device changes (`--monitor`).
  EthtoolCmd monitor() => token('--monitor');

  /// Shows tunnel offload capabilities (`--show-tunnels`).
  EthtoolCmd showTunnels() => token('--show-tunnels');

  /// Displays transceiver module parameters (`--show-module`).
  EthtoolCmd showModule() => token('--show-module');

  /// Configures transceiver module parameters; use [param] `power-mode-policy` with `high` or `auto` (`--set-module`).
  EthtoolCmd setModule() => token('--set-module');

  /// Flashes transceiver module firmware from a file; use [param] for `pass` (`--flash-module-firmware`).
  EthtoolCmd flashModuleFirmware(String file) => pair('--flash-module-firmware', file);

  /// Shows the PLCA (Physical Layer Collision Avoidance) configuration (`--get-plca-cfg`).
  EthtoolCmd getPlcaCfg() => token('--get-plca-cfg');

  /// Sets the PLCA configuration; use [param] for `enable`, `node-id`, `node-cnt`, `to-tmr`, `burst-cnt`, `burst-tmr` (`--set-plca-cfg`).
  EthtoolCmd setPlcaCfg() => token('--set-plca-cfg');

  /// Shows the PLCA status (`--get-plca-status`).
  EthtoolCmd getPlcaStatus() => token('--get-plca-status');

  /// Shows the MAC Merge layer state (`--show-mm`).
  EthtoolCmd showMm() => token('--show-mm');

  /// Configures the MAC Merge layer; use [param] for `pmac-enabled`, `tx-enabled`, `verify-enabled` and the rest (`--set-mm`).
  EthtoolCmd setMm() => token('--set-mm');

  /// Shows Power Sourcing Equipment status (`--show-pse`).
  EthtoolCmd showPse() => token('--show-pse');

  /// Configures Power Sourcing Equipment; use [param] for `podl-pse-admin-control`, `c33-pse-admin-control`, `c33-pse-avail-pw-limit` (`--set-pse`).
  EthtoolCmd setPse() => token('--set-pse');

  /// Shows mean-square-error PHY diagnostics (`--show-mse`).
  EthtoolCmd showMse() => token('--show-mse');

  /// Lists the PHY devices attached to the interface (`--show-phys`).
  EthtoolCmd showPhys() => token('--show-phys');

  /// Adds a `key value` parameter pair, the shape most sub-modes take after the device name.
  EthtoolCmd param(String key, String value) => pair(key, value);

  /// Adds one bare parameter token, for a sub-mode flag that takes no value of its own.
  EthtoolCmd flag(String value) => token(value);

  /// Adds the network interface name this call targets, e.g. `eth0`.
  EthtoolCmd device(String name) => token(name);
}

/// `ethtool`, ready to take a mode and a device name.
// ignore: non_constant_identifier_names
EthtoolCmd get Ethtool => EthtoolCmd();
