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

/// `chkdsk`, the file-system checker for FAT, FAT32, exFAT and NTFS volumes.
/// Windows only, and needs an elevated (Administrators-group) prompt to do
/// anything more than report.
///
/// ```dart
/// final ShellResult check = await Chkdsk.volume('D:').fix().asRoot().output();
/// // exit code: 0 clean, 1 fixed, 2 cleanup (no /f), 3 could not fix
/// ```
///
/// **Run with no repair flag ([fix], [recover], [forceDismount], [bitmap]),
/// `chkdsk` only reports — it changes nothing.** [fix] is what actually
/// corrects errors, and it needs to lock the volume; a volume with open
/// handles either refuses or schedules the check for next restart, which is
/// not something a script waiting on this call's exit code will see happen.
///
/// [forceDismount] invalidates every open handle to the drive before
/// checking it — anything with that volume open loses its handle out from
/// under it, which is why it isn't the default.
///
/// **Exit codes carry the result, not just success/failure**: `0` clean,
/// `1` errors found and fixed, `2` cleanup performed (or skipped because
/// [fix] wasn't given), `3` could not check or could not fix. Read
/// [ShellResult.exitCode] rather than just [ShellResult.success].
class ChkdskCmd extends CommandBuilder<ChkdskCmd> {
  @override
  final String executable = 'chkdsk';

  /// The drive letter (with colon), mount point, or volume name to check.
  /// First positional argument; omit it to check the current drive.
  ChkdskCmd volume(String value) => token(value);

  /// FAT/FAT32 only: a file or wildcard pattern (`?`, `*`) to check for
  /// fragmentation, in place of [volume].
  ChkdskCmd file(String pattern) => token(pattern);

  /// Fixes errors on the disk (`/f`). The disk must be lockable; open
  /// handles get a "check on next restart?" prompt instead.
  ChkdskCmd fix() => token('/f');

  /// Prints every file name in every directory as it checks (`/v`).
  ChkdskCmd verbose() => token('/v');

  /// Locates bad sectors and recovers what's readable (`/r`). Includes
  /// [fix]'s effect, plus the physical-sector pass — the slow one, especially
  /// on a spinning disk.
  ChkdskCmd recover() => token('/r');

  /// Dismounts the volume first if needed, invalidating every open handle to
  /// it (`/x`). Includes [fix]'s effect.
  ChkdskCmd forceDismount() => token('/x');

  /// NTFS only: a lighter check of index entries, faster than the default
  /// (`/i`).
  ChkdskCmd indexOnly() => token('/i');

  /// NTFS only: skips checking cycles within the folder structure, faster
  /// than the default (`/c`).
  ChkdskCmd noCycleCheck() => token('/c');

  /// NTFS only: reads (with no argument) or changes the log file size
  /// (`/l[:<size>]`).
  ChkdskCmd logSize([String? size]) => token(size == null ? '/l' : '/l:$size');

  /// NTFS only: clears the volume's bad-cluster list and rescans every
  /// cluster (`/b`). Includes [recover]'s effect. Meant to run once, after
  /// imaging a volume onto a new physical disk.
  ChkdskCmd bitmap() => token('/b');

  /// NTFS only: runs an online scan without dismounting the volume (`/scan`).
  ChkdskCmd scan() => token('/scan');

  /// NTFS only, with [scan]: skips online repair entirely and queues every
  /// defect found for an offline fix, e.g. via [spotFix] (`/forceofflinefix`).
  ChkdskCmd forceOfflineFix() => token('/forceofflinefix');

  /// NTFS only, with [scan]: spends more system resources to finish the scan
  /// faster, at the cost of other work on the machine (`/perf`).
  ChkdskCmd perf() => token('/perf');

  /// NTFS only: runs spot-fixing — a targeted offline repair — on the volume
  /// (`/spotfix`).
  ChkdskCmd spotFix() => token('/spotfix');

  /// NTFS only: garbage-collects unneeded security-descriptor data; implies
  /// [fix] (`/sdcleanup`).
  ChkdskCmd sdCleanup() => token('/sdcleanup');

  /// Runs a full offline scan and fix on the volume (`/offlinescanandfix`).
  ChkdskCmd offlineScanAndFix() => token('/offlinescanandfix');

  /// FAT/FAT32/exFAT only: frees orphaned cluster chains outright instead of
  /// recovering their contents (`/freeorphanedchains`).
  ChkdskCmd freeOrphanedChains() => token('/freeorphanedchains');

  /// FAT/FAT32/exFAT only: marks the volume clean when no corruption was
  /// found, even without [fix] (`/markclean`).
  ChkdskCmd markClean() => token('/markclean');

  /// Prints usage help (`/?`).
  ChkdskCmd help() => token('/?');
}

/// `chkdsk`, ready to take its first option.
// ignore: non_constant_identifier_names
ChkdskCmd get Chkdsk => ChkdskCmd();
