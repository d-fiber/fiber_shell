# fiber_shell by example

A runnable tour of the library, in eight short chapters. Each one is a single
file under `lib/src/`, written to be read top to bottom, and every line of it
actually runs.

```console
cd example
dart pub get

dart run lib/example.dart        # the whole tour
dart run lib/example.dart 3 8    # just chapters 3 and 8
```

Everything happens inside a throwaway directory under the system temp folder,
which is deleted when the tour ends. Nothing touches your machine, nothing asks
for a password, and no command is elevated for real.

The tour drives POSIX tools (`find`, `grep`, `sed`, `wc`), so it wants macOS or
Linux. The library itself covers Windows through the `powershell`, `netsh`,
`reg`, `schtasks` and `icacls` wrappers, and chapter 7 renders one of them from
any platform.

## The chapters

| # | File | What it shows |
|---|------|---------------|
| 1 | `lib/src/chapter_01_running_a_command.dart` | One method is one option; `line` renders, `execute()` runs, a non-zero status throws |
| 2 | `lib/src/chapter_02_reading_results.dart` | `output()` never throws; `ShellResult` carries the status, both streams, the duration |
| 3 | `lib/src/chapter_03_piping.dart` | `\|` wires stdout into stdin between real processes, with `pipefail` semantics |
| 4 | `lib/src/chapter_04_chaining.dart` | `and()`, `or()` and `then()` for `&&`, `\|\|` and `;` |
| 5 | `lib/src/chapter_05_files_env_and_stdin.dart` | `writeTo` a file, feed `input`, set `cwd` and `env`, check with `commandExists` |
| 6 | `lib/src/chapter_06_background_jobs.dart` | `background()`, `waitUntil(...)`, `kill()`, and reading the result afterwards |
| 7 | `lib/src/chapter_07_elevation_and_dry_run.dart` | `asRoot()` on the command rather than the run; describing a plan without running it |
| 8 | `lib/src/chapter_08_your_own_command.dart` | Wrapping a tool the catalogue does not ship yet, in about twenty lines |

## The shortest possible version

If you read nothing else, read this:

```dart
import 'package:fiber_shell/fiber_shell.dart';

Future<void> main() async {
  // Build it. Nothing has run yet.
  final MkdirCmd command = Mkdir.parents().path('build/artifacts');

  // Look at it: `mkdir -p build/artifacts`.
  print(command.line);

  // Run it, with stdio inherited. Throws ShellException on a non-zero status.
  await command.execute();

  // Or run it and read what happened, without ever throwing.
  final ShellResult result = await (Grep.pattern('ERROR').file('server.log') | Wc.lines()).output();
  if (result.failed) print(result.error);
  print('${result.text} errors');
}
```

## Two things worth knowing before you start

**`line` is for reading, not for re-running.** It joins the executable and its
arguments with spaces so a human, a log file or a `--dry-run` flag can see what
would happen. It is not shell-quoted: an argument containing a space renders as
two words. That is fine, because nothing in this library ever hands a
string back to a shell.

**Elevation belongs to the command, not to the run.** `asRoot()` marks a single
command, which is what a pipeline needs: only the stage reading the protected
file wants the rights. It adds `sudo` on Linux and leaves the command alone
elsewhere.
