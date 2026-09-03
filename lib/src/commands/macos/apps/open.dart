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

/// `open`, the command-line front end to LaunchServices: it opens a file, a
/// directory or a URL exactly as a double-click would. macOS only.
///
/// ```dart
/// await Open.application('Preview').waitForExit().file(report.path).execute();
/// await Open.url('https://example.com').execute();
/// ```
///
/// [appArgs] is the argument-boundary trap: everything added after it is handed
/// to the launched application's own `argv`, not opened or interpreted by
/// `open` at all, so it has to come last in the chain:
///
/// ```dart
/// Open.application('MyTool').file(input).appArgs().arg('--flag').line;
/// // 'open -a MyTool input.txt --args --flag'
/// ```
///
/// [waitForExit] is what makes `open` useful as a blocking launcher, the
/// shape `$EDITOR` wants; pair it with [newInstance] so it waits for the
/// instance it just started rather than one already running.
class OpenCmd extends CommandBuilder<OpenCmd> {
  @override
  final String executable = 'open';

  /// Opens with this application, by name (`-a`).
  OpenCmd application(String name) => pair('-a', name);

  /// Opens with the application matching this bundle identifier (`-b`).
  OpenCmd bundleIdentifier(String id) => pair('-b', id);

  /// Opens with TextEdit (`-e`).
  OpenCmd textEdit() => token('-e');

  /// Opens with the default text editor, as LaunchServices resolves it
  /// (`-t`).
  OpenCmd defaultTextEditor() => token('-t');

  /// Reads from stdin and opens the result in the default text editor
  /// (`-f`). End the input with EOF (Control-D).
  OpenCmd fromStdin() => token('-f');

  /// Launches fresh, without restoring windows or other saved state (`-F`,
  /// `--fresh`).
  OpenCmd fresh() => token('-F');

  /// Reveals the file in the Finder instead of opening it (`-R`,
  /// `--reveal`).
  OpenCmd reveal() => token('-R');

  /// Blocks until the launched application (or the one already running)
  /// exits (`-W`, `--wait-apps`).
  OpenCmd waitForExit() => token('-W');

  /// Starts a new instance even if the application is already running
  /// (`-n`, `--new`).
  OpenCmd newInstance() => token('-n');

  /// Launches the app hidden (`-j`, `--hide`).
  OpenCmd hidden() => token('-j');

  /// Launches without bringing the app to the foreground (`-g`,
  /// `--background`).
  OpenCmd launchInBackground() => token('-g');

  /// Searches the SDK header locations for a header matching this name and
  /// opens it (`-h`, `--header`). A full name such as `NSView.h` resolves
  /// faster than a partial one.
  OpenCmd header() => token('-h');

  /// Under [header], limits the search to SDKs whose name contains this
  /// string (`-s`).
  OpenCmd sdk(String name) => pair('-s', name);

  /// Opens this URL, even when it also matches a file path (`-u`,
  /// `--url`).
  OpenCmd url(String value) => pair('-u', value);

  /// Launches with the given CPU architecture, one of `any`, `arm`,
  /// `arm64`, `arm64e`, `arm64_32`, `x86_64`, `x86_64h`, `i386`
  /// (`--arch`).
  OpenCmd arch(String value) => pair('--arch', value);

  /// Connects the launched application's stdin to this path (`-i`,
  /// `--stdin`). Defaults to `/dev/null`.
  OpenCmd stdinPath(String path) => pair('-i', path);

  /// Connects the launched application's stdout to this path (`-o`,
  /// `--stdout`).
  OpenCmd stdoutPath(String path) => pair('-o', path);

  /// Connects the launched application's stderr to this path (`--stderr`).
  OpenCmd stderrPath(String path) => pair('--stderr', path);

  /// Adds an environment variable to the launched process, `NAME=value` or
  /// a bare `NAME` for an empty value (`--env`).
  OpenCmd env(String value) => pair('--env', value);

  /// Marks the end of `open`'s own options (`--args`). Everything after
  /// this is passed straight through to the launched application's `argv`
  /// rather than opened; see the class docs.
  OpenCmd appArgs() => token('--args');

  /// A file, directory or URL to open, or — after [args] — a bare argument
  /// forwarded to the launched application.
  OpenCmd file(String path) => token(path);
}

/// `open`, ready to take its first option.
// ignore: non_constant_identifier_names
OpenCmd get Open => OpenCmd();
