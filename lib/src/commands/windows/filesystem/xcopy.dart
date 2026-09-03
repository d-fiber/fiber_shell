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

/// `xcopy`, the old recursive copier that predates `robocopy` and still ships
/// alongside it. Windows only.
///
/// ```dart
/// final ShellResult copied = await Xcopy
///     .source(build.path)
///     .destination(deploy.path)
///     .subdirectoriesIncludingEmpty()
///     .overwriteQuiet()
///     .output();
/// ```
///
/// [Robocopy] (already wrapped) is the better choice for anything that needs
/// retries, mirroring or logging; `xcopy` earns its keep for the simple case
/// where its prompts-suppression flags are enough.
///
/// **Without [overwriteQuiet], `xcopy` prompts on every file it would
/// overwrite**, and without [assumeDirectory] it also prompts to ask whether
/// an ambiguous destination is a file or a directory. A non-interactive
/// process just hangs there forever waiting on a keystroke that never comes.
///
/// Exit codes are not pass/fail the way most tools in this catalogue are:
/// `0` copied fine, `1` nothing matched, `2` the user hit Ctrl+C, `4` an
/// initialization error (out of memory or disk, or a bad path), `5` a disk
/// write error. Read [ShellResult.exitCode] rather than trusting [execute]
/// to throw only on real trouble — `1` is not always worth failing a script
/// over.
///
/// Every documented switch: `/w`, `/p`, `/c`, `/v`, `/q`, `/f`, `/l`, `/g`,
/// `/d`, `/u`, `/i`, `/s`, `/e`, `/t`, `/k`, `/r`, `/h`, `/a`, `/m`, `/n`,
/// `/o`, `/x`, `/exclude`, `/y`, `/-y`, `/z`, `/b`, `/j`, `/compress`,
/// `/sparse`, `/-sparse`, `/noclone`.
class XcopyCmd extends CommandBuilder<XcopyCmd> {
  @override
  final String executable = 'xcopy';

  /// The directory or file to copy from. Comes first.
  XcopyCmd source(String path) => token(path);

  /// The directory or file to copy to. Comes second.
  XcopyCmd destination(String path) => token(path);

  /// Waits for a keypress before copying, printing a prompt first (`/w`).
  /// The default is to start immediately; this is rarely wanted in a script.
  XcopyCmd waitForKeypress() => token('/w');

  /// Asks whether to create each destination file (`/p`).
  XcopyCmd confirmEachFile() => token('/p');

  /// Ignores errors instead of stopping on the first one (`/c`).
  XcopyCmd ignoreErrors() => token('/c');

  /// Verifies each file as it is written, comparing it to the source (`/v`).
  XcopyCmd verify() => token('/v');

  /// Suppresses the `xcopy` status messages (`/q`).
  XcopyCmd quiet() => token('/q');

  /// Displays source and destination file names while copying (`/f`).
  XcopyCmd showFullPaths() => token('/f');

  /// Lists the files that would be copied, without copying them (`/l`).
  XcopyCmd listOnly() => token('/l');

  /// Creates decrypted destination files when the destination volume does
  /// not support encryption (`/g`).
  XcopyCmd allowDecryptedDestination() => token('/g');

  /// Copies only source files changed on or after this date, `MM-DD-YYYY`;
  /// omit [date] to copy every source file newer than its destination
  /// counterpart (`/d`).
  XcopyCmd changedSince([String? date]) => token(date == null ? '/d' : '/d:$date');

  /// Copies only source files that already exist at the destination (`/u`).
  XcopyCmd updateExistingOnly() => token('/u');

  /// Assumes an ambiguous destination is a directory, suppressing the
  /// file-or-directory prompt (`/i`).
  XcopyCmd assumeDirectory() => token('/i');

  /// Copies subdirectories, skipping the empty ones (`/s`).
  XcopyCmd subdirectories() => token('/s');

  /// Copies them including the empty ones (`/e`). Use with [subdirectories]
  /// or [treeOnly].
  XcopyCmd subdirectoriesIncludingEmpty() => token('/e');

  /// Copies the subdirectory structure only, no files (`/t`). Combine with
  /// [subdirectoriesIncludingEmpty] to include the empty directories too.
  XcopyCmd treeOnly() => token('/t');

  /// Keeps the read-only attribute on destination files if the source had it
  /// (`/k`). By default `xcopy` clears it.
  XcopyCmd keepAttributes() => token('/k');

  /// Copies read-only files too (`/r`).
  XcopyCmd includeReadOnly() => token('/r');

  /// Copies files with the hidden and system attributes, which are skipped
  /// by default (`/h`).
  XcopyCmd includeHiddenAndSystem() => token('/h');

  /// Copies only source files with the archive attribute set, and does not
  /// clear it (`/a`).
  XcopyCmd archiveOnly() => token('/a');

  /// The same, but clears the archive attribute on the source files after
  /// copying (`/m`).
  XcopyCmd archiveOnlyAndReset() => token('/m');

  /// Uses NTFS short (8.3) names, needed when copying onto a FAT volume or
  /// where the destination requires 8.3 naming (`/n`).
  XcopyCmd useShortNames() => token('/n');

  /// Copies file ownership and discretionary ACL information (`/o`).
  XcopyCmd withOwnershipAndAcls() => token('/o');

  /// Copies file audit settings and system ACL information; implies
  /// [withOwnershipAndAcls] (`/x`).
  XcopyCmd withAuditSettings() => token('/x');

  /// Excludes files whose path matches any string listed, one per line, in
  /// these files (`/exclude:`).
  XcopyCmd exclude(String listFiles) => token('/exclude:$listFiles');

  /// Overwrites without asking (`/y`). The one flag that keeps this
  /// non-interactive; also settable through the `COPYCMD` environment
  /// variable, which this overrides.
  XcopyCmd overwriteQuiet() => token('/y');

  /// Asks before overwriting, overriding a `/y` set through `COPYCMD`
  /// (`/-y`).
  XcopyCmd overwriteConfirm() => token('/-y');

  /// Copies over a network in restartable mode, resuming after a dropped
  /// connection (`/z`). Also shows a per-file completion percentage.
  XcopyCmd restartable() => token('/z');

  /// Copies the symbolic link itself rather than its target (`/b`).
  XcopyCmd copySymlink() => token('/b');

  /// Copies without buffering, recommended for very large files (`/j`).
  XcopyCmd unbuffered() => token('/j');

  /// Requests network compression during the transfer, where supported
  /// (`/compress`).
  XcopyCmd compress() => token('/compress');

  /// Retains the sparse state of files during the copy (`/sparse`).
  XcopyCmd sparse() => token('/sparse');

  /// Disables retaining it, overriding a preceding [sparse] (`/-sparse`).
  XcopyCmd noSparse() => token('/-sparse');

  /// Skips block-cloning as a copy optimization (`/noclone`).
  XcopyCmd noClone() => token('/noclone');
}

/// `xcopy`, ready to take its first option.
// ignore: non_constant_identifier_names
XcopyCmd get Xcopy => XcopyCmd();
