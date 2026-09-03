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

/// `sed`, the stream editor. On every Unix, absent from Windows.
///
/// ```dart
/// final ShellResult patched = await Sed.expression('s/^PORT=.*/PORT=8080/').file(env.path).output();
/// ```
///
/// **[inPlace] is the trap.** BSD sed requires an extension argument and takes
/// an empty string to mean none; GNU sed takes the extension glued to the flag
/// and treats a separate argument as a filename. So `sed -i ''` edits in place
/// on macOS and, on Linux, tries to edit a file called `''`. There is no
/// spelling that works on both: [inPlace] emits the BSD form, [inPlaceGnu] the
/// GNU one, and something has to choose between them.
///
/// Which is the argument for not using sed at all here: reading the file in
/// Dart, replacing with a `RegExp`, and writing it back is portable, testable,
/// and does not silently rewrite a file when the pattern was wrong.
class SedCmd extends CommandBuilder<SedCmd> {
  @override
  final String executable = 'sed';

  /// Reads the patterns as extended regular expressions (`-E`).
  ///
  /// The one spelling both flavours accept; the older `-r` is GNU only.
  SedCmd extendedRegex() => token('-E');

  /// Prints nothing unless the script says to (`-n`).
  SedCmd quiet() => token('-n');

  /// Adds a command to the script (`-e`). Repeatable.
  SedCmd expression(String value) => pair('-e', value);

  /// Reads the script from a file (`-f`).
  SedCmd scriptFile(String path) => pair('-f', path);

  /// Edits the files in place, BSD style (`-i ''`).
  ///
  /// Fails on GNU sed, which reads the empty argument as a filename.
  SedCmd inPlace() => pair('-i', '');

  /// Edits in place keeping a backup with this extension (`-i ext`).
  SedCmd inPlaceBackup(String extension) => pair('-i', extension);

  /// Edits the files in place, GNU style (`-i`).
  ///
  /// Fails on BSD sed, which reads the next argument as the extension.
  SedCmd inPlaceGnu() => token('-i');

  /// Treats the files as one long stream rather than one each (`-s` inverted).
  SedCmd separateFiles() => token('-s');

  /// Flushes after every line (`-l` on BSD, `-u` on GNU).
  SedCmd lineBuffered() => token('-l');

  /// Reads the input in text mode, whatever the locale (`-a`).
  SedCmd delayedOpen() => token('-a');

  /// Ends the options (`--`).
  SedCmd endOfOptions() => token('--');

  /// The script, when it has not already been given through [expression].
  SedCmd script(String value) => token(value);

  /// Adds a file to edit. Without one sed reads stdin.
  SedCmd file(String path) => token(path);
}

// ignore: non_constant_identifier_names
SedCmd get Sed => SedCmd();
