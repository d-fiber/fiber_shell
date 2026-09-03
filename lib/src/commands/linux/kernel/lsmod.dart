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

/// `lsmod`, the kmod module lister. Linux only: it reformats `/proc/modules`,
/// which does not exist outside the Linux kernel.
///
/// ```dart
/// final ShellResult loaded = await (Lsmod.arg | Grep.pattern('nf_tables')).output();
/// ```
///
/// It takes no argument that selects or filters what is listed: the output is
/// always `module  size  use-count  used-by`, one line per loaded module,
/// whitespace separated. Piping into `GrepCmd` or `AwkCmd` is the intended way
/// to narrow it down; `modinfo <name>` is the tool for details on one module
/// rather than the full list.
///
/// Reading needs no privilege.
class LsmodCmd extends CommandBuilder<LsmodCmd> {
  @override
  final String executable = 'lsmod';

  /// Sends error messages to syslog instead of stderr (`-s`, `--syslog`).
  LsmodCmd syslog() => token('--syslog');

  /// Prints what the program is doing as it runs, not just when something
  /// goes wrong (`-v`, `--verbose`).
  LsmodCmd verbose() => token('--verbose');

  /// Prints the usage summary (`-h`, `--help`).
  LsmodCmd help() => token('--help');

  /// Prints the version (`-V`, `--version`).
  LsmodCmd version() => token('--version');
}

/// `lsmod`, ready to run or take an option.
// ignore: non_constant_identifier_names
LsmodCmd get Lsmod => LsmodCmd();
