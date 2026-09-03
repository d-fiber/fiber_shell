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

/// `mkdir`, the directory maker, in `/bin` on every Unix and part of coreutils on
/// Linux. Nothing to install, anywhere.
///
/// ```dart
/// await Mkdir.parents().mode('700').path('/var/lib/koko/keys').execute();
/// ```
///
/// The BSD version on macOS and the GNU one agree on everything this wrapper
/// exposes; `mkdir` is one of the few utilities where that is true.
class MkdirCmd extends CommandBuilder<MkdirCmd> {
  @override
  final String executable = 'mkdir';

  /// Creates the missing parents too, and stays quiet if the directory is already there (`-p`).
  MkdirCmd parents() => token('-p');

  /// Prints each directory as it is created (`-v`).
  MkdirCmd verbose() => token('-v');

  /// Sets the permissions of the final directory, octal or symbolic (`-m`).
  ///
  /// Only the last component gets them: parents made by [parents] keep `0777` minus the umask.
  MkdirCmd mode(String value) => pair('-m', value);

  /// Ends the options, so a name starting with a dash is still a name (`--`).
  MkdirCmd endOfOptions() => token('--');

  /// Adds a directory to create. Repeat for several.
  MkdirCmd path(String value) => token(value);
}

/// `mkdir`, ready to take its first option.
// ignore: non_constant_identifier_names
MkdirCmd get Mkdir => MkdirCmd();
