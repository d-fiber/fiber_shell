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

/// `dscl`, the Directory Service tool, which is what macOS has instead of
/// `/etc/passwd`, and therefore the counterpart of `usermod` and `useradd` in
/// this directory. Accounts live in a directory node, and editing the flat files
/// achieves nothing.
///
/// ```dart
/// final ShellResult shell = await Dscl.node('.').read().path('/Users/deploy').arg('UserShell').output();
/// // UserShell: /bin/zsh
/// ```
///
/// **The order is options, then node, then command**: `dscl -plist . -read …`,
/// never `dscl . -plist read …`. Get it wrong and dscl prints its usage and
/// **exits zero**, so the mistake reads as a success that returned nothing. Write
/// [plist] and the other options before [node].
///
/// `.` is the local node. Without a command dscl drops into an interactive
/// prompt, which is not what a script wants, so always give it something to do.
///
/// **Creating a usable account takes several calls**, not one: the record, then
/// `UserShell`, `RealName`, `UniqueID`, `PrimaryGroupID`, `NFSHomeDirectory`,
/// then adding it to a group. There is no `useradd` here. Pick a `UniqueID`
/// nobody has, since dscl will happily create a duplicate.
///
/// [read] prints `key: value`, and moves the value onto its own line when it
/// contains a space, so a parser has to handle both shapes. [plist] avoids the
/// question by printing a property list instead, which [PlutilCmd] then turns
/// into JSON:
///
/// ```dart
/// await (Dscl.plist().node('.').read().path('/Users/deploy').arg('UserShell')
///         | Plutil.convert('json').outputPath('-').file('-'))
///     .output();
/// ```
///
/// Anything that writes wants `asRoot()`.
class DsclCmd extends CommandBuilder<DsclCmd> {
  @override
  final String executable = 'dscl';

  /// The directory node to work in. `.` is the local one.
  DsclCmd node(String value) => token(value);

  /// The user to authenticate as on a remote node (`-u`).
  DsclCmd user(String name) => pair('-u', name);

  /// The password to authenticate with (`-P`).
  ///
  /// It lands in the process arguments where `ps` can read it. Leaving it out
  /// makes dscl prompt, which is safer and unusable in a script, so prefer a
  /// local node and `asRoot()`.
  DsclCmd password(String value) => pair('-P', value);

  /// Prompts for the password (`-p`). Interactive.
  DsclCmd promptPassword() => token('-p');

  /// Opens a local node backed by this file (`-f`).
  DsclCmd localFile(String path) => pair('-f', path);

  /// Prints the raw attribute names rather than the friendly ones (`-raw`).
  DsclCmd raw() => token('-raw');

  /// Prints the output as a plist (`-plist`).
  DsclCmd plist() => token('-plist');

  /// URL-encodes the values, so nothing contains a space (`-url`).
  DsclCmd urlEncoded() => token('-url');

  /// Says nothing beyond the answer (`-q`).
  DsclCmd quiet() => token('-q');

  /// Reads a record, or one of its properties (`read`).
  DsclCmd read() => token('read');

  /// Reads every record of a type (`readall`).
  DsclCmd readAll() => token('readall');

  /// Reads inside an attribute that holds a property list (`readpl`).
  ///
  /// Takes three arguments (the record path, the attribute, then a path inside
  /// the plist) and is not the way to read an ordinary attribute; [read] is.
  DsclCmd readPropertyList() => token('readpl');

  /// The same for an attribute holding several property lists, by index (`readpli`).
  DsclCmd readPropertyListIndexed() => token('readpli');

  /// Lists the records under a path (`list`).
  DsclCmd list() => token('list');

  /// Searches for records whose attribute matches a value (`search`).
  DsclCmd search() => token('search');

  /// Creates a record, or sets a property (`create`).
  DsclCmd create() => token('create');

  /// Creates a value inside a property list attribute (`createpl`).
  DsclCmd createPropertyList() => token('createpl');

  /// Adds a value to an existing property (`append`).
  ///
  /// The one that adds an account to a group without emptying the group first.
  DsclCmd append() => token('append');

  /// Adds a value only if it is not already there (`merge`).
  DsclCmd merge() => token('merge');

  /// Replaces one value of a property with another (`change`).
  DsclCmd change() => token('change');

  /// Replaces the value at an index (`changei`).
  DsclCmd changeIndexed() => token('changei');

  /// Deletes a record, a property, or one of its values (`delete`).
  DsclCmd delete() => token('delete');

  /// Compares two records (`diff`).
  DsclCmd diff() => token('diff');

  /// Sets an account password (`passwd`).
  DsclCmd passwd() => token('passwd');

  /// Checks an account password (`auth`).
  DsclCmd auth() => token('auth');

  /// The record path, `/Users/deploy` or `/Groups/staff`.
  DsclCmd path(String value) => token(value);

  /// Adds a bare argument: an attribute name, a value.
  DsclCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
DsclCmd get Dscl => DsclCmd();
