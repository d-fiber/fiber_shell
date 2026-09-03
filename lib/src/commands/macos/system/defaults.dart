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

/// `defaults`, the preferences editor. macOS only: it reads and writes the
/// `cfprefsd` domains that back every application's settings.
///
/// ```dart
/// final ShellResult value = await Defaults.read().domain('com.apple.dock').key('autohide').output();
/// await Defaults.write().domain('com.apple.dock').key('autohide').boolean('true').execute();
/// ```
///
/// **A running application will not see the change**, and may well overwrite it:
/// preferences are cached per process by `cfprefsd`, so the usual recipe is to
/// write while the application is closed, or to restart it afterwards.
///
/// A domain is a bundle identifier, `-globalDomain`, or a path to a plist with
/// the extension left off. That last form is the useful one for a plist that
/// belongs to no application, but for those [PlutilCmd] edits the file
/// directly and skips the cache entirely.
///
/// The type flags are not cosmetic. Writing `true` without [boolean] stores the
/// four-character string, and whatever reads it later gets a string that is
/// always truthy.
class DefaultsCmd extends CommandBuilder<DefaultsCmd> {
  @override
  final String executable = 'defaults';

  /// Works on the per-machine preferences of this host (`-currentHost`).
  DefaultsCmd currentHost() => token('-currentHost');

  /// Works on the per-machine preferences of a named host (`-host`).
  DefaultsCmd host(String name) => pair('-host', name);

  /// Prints a domain, a key, or everything (`read`).
  DefaultsCmd read() => token('read');

  /// Prints the type of a key (`read-type`).
  DefaultsCmd readType() => token('read-type');

  /// Writes a key, or replaces a whole domain (`write`).
  DefaultsCmd write() => token('write');

  /// Renames a key, keeping its value (`rename`).
  DefaultsCmd rename() => token('rename');

  /// Deletes a key, or a whole domain (`delete`).
  DefaultsCmd delete() => token('delete');

  /// Deletes it from every container (`delete-all`).
  DefaultsCmd deleteAll() => token('delete-all');

  /// Writes a plist file, or stdin, into a domain (`import`).
  DefaultsCmd importPlist() => token('import');

  /// Writes a domain out as a plist, `-` for stdout (`export`).
  DefaultsCmd exportPlist() => token('export');

  /// Lists every domain (`domains`).
  DefaultsCmd domains() => token('domains');

  /// Finds the entries containing a word, across every domain (`find`).
  DefaultsCmd find() => token('find');

  /// Prints the usage summary (`help`).
  DefaultsCmd help() => token('help');

  /// The domain: a bundle identifier, or a plist path without the extension.
  DefaultsCmd domain(String value) => token(value);

  /// The domain of an application, found by name (`-app`).
  DefaultsCmd app(String name) => pair('-app', name);

  /// The domain shared by everything (`-globalDomain`).
  DefaultsCmd globalDomain() => token('-globalDomain');

  /// The key inside the domain.
  DefaultsCmd key(String name) => token(name);

  /// Writes the value as a string (`-string`).
  DefaultsCmd string(String value) => pair('-string', value);

  /// Writes it as raw data, given in hex (`-data`).
  DefaultsCmd data(String hex) => pair('-data', hex);

  /// Writes it as an integer (`-int`).
  DefaultsCmd integer(String value) => pair('-int', value);

  /// Writes it as a float (`-float`).
  DefaultsCmd float(String value) => pair('-float', value);

  /// Writes it as a boolean: `true`, `false`, `yes` or `no` (`-bool`).
  DefaultsCmd boolean(String value) => pair('-bool', value);

  /// Writes it as a date (`-date`).
  DefaultsCmd date(String value) => pair('-date', value);

  /// Writes it as an array; every argument after this one is an element (`-array`).
  DefaultsCmd array() => token('-array');

  /// Appends to an existing array (`-array-add`).
  DefaultsCmd arrayAdd() => token('-array-add');

  /// Writes it as a dictionary of alternating keys and values (`-dict`).
  DefaultsCmd dictionary() => token('-dict');

  /// Adds to an existing dictionary (`-dict-add`).
  DefaultsCmd dictionaryAdd() => token('-dict-add');

  /// Adds a bare argument: a value, an array element, a dictionary key.
  DefaultsCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
DefaultsCmd get Defaults => DefaultsCmd();
