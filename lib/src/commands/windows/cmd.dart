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

/// `cmd.exe`, the Windows command interpreter, the counterpart of `sh` in this
/// directory, and the shell every `.bat` and `.cmd` file speaks.
///
/// ```dart
/// await Cmd.run().script('mklink /D current release-42').execute();
/// ```
///
/// **[run] must come last**: everything after it is the command line, not an
/// option for cmd itself.
///
/// Prefer [ShellScript] composition when all you want is `|`, `&&` or `;`: they
/// are already there, without a second parser to satisfy. This wrapper is for
/// what only cmd can do: a batch file, `mklink`, an internal command like `dir`
/// or `set` that has no executable behind it.
///
/// The quoting rules are their own subject. `& | < > ( ) ^ @` are syntax and need
/// a `^` in front, `%name%` is expanded before the command runs, and [noParse]
/// changes how the outer quotes are treated. Anything interpolated into the
/// string needs thought.
class CmdCmd extends CommandBuilder<CmdCmd> {
  @override
  final String executable = 'cmd';

  /// Runs the command line that follows and exits (`/c`). Comes last.
  CmdCmd run() => token('/c');

  /// Runs it and stays open (`/k`). Not for a script.
  CmdCmd runAndStay() => token('/k');

  /// Strips only the outer quotes of the command line (`/s`).
  CmdCmd noParse() => token('/s');

  /// Turns the prompt echo off (`/q`).
  CmdCmd quiet() => token('/q');

  /// Skips the AutoRun commands from the registry (`/d`).
  ///
  /// Worth setting: AutoRun lets a machine inject a command into every single
  /// `cmd` that starts, and its output lands in yours.
  CmdCmd noAutoRun() => token('/d');

  /// Writes the output as ANSI (`/a`).
  CmdCmd ansiOutput() => token('/a');

  /// Writes the output as Unicode (`/u`).
  CmdCmd unicodeOutput() => token('/u');

  /// Sets the background and foreground colours (`/t`).
  CmdCmd colors(String value) => token('/t:$value');

  /// Turns the command extensions on (`/e:on`).
  CmdCmd extensionsOn() => token('/e:on');

  /// Turns them off (`/e:off`).
  CmdCmd extensionsOff() => token('/e:off');

  /// Turns file and directory name completion on (`/f:on`).
  CmdCmd completionOn() => token('/f:on');

  /// Turns it off (`/f:off`).
  CmdCmd completionOff() => token('/f:off');

  /// Turns delayed variable expansion on, so `!name!` works (`/v:on`).
  CmdCmd delayedExpansionOn() => token('/v:on');

  /// Turns it off (`/v:off`).
  CmdCmd delayedExpansionOff() => token('/v:off');

  /// The command line to run, after [run].
  CmdCmd script(String value) => token(value);

  /// Adds a bare argument.
  CmdCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
CmdCmd get Cmd => CmdCmd();
