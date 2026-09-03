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

/// `cat`, the simplest way to read a file into stdout. On every Unix.
///
/// ```dart
/// final ShellResult contents = await Cat.file('/etc/hosts').output();
/// ```
///
/// For anything past "print this file", prefer reading it in Dart: `cat` piped
/// into another process only exists to work around a tool that cannot take a
/// filename, the so-called "useless use of cat". [showAll], [showTabs],
/// [nonprintingAndEnds] and the plain end-marker form of [showEnds] are GNU
/// extensions; BSD cat has [nonprintingAndEnds] and [nonprintingAndTabs] under
/// the same letters but no long options and no way to print a line ending
/// without also turning on non-printing display. [lock] and unbuffered's
/// meaning under [unbuffered] are BSD-only; GNU accepts `-u` but ignores it,
/// since GNU `cat` is already unbuffered.
class CatCmd extends CommandBuilder<CatCmd> {
  @override
  final String executable = 'cat';

  /// Numbers the non-blank output lines, starting at 1 (`-b`, `--number-nonblank`).
  ///
  /// Overrides [numberLines] when both are given.
  CatCmd numberNonBlank() => token('-b');

  /// Shows non-printing characters and a `$` at the end of each line (`-e`).
  ///
  /// The BSD flag, and the GNU shorthand for [showNonprinting] plus [showEnds].
  CatCmd nonprintingAndEnds() => token('-e');

  /// Marks the end of each line with `$`, nothing else (`-E`, `--show-ends`). GNU only.
  CatCmd showEnds() => token('-E');

  /// Sets an exclusive advisory lock on stdout while writing (`-l`). BSD only.
  CatCmd lock() => token('-l');

  /// Numbers every output line, starting at 1 (`-n`, `--number`).
  CatCmd numberLines() => token('-n');

  /// Squeezes runs of blank lines down to one (`-s`, `--squeeze-blank`).
  CatCmd squeezeBlank() => token('-s');

  /// Shows non-printing characters and tabs as `^I` (`-t`).
  ///
  /// The BSD flag, and the GNU shorthand for [showNonprinting] plus [showTabs].
  CatCmd nonprintingAndTabs() => token('-t');

  /// Shows tab characters as `^I`, nothing else (`-T`, `--show-tabs`). GNU only.
  CatCmd showTabs() => token('-T');

  /// Disables output buffering (`-u`). A no-op on GNU cat, which is always unbuffered.
  CatCmd unbuffered() => token('-u');

  /// Shows non-printing characters, control codes as `^X` (`-v`, `--show-nonprinting`).
  CatCmd showNonprinting() => token('-v');

  /// The GNU shorthand for [showNonprinting], [showEnds] and [showTabs] together
  /// (`-A`, `--show-all`). BSD cat has no equivalent; use the three flags separately.
  CatCmd showAll() => token('-A');

  /// Prints the usage summary (`--help`). GNU only.
  CatCmd help() => token('--help');

  /// Prints the version and exits (`--version`). GNU only.
  CatCmd version() => token('--version');

  /// Ends the options, so a filename starting with a dash is still a filename (`--`).
  CatCmd endOfOptions() => token('--');

  /// Adds a file to read. Repeat for several, in order; `-` means stdin.
  CatCmd file(String path) => token(path);
}

/// `cat`, ready to take its first option.
// ignore: non_constant_identifier_names
CatCmd get Cat => CatCmd();
