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
