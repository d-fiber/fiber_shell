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

    test('bun run takes its flags before the script it runs', () {
      expect(Bun.run().hot().arg('index.ts').line, 'bun run --hot index.ts');
    });

    test('gh keeps the subcommand chain ahead of its own flags', () {
      expect(Gh.pr().list().state('open').limit(5).line, 'gh pr list --state open --limit 5');
    });

    test('tofu renders single-dash flags, the grammar OpenTofu expects', () {
      expect(Tofu.plan().noInput().noColor().line, 'tofu plan -input=false -no-color');
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

    test('rsync takes the source before the destination, after its flags', () {
      expect(
        Rsync.archive().delete().source('/a/').destination('host:/b/').line,
        'rsync --archive --delete /a/ host:/b/',
      );
    });
  });

  group('linux', () {
    test('systemctl takes the verb then the unit', () {
      expect(Systemctl.restart().unit('nginx').line, 'systemctl restart nginx');
    });

    test('ufw mirrors the English rule grammar', () {
      expect(Ufw.allow().arg('443/tcp').line, 'ufw allow 443/tcp');
    });

    test('nproc takes a single flag and nothing else', () {
      expect(Nproc.all().line, 'nproc --all');
    });

    test('lscpu joins a column list into one --parse argument', () {
      expect(Lscpu.parse(columns: <String>['Core', 'Socket']).line, 'lscpu --parse=Core,Socket');
    });

    test('dnf answers yes to every prompt before naming the package', () {
      expect(Dnf.install().assumeYes().arg('docker-ce').line, 'dnf install --assumeyes docker-ce');
    });

    test('pacman repeats -S for a full system upgrade', () {
      expect(Pacman.sync().refresh().sysupgrade().line, 'pacman -S --refresh --sysupgrade');
    });

    test('apk adds a package by name', () {
      expect(Apk.add().arg('curl').line, 'apk add curl');
    });
  });

  group('macos', () {
    test('launchctl renders a modern verb', () {
      expect(Launchctl.printTarget().line, 'launchctl print');
    });

    test('the Darwin sysctl reads a value by name, unlike the Linux one', () {
      expect(DarwinSysctl.valuesOnly().arg('hw.physicalcpu').line, 'sysctl -n hw.physicalcpu');
    });

    test('brew installs a formula or cask by name', () {
      expect(Brew.install().arg('wget').line, 'brew install wget');
    });
  });

  group('windows', () {
    test('powershell keeps the script behind -Command', () {
      expect(PowerShell.noProfile().command('Get-Date').line, 'powershell -NoProfile -Command Get-Date');
    });

    test('a Windows wrapper renders the same from any platform', () {
      expect(Tasklist.line, 'tasklist');
    });

    test('winget installs by exact identifier match', () {
      expect(Winget.install().exact().id('Git.Git').line, 'winget install --exact --id Git.Git');
    });

    test('scoop installs an app at machine scope', () {
      expect(Scoop.install().global().arg('git').line, 'scoop install --global git');
    });
  });

  group('elevation renders per platform', () {
    test('the elevated line always contains the original command', () {
      expect(Systemctl.restart().unit('nginx').asRoot().line, contains('systemctl restart nginx'));
    });
  });
}
