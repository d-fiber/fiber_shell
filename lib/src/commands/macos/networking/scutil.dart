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
