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

/// `launchctl`, the launchd front end, which is what macOS has instead of
/// systemd, and therefore the counterpart of `systemctl` in this directory.
///
/// ```dart
/// await Launchctl.bootstrap().domain('gui', service: null).arg(plist.path).execute();
/// final ShellResult loaded = await Launchctl.list().arg('com.koko.api').output();
/// ```
///
/// Everything hangs off a **domain target**: `system`, `user/<uid>`,
/// `gui/<uid>`, `session/<asid>` or `pid/<pid>`. [domain] builds one. The old
/// verbs ([load], [unload], [start], [stop], [list]) guess the domain from who
/// is running them, which is why the same command behaves differently under
/// `sudo`; the modern ones take the target explicitly and are worth the extra
/// words.
///
/// Two traps. [bootstrap] fails with a bare `Input/output error` when the plist
/// is malformed, and says nothing more useful, so validate it with `plutil -lint`
/// first. And [enable] survives reboots while [bootout] does not, so a service
/// that keeps coming back was disabled the wrong way.
class LaunchctlCmd extends CommandBuilder<LaunchctlCmd> {
  @override
  final String executable = 'launchctl';

  /// Loads a domain, or a service into a domain (`bootstrap`).
  LaunchctlCmd bootstrap() => token('bootstrap');

  /// Tears a domain down, or removes a service from one (`bootout`).
  LaunchctlCmd bootout() => token('bootout');

  /// Enables a service, persistently across reboots (`enable`).
  LaunchctlCmd enable() => token('enable');

  /// Disables a service, persistently across reboots (`disable`).
  LaunchctlCmd disable() => token('disable');

  /// Starts a service now, whatever its conditions say (`kickstart`).
  LaunchctlCmd kickstart() => token('kickstart');

  /// Attaches the debugger to a service (`attach`).
  LaunchctlCmd attach() => token('attach');

  /// Sets up the next launch of a service for debugging (`debug`).
  LaunchctlCmd debug() => token('debug');

  /// Sends a signal to a running service (`kill`).
  LaunchctlCmd kill() => token('kill');

  /// Explains why a service is running (`blame`).
  LaunchctlCmd blame() => token('blame');

  /// Prints everything launchd knows about a domain or a service (`print`).
  ///
  /// Where the exit status, the last exit reason and the resolved environment
  /// live: far more than [list] gives.
  LaunchctlCmd printTarget() => token('print');

  /// Prints the state of the service cache (`print-cache`).
  LaunchctlCmd printCache() => token('print-cache');

  /// Prints which services are disabled (`print-disabled`).
  LaunchctlCmd printDisabled() => token('print-disabled');

  /// Prints the plist embedded in a binary (`plist`).
  LaunchctlCmd plist() => token('plist');

  /// Prints the Mach port information of a process (`procinfo`).
  LaunchctlCmd procinfo() => token('procinfo');

  /// Prints the Mach port information of the host (`hostinfo`).
  LaunchctlCmd hostinfo() => token('hostinfo');

  /// Reads or changes launchd's resource limits (`limit`).
  LaunchctlCmd limit() => token('limit');

  /// Changes a persistent launchd configuration parameter (`config`).
  LaunchctlCmd config() => token('config');

  /// Dumps the whole launchd state (`dumpstate`). Enormous, and occasionally the
  /// only way to see what a service is waiting on.
  LaunchctlCmd dumpstate() => token('dumpstate');

  /// Reboots the machine in the given fashion (`reboot`).
  LaunchctlCmd reboot() => token('reboot');

  /// Loads a service from a plist, the legacy verb (`load`).
  LaunchctlCmd load() => token('load');

  /// Unloads a service, the legacy verb (`unload`).
  LaunchctlCmd unload() => token('unload');

  /// Unloads a service by name (`remove`).
  LaunchctlCmd remove() => token('remove');

  /// Lists the services of the current domain (`list`).
  ///
  /// Three columns: pid, last exit status, label. A dash for the pid means
  /// loaded but not running.
  LaunchctlCmd list() => token('list');

  /// Starts a loaded service (`start`).
  LaunchctlCmd start() => token('start');

  /// Stops a running service (`stop`). launchd restarts it if it is set to.
  LaunchctlCmd stop() => token('stop');

  /// Sets an environment variable for every service in the domain (`setenv`).
  LaunchctlCmd setenv() => token('setenv');

  /// Unsets one (`unsetenv`).
  LaunchctlCmd unsetenv() => token('unsetenv');

  /// Reads one back (`getenv`).
  LaunchctlCmd getenv() => token('getenv');

  /// Runs a program in another process's bootstrap context (`bsexec`).
  LaunchctlCmd bsexec() => token('bsexec');

  /// Runs a program in a given user's bootstrap context (`asuser`).
  LaunchctlCmd asuser() => token('asuser');

  /// Submits a simple job without writing a plist (`submit`).
  LaunchctlCmd submit() => token('submit');

  /// Prints the pid of the launchd running this session (`managerpid`).
  LaunchctlCmd managerpid() => token('managerpid');

  /// Prints its uid (`manageruid`).
  LaunchctlCmd manageruid() => token('manageruid');

  /// Prints its name (`managername`).
  LaunchctlCmd managername() => token('managername');

  /// Turns a launchd error code into words (`error`).
  LaunchctlCmd error() => token('error');

  /// Prints the launchd variant (`variant`).
  LaunchctlCmd variant() => token('variant');

  /// Prints the launchd version (`version`).
  LaunchctlCmd version() => token('version');

  /// Prints the usage of a subcommand (`help`).
  LaunchctlCmd help() => token('help');

  /// Builds a domain target, optionally down to one service.
  ///
  /// `domain('system')` gives `system`, `domain('gui', uid: '501')` gives
  /// `gui/501`, and adding a service name gives `gui/501/com.koko.api`.
  LaunchctlCmd domain(String kind, {String? uid, String? service}) {
    final String base = uid == null ? kind : '$kind/$uid';
    return token(service == null ? base : '$base/$service');
  }

  /// Adds a bare argument: a plist path, a service label, a signal.
  LaunchctlCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
LaunchctlCmd get Launchctl => LaunchctlCmd();
