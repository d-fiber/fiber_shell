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

/// Starting something and coming straight back, the way `&` does.
Future<void> run(Directory workspace) async {
  final File ready = File('${workspace.path}/ready.flag');

  // A stand-in for the thing you actually start: a dev server, a watcher, a
  // long build. It touches a file once it is up, then keeps running.
  //
  // The `exec` matters. `kill()` signals the processes this library started,
  // and nothing below them: a shell that spawns a child and waits would take
  // the signal while the grandchild kept the pipes open, and `wait()` would sit
  // there until the grandchild exited on its own.
  final BackgroundJob job = await Sh.c().script('sleep 1; : > "${ready.path}"; exec sleep 30').background();
  print('  pid      : ${job.pid}');

  // `waitUntil` polls a command until it exits zero, and reports whether that
  // happened before the timeout. It is how you wait for a port to open or a
  // socket file to appear instead of sleeping and hoping.
  final bool up = await waitUntil(<String>['test', '-f', ready.path], interval: 1, timeout: 15);
  print('  ready    : $up');

  // Both streams are collected in the background while the job runs, so the
  // result is still complete after the job has been stopped.
  job.kill();
  final ShellResult stopped = await job.wait();
  print('  stopped  : exit ${stopped.exitCode} after ${stopped.duration.inMilliseconds}ms');

  // `wait()` is safe to call more than once, and safe after `kill()`.
  final BackgroundJob quick = await Sh.c().script('echo "worker done"').background();
  print('  waited   : ${(await quick.wait()).text}');

  // Nobody reaps a job for you: returning from main with one still running
  // leaves the child to the operating system.
}
