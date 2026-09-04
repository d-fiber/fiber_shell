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

/// `screencapture`, the command-line screenshot and screen-recording tool
/// built into macOS. Undocumented by Apple beyond its own `-h` text; this
/// wrapper follows that text and the man page. macOS only.
///
/// ```dart
/// await Screencapture.silent().type('png').file('shot.png').execute();
/// await Screencapture.silent().windowId(id).file('window.png').execute();
/// ```
///
/// The trap that bites automation: several modes are interactive by default.
/// [interactive] waits for a mouse click or window selection and will hang a
/// non-interactive script forever; [delay] (default 5 seconds if [interactive]
/// is used without it explicitly) and [presentUi] have similar pitfalls.
/// For scripting, prefer a non-interactive capture — [mainMonitorOnly],
/// [rect], [windowId], or plain full-screen — combined with [silent] to
/// suppress the shutter sound. Capturing over SSH additionally needs
/// `sudo launchctl bsexec <loginwindow-pid> screencapture ...` to run in the
/// same bootstrap context as the login window; there is no flag for that,
/// it is an invocation-level workaround.
class ScreencaptureCmd extends CommandBuilder<ScreencaptureCmd> {
  @override
  final String executable = 'screencapture';

  /// Sends the capture to the clipboard instead of a file (`-c`).
  ScreencaptureCmd toClipboard() => token('-c');

  /// Captures the Touch Bar too; non-interactive modes only (`-b`).
  ScreencaptureCmd touchBar() => token('-b');

  /// Captures the cursor along with the screen; non-interactive modes only
  /// (`-C`).
  ScreencaptureCmd withCursor() => token('-C');

  /// Shows capture errors to the user graphically (`-d`).
  ScreencaptureCmd displayErrors() => token('-d');

  /// Captures interactively, by mouse selection or window click (`-i`).
  /// Control-click sends the result to the clipboard; space toggles
  /// selection/window mode; escape cancels. Blocks until the user acts —
  /// avoid in unattended scripts.
  ScreencaptureCmd interactive() => token('-i');

  /// Captures only the main monitor; undefined when [interactive] is also
  /// set (`-m`).
  ScreencaptureCmd mainMonitorOnly() => token('-m');

  /// Captures or records from the given display: `1` is the main display,
  /// `2` the secondary, and so on (`-D`).
  ScreencaptureCmd display(int number) => joined('-D', '$number');

  /// In window capture mode, omits the window's drop shadow (`-o`).
  ScreencaptureCmd noShadow() => token('-o');

  /// Uses the default capture settings and ignores any file arguments
  /// (`-p`).
  ScreencaptureCmd defaults() => token('-p');

  /// Opens the capture in a new Mail message (`-M`).
  ScreencaptureCmd toMail() => token('-M');

  /// Opens the capture in Preview, or QuickTime Player for video (`-P`).
  ScreencaptureCmd toPreview() => token('-P');

  /// Opens the capture in the app matching this bundle id (`-B`).
  ScreencaptureCmd openWithBundle(String bundleId) => joined('-B', bundleId);

  /// Restricts interactive capture to mouse selection mode only (`-s`).
  ScreencaptureCmd selectionOnly() => token('-s');

  /// In window capture mode, captures the whole screen rather than the
  /// window (`-S`).
  ScreencaptureCmd screenNotWindow() => token('-S');

  /// The starting mode for interactive capture: `selection`, `window` or
  /// `video` (`-J`).
  ScreencaptureCmd startStyle(String style) => joined('-J', style);

  /// The image format to write: `png` (default), `pdf`, `jpg`, `tiff` and
  /// others (`-t`).
  ScreencaptureCmd type(String format) => joined('-t', format);

  /// Delays the capture by this many seconds; defaults to 5 under
  /// [interactive] (`-T`).
  ScreencaptureCmd delay(int seconds) => joined('-T', '$seconds');

  /// Restricts interactive capture to window selection mode only (`-w`).
  ScreencaptureCmd windowOnly() => token('-w');

  /// Starts interactive capture already in window selection mode (`-W`).
  ScreencaptureCmd startInWindowMode() => token('-W');

  /// Suppresses the shutter sound (`-x`). The one flag every non-interactive
  /// script should reach for.
  ScreencaptureCmd silent() => token('-x');

  /// Excludes windows attached to the selected window (`-a`).
  ScreencaptureCmd excludeAttached() => token('-a');

  /// Skips adding DPI metadata to the captured image (`-r`).
  ScreencaptureCmd noDpiMetadata() => token('-r');

  /// Captures the window with this window id (`-l`).
  ScreencaptureCmd windowId(int id) => joined('-l', '$id');

  /// Captures a screen rectangle: `x,y,width,height` (`-R`).
  ScreencaptureCmd rect(String xywh) => joined('-R', xywh);

  /// Records video of the screen instead of a still image (`-v`).
  ScreencaptureCmd video() => token('-v');

  /// Limits video capture to this many seconds (`-V`).
  ScreencaptureCmd videoLimit(int seconds) => joined('-V', '$seconds');

  /// Captures audio during a video recording, using the default input
  /// (`-g`).
  ScreencaptureCmd withAudio() => token('-g');

  /// Captures audio during a video recording, from the given audio source id
  /// (`-G`).
  ScreencaptureCmd audioSource(String id) => joined('-G', id);

  /// Shows mouse clicks during video recording (`-k`).
  ScreencaptureCmd showClicks() => token('-k');

  /// Shows the interactive toolbar during interactive capture (`-U`).
  ScreencaptureCmd showToolbar() => token('-U');

  /// Presents the system capture UI after finishing, ignoring any file
  /// arguments (`-u`).
  ScreencaptureCmd presentUi() => token('-u');

  /// Where to save the capture; one path per screen when several are
  /// captured at once. Omit entirely with [toClipboard], [toMail] or
  /// [toPreview].
  ScreencaptureCmd file(String path) => token(path);
}

/// `screencapture`, ready to take its first option.
// ignore: non_constant_identifier_names
ScreencaptureCmd get Screencapture => ScreencaptureCmd();
