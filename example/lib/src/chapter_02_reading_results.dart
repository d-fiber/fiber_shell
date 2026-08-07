import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';

/// What comes back from a command, and why a failure is a value here.
///
/// `execute()` throws on a non-zero status; `output()` never does. Reach for
/// `output()` whenever failing is one of the answers rather than an accident.
Future<void> run(Directory workspace) async {
  final File notes = File('${workspace.path}/notes.txt');
  await notes.writeAsString('alpha\nbeta\ngamma\n\ndelta\n');

  final ShellResult listed = await Grep.lineNumber().pattern('a').file(notes.path).output();
  print('  command  : ${listed.command}');
  print('  success  : ${listed.success}');
  print('  text     : ${listed.text.replaceAll('\n', ', ')}');
  print('  lines    : ${listed.lines.length} non-blank lines');
  print('  duration : ${listed.duration.inMilliseconds}ms');

  // A command that fails comes back through the same door, with its stderr
  // attached rather than thrown away.
  final ShellResult missing = await Grep.pattern('alpha').file('${workspace.path}/absent.txt').output();
  print('  failed   : ${missing.failed} (exit ${missing.exitCode})');
  print('  stderr   : ${missing.error}');

  // `textOrNull` folds "could not run" and "printed nothing" into the single
  // answer a lookup usually wants: no value.
  print('  fallback : ${missing.textOrNull ?? '<none>'}');

  // `orThrow()` is the other direction, for the cases with no sensible
  // fallback: the stderr becomes the message someone ends up reading.
  try {
    missing.orThrow();
  } on ShellException catch (error) {
    print('  orThrow  : $error');
  }

  // Output is kept as bytes and decoded on demand, so one type carries text and
  // binary alike: `openssl pkey -outform DER` writes a key, not a string.
  final ShellResult raw = await Find.path(workspace.path).type('f').output();
  print('  bytes    : ${raw.bytes.length} captured, decoded only when read');
}
