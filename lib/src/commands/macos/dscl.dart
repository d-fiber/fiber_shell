// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

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
