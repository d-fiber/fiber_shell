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

/// `qlmanage`, the Quick Look Server's debug and management tool: testing
/// generators and driving thumbnail/preview generation from the command
/// line. macOS only.
///
/// ```dart
/// await Qlmanage.thumbnails().size(512).outputDir('thumbs/').file('report.pdf').execute();
/// final ShellResult stats = await Qlmanage.stats(['plugins']).output();
/// ```
///
/// [thumbnails] and [previews] normally pop the Quick Look window on
/// screen; [outputDir] is what redirects the result to files instead,
/// making this usable headlessly. [remote] routes generation through the
/// running `quicklookd` rather than computing in-process, which matters
/// when testing a generator that is also registered system-wide. [reset]
/// invalidates every client's generator cache, not just this process's —
/// a blunt tool to reach for only when a generator update genuinely isn't
/// being picked up.
class QlmanageCmd extends CommandBuilder<QlmanageCmd> {
  @override
  final String executable = 'qlmanage';

  /// Prints extensive help (`-h`).
  QlmanageCmd help() => token('-h');

  /// Forces reloading the generators list, or resets the thumbnail disk
  /// cache when [target] is `cache` (`-r [cache]`).
  QlmanageCmd reset([String? target]) => target == null ? token('-r') : pair('-r', target);

  /// Displays statistics about `quicklookd`: any of `plugins`, `server`,
  /// `memory`, `burst`, `threads`, `other`, or none for everything (`-m`).
  QlmanageCmd stats([List<String> names = const []]) => names.isEmpty ? token('-m') : joinedAll('-m', names);

  /// Computes Quick Look previews of the given documents (`-p`).
  QlmanageCmd previews() => token('-p');

  /// Computes Quick Look thumbnails of the given documents (`-t`).
  QlmanageCmd thumbnails() => token('-t');

  /// Routes generation through the running `quicklookd` (remote
  /// computation) rather than in-process (`-x`).
  QlmanageCmd remote() => token('-x');

  /// Computes the thumbnail in icon mode (`-i`).
  QlmanageCmd iconMode() => token('-i');

  /// The thumbnail size, in points (`-s`).
  QlmanageCmd size(int points) => pair('-s', '$points');

  /// The thumbnail scale factor (`-f`).
  QlmanageCmd factor(num value) => pair('-f', '$value');

  /// The thumbnail scale factor, drawn downscaled and compared against 1x
  /// (`-F`).
  QlmanageCmd factorCompare(num value) => pair('-F', '$value');

  /// Displays generation performance info instead of the thumbnails
  /// themselves (`-z`).
  QlmanageCmd performanceInfo() => token('-z');

  /// Writes results into this directory instead of displaying them
  /// (`-o`). Required for headless (non-interactive) use.
  QlmanageCmd outputDir(String dir) => pair('-o', dir);

  /// Forces the content type (UTI) used for the documents, instead of
  /// letting Quick Look detect it (`-c`).
  QlmanageCmd contentType(String uti) => pair('-c', uti);

  /// Forces a specific generator to be used, rather than the one Quick Look
  /// would pick (`-g`).
  QlmanageCmd generator(String bundleId) => pair('-g', bundleId);

  /// A file to generate a thumbnail or preview for. Repeatable.
  QlmanageCmd file(String path) => token(path);
}

/// `qlmanage`, ready to take its first option.
// ignore: non_constant_identifier_names
QlmanageCmd get Qlmanage => QlmanageCmd();
