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

/// `attrib`, the file attribute editor: read-only, hidden, system, archive
/// and beyond. Windows only.
///
/// ```dart
/// await Attrib.plus('h').plus('s').file(r'C:\Data\config.ini').output();
/// ```
///
/// **Every other wrapper in this catalogue takes a flag spelled `-x` or
/// `/x`; `attrib` takes a bare `+x` or `-x` directly against the letter**,
/// with no separating dash or slash. [plus] and [minus] emit exactly that
/// shape, so `Attrib.plus('r')` becomes the single token `+r`, not two.
///
/// The full letter set `attrib` understands: `r` read-only, `a` archive
/// (what [Xcopy]'s `/a`/`/m` look at), `s` system, `h` hidden, `o` offline,
/// `i` not-content-indexed, `x` scrub, `p` pinned, `u` unpinned, `b` SMR
/// blob. `s` and `h` must themselves be cleared before any other attribute
/// on that file can change.
///
/// Every documented switch: `{+|-}r`, `{+|-}a`, `{+|-}s`, `{+|-}h`, `{+|-}o`,
/// `{+|-}i`, `{+|-}x`, `{+|-}p`, `{+|-}u`, `{+|-}b`, `/s`, `/d`, `/l`.
class AttribCmd extends CommandBuilder<AttribCmd> {
  @override
  final String executable = 'attrib';

  /// Sets an attribute letter, e.g. `plus('r')` for read-only.
  AttribCmd plus(String letter) => token('+$letter');

  /// Clears an attribute letter, e.g. `minus('h')` to unhide.
  AttribCmd minus(String letter) => token('-$letter');

  /// Recurses into matching files in the current directory and its
  /// subdirectories (`/s`).
  AttribCmd recursive() => token('/s');

  /// Under [recursive], also processes directories themselves (`/d`).
  AttribCmd includeDirectories() => token('/d');

  /// Acts on a symbolic link itself rather than the target it points to
  /// (`/l`).
  AttribCmd reparsePoint() => token('/l');

  /// The file or directory to act on. Wildcards (`?`, `*`) allowed.
  AttribCmd path(String value) => token(value);
}

/// `attrib`, ready to take its first option.
// ignore: non_constant_identifier_names
AttribCmd get Attrib => AttribCmd();
