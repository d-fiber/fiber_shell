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

/// `plutil`, the property list tool. macOS only, and the honest way to touch a
/// plist from a script: it edits the file rather than the preferences cache, so
/// nothing has to be restarted and nothing gets overwritten behind you.
///
/// ```dart
/// final ShellResult ok = await Plutil.lint().file(plist.path).output();
/// final ShellResult json = await Plutil.convert('json').outputPath('-').file(plist.path).output();
/// ```
///
/// [lint] before handing a plist to `launchctl` saves an afternoon: launchd
/// rejects a malformed one with an error that says nothing about what is wrong.
///
/// [convert] to `json` with `-` as the output path is how a plist becomes
/// something Dart can parse: plists come in three encodings, one of which is
/// binary, and only this turns all of them into the same thing.
///
/// **[convert] rewrites the file in place** unless [outputPath] says otherwise.
class PlutilCmd extends CommandBuilder<PlutilCmd> {
  @override
  final String executable = 'plutil';

  /// Prints the usage summary (`-help`).
  PlutilCmd help() => token('-help');

  /// Prints the plist in a readable form (`-p`). The layout is not stable; do not
  /// parse it.
  PlutilCmd printReadable() => token('-p');

  /// Checks the file for syntax errors (`-lint`). The default command.
  PlutilCmd lint() => token('-lint');

  /// Converts to a format: `xml1`, `binary1`, `json`, `swift`, `objc` (`-convert`).
  PlutilCmd convert(String format) => pair('-convert', format);

  /// Inserts a value at a key path (`-insert`).
  PlutilCmd insert(String keyPath) => pair('-insert', keyPath);

  /// Replaces the value at a key path (`-replace`).
  PlutilCmd replace(String keyPath) => pair('-replace', keyPath);

  /// Removes the value at a key path (`-remove`).
  PlutilCmd remove(String keyPath) => pair('-remove', keyPath);

  /// Prints the value at a key path, in the given format (`-extract`).
  ///
  /// With `raw` it prints the value alone, which is what a script wants.
  PlutilCmd extract(String keyPath, String format) {
    tokens
      ..add('-extract')
      ..add(keyPath)
      ..add(format);
    return self;
  }

  /// Prints the type of the value at a key path (`-type`).
  PlutilCmd typeOf(String keyPath) => pair('-type', keyPath);

  /// Fails unless the value has this type (`-expect`).
  PlutilCmd expect(String type) => pair('-expect', type);

  /// Creates an empty plist in this format (`-create`).
  PlutilCmd create(String format) => pair('-create', format);

  /// The type of the value being inserted or replaced, `-string` and friends.
  PlutilCmd valueType(String type) => token('-$type');

  /// Appends rather than replacing, for an array (`-append`).
  PlutilCmd append() => token('-append');

  /// Leaves off the trailing newline after a raw [extract] (`-n`).
  PlutilCmd noNewline() => token('-n');

  /// Says nothing when it works (`-s`).
  PlutilCmd silent() => token('-s');

  /// Indents the JSON it writes (`-r`).
  PlutilCmd readableJson() => token('-r');

  /// Where the converted file goes, `-` for stdout (`-o`).
  PlutilCmd outputPath(String path) => pair('-o', path);

  /// The extension for the converted files (`-e`).
  PlutilCmd extension(String value) => pair('-e', value);

  /// Ends the options, so everything after is a file name (`--`).
  PlutilCmd endOfOptions() => token('--');

  /// Adds a plist to work on. `-` reads stdin.
  PlutilCmd file(String path) => token(path);

  /// Adds a bare argument, the value of an insert or a replace.
  PlutilCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
PlutilCmd get Plutil => PlutilCmd();
