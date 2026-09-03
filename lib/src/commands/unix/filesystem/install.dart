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

/// `install`, the copier that sets mode and ownership in one go, in `/usr/bin` on
/// macOS and part of coreutils on Linux.
///
/// ```dart
/// await Install.directory().owner('postgres').mode('700').path(dataDir).execute();
/// ```
///
/// **The two versions barely overlap.** This wrapper follows BSD, the one on this
/// machine: [backup], [backupSuffix], [compareCopy], [destdir], [fileFlags],
/// [hash], [linkFlags], [metalog], [tags], [flush] and [unprivileged] are BSD
/// inventions, and GNU install has its own `-D`, `-t` and `--strip-program` with
/// different meanings. Only [directory], [owner], [group], [mode], [preserveTimes],
/// [strip] and [verbose] mean the same thing on both.
class InstallCmd extends CommandBuilder<InstallCmd> {
  @override
  final String executable = 'install';

  /// Creates directories instead of copying files, parents included (`-d`).
  InstallCmd directory() => token('-d');

  /// Renames an existing target to `file.old` before writing over it (`-b`).
  InstallCmd backup() => token('-b');

  /// Uses this suffix for [backup] instead of `.old` (`-B`).
  InstallCmd backupSuffix(String value) => pair('-B', value);

  /// Copies, but leaves the timestamp alone when the target is already identical (`-C`).
  InstallCmd compareCopy() => token('-C');

  /// Copies (`-c`). Already the default; the flag exists for old scripts.
  InstallCmd copy() => token('-c');

  /// Names the root the items are installed under, for the metalog (`-D`).
  ///
  /// It does not change where the files actually land.
  InstallCmd destdir(String path) => pair('-D', path);

  /// Sets the target's BSD file flags, `chflags` style (`-f`).
  InstallCmd fileFlags(String value) => pair('-f', value);

  /// Sets the group, by name or gid (`-g`).
  InstallCmd group(String value) => pair('-g', value);

  /// Digests each file into the metalog: `none`, `sha1`, `sha256` or `sha512` (`-h`).
  InstallCmd hash(String value) => pair('-h', value);

  /// Links instead of copying: `a`, `r`, `h`, `s` or `m` (`-l`).
  InstallCmd linkFlags(String value) => pair('-l', value);

  /// Writes an mtree line per item into this file (`-M`).
  InstallCmd metalog(String path) => pair('-M', path);

  /// Sets the permissions, octal or symbolic (`-m`). Defaults to `0755`.
  InstallCmd mode(String value) => pair('-m', value);

  /// Sets the owner, by name or uid (`-o`).
  InstallCmd owner(String value) => pair('-o', value);

  /// Keeps the access and modification times of the source (`-p`).
  InstallCmd preserveTimes() => token('-p');

  /// Fsyncs each file after copying (`-S`).
  ///
  /// Costs real time, and buys back a partial file after a crash.
  InstallCmd flush() => token('-S');

  /// Runs the binary through `strip` on the way in (`-s`).
  InstallCmd strip() => token('-s');

  /// Writes these mtree tags into the metalog (`-T`).
  InstallCmd tags(String value) => pair('-T', value);

  /// Admits it is not root, so owner, group and flags are left alone (`-U`).
  InstallCmd unprivileged() => token('-U');

  /// Prints each file as it is installed (`-v`).
  InstallCmd verbose() => token('-v');

  /// Ends the options, for paths that start with a dash (`--`).
  InstallCmd endOfOptions() => token('--');

  /// Adds a source, or the destination when it comes last.
  InstallCmd path(String value) => token(value);
}

/// `install`, ready to take its first option.
// ignore: non_constant_identifier_names
InstallCmd get Install => InstallCmd();
