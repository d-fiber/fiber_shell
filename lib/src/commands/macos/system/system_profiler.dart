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

/// `system_profiler`, which reports the hardware and software configuration
/// of the machine. macOS only.
///
/// ```dart
/// final ShellResult report = await SystemProfiler.json().detailLevel('mini').dataType('SPHardwareDataType').output();
/// ```
///
/// Called with no [dataType] at all, it walks every data type there is,
/// which routinely takes over a minute; naming the types you actually want,
/// as in the example above, is what keeps this usable in a script. Progress
/// and error text goes to stderr while the report itself goes to stdout, so
/// piping stdout alone is already clean without an explicit filter.
class SystemProfilerCmd extends CommandBuilder<SystemProfilerCmd> {
  @override
  final String executable = 'system_profiler';

  /// Prints usage information and examples (`-usage`).
  SystemProfilerCmd usage() => token('-usage');

  /// Lists the data types available to pass to [dataType] (`-listDataTypes`).
  SystemProfilerCmd listDataTypes() => token('-listDataTypes');

  /// Generates the report as XML rather than plain text (`-xml`). Saved
  /// with a `.spx` suffix, the file opens directly in System
  /// Information.app.
  SystemProfilerCmd xml() => token('-xml');

  /// Generates the report as JSON rather than plain text (`-json`).
  SystemProfilerCmd json() => token('-json');

  /// The level of detail to report: `mini` for nothing personally
  /// identifying, `basic` for hardware and network only, `full` for
  /// everything (`-detailLevel`).
  SystemProfilerCmd detailLevel(String level) => pair('-detailLevel', level);

  /// The longest to wait for results, in seconds, before returning an
  /// incomplete report; `0` waits indefinitely (`-timeout`). Defaults to
  /// 180.
  SystemProfilerCmd timeout(int seconds) => pair('-timeout', '$seconds');

  /// Limits the report to this data type, e.g. `SPHardwareDataType` or
  /// `SPNetworkDataType` (positional). Repeatable.
  SystemProfilerCmd dataType(String type) => token(type);
}

/// `system_profiler`, ready to take its first option.
// ignore: non_constant_identifier_names
SystemProfilerCmd get SystemProfiler => SystemProfilerCmd();
