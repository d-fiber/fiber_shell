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
