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

/// `tee`, which copies stdin to a file and to stdout at once. On every Unix,
/// absent from Windows.
///
/// ```dart
/// await (Deno.test().scriptArg('tests/') | Tee.append().file(log.path)).execute();
/// ```
///
/// The point is having both: the output scrolls past for whoever is watching and
/// lands in a file for whoever reads it afterwards. `writeTo` gives only the
/// file.
///
/// Its other use is writing to a file you cannot open yourself: `… | sudo tee
/// /etc/sysctl.d/99-koko.conf` puts the privilege on `tee` rather than on the
/// shell, since a redirection is opened by the shell before `sudo` ever runs.
/// Here that is `Tee.file(path).asRoot()`.
///
/// **Without [append] it truncates**, and it truncates when the pipeline starts,
/// so a producer that fails immediately still leaves the file empty.
class TeeCmd extends CommandBuilder<TeeCmd> {
  @override
  final String executable = 'tee';

  /// Appends rather than truncating (`-a`).
  TeeCmd append() => token('-a');

  /// Ignores the interrupt signal (`-i`).
  TeeCmd ignoreInterrupts() => token('-i');

  /// Ends the options, for names starting with a dash (`--`).
  TeeCmd endOfOptions() => token('--');

  /// Adds a file to write to. Repeat for several.
  TeeCmd file(String path) => token(path);
}

// ignore: non_constant_identifier_names
TeeCmd get Tee => TeeCmd();
