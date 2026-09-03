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

import 'dart:io';

import 'package:test/test.dart';

final Directory sources = Directory('lib/src');

final Directory commands = Directory('lib/src/commands');

final File barrel = File('lib/fiber_shell.dart');

List<File> dartFilesUnder(Directory directory) => directory
    .listSync(recursive: true)
    .whereType<File>()
    .where((File file) => file.path.endsWith('.dart'))
    .toList(growable: false);

String relativeToLib(File file) => file.path.replaceFirst(RegExp(r'^lib[/\\]'), '').replaceAll(r'\', '/');

void main() {
  setUpAll(() {
    expect(
      commands.existsSync(),
      isTrue,
      reason: 'this suite reads the sources, so it has to run from the package root',
    );
  });

  group('the barrel', () {
    test('exports every file under lib/src', () {
      final Set<String> exported = RegExp(
        "export '([^']+)'",
      ).allMatches(barrel.readAsStringSync()).map((RegExpMatch match) => match.group(1)!).toSet();
      final Set<String> present = dartFilesUnder(sources).map(relativeToLib).toSet();

      expect(
        present.difference(exported),
        isEmpty,
        reason: 'a wrapper that is not exported is invisible to anyone importing the package',
      );
    });

    test('has no export pointing at a file that no longer exists', () {
      final Set<String> exported = RegExp(
        "export '([^']+)'",
      ).allMatches(barrel.readAsStringSync()).map((RegExpMatch match) => match.group(1)!).toSet();
      final Set<String> present = dartFilesUnder(sources).map(relativeToLib).toSet();

      expect(exported.difference(present), isEmpty);
    });
  });

  group('every wrapper', () {
    late List<File> files;

    setUpAll(() => files = dartFilesUnder(commands));

    test('names itself as its own type argument', () {
      final List<String> broken = <String>[];
      for (final File file in files) {
        final RegExpMatch? declaration = RegExp(
          r'class (\w+)Cmd extends CommandBuilder<(\w+)Cmd>',
        ).firstMatch(file.readAsStringSync());
        if (declaration == null || declaration.group(1) != declaration.group(2)) {
          broken.add(relativeToLib(file));
        }
      }

      expect(
        broken,
        isEmpty,
        reason: 'CommandBuilder casts `this` to its type argument, so a mismatch throws at runtime',
      );
    });

    test('declares a non-empty executable that is a single word', () {
      final List<String> broken = <String>[];
      for (final File file in files) {
        final RegExpMatch? executable = RegExp(
          r"final String executable = '([^']*)'",
        ).firstMatch(file.readAsStringSync());
        if (executable == null || executable.group(1)!.trim().isEmpty || executable.group(1)!.contains(' ')) {
          broken.add(relativeToLib(file));
        }
      }

      expect(broken, isEmpty, reason: 'the executable is passed to Process.start as one argument');
    });

    test('offers a facade getter that builds a fresh command', () {
      final List<String> broken = <String>[];
      for (final File file in files) {
        final String text = file.readAsStringSync();
        final String? wrapper = RegExp(r'class (\w+)Cmd extends CommandBuilder').firstMatch(text)?.group(1);
        if (wrapper == null || !RegExp('${wrapper}Cmd get \\w+ => ${wrapper}Cmd\\(\\);').hasMatch(text)) {
          broken.add(relativeToLib(file));
        }
      }

      expect(
        broken,
        isEmpty,
        reason: 'a getter hands back a new builder each time; a final field would share one between calls',
      );
    });
  });
}
