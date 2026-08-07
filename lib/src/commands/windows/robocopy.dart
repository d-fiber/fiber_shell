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

/// `robocopy`, the resilient copier, the counterpart of `rsync`, and far more
/// capable than `copy`. Windows only, and part of Windows itself.
///
/// ```dart
/// final ShellResult copied = await Robocopy
///     .source(build.path)
///     .destination(deploy.path)
///     .mirror()
///     .retries('2')
///     .waitBetweenRetries('5')
///     .noProgress()
///     .output();
/// if (copied.exitCode >= 8) throw StateError(copied.text);
/// ```
///
/// **The exit codes are a bit field, and success is not zero.** `0` means
/// nothing needed copying, `1` files were copied, `2` extra files exist in the
/// destination, `3` both, and so on; **anything from `8` up is a failure**. So
/// [execute] would throw on a perfectly good copy: use [output] and compare
/// against `8`.
///
/// [mirror] makes the destination match the source, which means **deleting**
/// whatever is not in the source. Pointed at the wrong directory it empties it.
/// [listOnly] first is cheap insurance.
///
/// The default retry policy is a million attempts thirty seconds apart, which is
/// a script that hangs for a month. Always set [retries] and
/// [waitBetweenRetries].
class RobocopyCmd extends CommandBuilder<RobocopyCmd> {
  @override
  final String executable = 'robocopy';

  /// The directory to copy from. Comes first.
  RobocopyCmd source(String path) => token(path);

  /// The directory to copy to. Comes second.
  RobocopyCmd destination(String path) => token(path);

  /// The files to copy, wildcards allowed. Defaults to everything.
  RobocopyCmd file(String pattern) => token(pattern);

  /// Copies the subdirectories, skipping the empty ones (`/s`).
  RobocopyCmd subdirectories() => token('/s');

  /// Copies them including the empty ones (`/e`).
  RobocopyCmd subdirectoriesIncludingEmpty() => token('/e');

  /// Only the top so many levels (`/lev`).
  RobocopyCmd levels(String value) => token('/lev:$value');

  /// Copies restartably, so an interrupted file resumes (`/z`).
  RobocopyCmd restartable() => token('/z');

  /// Copies in backup mode, ignoring the ACLs that would block it (`/b`).
  RobocopyCmd backupMode() => token('/b');

  /// Restartable, falling back to backup mode when access is denied (`/zb`).
  RobocopyCmd restartableBackup() => token('/zb');

  /// Unbuffered I/O, which is what large files want (`/j`).
  RobocopyCmd unbuffered() => token('/j');

  /// Which file properties to copy: `D`ata `A`ttributes `T`imes `S`ecurity
  /// `O`wner `U`auditing (`/copy`).
  RobocopyCmd copyFlags(String value) => token('/copy:$value');

  /// The same for directories (`/dcopy`).
  RobocopyCmd dirCopyFlags(String value) => token('/dcopy:$value');

  /// Copies the security descriptors too (`/sec`).
  RobocopyCmd withSecurity() => token('/sec');

  /// Copies everything a file carries (`/copyall`).
  RobocopyCmd copyAll() => token('/copyall');

  /// Deletes what the destination has and the source does not (`/purge`).
  RobocopyCmd purge() => token('/purge');

  /// Makes the destination match the source exactly (`/mir`).
  ///
  /// `/e` plus `/purge`: it deletes. Run [listOnly] once before trusting a path.
  RobocopyCmd mirror() => token('/mir');

  /// Moves the files, deleting them from the source (`/mov`).
  RobocopyCmd moveFiles() => token('/mov');

  /// Moves files and directories both (`/move`).
  RobocopyCmd moveAll() => token('/move');

  /// Creates the tree and zero-length files only (`/create`).
  RobocopyCmd createOnly() => token('/create');

  /// Copies with this many threads, 1 to 128 (`/mt`).
  RobocopyCmd multithreaded(String count) => token('/mt:$count');

  /// Asks for network compression (`/compress`).
  RobocopyCmd compress() => token('/compress');

  /// Copies the symbolic links themselves rather than their targets (`/sl`).
  RobocopyCmd copySymlinks() => token('/sl');

  /// Excludes the files matching these names (`/xf`).
  RobocopyCmd excludeFiles(String pattern) => pair('/xf', pattern);

  /// Excludes the directories matching these names (`/xd`).
  RobocopyCmd excludeDirs(String pattern) => pair('/xd', pattern);

  /// Excludes the changed files (`/xc`).
  RobocopyCmd excludeChanged() => token('/xc');

  /// Excludes the newer ones (`/xn`).
  RobocopyCmd excludeNewer() => token('/xn');

  /// Excludes the older ones (`/xo`).
  RobocopyCmd excludeOlder() => token('/xo');

  /// Excludes the extra files, the ones only the destination has (`/xx`).
  RobocopyCmd excludeExtra() => token('/xx');

  /// Excludes the lonely ones, so nothing new is added (`/xl`).
  RobocopyCmd excludeLonely() => token('/xl');

  /// Includes the identical files (`/is`).
  RobocopyCmd includeSame() => token('/is');

  /// Includes the ones differing only in attributes (`/it`).
  RobocopyCmd includeTweaked() => token('/it');

  /// Excludes the files larger than this (`/max`).
  RobocopyCmd maxSize(String bytes) => token('/max:$bytes');

  /// Excludes the ones smaller (`/min`).
  RobocopyCmd minSize(String bytes) => token('/min:$bytes');

  /// Excludes the files older than this many days, or this date (`/maxage`).
  RobocopyCmd maxAge(String value) => token('/maxage:$value');

  /// Excludes the newer ones (`/minage`).
  RobocopyCmd minAge(String value) => token('/minage:$value');

  /// Excludes the junction points (`/xj`).
  RobocopyCmd excludeJunctions() => token('/xj');

  /// Assumes FAT timestamps, two-second precision (`/fft`).
  RobocopyCmd fatFileTimes() => token('/fft');

  /// Allows a one-hour difference for daylight saving (`/dst`).
  RobocopyCmd daylightSaving() => token('/dst');

  /// How many times to retry a failed file (`/r`). The default is a million.
  RobocopyCmd retries(String count) => token('/r:$count');

  /// How long to wait between retries, in seconds (`/w`). The default is thirty.
  RobocopyCmd waitBetweenRetries(String seconds) => token('/w:$seconds');

  /// Lists what would be copied and copies nothing (`/l`).
  RobocopyCmd listOnly() => token('/l');

  /// The verbose listing, skipped files included (`/v`).
  RobocopyCmd verbose() => token('/v');

  /// Adds the full paths to the output (`/fp`).
  RobocopyCmd fullPaths() => token('/fp');

  /// Prints the sizes in bytes (`/bytes`).
  RobocopyCmd bytes() => token('/bytes');

  /// Leaves the file names out of the log (`/nfl`).
  RobocopyCmd noFileList() => token('/nfl');

  /// Leaves the directory names out (`/ndl`).
  RobocopyCmd noDirectoryList() => token('/ndl');

  /// Drops the percentage counter (`/np`).
  ///
  /// Worth having whenever the output is captured: the counter rewrites its own
  /// line and turns a log into noise.
  RobocopyCmd noProgress() => token('/np');

  /// Leaves the sizes out (`/ns`).
  RobocopyCmd noSize() => token('/ns');

  /// Leaves the file classes out (`/nc`).
  RobocopyCmd noClass() => token('/nc');

  /// Drops the job header (`/njh`).
  RobocopyCmd noJobHeader() => token('/njh');

  /// Drops the job summary (`/njs`).
  RobocopyCmd noJobSummary() => token('/njs');

  /// Writes the output to a log file, replacing it (`/log`).
  RobocopyCmd log(String path) => token('/log:$path');

  /// Appends to it instead (`/log+`).
  RobocopyCmd logAppend(String path) => token('/log+:$path');

  /// Writes to the console and to the log at once (`/tee`).
  RobocopyCmd tee() => token('/tee');

  /// Adds a bare argument.
  RobocopyCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
RobocopyCmd get Robocopy => RobocopyCmd();
