// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

@TestOn('!windows')
library;

import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'process_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ShellCommand>()])
MockShellCommand commandOf(String executable, List<String> args) {
  final MockShellCommand command = MockShellCommand();
  when(command.executable).thenReturn(executable);
  when(command.args).thenReturn(args);
  return command;
}

void main() {
  group('commandLine', () {
    test('joins the executable and its arguments', () {
      expect(commandLine(commandOf('probe', <String>['--flag', 'value'])), 'probe --flag value');
    });

    test('renders a bare command as the executable alone', () {
      expect(commandLine(commandOf('probe', <String>[])), 'probe');
    });

    test('does not quote, so an argument with a space comes out ambiguous', () {
      expect(commandLine(commandOf('probe', <String>['two words'])), 'probe two words');
    });
  });

  group('commandArgv', () {
    test('flattens the command into an argv list', () {
      expect(commandArgv(commandOf('probe', <String>['a', 'b'])), <String>['probe', 'a', 'b']);
    });

    test('reads the command only through the interface', () {
      final MockShellCommand command = commandOf('probe', <String>['a']);
      commandArgv(command);
      verify(command.executable).called(1);
      verify(command.args).called(1);
    });

    test('the privileged form matches what this platform does', () {
      final List<String> argv = commandArgv(commandOf('probe', <String>['a']), asPrivileged: true);
      expect(argv, Platform.isLinux ? <String>['sudo', 'probe', 'a'] : <String>['probe', 'a']);
    });
  });

  group('privileged', () {
    test('adds sudo on Linux and leaves the command alone elsewhere', () {
      final Invocation invocation = privileged('probe', <String>['a']);
      expect(invocation.executable, Platform.isLinux ? 'sudo' : 'probe');
      expect(invocation.argv, Platform.isLinux ? <String>['sudo', 'probe', 'a'] : <String>['probe', 'a']);
    });

    test('keeps the original command inside the arguments when it elevates', () {
      expect(privileged('probe', <String>['a']).argv, containsAllInOrder(<String>['probe', 'a']));
    });
  });

  group('captureResult', () {
    test('runs whatever the interface reports and collects its stdout', () async {
      final ShellResult result = await captureResult(commandOf('echo', <String>['hello']));
      expect(result.success, isTrue);
      expect(result.text, 'hello');
    });

    test('records the status and the stderr of a failing command', () async {
      final ShellResult result = await captureResult(commandOf('ls', <String>['/definitely/not/here']));
      expect(result.failed, isTrue);
      expect(result.error, isNotEmpty);
    });

    test('writes input to stdin before closing it', () async {
      final ShellResult result = await captureResult(commandOf('cat', <String>[]), input: 'piped in');
      expect(result.text, 'piped in');
    });

    test('runs in cwd when one is given', () async {
      final Directory workspace = await Directory.systemTemp.createTemp('fiber_shell_test.');
      addTearDown(() => workspace.delete(recursive: true));

      final ShellResult result = await captureResult(commandOf('pwd', <String>[]), cwd: workspace.path);
      expect(result.text, endsWith(workspace.uri.pathSegments[workspace.uri.pathSegments.length - 2]));
    });

    test('passes env through to the process', () async {
      final ShellResult result = await captureResult(
        commandOf('sh', <String>['-c', r'echo "$FIBER_SHELL_TEST"']),
        env: <String, String>{'FIBER_SHELL_TEST': 'from env'},
      );
      expect(result.text, 'from env');
    });

    test('measures how long the process ran', () async {
      final ShellResult result = await captureResult(commandOf('true', <String>[]));
      expect(result.duration, greaterThan(Duration.zero));
    });
  });

  group('streamCommand', () {
    test('returns normally on a zero status', () {
      expect(streamCommand(commandOf('true', <String>[])), completes);
    });

    test('throws on a non-zero status', () {
      expect(streamCommand(commandOf('false', <String>[])), throwsA(isA<ShellException>()));
    });
  });

  group('commandExists', () {
    test('finds a program on PATH', () async {
      expect(await commandExists('sh'), isTrue);
    });

    test('reports a missing program rather than throwing', () async {
      expect(await commandExists('fiber-shell-no-such-binary'), isFalse);
    });
  });

  group('waitUntil', () {
    test('returns true as soon as the command exits zero', () async {
      expect(await waitUntil(<String>['true']), isTrue);
    });

    test('returns false rather than throwing when the timeout runs out', () async {
      expect(await waitUntil(<String>['false'], interval: 1, timeout: 0), isFalse);
    });

    test('polls until the condition holds', () async {
      final Directory workspace = await Directory.systemTemp.createTemp('fiber_shell_test.');
      addTearDown(() => workspace.delete(recursive: true));
      final File flag = File('${workspace.path}/ready');

      Future<void>.delayed(const Duration(milliseconds: 300), () => flag.writeAsStringSync(''));
      expect(await waitUntil(<String>['test', '-f', flag.path], interval: 1, timeout: 10), isTrue);
    });
  });

  group('sh and capture', () {
    test('sh throws a ShellException naming the command', () {
      expect(
        sh('false', <String>['--flag']),
        throwsA(
          isA<ShellException>().having(
            (ShellException error) => error.message,
            'message',
            allOf(contains('false --flag'), contains('1')),
          ),
        ),
      );
    });

    test('capture returns the process result without throwing', () async {
      final ProcessResult result = await capture('false', <String>[]);
      expect(result.exitCode, 1);
    });
  });
}
