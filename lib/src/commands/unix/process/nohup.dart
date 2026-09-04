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

/// `nohup`: runs another program immune to `SIGHUP`, on every Unix — the
/// classic way to keep a process alive after the shell that started it exits.
/// Genuinely has no options of its own beyond ending the argument list; the
/// entire surface is which program to run and what to hand it.
///
/// ```dart
/// await Nohup.command('long-running-job').arg('--flag').background();
/// ```
///
/// If stdout is a terminal, `nohup` redirects it to `nohup.out` in the current
/// directory (or `$HOME/nohup.out` if that fails); stderr follows stdout.
/// Piping stdout yourself, the way [PipeStage.background] and
/// [CommandBuilder.output] already do, sidesteps that file entirely. Exit
/// status `126` means the program was found but could not be run; `127` means
/// it could not be found at all.
class NohupCmd extends CommandBuilder<NohupCmd> {
  @override
  final String executable = 'nohup';

  /// Ends the options, for a program name that itself starts with `-` (`--`).
  NohupCmd endOfOptions() => token('--');

  /// The program to run immune to hangups.
  NohupCmd command(String executable) => token(executable);

  /// Adds one argument for [command]. Repeat for several, in order.
  NohupCmd arg(String value) => token(value);
}

/// `nohup`, ready to take the command to run.
// ignore: non_constant_identifier_names
NohupCmd get Nohup => NohupCmd();
