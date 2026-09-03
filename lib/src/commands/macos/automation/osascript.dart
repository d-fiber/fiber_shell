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

/// `osascript`, which runs an OSA script — AppleScript by default,
/// JavaScript for Automation with [language] — from the command line. macOS
/// only.
///
/// ```dart
/// final ShellResult name = await Osascript
///     .statement('tell application "Finder"')
///     .statement('return name of startup disk')
///     .statement('end tell')
///     .output();
/// ```
///
/// The first run against a given application triggers a TCC prompt for
/// Automation (and Accessibility, for UI scripting) permission; a script run
/// unattended, over SSH or from a launchd job, fails silently until Terminal
/// or the calling process has been granted that access in System Settings.
/// There is no flag that skips the prompt.
///
/// [statement] builds a script line by line and is the form worth quoting
/// correctly from Dart rather than a shell; a script already saved as a file
/// or a compiled `.scpt` is passed with [scriptFile] instead, and [arg] adds
/// the values handed to the script's `run` handler.
class OsascriptCmd extends CommandBuilder<OsascriptCmd> {
  @override
  final String executable = 'osascript';

  /// Adds one line of the script (`-e`). Repeatable; each call builds up
  /// another line of a multi-line script, and once given, `osascript` does
  /// not also look for a script file.
  OsascriptCmd statement(String line) => pair('-e', line);

  /// Runs interactively, prompting for one line at a time and printing its
  /// result (`-i`). Not for a script; any [statement] or [scriptFile] given
  /// alongside is loaded but not run before the prompt starts.
  OsascriptCmd interactive() => token('-i');

  /// Overrides the language used to compile a plain-text script, `AppleScript`
  /// or `JavaScript` (`-l`). Plain text is AppleScript by default.
  OsascriptCmd language(String name) => pair('-l', name);

  /// Sets the output style modifiers directly, any combination of `e`, `h`,
  /// `o`, `s` (`-s`). Prefer [humanReadable], [recompilableSource],
  /// [errorsToStderr] or [errorsToStdout] for the common single-letter
  /// cases.
  OsascriptCmd styleFlags(String flags) => pair('-s', flags);

  /// Prints results in human-readable form: no quotes on strings, no escaped
  /// characters (`-s h`). The default.
  OsascriptCmd humanReadable() => pair('-s', 'h');

  /// Prints results in recompilable source form, so `{"foo", "bar"}` and
  /// `{{"foo", {"bar"}}}` no longer look identical (`-s s`).
  OsascriptCmd recompilableSource() => pair('-s', 's');

  /// Sends script errors to stderr, keeping stdout to valid results only
  /// (`-s e`). The default.
  OsascriptCmd errorsToStderr() => pair('-s', 'e');

  /// Sends script errors to stdout instead, so an automated test can tell a
  /// script error from other diagnostic output (`-s o`).
  OsascriptCmd errorsToStdout() => pair('-s', 'o');

  /// The script file to run, plain text or a compiled `.scpt`. Pass `-` to
  /// read the script from stdin.
  OsascriptCmd scriptFile(String path) => token(path);

  /// An argument passed to the script's `run` handler, in order.
  OsascriptCmd arg(String value) => token(value);
}

/// `osascript`, ready to take its first option.
// ignore: non_constant_identifier_names
OsascriptCmd get Osascript => OsascriptCmd();
