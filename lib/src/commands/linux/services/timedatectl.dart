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

/// `timedatectl`, systemd's clock, timezone and NTP control front end.
/// systemd only, so Linux only, and not on a system that manages time some
/// other way.
///
/// ```dart
/// final ShellResult tz = await Timedatectl.show().property('Timezone').valueOnly().output();
/// await Timedatectl.setTimezone('America/New_York').asRoot().execute();
/// await Timedatectl.setNtp('true').asRoot().execute();
/// ```
///
/// [status] is built for a human; [show] prints the same facts as
/// `Key=Value` lines, the shape worth parsing, and [property] narrows it to
/// one field at a time. [setTime] fails outright while `systemd-timesyncd` (or
/// another NTP client) is active — [setNtp] `false` first, or expect it to be
/// rejected. Anything that changes the clock, timezone or NTP state wants
/// `asRoot()`; the query verbs need nothing.
class TimedatectlCmd extends CommandBuilder<TimedatectlCmd> {
  @override
  final String executable = 'timedatectl';

  /// Shows the current clock, timezone and NTP sync state, formatted for a human (`status`).
  TimedatectlCmd status() => token('status');

  /// Shows the same facts as [status], as `Key=Value` lines meant to be parsed (`show`).
  TimedatectlCmd show() => token('show');

  /// Sets the system clock, `"YYYY-MM-DD HH:MM:SS"` (`set-time`).
  ///
  /// Rejected while NTP synchronization is active; call [setNtp] with
  /// `false` first.
  TimedatectlCmd setTime(String time) => pair('set-time', time);

  /// Sets the system timezone, e.g. `America/New_York` (`set-timezone`).
  TimedatectlCmd setTimezone(String timezone) => pair('set-timezone', timezone);

  /// Lists every timezone name this system recognises (`list-timezones`).
  TimedatectlCmd listTimezones() => token('list-timezones');

  /// Sets whether the hardware clock is kept in local time (`true`) instead of UTC (`false`) (`set-local-rtc`).
  TimedatectlCmd setLocalRtc(String boolean) => pair('set-local-rtc', boolean);

  /// Enables or disables NTP-based synchronization (`set-ntp`).
  TimedatectlCmd setNtp(String boolean) => pair('set-ntp', boolean);

  /// Shows `systemd-timesyncd`'s current sync status, formatted for a human (`timesync-status`).
  TimedatectlCmd timesyncStatus() => token('timesync-status');

  /// Shows the same facts as [timesyncStatus], as `Key=Value` lines (`show-timesync`).
  TimedatectlCmd showTimesync() => token('show-timesync');

  /// Sets the NTP servers for one `systemd-networkd`-managed interface (`ntp-servers`).
  TimedatectlCmd ntpServers(String interface, List<String> servers) {
    token('ntp-servers');
    token(interface);
    for (final server in servers) {
      token(server);
    }
    return self;
  }

  /// Reverts an interface's NTP servers back to the global default (`revert`).
  TimedatectlCmd revert(String interface) => pair('revert', interface);

  /// Skips the polkit authentication prompt for a privileged call (`--no-ask-password`).
  TimedatectlCmd noAskPassword() => token('--no-ask-password');

  /// Under [setLocalRtc], also adjusts the system clock from the RTC's new interpretation (`--adjust-system-clock`).
  TimedatectlCmd adjustSystemClock() => token('--adjust-system-clock');

  /// Keeps [timesyncStatus] running and printing updates instead of exiting after one (`--monitor`).
  TimedatectlCmd monitor() => token('--monitor');

  /// Shows every property under [show], including ones that are empty or unset (`-a`, `--all`).
  TimedatectlCmd all() => token('--all');

  /// Limits [show] to this property name. Repeatable (`-p`, `--property`).
  TimedatectlCmd property(String name) => joined('--property', name);

  /// Under [show]/[property], prints only the value, not the `Key=` prefix (`--value`).
  TimedatectlCmd valueOnly() => token('--value');

  /// Runs against a remote machine over SSH (`-H`, `--host`).
  TimedatectlCmd host(String value) => pair('--host', value);

  /// Runs against a local container or VM (`-M`, `--machine`).
  TimedatectlCmd machine(String value) => pair('--machine', value);

  /// Prints the usage summary (`-h`, `--help`).
  TimedatectlCmd help() => token('--help');

  /// Prints the version (`--version`).
  TimedatectlCmd version() => token('--version');

  /// Writes straight out rather than through a pager (`--no-pager`).
  TimedatectlCmd noPager() => token('--no-pager');
}

/// `timedatectl`, ready to take its verb.
// ignore: non_constant_identifier_names
TimedatectlCmd get Timedatectl => TimedatectlCmd();
