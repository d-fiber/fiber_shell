import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';

/// `wc`, a wrapper the catalogue does not ship yet.
///
/// A wrapper is a class that names itself as its own type argument. That is
/// what keeps a chain typed: every option below returns `WcCmd` rather than the
/// base class, so the last call in a chain still knows what it is holding.
///
/// Four helpers cover the argument shapes command-line tools use:
///
/// - `token('-l')` for a bare flag
/// - `pair('-C', path)` when the value is its own argument
/// - `joined('--max-count', '5')` when the tool wants `--name=value`
/// - `joinedAll('--allow', <String>['read', 'net'])` for a comma-separated list
class WcCmd extends CommandBuilder<WcCmd> {
  @override
  final String executable = 'wc';

  /// Counts lines (`-l`).
  WcCmd lines() => token('-l');

  /// Counts words (`-w`).
  WcCmd words() => token('-w');

  /// Counts bytes (`-c`).
  WcCmd bytes() => token('-c');

  /// Adds a path to count.
  WcCmd file(String path) => token(path);
}

/// `wc`, ready to take its first option.
// ignore: non_constant_identifier_names
WcCmd get Wc => WcCmd();

/// Writing the wrapper the catalogue is missing.
Future<void> run(Directory workspace) async {
  final File log = File('${workspace.path}/audit.log');
  await log.writeAsString('ok\nok\nERROR broken\nok\nERROR broken again\n');

  final ShellResult counted = await Wc.lines().file(log.path).output();
  print('  wc says  : ${counted.text.split('/').first.trim()} lines');

  // The new wrapper composes with everything else from the moment it exists.
  // Pipes, chains, elevation, background jobs and `line` all come from the base
  // class, so there is nothing else to implement.
  final Pipeline errors = Grep.pattern('ERROR').file(log.path) | Wc.lines();
  print('  \$ ${errors.line}');
  print('  errors   : ${(await errors.output()).text.trim()}');

  // One thing to watch when naming options: `execute`, `output`, `writeTo`,
  // `line`, `asRoot`, `stages`, `token`, `pair`, `joined` and `joinedAll` are
  // already taken by the base class. Colliding with one is an invalid override,
  // so it fails to compile rather than misbehaving at runtime, which is how
  // curl's `-o` ended up as `outputFile()` in this package.
}
