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

/// `powershell.exe`, Windows PowerShell, the edition preinstalled on Windows.
/// Windows only: the executable does not exist on the other platforms, so this is
/// the Windows branch of `Keyring`.
///
/// ```dart
/// final ShellResult r = await PowerShell.noProfile().command(script).output();
/// ```
///
/// Note the executable. `powershell` is the built-in edition; the modern
/// cross-platform PowerShell installs itself as `pwsh` and is not there by
/// default. This wrapper calls the built-in one deliberately, since `Keyring`
/// only wants DPAPI through `ConvertTo-SecureString`, which it has.
///
/// [command] and [file] both swallow everything after them, since PowerShell
/// reads the rest of the line as the script and its arguments, so they go last.
/// [noProfile] belongs on essentially every call: without it a user's profile
/// runs first, and whatever it prints lands in your stdout.
class PowerShellCmd extends CommandBuilder<PowerShellCmd> {
  @override
  final String executable = 'powershell';

  /// Skips the user and system profiles (`-NoProfile`).
  PowerShellCmd noProfile() => token('-NoProfile');

  /// Hides the copyright banner (`-NoLogo`).
  PowerShellCmd noLogo() => token('-NoLogo');

  /// Stays open after the startup commands (`-NoExit`). Not for a script.
  PowerShellCmd noExit() => token('-NoExit');

  /// Turns a prompt into an error rather than a hang (`-NonInteractive`).
  PowerShellCmd nonInteractive() => token('-NonInteractive');

  /// Starts in a single-threaded apartment (`-Sta`), the default since 3.0.
  PowerShellCmd sta() => token('-Sta');

  /// Starts in a multi-threaded apartment (`-Mta`).
  PowerShellCmd mta() => token('-Mta');

  /// Starts a specific engine version, `2.0` or `3.0` (`-Version`). It has to be installed.
  PowerShellCmd version(String value) => pair('-Version', value);

  /// Loads a console file made by `Export-Console` (`-PSConsoleFile`).
  PowerShellCmd psConsoleFile(String path) => pair('-PSConsoleFile', path);

  /// Runs against a registered remoting endpoint (`-ConfigurationName`).
  PowerShellCmd configurationName(String name) => pair('-ConfigurationName', name);

  /// Sets the execution policy for this session only (`-ExecutionPolicy`).
  ///
  /// The registry setting is left alone, which is what makes `Bypass` acceptable in a scripted call.
  PowerShellCmd executionPolicy(String policy) => pair('-ExecutionPolicy', policy);

  /// How to read what arrives on stdin: `Text` or `XML` (`-InputFormat`).
  PowerShellCmd inputFormat(String format) => pair('-InputFormat', format);

  /// How to write what goes to stdout: `Text` or `XML` (`-OutputFormat`).
  PowerShellCmd outputFormat(String format) => pair('-OutputFormat', format);

  /// The window style: `Normal`, `Minimized`, `Maximized` or `Hidden` (`-WindowStyle`).
  PowerShellCmd windowStyle(String style) => pair('-WindowStyle', style);

  /// A base64 UTF-16LE script (`-EncodedCommand`).
  ///
  /// The way out when the script is full of quotes that no amount of escaping survives.
  PowerShellCmd encodedCommand(String value) => pair('-EncodedCommand', value);

  /// The script to run (`-Command`). Everything after it is part of the script, so put it last.
  PowerShellCmd command(String script) => pair('-Command', script);

  /// The script file to run (`-File`). Same rule: it must come last.
  PowerShellCmd file(String path) => pair('-File', path);

  /// Prints the usage summary (`-Help`).
  PowerShellCmd help() => token('-Help');

  /// Adds an argument, after [command] or [file].
  PowerShellCmd scriptArg(String value) => token(value);
}

/// `powershell`, ready to take its first option.
// ignore: non_constant_identifier_names
PowerShellCmd get PowerShell => PowerShellCmd();
