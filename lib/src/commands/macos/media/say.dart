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

/// `say`, the Speech Synthesis Manager's command-line face: converts text to
/// audible speech, either played through the current output device or
/// written to a file. macOS only.
///
/// ```dart
/// await Say.text('build finished').execute();
/// await Say.voice('Alex').outputFile('narration.m4a').dataFormat('alac').inputFile('script.txt').execute();
/// ```
///
/// [voiceList], [audioDeviceList], [fileFormatList], [dataFormatList] and
/// [bitRateList] all work the same way: pass `?` as the value to make `say`
/// print the available choices instead of speaking, which is the documented
/// way to discover installed voices (`say -v ?`) rather than hardcoding a
/// list that drifts from what is actually installed. Output defaults to
/// AIFF; anything else needs [fileFormat] (and often [dataFormat]) alongside
/// [outputFile], not just a differently-named file — `say` infers the format
/// from the extension when it can, but the flags are the reliable path.
/// When stdin is a TTY, `say` speaks line by line and [outputFile] only ever
/// captures the last line, which is easy to miss when redirecting a script's
/// own output into it.
class SayCmd extends CommandBuilder<SayCmd> {
  @override
  final String executable = 'say';

  /// The text to speak, as one or more words joined by the shell (`string`).
  /// Repeatable; each call adds one argument.
  SayCmd text(String value) => token(value);

  /// Reads the text to speak from a file, or from stdin when [path] is `-`
  /// (`-f`, `--input-file`).
  SayCmd inputFile(String path) => pair('-f', path);

  /// The voice to speak with (`-v`, `--voice`). Pass `?` to list installed
  /// voices instead of speaking.
  SayCmd voice(String name) => pair('-v', name);

  /// Lists the voices installed on this system, instead of speaking
  /// (`-v ?`).
  SayCmd voiceList() => pair('-v', '?');

  /// The speech rate, in words per minute (`-r`, `--rate`).
  SayCmd rate(int wordsPerMinute) => pair('-r', '$wordsPerMinute');

  /// Writes the audio to this file instead of playing it (`-o`,
  /// `--output-file`). AIFF unless [fileFormat] says otherwise.
  SayCmd outputFile(String path) => pair('-o', path);

  /// Redirects speech output over the network via AUNetSend, to a service
  /// name and/or port (`-n`, `--network-send`).
  SayCmd networkSend(String nameOrPort) => pair('-n', nameOrPort);

  /// Plays through a specific audio device, by ID or name prefix (`-a`,
  /// `--audio-device`). Pass `?` to list output devices instead of speaking.
  SayCmd audioDevice(String idOrName) => pair('-a', idOrName);

  /// Lists the audio output devices, instead of speaking (`-a ?`).
  SayCmd audioDeviceList() => pair('-a', '?');

  /// Shows a synthesis progress meter (`--progress`).
  SayCmd progress() => token('--progress');

  /// Prints the text line by line as it is spoken, highlighting the current
  /// words (`-i`, `--interactive`). Optionally takes a terminfo capability
  /// or colour name/pair as markup; defaults to reverse video.
  SayCmd interactive([String? markup]) => markup == null ? token('-i') : joined('--interactive', markup);

  /// The output file format when [outputFile] is not AIFF: `AIFF`, `caff`,
  /// `m4af` or `WAVE` (`--file-format`). Pass `?` to list writable formats.
  SayCmd fileFormat(String format) => joined('--file-format', format);

  /// Lists the writable output file formats, instead of speaking
  /// (`--file-format=?`).
  SayCmd fileFormatList() => joined('--file-format', '?');

  /// The audio data format stored in the output file: a codec id like `aac`
  /// or `alac`, or a linear PCM spec like `BEI16`/`LEF32@8000`
  /// (`--data-format`). Pass `?` to list the formats valid for the current
  /// file format.
  SayCmd dataFormat(String format) => joined('--data-format', format);

  /// Lists the data formats valid for the current (or named) file format,
  /// instead of speaking (`--data-format=?`).
  SayCmd dataFormatList() => joined('--data-format', '?');

  /// The channel count of the output audio, generally of limited use since
  /// most voices are mono (`--channels`).
  SayCmd channels(int count) => joined('--channels', '$count');

  /// The bit rate for formats like AAC (`--bit-rate`). Pass `?` to list the
  /// valid rates.
  SayCmd bitRate(int rate) => joined('--bit-rate', '$rate');

  /// Lists the valid bit rates for the current format, instead of speaking
  /// (`--bit-rate=?`).
  SayCmd bitRateList() => joined('--bit-rate', '?');

  /// The audio converter quality, from `0` (lowest) to `127` (highest)
  /// (`--quality`).
  SayCmd quality(int level) => joined('--quality', '$level');
}

/// `say`, ready to take its first option.
// ignore: non_constant_identifier_names
SayCmd get Say => SayCmd();
