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

/// `readlink`: prints the target of a symbolic link, on every Unix. On BSD and
/// macOS it is the same binary as `stat` invoked under a different name; on
/// Linux it is its own coreutils program with a noticeably richer flag set.
///
/// ```dart
/// final ShellResult real = await Readlink.canonicalize().path(maybeSymlink).output();
/// if (real.success) print(real.text); // the fully-resolved absolute path
/// ```
///
/// Plain `readlink` (no flags) prints nothing and fails on anything that is not
/// itself a symlink. [canonicalize] changes that: the argument no longer has to
/// be a symlink, every component of the path is resolved, and the result is
/// always an absolute path — the shape a script usually wants. [canonicalizeExisting]
/// and [canonicalizeMissing] refine that further, and are GNU-only, like [quiet],
/// [verbose] and [zeroTerminated]; BSD readlink recognises only [canonicalize]
/// and [noNewline], and suppresses error messages by default (there is no [quiet]
/// to reach for).
class ReadlinkCmd extends CommandBuilder<ReadlinkCmd> {
  @override
  final String executable = 'readlink';

  /// Canonicalizes by resolving every symlink in every component, recursively;
  /// on GNU, every component but the last must exist (`-f`).
  ReadlinkCmd canonicalize() => token('-f');

  /// Canonicalizes like [canonicalize], but every component, the last included,
  /// must exist (`-e`). GNU only.
  ReadlinkCmd canonicalizeExisting() => token('-e');

  /// Canonicalizes like [canonicalize], with no existence requirement at all
  /// (`-m`). GNU only.
  ReadlinkCmd canonicalizeMissing() => token('-m');

  /// Omits the trailing newline after the printed target (`-n`).
  ReadlinkCmd noNewline() => token('-n');

  /// Suppresses most error messages (`-q`/`-s`). GNU only; BSD readlink is
  /// already quiet by default.
  ReadlinkCmd quiet() => token('-q');

  /// Reports error messages instead of suppressing them (`-v`). GNU only.
  ReadlinkCmd verbose() => token('-v');

  /// Ends each printed line with NUL instead of newline (`-z`). GNU only.
  ReadlinkCmd zeroTerminated() => token('-z');

  /// The path whose target, or canonical form, should be printed.
  ReadlinkCmd path(String value) => token(value);

  /// Prints the usage summary and exits (`--help`). GNU only.
  ReadlinkCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  ReadlinkCmd version() => token('--version');
}

/// `readlink`, ready to take its first option.
// ignore: non_constant_identifier_names
ReadlinkCmd get Readlink => ReadlinkCmd();
