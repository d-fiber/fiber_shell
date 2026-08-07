import 'dart:io';

import 'src/chapter_01_running_a_command.dart' as running_a_command;
import 'src/chapter_02_reading_results.dart' as reading_results;
import 'src/chapter_03_piping.dart' as piping;
import 'src/chapter_04_chaining.dart' as chaining;
import 'src/chapter_05_files_env_and_stdin.dart' as files_env_and_stdin;
import 'src/chapter_06_background_jobs.dart' as background_jobs;
import 'src/chapter_07_elevation_and_dry_run.dart' as elevation_and_dry_run;
import 'src/chapter_08_your_own_command.dart' as your_own_command;

/// One chapter of the tour: a title, and the code that demonstrates it.
class Chapter {
  const Chapter(this.title, this.run);

  /// What the chapter is about, printed as its header.
  final String title;

  /// The chapter's code, handed a scratch directory it may write into freely.
  final Future<void> Function(Directory workspace) run;
}

/// The tour, in the order it is meant to be read.
const List<Chapter> chapters = <Chapter>[
  Chapter('Running a command', running_a_command.run),
  Chapter('Reading results', reading_results.run),
  Chapter('Piping', piping.run),
  Chapter('Chaining on success and failure', chaining.run),
  Chapter('Files, stdin, cwd and env', files_env_and_stdin.run),
  Chapter('Background jobs', background_jobs.run),
  Chapter('Elevation and dry runs', elevation_and_dry_run.run),
  Chapter('Adding your own command', your_own_command.run),
];

/// Runs the whole tour, or the chapters named on the command line.
///
/// ```console
/// dart run lib/example.dart        # all of it
/// dart run lib/example.dart 3 8    # just piping and custom wrappers
/// ```
Future<void> main(List<String> arguments) async {
  if (Platform.isWindows) {
    print('This tour drives POSIX tools (find, grep, sed, wc), so it wants a Unix-like machine.');
    print('The library itself covers Windows: see the powershell, netsh, reg and schtasks wrappers.');
    return;
  }

  final List<Chapter> selected = _select(arguments);
  final Directory workspace = await Directory.systemTemp.createTemp('fiber_shell_example.');
  print('workspace: ${workspace.path}');

  try {
    for (final Chapter chapter in selected) {
      final String number = '${chapters.indexOf(chapter) + 1}'.padLeft(2, '0');
      print('\n$number. ${chapter.title}');
      print('─' * 60);
      await chapter.run(workspace);
    }
    print('\nDone. Every chapter lives in example/lib/src, in the order above.');
  } finally {
    await workspace.delete(recursive: true);
  }
}

/// The chapters asked for, or all of them when nothing was asked.
List<Chapter> _select(List<String> arguments) {
  if (arguments.isEmpty) return chapters;

  final List<Chapter> picked = <Chapter>[];
  for (final String argument in arguments) {
    final int? number = int.tryParse(argument);
    if (number == null || number < 1 || number > chapters.length) {
      throw ArgumentError('Chapters run from 1 to ${chapters.length}; got "$argument".');
    }
    picked.add(chapters[number - 1]);
  }
  return picked;
}
