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

/// `systemctl`, the service manager front end. systemd only, so Linux only, and
/// not even all of Linux: a container almost never runs it, and a few
/// distributions still do not.
///
/// ```dart
/// final ShellResult up = await Systemctl.isActive().unit('docker').output();
/// if (up.failed) await Systemctl.start().unit('docker').asRoot().execute();
/// ```
///
/// The query commands are built to be read from the exit status rather than from
/// the output: [isActive], [isEnabled] and [isFailed] print a word and exit
/// non-zero when the answer is no. Use [output] and [ShellResult.success], not
/// [execute].
///
/// Two distinctions that cost people an afternoon. [start] runs a unit now,
/// [enable] makes it run at boot, and neither implies the other. [now] is what
/// does both in one call. And after editing a unit file, [daemonReload] is
/// mandatory: without it systemd keeps serving the version it read at boot.
///
/// Anything that changes state wants `asRoot()`.
class SystemctlCmd extends CommandBuilder<SystemctlCmd> {
  @override
  final String executable = 'systemctl';

  /// Starts units now (`start`).
  SystemctlCmd start() => token('start');

  /// Stops units now (`stop`).
  SystemctlCmd stop() => token('stop');

  /// Stops then starts units (`restart`).
  SystemctlCmd restart() => token('restart');

  /// Asks units to reread their configuration without stopping (`reload`).
  SystemctlCmd reload() => token('reload');

  /// Reloads when the unit supports it, restarts otherwise (`reload-or-restart`).
  SystemctlCmd reloadOrRestart() => token('reload-or-restart');

  /// Restarts only the units that are already running (`try-restart`).
  SystemctlCmd tryRestart() => token('try-restart');

  /// Reloads or restarts, but only what is running (`try-reload-or-restart`).
  SystemctlCmd tryReloadOrRestart() => token('try-reload-or-restart');

  /// Makes units start at boot (`enable`). Does not start them; see [now].
  SystemctlCmd enable() => token('enable');

  /// Stops units starting at boot (`disable`).
  SystemctlCmd disable() => token('disable');

  /// Resets the enablement symlinks to what the unit file asks for (`reenable`).
  SystemctlCmd reenable() => token('reenable');

  /// Links units to `/dev/null`, so nothing can start them at all (`mask`).
  ///
  /// Stronger than [disable]: another unit depending on a masked one fails rather
  /// than pulling it in.
  SystemctlCmd mask() => token('mask');

  /// Removes the mask (`unmask`).
  SystemctlCmd unmask() => token('unmask');

  /// Resets units to the distribution preset (`preset`).
  SystemctlCmd preset() => token('preset');

  /// Resets every unit to its preset (`preset-all`).
  SystemctlCmd presetAll() => token('preset-all');

  /// Asks whether units are running (`is-active`). The status carries the answer.
  SystemctlCmd isActive() => token('is-active');

  /// Asks whether units start at boot (`is-enabled`).
  SystemctlCmd isEnabled() => token('is-enabled');

  /// Asks whether units are in the failed state (`is-failed`).
  SystemctlCmd isFailed() => token('is-failed');

  /// Prints the state of units with their last log lines (`status`).
  ///
  /// Built for a human. Parse [show] instead.
  SystemctlCmd status() => token('status');

  /// Prints unit properties as `key=value` (`show`). The scriptable one.
  SystemctlCmd show() => token('show');

  /// Prints the unit file and its drop-ins (`cat`).
  SystemctlCmd cat() => token('cat');

  /// Opens the unit in an editor (`edit`). Interactive.
  SystemctlCmd edit() => token('edit');

  /// Sends a signal to the processes of a unit (`kill`).
  SystemctlCmd kill() => token('kill');

  /// Clears the failed state so a unit can start again (`reset-failed`).
  SystemctlCmd resetFailed() => token('reset-failed');

  /// Changes a unit property at runtime (`set-property`).
  SystemctlCmd setProperty() => token('set-property');

  /// Lists the units systemd currently has in memory (`list-units`).
  SystemctlCmd listUnits() => token('list-units');

  /// Lists the unit files installed on disk (`list-unit-files`).
  SystemctlCmd listUnitFiles() => token('list-unit-files');

  /// Lists what a unit pulls in (`list-dependencies`).
  SystemctlCmd listDependencies() => token('list-dependencies');

  /// Rereads the unit files from disk (`daemon-reload`).
  ///
  /// Required after writing or editing a unit file, and it changes nothing that
  /// is already running: a [restart] still has to follow.
  SystemctlCmd daemonReload() => token('daemon-reload');

  /// Restarts the machine (`reboot`).
  SystemctlCmd reboot() => token('reboot');

  /// Shuts the machine down (`poweroff`).
  SystemctlCmd poweroff() => token('poweroff');

  /// Halts without cutting the power (`halt`).
  SystemctlCmd halt() => token('halt');

  /// Suspends to RAM (`suspend`).
  SystemctlCmd suspend() => token('suspend');

  /// Suspends to disk (`hibernate`).
  SystemctlCmd hibernate() => token('hibernate');

  /// Asks whether the system finished booting cleanly (`is-system-running`).
  SystemctlCmd isSystemRunning() => token('is-system-running');

  /// Enters the default target (`default`).
  SystemctlCmd defaultTarget() => token('default');

  /// Enters rescue mode (`rescue`).
  SystemctlCmd rescue() => token('rescue');

  /// Enters emergency mode (`emergency`).
  SystemctlCmd emergency() => token('emergency');

  /// Starts or stops the unit at the same time as enabling or disabling it (`--now`).
  SystemctlCmd now() => token('--now');

  /// Says nothing, leaving only the exit status (`--quiet`).
  SystemctlCmd quiet() => token('--quiet');

  /// Works on the system manager, the default (`--system`).
  SystemctlCmd system() => token('--system');

  /// Works on the calling user's manager instead (`--user`).
  SystemctlCmd user() => token('--user');

  /// Writes straight out rather than through a pager (`--no-pager`).
  ///
  /// Without it systemctl may block forever waiting for a pager nobody is
  /// reading. Worth having on every scripted call.
  SystemctlCmd noPager() => token('--no-pager');

  /// Queues the job and returns instead of waiting for it (`--no-block`).
  SystemctlCmd noBlock() => token('--no-block');

  /// Skips the graceful path, or ignores the errors (`--force`).
  SystemctlCmd force() => token('--force');

  /// Only the units that failed (`--failed`).
  SystemctlCmd failed() => token('--failed');

  /// Inactive units and every property, not just the interesting ones (`--all`).
  SystemctlCmd all() => token('--all');

  /// Only this unit type: `service`, `socket`, `timer` and so on (`--type`).
  SystemctlCmd type(String value) => joined('--type', value);

  /// Only the units in this load, active or sub state (`--state`).
  SystemctlCmd state(String value) => joined('--state', value);

  /// Only this property of [show] (`--property`).
  SystemctlCmd property(String name) => joined('--property', name);

  /// Prints the property value without its name (`--value`).
  ///
  /// `--property=ActiveState --value` is how you read one fact out of systemd
  /// without parsing anything.
  SystemctlCmd valueOnly() => token('--value');

  /// How many log lines [status] shows (`--lines`).
  SystemctlCmd lines(String count) => joined('--lines', count);

  /// The journal output format used by [status] (`--output`).
  SystemctlCmd output_(String value) => joined('--output', value);

  /// Works inside this filesystem root (`--root`).
  SystemctlCmd root(String path) => joined('--root', path);

  /// Waits for the job to finish before returning (`--wait`).
  SystemctlCmd waitForJob() => token('--wait');

  /// The signal [kill] sends (`--signal`).
  SystemctlCmd signal(String value) => joined('--signal', value);

  /// Adds a unit name. The `.service` suffix is assumed when left out.
  SystemctlCmd unit(String name) => token(name);

  /// Adds a bare argument.
  SystemctlCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
SystemctlCmd get Systemctl => SystemctlCmd();
