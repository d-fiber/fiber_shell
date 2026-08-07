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
