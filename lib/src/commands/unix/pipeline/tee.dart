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

/// `tee`, which copies stdin to a file and to stdout at once. On every Unix,
/// absent from Windows.
///
/// ```dart
/// await (Deno.test().scriptArg('tests/') | Tee.append().file(log.path)).execute();
/// ```
///
/// The point is having both: the output scrolls past for whoever is watching and
/// lands in a file for whoever reads it afterwards. `writeTo` gives only the
/// file.
///
/// Its other use is writing to a file you cannot open yourself: `… | sudo tee
/// /etc/sysctl.d/99-koko.conf` puts the privilege on `tee` rather than on the
/// shell, since a redirection is opened by the shell before `sudo` ever runs.
/// Here that is `Tee.file(path).asRoot()`.
///
/// **Without [append] it truncates**, and it truncates when the pipeline starts,
/// so a producer that fails immediately still leaves the file empty.
class TeeCmd extends CommandBuilder<TeeCmd> {
  @override
  final String executable = 'tee';

  /// Appends rather than truncating (`-a`).
  TeeCmd append() => token('-a');

  /// Ignores the interrupt signal (`-i`).
  TeeCmd ignoreInterrupts() => token('-i');

  /// Ends the options, for names starting with a dash (`--`).
  TeeCmd endOfOptions() => token('--');

  /// Adds a file to write to. Repeat for several.
  TeeCmd file(String path) => token(path);
}

// ignore: non_constant_identifier_names
TeeCmd get Tee => TeeCmd();
