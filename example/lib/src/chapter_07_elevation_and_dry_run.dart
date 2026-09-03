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

import 'package:fiber_shell/fiber_shell.dart';

/// Elevation, and describing a command instead of running it.
///
/// Nothing in this chapter runs. Every command is rendered through `line`,
/// which is the point: the same builders describe what you would do as well as
/// do it, so a plan and its execution can never drift apart.
Future<void> run(Directory workspace) async {
  // `asRoot()` marks the command rather than the run, so elevation survives
  // being piped or chained. On Linux it becomes `sudo`; on macOS and Windows
  // the command is handed over untouched, because `sudo` is not the answer
  // there.
  final ElevatedCommand restart = Systemctl.restart().unit('nginx').asRoot();
  print('  \$ ${restart.line}');

  // Only the stage that needs the rights takes them, which is why elevation
  // belongs to the command and not to the run.
  final Pipeline audit = Grep.pattern('Failed password').file('/var/log/auth.log').asRoot() | Grep.count().pattern('.');
  print('  \$ ${audit.line}');

  // A whole plan, rendered before anything touches the machine.
  final ShellScript firewall = Ufw.allow().arg('443/tcp').asRoot().and(Ufw.reload().asRoot());
  print('  \$ ${firewall.line}');

  // The Windows wrappers render the same way from any platform, which makes
  // them worth reading even here.
  print('  \$ ${PowerShell.command('Get-Service Spooler').line}');

  print('  (nothing above was run: only `line` was read)');
  print('  workspace left untouched: ${workspace.path}');

  // One honest caveat: `line` joins the executable and its arguments with
  // spaces, for a human to read and for a log to keep. It is not shell-quoted,
  // so an argument containing a space renders as two words. Read it, log it,
  // show it behind `--dry-run`, but do not build a shell command out of it.
  print('  \$ ${Grep.pattern('two words').file('/etc/hosts').line}');
}
