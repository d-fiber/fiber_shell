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

/// `sysctl`, the BSD kernel-state tool macOS ships. **A different program from the Linux
/// `sysctl`** this package already wraps as [Sysctl]: this one takes single-letter getopt flags
/// and dotted `hw.`/`kern.`/`net.`/`vm.`/`user.` names, rather than the `--long` flags and the
/// `/proc/sys` paths the Linux one reads.
///
/// ```dart
/// final ShellResult cores = await DarwinSysctl.valuesOnly().arg('hw.physicalcpu').output();
/// await DarwinSysctl.arg('kern.hostname=box').asRoot().execute();
/// ```
///
/// Reading needs no privilege. Writing usually does, hence `asRoot()`, though a handful of
/// `kern.*` values are marked changeable without it; nothing here tells those apart, so a caller
/// that only sometimes needs root should try unprivileged first and elevate on failure rather
/// than assume either way.
class DarwinSysctlCmd extends CommandBuilder<DarwinSysctlCmd> {
  @override
  final String executable = 'sysctl';

  /// Lists every readable value, opaque ones included, the same as [opaque] plus [all] (`-A`).
  DarwinSysctlCmd allWithOpaque() => token('-A');

  /// Lists every readable value except the opaque ones (`-a`). Ignored once a name is given.
  DarwinSysctlCmd all() => token('-a');

  /// Prints the value in raw binary, with no name and no trailing newline (`-b`).
  ///
  /// Meant for a single variable: nothing separates one value from the next.
  DarwinSysctlCmd binary() => token('-b');

  /// Reads this many bytes from a variable of variable length (`-B`).
  ///
  /// A probe value of `0` is valid, and is how a caller asks for the length without the value.
  DarwinSysctlCmd bufferSize(int bytes) => pair('-B', '$bytes');

  /// Prints the description of the variable instead of its value (`-d`).
  DarwinSysctlCmd description() => token('-d');

  /// Separates the name and the value with `=` rather than a space (`-e`).
  ///
  /// What produces output `sysctl` itself can read back. Ignored under [namesOnly] or
  /// [valuesOnly], and while a value is being set.
  DarwinSysctlCmd equalsSeparator() => token('-e');

  /// Reads `name value` pairs from this file before the ones named on the command line (`-f`).
  DarwinSysctlCmd file(String path) => pair('-f', path);

  /// Prints the format of the variable: additional detail for the struct types, `clockinfo`,
  /// `timeval` and `loadavg` among them (`-F`).
  DarwinSysctlCmd format() => token('-F');

  /// Formats the output for a person to read rather than a script (`-h`).
  DarwinSysctlCmd human() => token('-h');

  /// Ignores a name this machine does not carry instead of failing on it (`-i`).
  ///
  /// What lets one script read the same names across machines that are not all running exactly
  /// the same kernel.
  DarwinSysctlCmd ignoreUnknown() => token('-i');

  /// Shows the length of each variable next to its value (`-l`). Not with [namesOnly].
  DarwinSysctlCmd length() => token('-l');

  /// Prints only the names, not the values (`-N`).
  ///
  /// Particularly useful for a shell's programmable completion, which is what the underlying
  /// `-Na` gives `zsh` and `tcsh` for completing sysctl names.
  DarwinSysctlCmd namesOnly() => token('-N');

  /// Prints only the values, not the names (`-n`). What a shell assignment wants.
  DarwinSysctlCmd valuesOnly() => token('-n');

  /// Shows the opaque variables too, as a hex dump of their first sixteen bytes (`-o`).
  ///
  /// The opaque data is normally suppressed; a purpose-built reader like `ps` or `netstat` makes
  /// more sense of it than a hex dump ever will.
  DarwinSysctlCmd opaque() => token('-o');

  /// Suppresses the warnings sysctl would otherwise print to standard error (`-q`).
  DarwinSysctlCmd quiet() => token('-q');

  /// Prints the type of the variable (`-t`).
  DarwinSysctlCmd type() => token('-t');

  /// Lists only the variables a privileged process could change (`-W`).
  ///
  /// The set of runtime tunables, as opposed to the read-only ones no `asRoot()` will move.
  DarwinSysctlCmd writableOnly() => token('-W');

  /// The same as [hexDump] plus [all] (`-X`).
  DarwinSysctlCmd allHexDump() => token('-X');

  /// Like [opaque], but dumps the whole value in hex instead of just the first sixteen bytes (`-x`).
  DarwinSysctlCmd hexDump() => token('-x');

  /// Reads a MIB name, or writes it with `name=value` (`,value` for a struct with several
  /// fields).
  DarwinSysctlCmd arg(String value) => token(value);
}

/// `sysctl`, macOS's BSD kernel-state tool, ready to take its first option.
// ignore: non_constant_identifier_names
DarwinSysctlCmd get DarwinSysctl => DarwinSysctlCmd();
