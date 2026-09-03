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

/// `icacls`, the ACL editor, the counterpart of `chmod`, except Windows
/// permissions are access control lists rather than nine bits. Windows only.
///
/// ```dart
/// await Icacls.name(keyFile).inheritance('r').grantReplace(r'%USERNAME%:F').execute();
/// ```
///
/// That pair is the closest thing to `chmod 600`: cut the inheritance from the
/// parent folder, then grant the owner alone. Cutting inheritance first is the
/// part people forget: a `grant` on a file that still inherits `Users:(RX)`
/// leaves everyone able to read it.
///
/// **[grant] adds to the existing permissions; [grantReplace] replaces them.**
/// The difference is `:r`, two characters, and it decides whether the command
/// tightens anything at all.
///
/// The permission letters are `N` none, `F` full, `M` modify, `RX` read and
/// execute, `R` read, `W` write, `D` delete; the inheritance flags `(OI)`
/// object-inherit and `(CI)` container-inherit only mean something on a
/// directory. A deny beats every grant, whatever the order.
///
/// [save] before a bulk change is the only undo, and [restore] is how you use it.
class IcaclsCmd extends CommandBuilder<IcaclsCmd> {
  @override
  final String executable = 'icacls';

  /// The file or directory to act on. Comes first.
  IcaclsCmd name(String path) => token(path);

  /// Grants rights on top of what is already there (`/grant`).
  IcaclsCmd grant(String sidAndPerm) => pair('/grant', sidAndPerm);

  /// Replaces the explicit grants of that SID (`/grant:r`).
  IcaclsCmd grantReplace(String sidAndPerm) => pair('/grant:r', sidAndPerm);

  /// Denies rights explicitly (`/deny`). A deny wins over any grant.
  IcaclsCmd deny(String sidAndPerm) => pair('/deny', sidAndPerm);

  /// Removes every entry for a SID (`/remove`).
  IcaclsCmd remove(String sid) => pair('/remove', sid);

  /// Removes only its grants (`/remove:g`).
  IcaclsCmd removeGrants(String sid) => pair('/remove:g', sid);

  /// Removes only its denials (`/remove:d`).
  IcaclsCmd removeDenials(String sid) => pair('/remove:d', sid);

  /// Sets inheritance: `e` enable, `d` disable and copy, `r` disable and remove
  /// (`/inheritancelevel:`).
  ///
  /// `d` keeps the inherited entries as explicit ones, `r` throws them away,
  /// which is usually what "only the owner" means.
  IcaclsCmd inheritance(String level) => token('/inheritancelevel:$level');

  /// Changes the owner (`/setowner`).
  IcaclsCmd setOwner(String user) => pair('/setowner', user);

  /// Finds the files whose ACL names a SID (`/findsid`).
  IcaclsCmd findSid(String sid) => pair('/findsid', sid);

  /// Reports the ACLs that are malformed (`/verify`).
  IcaclsCmd verify() => token('/verify');

  /// Throws the ACL away and inherits from the parent again (`/reset`).
  IcaclsCmd reset() => token('/reset');

  /// Writes the ACLs of the matching files to a file (`/save`).
  IcaclsCmd save(String aclFile) => pair('/save', aclFile);

  /// Applies a saved ACL file to a directory (`/restore`).
  IcaclsCmd restore(String aclFile) => pair('/restore', aclFile);

  /// Sets the integrity level, `l`, `m` or `h` (`/setintegritylevel`).
  IcaclsCmd setIntegrityLevel(String level) => pair('/setintegritylevel', level);

  /// Replaces one SID with another (`/substitute`).
  IcaclsCmd substitute(String oldSid, String newSid) {
    tokens
      ..add('/substitute')
      ..add(oldSid)
      ..add(newSid);
    return self;
  }

  /// Recurses into the subdirectories (`/t`).
  IcaclsCmd recursive() => token('/t');

  /// Carries on past the files it could not change (`/c`).
  IcaclsCmd continueOnError() => token('/c');

  /// Acts on a symbolic link rather than its target (`/l`).
  IcaclsCmd symlinkItself() => token('/l');

  /// Says nothing on success (`/q`).
  IcaclsCmd quiet() => token('/q');

  /// Adds a bare argument.
  IcaclsCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
IcaclsCmd get Icacls => IcaclsCmd();
