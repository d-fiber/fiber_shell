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

/// `sysctl`, the kernel parameter tool. A `sysctl` exists on macOS and the BSDs
/// too, but it is **a different program with different flags**. This wrapper
/// follows the Linux one from procps-ng, where the parameters are the
/// dot-separated paths under `/proc/sys`.
///
/// ```dart
/// await Sysctl.write().arg('net.ipv4.ip_forward=1').asRoot().execute();
/// final ShellResult value = await Sysctl.valuesOnly().arg('net.ipv4.ip_forward').output();
/// ```
///
/// A value set this way lasts until the next reboot. Making it stick means
/// writing it into `/etc/sysctl.d/` and then [loadFrom] or [systemFiles], which
/// is what a provisioning step should do rather than setting it live and hoping.
///
/// Writing wants `asRoot()`; reading does not.
class SysctlCmd extends CommandBuilder<SysctlCmd> {
  @override
  final String executable = 'sysctl';

  /// Prints every readable parameter (`--all`).
  SysctlCmd all() => token('--all');

  /// Includes the deprecated parameters in [all] (`--deprecated`).
  SysctlCmd deprecated() => token('--deprecated');

  /// Prints the value with no trailing newline (`--binary`).
  SysctlCmd binary() => token('--binary');

  /// Says nothing about the keys it does not recognise (`--ignore`).
  ///
  /// What lets one settings file cover kernels that do not all have the same
  /// parameters.
  SysctlCmd ignoreUnknown() => token('--ignore');

  /// Prints the names without the values (`--names`).
  SysctlCmd namesOnly() => token('--names');

  /// Prints the values without the names (`--values`).
  SysctlCmd valuesOnly() => token('--values');

  /// Applies the settings in this file, or `/etc/sysctl.conf` (`--load`).
  SysctlCmd loadFrom(String path) => joined('--load', path);

  /// Applies the settings from every system configuration file (`--system`).
  SysctlCmd systemFiles() => token('--system');

  /// Only the settings whose name matches this regular expression (`--pattern`).
  SysctlCmd pattern(String value) => joined('--pattern', value);

  /// Does not echo what it set (`--quiet`).
  SysctlCmd quiet() => token('--quiet');

  /// Reads every argument as an assignment, and fails on one that is not (`--write`).
  ///
  /// Worth setting: without it a mistyped `key=value` is read as a request to
  /// print a key, and the command succeeds having changed nothing.
  SysctlCmd write() => token('--write');

  /// Prints the usage summary (`--help`).
  SysctlCmd help() => token('--help');

  /// Prints the version (`--version`).
  SysctlCmd version() => token('--version');

  /// Adds a parameter name, or a `name=value` assignment.
  SysctlCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
SysctlCmd get Sysctl => SysctlCmd();
