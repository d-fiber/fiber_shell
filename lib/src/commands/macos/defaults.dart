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
