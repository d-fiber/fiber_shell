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

/// `xcrun`, which locates or runs a developer tool inside the active Xcode
/// toolchain without hardcoding its path. macOS only.
///
/// ```dart
/// final ShellResult path = await Xcrun.find().tool('swiftc').output();
/// await Xcrun.sdk('macosx').tool('clang').arg('--version').execute();
/// ```
///
/// The active developer directory comes from [XcodeSelectCmd], overridable
/// with the `DEVELOPER_DIR` environment variable; the SDK searched comes from
/// `SDKROOT` unless [sdk] overrides it. [find] only prints the resolved
/// path; without it, `xcrun` executes the named tool with the arguments that
/// follow, which is the form that lets a script call `clang` or `swiftc`
/// correctly regardless of which Xcode is currently selected.
class XcrunCmd extends CommandBuilder<XcrunCmd> {
  @override
  final String executable = 'xcrun';

  /// The SDK to search for the tool in, by name or partial name (`--sdk`).
  /// Defaults to `SDKROOT`, then the most recent SDK installed. See
  /// `xcodebuild -showsdks` for the names available.
  XcrunCmd sdk(String name) => pair('--sdk', name);

  /// The toolchain to resolve the tool from (`--toolchain`). Defaults to
  /// `TOOLCHAINS`.
  XcrunCmd toolchain(String name) => pair('--toolchain', name);

  /// Explains how the lookup was performed (`-v`, `--verbose`).
  XcrunCmd verbose() => token('-v');

  /// Skips the lookup cache, refreshing the cached entry (`-n`,
  /// `--no-cache`).
  XcrunCmd noCache() => token('-n');

  /// Deletes the lookup cache outright, so every value is re-cached (`-k`,
  /// `--kill-cache`).
  XcrunCmd killCache() => token('-k');

  /// Prints the full command line invoked (`-l`, `--log`).
  XcrunCmd log() => token('-l');

  /// Prints the resolved tool path instead of running it (`-f`, `--find`).
  XcrunCmd find() => token('--find');

  /// Runs the resolved tool with the arguments given (`-r`, `--run`). The
  /// default mode.
  XcrunCmd run() => token('--run');

  /// Prints the path to the selected SDK (`--show-sdk-path`).
  XcrunCmd showSdkPath() => token('--show-sdk-path');

  /// Prints the selected SDK's version (`--show-sdk-version`).
  XcrunCmd showSdkVersion() => token('--show-sdk-version');

  /// Prints the selected SDK's build version (`--show-sdk-build-version`).
  XcrunCmd showSdkBuildVersion() => token('--show-sdk-build-version');

  /// Prints the path to the selected SDK's platform
  /// (`--show-sdk-platform-path`).
  XcrunCmd showSdkPlatformPath() => token('--show-sdk-platform-path');

  /// Prints the selected SDK's platform version
  /// (`--show-sdk-platform-version`).
  XcrunCmd showSdkPlatformVersion() => token('--show-sdk-platform-version');

  /// Prints the path to the preferred toolchain for the selected SDK
  /// (`--show-toolchain-path`).
  XcrunCmd showToolchainPath() => token('--show-toolchain-path');

  /// The tool to locate or run, e.g. `clang`, `swiftc`, `xcodebuild`.
  XcrunCmd tool(String name) => token(name);

  /// An argument passed through to the resolved tool.
  XcrunCmd arg(String value) => token(value);
}

/// `xcrun`, ready to take its first option.
// ignore: non_constant_identifier_names
XcrunCmd get Xcrun => XcrunCmd();
