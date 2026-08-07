import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';

/// Where the output goes, where the input comes from, what the process sees.
Future<void> run(Directory workspace) async {
  final Directory sources = Directory('${workspace.path}/sources')..createSync(recursive: true);
  for (final String name in const <String>['app.dart', 'model.dart', 'README.md']) {
    await File('${sources.path}/$name').writeAsString('// $name\n');
  }

  // `writeTo` sends stdout into a file, the way `>` does. The redirection is
  // Dart's, so the destination is a path rather than a piece of shell syntax.
  //
  // Note the glob: `*.dart` reaches find untouched, because there is no shell
  // in front of it to expand it against the current directory first.
  final File inventory = File('${workspace.path}/inventory.txt');
  await Find.path(sources.path).type('f').name('*.dart').writeTo(inventory);
  print('  inventory: ${(await inventory.readAsLines()).length} files');

  // `input` feeds stdin. Some tools take their secret no other way. GNOME's
  // `secret-tool store` is the usual reason this parameter exists.
  final ShellResult framed = await Sed.expression('s/.*/[&]/').output(input: 'alpha\nbeta\n');
  print('  stdin    : ${framed.lines}');

  // `cwd` and `env` are per-run and available on every runner. Nothing leaks in
  // from a shell you did not start; what you pass is merged over the process's
  // own environment.
  final ShellResult located = await Find.path('.').maxDepth('1').name('*.dart').output(cwd: sources.path);
  print('  cwd      : ${located.lines.length} matches relative to sources/');

  final ShellResult greeted = await Sh.c().script(r'echo "$GREETING from $(basename $(pwd))"').output(
    cwd: sources.path,
    env: <String, String>{'GREETING': 'hello'},
  );
  print('  env      : ${greeted.text}');

  // That last one used the `sh` wrapper, which exists for the times you
  // genuinely want a shell program. The difference from every other library is
  // that you chose it: nothing above this line went through one.

  // And before running something that may simply not be installed:
  print('  docker   : ${await commandExists('docker') ? 'available' : 'not on this machine'}');
}
