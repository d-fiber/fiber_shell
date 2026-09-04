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

/// `diskpart`, the disk/partition/volume management interpreter. Windows
/// only, and needs an elevated (Administrators-group) prompt.
///
/// **This wrapper does not — cannot — model `diskpart`'s own commands.**
/// Unlike every other wrapper in this catalogue, `diskpart.exe` itself takes
/// almost no command-line switches at all: its real vocabulary (`select
/// disk`, `create partition primary`, `clean`, `format`, `assign`, …) lives
/// entirely inside an interactive text-mode shell, or a script fed to it with
/// [script]. There is no way to pass `select disk 1` as `argv` the way `rm
/// -rf` passes `-rf`. So this class's job is narrow: build the invocation
/// that runs a script, not the operations inside it.
///
/// ```dart
/// final File script = await File('${Directory.systemTemp.path}\\wipe.txt').writeAsString(
///   'select disk 1\r\nclean\r\ncreate partition primary\r\nformat fs=ntfs quick\r\nassign letter=D\r\n',
/// );
/// await Diskpart.script(script.path).asRoot().execute();
/// ```
///
/// **`clean`, `clean all` and `format` inside a script are irreversible** —
/// they erase partition tables and, with `all`, every sector on the disk.
/// `diskpart` runs a script top to bottom and stops on the first error unless
/// each line ends with `noerr`; get the disk number wrong in `select disk`
/// and a `clean` further down the script can take out the wrong drive. There
/// is no confirmation prompt inside a scripted run — that's the whole point
/// of scripting it, and the whole risk of scripting it.
///
/// Two script lines you cannot get from the exit code alone: `list disk` /
/// `list volume` output has to be parsed from [ShellResult.text] if a script
/// needs to make a decision based on what disks exist, since there is no
/// structured (JSON/CSV) output mode.
class DiskpartCmd extends CommandBuilder<DiskpartCmd> {
  @override
  final String executable = 'diskpart';

  /// Runs the named script file instead of starting the interactive shell
  /// (`/s <script>`). This is the only way to drive `diskpart`
  /// non-interactively — see the class doc for why there is no per-operation
  /// method here.
  DiskpartCmd script(String path) => pair('/s', path);

  /// Prints usage help (`/?`).
  DiskpartCmd help() => token('/?');
}

/// `diskpart`, ready to take its first option.
// ignore: non_constant_identifier_names
DiskpartCmd get Diskpart => DiskpartCmd();
