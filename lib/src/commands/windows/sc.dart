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

/// `sc.exe`, the Service Control Manager client: what Windows has instead of
/// systemd, and therefore the counterpart of `systemctl` and `launchctl` here.
///
/// ```dart
/// final ShellResult state = await Sc.query().arg('koko-api').output();
/// ```
///
/// **The parameter syntax is unlike anything else in this directory.** The
/// equals sign is part of the option name and a space after it is mandatory:
/// `binpath= C:\app.exe`, never `binpath=C:\app.exe`. Written the natural way it
/// simply fails. The methods here emit the pair correctly, which is most of why
/// this wrapper is worth having.
///
/// [create] registers a service; it does not start one, and it does not make a
/// normal program into a service: a plain executable that does not answer the
/// service control protocol is started and then killed for not reporting in.
/// A wrapper such as NSSM or WinSW is the usual answer.
///
/// [query] prints the state as text; the exit code says whether the service
/// exists, not whether it is running.
///
/// Everything but the reads needs an elevated prompt, which is not something
/// `sudo` provides on Windows.
class ScCmd extends CommandBuilder<ScCmd> {
  @override
  final String executable = 'sc';

  /// The remote machine to talk to, in UNC form (`\\server`).
  ScCmd server(String name) => token(name);

  /// Registers a new service (`create`).
  ScCmd create() => token('create');

  /// Removes a service from the registry (`delete`).
  ScCmd delete() => token('delete');

  /// Starts a service (`start`).
  ScCmd start() => token('start');

  /// Stops a service (`stop`).
  ScCmd stop() => token('stop');

  /// Pauses a service (`pause`).
  ScCmd pause() => token('pause');

  /// Resumes a paused service (`continue`).
  ScCmd resume() => token('continue');

  /// Prints the state of a service (`query`).
  ScCmd query() => token('query');

  /// The same with the process id and flags (`queryex`).
  ScCmd queryEx() => token('queryex');

  /// Prints the configuration of a service (`qc`).
  ScCmd queryConfig() => token('qc');

  /// Changes the configuration of a service (`config`).
  ScCmd config() => token('config');

  /// Sets the description text (`description`).
  ScCmd description() => token('description');

  /// Sets what happens when the service fails (`failure`).
  ///
  /// Where automatic restart lives; a service without it stays down after a
  /// crash.
  ScCmd failure() => token('failure');

  /// Prints the security descriptor (`sdshow`).
  ScCmd securityShow() => token('sdshow');

  /// Sets the security descriptor (`sdset`).
  ScCmd securitySet() => token('sdset');

  /// Sends a control code to a service (`control`).
  ScCmd control() => token('control');

  /// Asks a service to report its state (`interrogate`).
  ScCmd interrogate() => token('interrogate');

  /// Prints the display name of a service key (`getdisplayname`).
  ScCmd getDisplayName() => token('getdisplayname');

  /// Prints the service key of a display name (`getkeyname`).
  ScCmd getKeyName() => token('getkeyname');

  /// The service type: `own`, `share`, `kernel`, `filesys`, `interact` (`type=`).
  ScCmd type(String value) => pair('type=', value);

  /// When it starts: `boot`, `system`, `auto`, `demand`, `disabled`, `delayed-auto` (`start=`).
  ScCmd startType(String value) => pair('start=', value);

  /// How bad a start failure is: `normal`, `severe`, `critical`, `ignore` (`error=`).
  ScCmd errorControl(String value) => pair('error=', value);

  /// The executable to run (`binpath=`). Required by [create], and it has no default.
  ScCmd binaryPath(String value) => pair('binpath=', value);

  /// The load-order group the service belongs to (`group=`).
  ScCmd group(String value) => pair('group=', value);

  /// Whether to take a TagID (`tag=`).
  ScCmd tag(String value) => pair('tag=', value);

  /// The services that must start first, separated by `/` (`depend=`).
  ScCmd depend(String value) => pair('depend=', value);

  /// The account to run as (`obj=`). Defaults to `LocalSystem`.
  ScCmd account(String value) => pair('obj=', value);

  /// The name shown in the services list (`displayname=`).
  ScCmd displayName(String value) => pair('displayname=', value);

  /// The password of the account (`password=`).
  ///
  /// It lands in the process arguments where anyone can read it. Prefer a
  /// built-in account, or set the password through the services console.
  ScCmd password(String value) => pair('password=', value);

  /// Adds a bare argument, the service name above all.
  ScCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
ScCmd get Sc => ScCmd();
