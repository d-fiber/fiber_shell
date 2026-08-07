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

/// `tar`, the archiver. On every Unix, and on current Windows too, which is what
/// earns it a place here rather than in `unix/`.
///
/// ```dart
/// await Tar.create().gzip().file(archive.path).changeDirectory(root).arg('.').execute();
/// ```
///
/// **The mode comes first**: [create], [extract], [list], [append] or [update],
/// then the options, then the paths.
///
/// Two implementations answer to the name and they are not interchangeable. The
/// BSD one, which also ships with Windows, reads far more formats than it writes
/// and takes [noSameOwner] and friends only in some modes; GNU tar has
/// [wildcards], [oneFileSystem] and `--warning`, which BSD does not. The options
/// this wrapper exposes are the ones both accept, apart from those marked
/// otherwise.
///
/// [changeDirectory] rather than a `cwd` is usually what you want when archiving:
/// it decides what the paths inside the archive look like, and an archive full of
/// absolute paths is a restore that overwrites the wrong machine.
class TarCmd extends CommandBuilder<TarCmd> {
  @override
  final String executable = 'tar';

  /// Creates an archive (`--create`).
  TarCmd create() => token('--create');

  /// Extracts from an archive (`--extract`).
  TarCmd extract() => token('--extract');

  /// Lists what an archive holds (`--list`).
  TarCmd list() => token('--list');

  /// Appends to an existing uncompressed archive (`--append`).
  TarCmd append() => token('--append');

  /// Appends only the entries newer than the ones inside (`--update`).
  TarCmd update() => token('--update');

  /// Compares the archive against the filesystem (`--compare`).
  TarCmd compare() => token('--compare');

  /// The archive file, `-` for stdin or stdout (`--file`).
  TarCmd file(String path) => pair('--file', path);

  /// Compresses with gzip (`--gzip`).
  TarCmd gzip() => token('--gzip');

  /// Compresses with bzip2 (`--bzip2`).
  TarCmd bzip2() => token('--bzip2');

  /// Compresses with xz (`--xz`).
  TarCmd xz() => token('--xz');

  /// Compresses with zstd (`--zstd`).
  TarCmd zstd() => token('--zstd');

  /// Compresses with lzma (`--lzma`).
  TarCmd lzma() => token('--lzma');

  /// Picks the decompressor from the file name (`--auto-compress`).
  TarCmd autoCompress() => token('--auto-compress');

  /// Changes directory before the paths that follow are read (`--directory`).
  ///
  /// The clean way to archive the contents of a directory without carrying the
  /// path to it inside the archive.
  TarCmd changeDirectory(String path) => pair('--directory', path);

  /// Lists each entry as it is processed (`--verbose`).
  TarCmd verbose() => token('--verbose');

  /// Says nothing (`--quiet`)
  TarCmd quiet() => token('--quiet');

  /// Strips this many leading path components while extracting (`--strip-components`).
  TarCmd stripComponents(String count) => pair('--strip-components', count);

  /// Excludes the paths matching this pattern (`--exclude`).
  TarCmd exclude(String pattern) => pair('--exclude', pattern);

  /// Excludes the patterns listed in this file (`--exclude-from`).
  TarCmd excludeFrom(String path) => pair('--exclude-from', path);

  /// Reads the list of paths from this file, one per line (`--files-from`).
  TarCmd filesFrom(String path) => pair('--files-from', path);

  /// Separates those paths with NUL rather than newline (`--null`).
  ///
  /// What makes [filesFrom] safe for names containing a newline.
  TarCmd nullSeparated() => token('--null');

  /// Restores the permissions as recorded (`--preserve-permissions`).
  TarCmd preservePermissions() => token('--preserve-permissions');

  /// Extracts as the current user rather than the recorded owner (`--no-same-owner`).
  TarCmd noSameOwner() => token('--no-same-owner');

  /// Applies the umask to the extracted permissions (`--no-same-permissions`).
  TarCmd noSamePermissions() => token('--no-same-permissions');

  /// Follows the symlinks instead of archiving them (`--dereference`).
  TarCmd dereference() => token('--dereference');

  /// Keeps the existing files rather than overwriting (`--keep-old-files`).
  TarCmd keepOldFiles() => token('--keep-old-files');

  /// Keeps a file that is newer than the archived one (`--keep-newer-files`).
  TarCmd keepNewerFiles() => token('--keep-newer-files');

  /// Removes each file once it is archived (`--remove-files`).
  TarCmd removeFiles() => token('--remove-files');

  /// Only the entries newer than this date or file (`--newer`).
  TarCmd newerThan(String value) => pair('--newer', value);

  /// Stays on one filesystem (`--one-file-system`). GNU only.
  TarCmd oneFileSystem() => token('--one-file-system');

  /// Matches the patterns as globs (`--wildcards`). GNU only.
  TarCmd wildcards() => token('--wildcards');

  /// The archive format to write: `gnutar`, `pax`, `ustar`, `v7` (`--format`).
  TarCmd format(String value) => pair('--format', value);

  /// Restores the modification times as recorded (`--preserve-order`).
  TarCmd preserveOrder() => token('--preserve-order');

  /// Uses this program to compress or decompress (`--use-compress-program`).
  TarCmd useCompressProgram(String value) => pair('--use-compress-program', value);

  /// Prints the total size when done (`--totals`).
  TarCmd totals() => token('--totals');

  /// Ends the options, for paths that start with a dash (`--`).
  TarCmd endOfOptions() => token('--');

  /// Adds a path to archive, or a pattern to extract.
  TarCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
TarCmd get Tar => TarCmd();
