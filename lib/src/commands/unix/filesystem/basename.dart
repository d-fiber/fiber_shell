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

/// `basename`: strips the leading directories (and, optionally, a trailing
/// suffix) off a path, on every Unix.
///
/// ```dart
/// final ShellResult r = await Basename.suffix('.tar.gz').path(archivePath).output();
/// // '/backups/db-2026-01-01.tar.gz' -> 'db-2026-01-01'
/// ```
///
/// The single-argument form (`basename string [suffix]`, via [path] and
/// [suffixArg]) and the flagged form ([all] with [suffix]) are mutually
/// exclusive on BSD; mixing them is a usage error, not a silent fallback.
/// [zeroTerminated] is a GNU extension, absent on BSD/macOS.
class BasenameCmd extends CommandBuilder<BasenameCmd> {
  @override
  final String executable = 'basename';

  /// Treats every operand as its own `string`, as if `basename` had been
  /// called once per argument (`-a`).
  BasenameCmd all() => token('-a');

  /// The suffix to strip, taken as an option rather than a trailing operand;
  /// left untouched if it equals the whole remaining name (`-s`).
  BasenameCmd suffix(String value) => pair('-s', value);

  /// Ends each printed name with NUL instead of newline (`-z`). GNU only.
  BasenameCmd zeroTerminated() => token('-z');

  /// The path to strip down to its last component.
  BasenameCmd path(String value) => token(value);

  /// The suffix to strip, in the single-argument form (`basename string
  /// suffix`) rather than through [suffix].
  BasenameCmd suffixArg(String value) => token(value);

  /// Prints the usage summary and exits (`--help`). GNU only.
  BasenameCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  BasenameCmd version() => token('--version');
}

/// `basename`, ready to take its first option.
// ignore: non_constant_identifier_names
BasenameCmd get Basename => BasenameCmd();
