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

import 'package:fiber_shell/fiber_shell.dart';
import 'package:test/test.dart';

void main() {
  group('common', () {
    test('git puts the global options before the subcommand', () {
      final GitCmd command = Git.repo('/repo').configOverride('user.name', 'Tester').commit().message('first');
      expect(command.line, 'git -C /repo -c user.name=Tester commit --message first');
    });

    test('git log renders a joined option', () {
      expect(Git.log().oneline().maxCount(5).line, 'git log --oneline --max-count=5');
    });

    test('curl keeps the url last, where it was put', () {
      expect(Curl.silent().location().url('https://example.test/x').line, 'curl -s -L https://example.test/x');
    });

    test('tar takes the mode first, then options, then paths', () {
      final TarCmd command = Tar.create().gzip().file('out.tgz').changeDirectory('/src').arg('.');
      expect(command.line, 'tar --create --gzip --file out.tgz --directory /src .');
    });

    test('docker compose seeds its subcommand and keeps docker as the executable', () {
      expect(DockerCompose.executable, 'docker');
      expect(DockerCompose.args.first, 'compose');
    });

    test('deno renders a comma-separated permission list as one argument', () {
      expect(Deno.allowReadPaths(<String>['/etc', '/var']).args, contains('--allow-read=/etc,/var'));
    });
  });

  group('unix', () {
    test('mkdir renders the short flag then the path', () {
      expect(Mkdir.parents().path('/tmp/build').line, 'mkdir -p /tmp/build');
    });

    test('grep keeps flags in the order they were chained', () {
      expect(Grep.lineNumber().invertMatch().pattern('a').file('b').line, 'grep -n -v a b');
    });

    test('sed passes the script as its own argument', () {
      expect(Sed.expression('s/a/b/').args, <String>['-e', 's/a/b/']);
    });

    test('rm renders each flag separately', () {
      expect(Rm.recursive().force().path('/tmp/x').line, 'rm -r -f /tmp/x');
    });

    test('find keeps the path before the primaries', () {
      expect(Find.path('/src').type('f').name('*.dart').line, 'find /src -type f -name *.dart');
    });

    test('sh reads its program from the next argument', () {
      expect(Sh.c().script('echo hi').args, <String>['-c', 'echo hi']);
    });
  });

  group('linux', () {
    test('systemctl takes the verb then the unit', () {
      expect(Systemctl.restart().unit('nginx').line, 'systemctl restart nginx');
    });

    test('ufw mirrors the English rule grammar', () {
      expect(Ufw.allow().arg('443/tcp').line, 'ufw allow 443/tcp');
    });
  });

  group('macos', () {
    test('launchctl renders a modern verb', () {
      expect(Launchctl.printTarget().line, 'launchctl print');
    });
  });

  group('windows', () {
    test('powershell keeps the script behind -Command', () {
      expect(PowerShell.noProfile().command('Get-Date').line, 'powershell -NoProfile -Command Get-Date');
    });

    test('a Windows wrapper renders the same from any platform', () {
      expect(Tasklist.line, 'tasklist');
    });
  });

  group('elevation renders per platform', () {
    test('the elevated line always contains the original command', () {
      expect(Systemctl.restart().unit('nginx').asRoot().line, contains('systemctl restart nginx'));
    });
  });
}
