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

/// `ss`, the socket lister from iproute2. Linux only, and the replacement for
/// `netstat`: same questions, answered from netlink rather than by walking
/// `/proc`, which shows on a machine with a lot of connections.
///
/// ```dart
/// final ShellResult listening = await Ss.tcp().listening().numeric().processes().output();
/// ```
///
/// The four flags above are the ones that matter. Without [numeric] ss resolves
/// every address and port, which is slow and turns `:5432` into `:postgresql`;
/// [listening] narrows it to what is bound, since ss shows established
/// connections by default; and [processes] names what holds the socket, which is
/// the answer you were usually after, and it needs `asRoot()` to name a process
/// that is not yours.
///
/// "Is the port up yet" is [listening] plus [filter], read from
/// [ShellResult.isNotEmpty] rather than from the exit status: ss exits zero
/// whether or not anything matched.
class SsCmd extends CommandBuilder<SsCmd> {
  @override
  final String executable = 'ss';

  /// Prints the usage summary (`--help`).
  SsCmd help() => token('--help');

  /// Prints the version (`--version`).
  SsCmd version() => token('--version');

  /// Leaves the addresses and ports as numbers (`--numeric`).
  SsCmd numeric() => token('--numeric');

  /// Resolves the addresses and ports to names (`--resolve`).
  SsCmd resolve() => token('--resolve');

  /// Listening and connected sockets both (`--all`).
  SsCmd all() => token('--all');

  /// Only the listening sockets (`--listening`).
  SsCmd listening() => token('--listening');

  /// Adds the timer information (`--options`).
  SsCmd timers() => token('--options');

  /// Adds the owning uid and the inode (`--extended`).
  SsCmd extended() => token('--extended');

  /// Adds the socket memory usage (`--memory`).
  SsCmd memory() => token('--memory');

  /// Names the process holding each socket (`--processes`).
  ///
  /// Needs root to name a process belonging to someone else; without it the
  /// column is simply empty, which reads as "nothing there".
  SsCmd processes() => token('--processes');

  /// Adds the TCP internals: congestion control, round-trip time (`--info`).
  SsCmd info() => token('--info');

  /// Prints the totals instead of the sockets (`--summary`).
  SsCmd summary() => token('--summary');

  /// Adds the SELinux context (`--context`).
  SsCmd context() => token('--context');

  /// Works inside this network namespace (`--net`).
  SsCmd netns(String name) => pair('--net', name);

  /// Shows the classic BPF filter attached to a socket (`--bpf`).
  SsCmd bpf() => token('--bpf');

  /// Keeps printing as sockets are destroyed (`--events`).
  SsCmd events() => token('--events');

  /// Closes the matching sockets (`--kill`). IPv4 and IPv6 only.
  SsCmd kill() => token('--kill');

  /// Drops the header line (`--no-header`). What you want before parsing.
  SsCmd noHeader() => token('--no-header');

  /// One socket per line, however long (`--oneline`).
  SsCmd oneline() => token('--oneline');

  /// IPv4 only (`--ipv4`).
  SsCmd ipv4() => token('--ipv4');

  /// IPv6 only (`--ipv6`).
  SsCmd ipv6() => token('--ipv6');

  /// Packet sockets (`--packet`).
  SsCmd packet() => token('--packet');

  /// TCP sockets (`--tcp`).
  SsCmd tcp() => token('--tcp');

  /// UDP sockets (`--udp`).
  SsCmd udp() => token('--udp');

  /// DCCP sockets (`--dccp`).
  SsCmd dccp() => token('--dccp');

  /// Raw sockets (`--raw`).
  SsCmd raw() => token('--raw');

  /// Unix domain sockets (`--unix`).
  SsCmd unix() => token('--unix');

  /// SCTP sockets (`--sctp`).
  SsCmd sctp() => token('--sctp');

  /// The socket family: `unix`, `inet`, `inet6`, `netlink`, `vsock` (`--family`).
  SsCmd family(String value) => pair('--family', value);

  /// The socket tables to dump, comma separated (`--query`).
  SsCmd query(String value) => pair('--query', value);

  /// Dumps the raw socket information into this file (`--diag`).
  SsCmd diag(String path) => pair('--diag', path);

  /// Reads the filter expression from this file (`--filter`).
  SsCmd filterFile(String path) => pair('--filter', path);

  /// Adds a filter expression, `sport = :5432` and the like.
  SsCmd filter(String expression) => token(expression);

  /// Adds a bare argument.
  SsCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
SsCmd get Ss => SsCmd();
