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

/// `ssh`, the OpenSSH client. Preinstalled on macOS and on Linux, and shipped
/// with Windows as an optional feature that is on by default, so a chain built
/// here runs on all three.
///
/// ```dart
/// await Ssh
///     .batchMode()
///     .option('StrictHostKeyChecking=accept-new')
///     .identityFile(deployKey.path)
///     .destination('deploy@example.com')
///     .remoteCommand('systemctl restart api')
///     .execute();
/// ```
///
/// Two settings decide whether an automated call hangs. [batchMode], really
/// `-o BatchMode=yes`, turns every password and passphrase prompt into an
/// immediate failure, and `StrictHostKeyChecking` decides what happens when the
/// host is unknown: `accept-new` trusts a first sighting and still refuses a key
/// that changed, which is the setting worth reaching for. Left alone, ssh asks a
/// question no script can answer.
///
/// [destination] comes before [remoteCommand], and everything after the command
/// is passed to it, not to ssh.
///
/// The remote command is a **string the remote shell parses**, not an argv. Two
/// shells get their say: the local one is skipped here, since nothing runs
/// through a shell locally, but the remote one is not. Anything interpolated into
/// it needs quoting.
class SshCmd extends CommandBuilder<SshCmd> {
  @override
  final String executable = 'ssh';

  /// IPv4 only (`-4`).
  SshCmd ipv4() => token('-4');

  /// IPv6 only (`-6`).
  SshCmd ipv6() => token('-6');

  /// Forwards the authentication agent to the remote side (`-A`).
  ///
  /// It lets whoever controls the far end use your keys while the session lasts.
  SshCmd forwardAgent() => token('-A');

  /// Does not forward the agent (`-a`).
  SshCmd noForwardAgent() => token('-a');

  /// The interface to bind before connecting (`-B`).
  SshCmd bindInterface(String name) => pair('-B', name);

  /// The local address to bind before connecting (`-b`).
  SshCmd bindAddress(String value) => pair('-b', value);

  /// Compresses everything on the wire (`-C`).
  SshCmd compression() => token('-C');

  /// The cipher list to offer (`-c`).
  SshCmd cipher(String spec) => pair('-c', spec);

  /// Opens a local SOCKS proxy on this port (`-D`).
  SshCmd dynamicForward(String value) => pair('-D', value);

  /// Writes the debug log to this file rather than stderr (`-E`).
  SshCmd logFile(String path) => pair('-E', path);

  /// The escape character, or `none` to disable it (`-e`).
  SshCmd escapeChar(String value) => pair('-e', value);

  /// The client config file to read (`-F`).
  ///
  /// `-F /dev/null` is how you run without a developer's `~/.ssh/config` quietly
  /// rewriting the host you asked for.
  SshCmd configFile(String path) => pair('-F', path);

  /// Goes to the background just before the remote command runs (`-f`).
  ///
  /// Not to be confused with `background()`, which backgrounds the local process:
  /// this one hands the session to ssh itself, and the Dart side returns as soon
  /// as ssh forks.
  SshCmd detach() => token('-f');

  /// Prints the resolved configuration and exits (`-G`).
  SshCmd printConfig() => token('-G');

  /// Lets remote hosts reach the locally forwarded ports (`-g`).
  SshCmd gatewayPorts() => token('-g');

  /// The PKCS#11 library holding the private key (`-I`).
  SshCmd pkcs11(String path) => pair('-I', path);

  /// The private key to authenticate with (`-i`).
  SshCmd identityFile(String path) => pair('-i', path);

  /// Connects through this jump host first (`-J`).
  SshCmd jumpHost(String destination) => pair('-J', destination);

  /// Turns GSSAPI authentication and delegation on (`-K`).
  SshCmd gssapiDelegate() => token('-K');

  /// Turns GSSAPI credential delegation off (`-k`).
  SshCmd noGssapiDelegate() => token('-k');

  /// Forwards a local port to a host reachable from the far end (`-L`).
  SshCmd localForward(String spec) => pair('-L', spec);

  /// The user to log in as (`-l`).
  SshCmd login(String name) => pair('-l', name);

  /// Becomes the master of a shared connection (`-M`).
  SshCmd master() => token('-M');

  /// The MAC algorithms to offer (`-m`).
  SshCmd mac(String spec) => pair('-m', spec);

  /// Runs no remote command, for a session that only forwards ports (`-N`).
  SshCmd noRemoteCommand() => token('-N');

  /// Reads stdin from `/dev/null` (`-n`).
  SshCmd noStdin() => token('-n');

  /// Sends a control command to a master connection: `check`, `exit`, `stop` (`-O`).
  SshCmd controlCommand(String value) => pair('-O', value);

  /// Sets a config option, exactly as `ssh_config` spells it (`-o`).
  ///
  /// Where `StrictHostKeyChecking`, `ConnectTimeout` and `ServerAliveInterval`
  /// live: most of what an unattended session needs.
  SshCmd option(String assignment) => pair('-o', assignment);

  /// The tag that selects a config block (`-P`).
  SshCmd tag(String name) => pair('-P', name);

  /// The port to connect to (`-p`).
  SshCmd port(String value) => pair('-p', value);

  /// Prints what this client supports and exits (`-Q`).
  SshCmd query(String option) => pair('-Q', option);

  /// Suppresses the warnings and diagnostics (`-q`).
  SshCmd quiet() => token('-q');

  /// Forwards a remote port back to a host reachable from here (`-R`).
  SshCmd remoteForward(String spec) => pair('-R', spec);

  /// The control socket of a shared connection (`-S`).
  SshCmd controlPath(String path) => pair('-S', path);

  /// Asks for a subsystem rather than a command, `sftp` and the like (`-s`).
  SshCmd subsystem() => token('-s');

  /// Allocates no pseudo-terminal (`-T`).
  ///
  /// The right default for a command whose output you capture: a tty turns the
  /// stream into something meant for a screen.
  SshCmd noTty() => token('-T');

  /// Forces a pseudo-terminal, twice over even without a local one (`-t`).
  SshCmd forceTty() => token('-t');

  /// Prints the version and exits (`-V`).
  SshCmd version() => token('-V');

  /// Prints debugging messages, repeatable for more (`-v`).
  SshCmd verbose() => token('-v');

  /// Forwards stdin and stdout to this host and port (`-W`).
  SshCmd stdioForward(String spec) => pair('-W', spec);

  /// Requests tunnel device forwarding (`-w`).
  SshCmd tunnel(String spec) => pair('-w', spec);

  /// Turns X11 forwarding on (`-X`).
  SshCmd x11() => token('-X');

  /// Turns X11 forwarding off (`-x`).
  SshCmd noX11() => token('-x');

  /// Turns trusted X11 forwarding on (`-Y`).
  SshCmd trustedX11() => token('-Y');

  /// Sends the log to syslog rather than stderr (`-y`).
  SshCmd syslog() => token('-y');

  /// Refuses to ask for a password or a passphrase (`-o BatchMode=yes`).
  ///
  /// An unattended session wants this: without it ssh waits at a prompt until
  /// something times out.
  SshCmd batchMode() => pair('-o', 'BatchMode=yes');

  /// How long to wait for the connection, in seconds (`-o ConnectTimeout=`).
  SshCmd connectTimeout(String seconds) => pair('-o', 'ConnectTimeout=$seconds');

  /// The host, as `user@host` or a name from the config.
  SshCmd destination(String value) => token(value);

  /// The command to run on the far end. Comes after [destination].
  SshCmd remoteCommand(String value) => token(value);

  /// Adds an argument for the remote command.
  SshCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
SshCmd get Ssh => SshCmd();
