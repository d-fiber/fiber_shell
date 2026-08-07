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

/// `scutil`, the System Configuration tool. macOS only, and the authority on the
/// live network state: the hostname, the DNS resolvers actually in use, the
/// proxies. Reading `/etc/resolv.conf` on a Mac tells you what mDNSResponder
/// felt like writing there; [dns] tells you the truth.
///
/// ```dart
/// final ShellResult name = await Scutil.getPreference('ComputerName').output();
/// ```
///
/// Three names, three meanings, and they drift apart on a machine nobody has
/// tidied: `ComputerName` is what people see, `LocalHostName` is the Bonjour
/// name, and `HostName` is what `hostname` returns. Setting one does not set the
/// others.
///
/// [setPreference] wants `asRoot()`; reading does not.
class ScutilCmd extends CommandBuilder<ScutilCmd> {
  @override
  final String executable = 'scutil';

  /// Reads a preference: `ComputerName`, `LocalHostName` or `HostName` (`--get`).
  ScutilCmd getPreference(String name) => pair('--get', name);

  /// Writes one (`--set`).
  ScutilCmd setPreference(String name) => pair('--set', name);

  /// Prints the DNS configuration in force (`--dns`).
  ///
  /// Resolvers in order, with their search domains and the interface each is
  /// bound to, none of which `/etc/resolv.conf` reflects.
  ScutilCmd dns() => token('--dns');

  /// Prints the proxy configuration in force (`--proxy`).
  ScutilCmd proxy() => token('--proxy');

  /// Manages VPN connections (`--nc`).
  ScutilCmd networkConnection() => token('--nc');

  /// Renews the DHCP lease of an interface (`--renew`).
  ScutilCmd renew(String interface) => pair('--renew', interface);

  /// Watches the reachability of a host or an address (`-r`).
  ScutilCmd reachability(String target) => pair('-r', target);

  /// Waits for reachability rather than reporting it once (`-W`).
  ScutilCmd watch() => token('-W');

  /// Waits for a dynamic store key to appear (`-w`).
  ScutilCmd waitKey(String key) => pair('-w', key);

  /// How long [waitKey] may wait (`-t`).
  ScutilCmd timeout(String seconds) => pair('-t', seconds);

  /// Adds a bare argument.
  ScutilCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
ScutilCmd get Scutil => ScutilCmd();
