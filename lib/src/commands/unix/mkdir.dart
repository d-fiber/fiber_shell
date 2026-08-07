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

/// `mkdir`, the directory maker, in `/bin` on every Unix and part of coreutils on
/// Linux. Nothing to install, anywhere.
///
/// ```dart
/// await Mkdir.parents().mode('700').path('/var/lib/koko/keys').execute();
/// ```
///
/// The BSD version on macOS and the GNU one agree on everything this wrapper
/// exposes; `mkdir` is one of the few utilities where that is true.
class MkdirCmd extends CommandBuilder<MkdirCmd> {
  @override
  final String executable = 'mkdir';

  /// Creates the missing parents too, and stays quiet if the directory is already there (`-p`).
  MkdirCmd parents() => token('-p');

  /// Prints each directory as it is created (`-v`).
  MkdirCmd verbose() => token('-v');

  /// Sets the permissions of the final directory, octal or symbolic (`-m`).
  ///
  /// Only the last component gets them: parents made by [parents] keep `0777` minus the umask.
  MkdirCmd mode(String value) => pair('-m', value);

  /// Ends the options, so a name starting with a dash is still a name (`--`).
  MkdirCmd endOfOptions() => token('--');

  /// Adds a directory to create. Repeat for several.
  MkdirCmd path(String value) => token(value);
}

/// `mkdir`, ready to take its first option.
// ignore: non_constant_identifier_names
MkdirCmd get Mkdir => MkdirCmd();
