import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';

/// Pipes, wired between processes in Dart rather than handed to a shell.
Future<void> run(Directory workspace) async {
  final File log = File('${workspace.path}/server.log');
  await log.writeAsString(const <String>[
    '12:00:01 INFO  listening on :8080',
    '12:00:04 ERROR upstream timeout',
    '12:00:09 WARN  deprecated header',
    '12:00:12 ERROR upstream timeout',
    '12:00:20 ERROR disk full',
    '',
  ].join('\n'));

  // Every stage starts at once and each stdout is wired into the next stdin,
  // exactly as a shell would, except the wiring is a Dart stream, so there is
  // no `sh -c` in the middle and no argument to escape.
  final Pipeline pipeline = Grep.pattern('ERROR').file(log.path) | Sed.expression('s/^[0-9:]* ERROR //');
  print('  \$ ${pipeline.line}');

  final ShellResult errors = await pipeline.output();
  print('  errors   : ${errors.lines}');

  // Pipelines build from the left, so a third stage is just another `|`.
  final ShellResult filtered = await (Grep.pattern('ERROR').file(log.path) |
          Sed.expression('s/^[0-9:]* ERROR //') |
          Grep.invertMatch().pattern('timeout'))
      .output();
  print('  filtered : ${filtered.lines}');

  // The status is the one `set -o pipefail` gives: the rightmost stage that
  // failed. Below, grep cannot open the file and sed is perfectly happy about
  // reading nothing; plain shell semantics would report 0 and hide the broken
  // first stage behind the successful last one.
  final ShellResult broken =
      await (Grep.pattern('ERROR').file('${workspace.path}/absent.log') | Sed.expression('s/a/b/')).output();
  print('  pipefail : exit ${broken.exitCode} for `${broken.command}`');

  // stdout of the last stage is in `bytes`; the stderr of every stage is kept
  // too, in order, so a failure in the middle is still readable.
  print('  stderr   : ${broken.error}');
}
