import 'dart:io';

import 'package:fiber_shell/fiber_shell.dart';

/// `&&`, `||` and `;`, as methods.
///
/// Dart cannot overload `&&` and `||`: they short-circuit, which makes them
/// syntax rather than operators, and `&` already reads as "background" to
/// anyone who knows a shell. So they are named: [ShellScript.and],
/// [ShellScript.or] and [ShellScript.then].
Future<void> run(Directory workspace) async {
  final Directory sources = Directory('${workspace.path}/sources')..createSync(recursive: true);
  await File('${sources.path}/app.dart').writeAsString('void main() {}\n');
  final String release = '${workspace.path}/release';

  // `and` is `&&`: the copy only happens if the directory was created.
  final ShellScript deploy =
      Mkdir.parents().path(release).and(Cp.recursive().source(sources.path).destination(release));
  print('  \$ ${deploy.line}');
  await deploy.execute();
  print('  copied   : ${File('$release/sources/app.dart').existsSync()}');

  // `or` is `||`: the fallback only runs if the first one failed. Here neither
  // file has the pattern, so the pair reports the fallback's own status.
  final ShellResult token = await Grep.quiet()
      .pattern('token')
      .file('${workspace.path}/absent.env')
      .or(Grep.quiet().pattern('token').file('${sources.path}/app.dart'))
      .output();
  print('  fallback : exit ${token.exitCode}');

  // `then` is `;`: the second runs whatever happened, and its status is the
  // pair's. The `rm` below fails and says so on stderr; nobody cares.
  final ShellScript cleanup = Rm.path('$release/not-there').then(Mkdir.parents().path('$release/logs'));
  print('  \$ ${cleanup.line}');
  final ShellResult swallowed = await cleanup.output();
  print('  swallowed: exit ${swallowed.exitCode}');

  // A chain is deliberately not a pipe stage. A shell needs a subshell to pipe
  // out of one, and there is no reason to fake that here: pipe the stages,
  // chain the outcomes.
}
