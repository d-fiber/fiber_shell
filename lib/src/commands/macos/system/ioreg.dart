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

/// `ioreg`, which shows the I/O Kit registry as an inverted provider/client
/// tree. macOS only.
///
/// ```dart
/// final ShellResult battery = await Ioreg.className('AppleSmartBattery').archiveXml().output();
/// ```
///
/// Object properties are hidden by default; supplying [className], [key] or
/// [name] is what makes `ioreg` show them, which is easy to miss when a
/// first attempt returns just the bare tree. [depth] of `1` shows only
/// (sub)tree roots — useful for a quick `-d 1 -k IORegistryPlanes` to
/// enumerate the available planes before picking one with [plane].
/// [archiveXml] is the only structured output mode; plain-text output has no
/// stable grammar to parse.
class IoregCmd extends CommandBuilder<IoregCmd> {
  @override
  final String executable = 'ioreg';

  /// Archives the output as XML (`-a`). The only machine-parseable mode.
  IoregCmd archiveXml() => token('-a');

  /// Shows the object name in bold (`-b`).
  IoregCmd bold() => token('-b');

  /// Shows properties only for objects that are, or derive from, this C++
  /// class, e.g. `IOService` (`-c`).
  IoregCmd className(String name) => pair('-c', name);

  /// Limits tree traversal to this depth, per subtree root (`-d`). `1`
  /// shows only the subtree roots.
  IoregCmd depth(int levels) => pair('-d', '$levels');

  /// Enables smart formatting of known properties (`reg`,
  /// `assigned-addresses`, `slot-names`, `ranges`, `interrupt-map`,
  /// `interrupt-parent`, `interrupts`) (`-f`).
  IoregCmd smartFormatting() => token('-f');

  /// Shows object inheritance (`-i`).
  IoregCmd inheritance() => token('-i');

  /// Shows properties only for objects carrying this exact property key
  /// (`-k`). Substrings do not match.
  IoregCmd key(String propertyKey) => pair('-k', propertyKey);

  /// Shows properties for every displayed object (`-l`).
  IoregCmd allProperties() => token('-l');

  /// Shows properties only for objects with this exact name (`-n`).
  IoregCmd name(String objectName) => pair('-n', objectName);

  /// Traverses this registry plane instead of the default `IOService`
  /// (`-p`). Discover others via `ioreg -d 1 -k IORegistryPlanes`.
  IoregCmd plane(String planeName) => pair('-p', planeName);

  /// Shows subtrees rooted by objects matching [className], [key] or [name]
  /// (`-r`). Has no effect unless one of those is also given.
  IoregCmd rootMatching() => token('-r');

  /// Shows the tree location (ancestors) of each matched subtree (`-t`).
  IoregCmd showLocation() => token('-t');

  /// Clips output to this line width; `0` for unlimited (`-w`). Defaults to
  /// the current screen width.
  IoregCmd width(int columns) => pair('-w', '$columns');

  /// Shows data and numbers in hexadecimal (`-x`).
  IoregCmd hex() => token('-x');

  /// Excludes DriverKit classes when matching with [className] (`-y`).
  IoregCmd excludeDriverKit() => token('-y');
}

/// `ioreg`, ready to take its first option.
// ignore: non_constant_identifier_names
IoregCmd get Ioreg => IoregCmd();
