import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';

/// Building a command, looking at it, then running it.
///
/// The three ideas the rest of the library rests on are all here: one method is
/// one option, the chain stays typed to the end, and nothing runs until asked.
Future<void> run(Directory workspace) async {
  final String artifacts = '${workspace.path}/build/artifacts';

  // Nothing has happened yet. `Mkdir` hands back a fresh builder, and every
  // option returns that same builder, so a chain only collects arguments.
  final MkdirCmd command = Mkdir.parents().path(artifacts);

  // `line` renders the command the way a terminal would show it, without
  // running it. This is all a `--dry-run` flag needs to be.
  print('  \$ ${command.line}');

  // `execute()` runs it with stdio inherited, so whatever the command prints
  // lands straight in this terminal. A non-zero status throws ShellException.
  await command.execute();
  print('  created  : ${Directory(artifacts).existsSync()}');

  // Each argument is passed as its own argument, never pasted into a string.
  // A space and a pair of parentheses in a path are just characters here: there
  // is no shell to quote them for.
  final String awkward = '$artifacts/report final (v2).txt';
  await File(awkward).writeAsString('done\n');
  final ShellResult found = await Find.path(artifacts).type('f').output();
  print('  found    : ${found.text.split('/').last}');

  // A status that was never going to be zero is not an accident, so it is not
  // always worth an exception. Chapter 2 is about the other runner; this is the
  // shape `execute()` takes when a command does fail.
  try {
    await Mkdir.path(artifacts).execute();
  } on ShellException catch (error) {
    print('  refused  : $error');
  }
}
