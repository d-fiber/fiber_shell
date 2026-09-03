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

/// `scp`, the OpenSSH file copier. Same package as `ssh`, so the same
/// availability: macOS, Linux, and Windows out of the box.
///
/// ```dart
/// await Scp
///     .batchMode()
///     .recursive()
///     .identityFile(deployKey.path)
///     .source(build.path)
///     .destination('deploy@example.com:/srv/app')
///     .execute();
/// ```
///
/// Modern scp speaks SFTP underneath rather than the old scp protocol, which is
/// why [legacyProtocol] exists at all. Reach for it only against a server too old
/// to answer otherwise.
///
/// [batchMode] belongs on every automated copy, for the same reason it does in
/// `ssh`: without it a missing key turns into a password prompt and the process
/// stops there.
///
/// **The remote path is expanded by the remote shell.** A space or a glob
/// character in a filename is read as syntax, not as part of the name;
/// [noStrictFilenameCheck] loosens the client-side check but does nothing about
/// that.
class ScpCmd extends CommandBuilder<ScpCmd> {
  @override
  final String executable = 'scp';

  /// Routes a remote-to-remote copy through this machine (`-3`).
  ScpCmd throughLocal() => token('-3');

  /// IPv4 only (`-4`).
  ScpCmd ipv4() => token('-4');

  /// IPv6 only (`-6`).
  ScpCmd ipv6() => token('-6');

  /// Forwards the authentication agent to the remote side (`-A`).
  ScpCmd forwardAgent() => token('-A');

  /// Refuses to ask for a password or a passphrase (`-B`).
  ScpCmd batchMode() => token('-B');

  /// Compresses the transfer (`-C`).
  ScpCmd compression() => token('-C');

  /// The cipher to use (`-c`).
  ScpCmd cipher(String value) => pair('-c', value);

  /// The sftp-server binary to run on the far end (`-D`).
  ScpCmd sftpServerPath(String path) => pair('-D', path);

  /// The ssh config file to read (`-F`).
  ScpCmd configFile(String path) => pair('-F', path);

  /// The private key to authenticate with (`-i`).
  ScpCmd identityFile(String path) => pair('-i', path);

  /// Connects through this jump host first (`-J`).
  ScpCmd jumpHost(String destination) => pair('-J', destination);

  /// Caps the bandwidth, in Kbit/s (`-l`).
  ScpCmd limit(String value) => pair('-l', value);

  /// Uses the old scp protocol instead of SFTP (`-O`).
  ScpCmd legacyProtocol() => token('-O');

  /// Sets an ssh config option (`-o`).
  ScpCmd option(String assignment) => pair('-o', assignment);

  /// The port to connect to (`-P`). Capital, unlike ssh.
  ScpCmd port(String value) => pair('-P', value);

  /// Keeps the times and the permission bits of the source (`-p`).
  ScpCmd preserve() => token('-p');

  /// Hides the progress meter and the diagnostics (`-q`).
  ScpCmd quiet() => token('-q');

  /// Copies remote-to-remote directly between the two hosts (`-R`).
  ScpCmd remoteToRemote() => token('-R');

  /// Copies directories whole (`-r`).
  ///
  /// It follows the symlinks it meets, so a link into `/` copies rather more than
  /// you meant.
  ScpCmd recursive() => token('-r');

  /// The program to use for the connection instead of ssh (`-S`).
  ScpCmd sshProgram(String path) => pair('-S', path);

  /// Turns the client-side filename check off (`-T`).
  ScpCmd noStrictFilenameCheck() => token('-T');

  /// Prints debugging messages (`-v`).
  ScpCmd verbose() => token('-v');

  /// Passes an option to the sftp layer (`-X`).
  ScpCmd sftpOption(String assignment) => pair('-X', assignment);

  /// Adds a source path, local or `user@host:path`. Repeat for several.
  ScpCmd source(String value) => token(value);

  /// The target path. Comes last.
  ScpCmd destination(String value) => token(value);
}

// ignore: non_constant_identifier_names
ScpCmd get Scp => ScpCmd();
