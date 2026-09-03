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

/// `nproc`, the GNU coreutils processor counter. Linux only: it reads
/// `/proc` and the process's own CPU affinity and cgroup quota, neither of
/// which exists on macOS.
///
/// ```dart
/// final ShellResult available = await Nproc.output();
/// final ShellResult installed = await Nproc.all().output();
/// ```
///
/// With no options, it prints the number of processors this process could
/// actually use, which is [all] minus whatever OpenMP variables or a cgroup
/// quota take away. That is almost always the number a caller wants, since
/// it is what a container's `--cpus` limit leaves behind.
class NprocCmd extends CommandBuilder<NprocCmd> {
  @override
  final String executable = 'nproc';

  /// Counts every installed processor, ignoring OpenMP variables and CPU
  /// quotas (`--all`).
  NprocCmd all() => token('--all');

  /// Excludes this many processing units from the count, never going below
  /// one (`--ignore`).
  NprocCmd ignore(int count) => joined('--ignore', '$count');

  /// Prints the usage summary (`--help`).
  NprocCmd help() => token('--help');

  /// Prints the version (`--version`).
  NprocCmd version() => token('--version');
}

/// `nproc`, ready to take its first option.
// ignore: non_constant_identifier_names
NprocCmd get Nproc => NprocCmd();
