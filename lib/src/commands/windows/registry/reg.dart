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

/// `reg.exe`, the registry editor. Windows has no `/etc`, and this is what
/// stands in for it.
///
/// ```dart
/// final ShellResult value = await Reg.query()
///     .key(r'HKLM\SOFTWARE\Koko')
///     .valueName('DataDir')
///     .output();
/// ```
///
/// [add] with [force] is the idempotent write: without it reg asks before
/// overwriting an existing value and an unattended run stops there.
///
/// **The 32-bit and 64-bit views are different registries.** A 32-bit process
/// reading `HKLM\SOFTWARE` is silently served `HKLM\SOFTWARE\WOW6432Node`
/// instead, so a value written by one build is invisible to the other.
/// [view32] and [view64] say which one you meant.
///
/// [exportKey] before touching anything under `HKLM` is cheap, and it is the
/// only undo there is.
///
/// Writing under `HKLM` needs an elevated prompt; `HKCU` does not.
class RegCmd extends CommandBuilder<RegCmd> {
  @override
  final String executable = 'reg';

  /// Creates a key, or writes a value (`add`).
  RegCmd add() => token('add');

  /// Compares two keys or values (`compare`).
  RegCmd compare() => token('compare');

  /// Copies a key somewhere else (`copy`).
  RegCmd copy() => token('copy');

  /// Deletes a key or a value (`delete`).
  RegCmd delete() => token('delete');

  /// Writes a key out to a `.reg` file (`export`).
  RegCmd exportKey() => token('export');

  /// Reads a `.reg` file back in (`import`).
  RegCmd importKey() => token('import');

  /// Mounts a hive file under a key (`load`).
  RegCmd load() => token('load');

  /// Prints a key and what is under it (`query`).
  RegCmd query() => token('query');

  /// Writes a saved hive back (`restore`).
  RegCmd restore() => token('restore');

  /// Saves a key to a hive file (`save`).
  RegCmd save() => token('save');

  /// Unmounts a hive loaded by [load] (`unload`).
  RegCmd unload() => token('unload');

  /// The value name to act on (`/v`).
  RegCmd valueName(String name) => pair('/v', name);

  /// The key's default, unnamed value (`/ve`).
  RegCmd defaultValue() => token('/ve');

  /// The value type: `REG_SZ`, `REG_DWORD`, `REG_MULTI_SZ`, `REG_EXPAND_SZ`… (`/t`).
  RegCmd type(String value) => pair('/t', value);

  /// The separator between the entries of a `REG_MULTI_SZ` (`/s`).
  RegCmd separator(String value) => pair('/s', value);

  /// Recurses into the subkeys, for [query] (`/s`).
  RegCmd recursive() => token('/s');

  /// The data to write (`/d`).
  RegCmd data(String value) => pair('/d', value);

  /// Does not ask before overwriting or deleting (`/f`).
  RegCmd force() => token('/f');

  /// Searches for this pattern, for [query] (`/f`).
  RegCmd findPattern(String value) => pair('/f', value);

  /// Restricts the search to key names (`/k`).
  RegCmd keysOnly() => token('/k');

  /// Restricts it to value data (`/d`).
  RegCmd dataOnly() => token('/d');

  /// Requires an exact match rather than a substring (`/e`).
  RegCmd exactMatch() => token('/e');

  /// Makes the search case-sensitive (`/c`).
  RegCmd caseSensitive() => token('/c');

  /// Uses the 32-bit registry view (`/reg:32`).
  RegCmd view32() => token('/reg:32');

  /// Uses the 64-bit one (`/reg:64`).
  RegCmd view64() => token('/reg:64');

  /// The key path, `HKLM\SOFTWARE\Koko` or `\\machine\HKLM\…` for a remote one.
  RegCmd key(String path) => token(path);

  /// Adds a bare argument, a file path above all.
  RegCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
RegCmd get Reg => RegCmd();
