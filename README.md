# fiber_shell

Typed shell command builder for Dart and Flutter desktop: CLI tools wrapped as
classes, pipes and chaining run in Dart.

Running a system command from Dart usually ends up as string concatenation
handed to `sh -c`: you escape every argument by hand, you lose autocompletion,
and Windows is off the table.

This package takes the other route. Every tool is a class where one method is
one option, and the chain stays typed end to end:

```dart
import 'package:fiber_shell/fiber_shell.dart';

await Rm.recursive().force().path('/tmp/build').execute();

final ShellResult result = await (Curl.silent().url(endpoint) | Jq.rawOutput().filter('.version')).output();
if (result.failed) print(result.error);
```

Shell operators are reimplemented in Dart rather than delegated to an
interpreter: `|` wires the streams between processes, and `&&`, `||`, `;`
become `and()`, `or()`, `then()`. No argument is ever interpolated into a
string, so there is nothing to escape and no injection surface.

Pure Dart, zero external dependencies. Works from a Dart CLI and from a Flutter
desktop app on Linux, macOS and Windows.

## Install

```yaml
dependencies:
  fiber_shell: ^1.0.0
```

```dart
import 'package:fiber_shell/fiber_shell.dart';
```

One import gives you every wrapper, the runners and the result type.

## The shape of it

A command is built, then run. Building never touches the machine.

```dart
final MkdirCmd command = Mkdir.parents().path('build/artifacts');

command.line;        // 'mkdir -p build/artifacts', rendered but not run
await command.execute();
```

`Mkdir` is a getter that hands back a fresh builder, and every option returns
that same builder, so a chain collects arguments and stops there.

### Four ways to run

| Call | What it does |
|------|--------------|
| `execute()` | Runs with stdio inherited, so output appears live. Throws `ShellException` on a non-zero status. |
| `output()` | Captures both streams and returns a `ShellResult`. Never throws on a non-zero status. |
| `writeTo(File)` | Sends stdout straight into a file, the way `>` does. |
| `background()` | Starts the job and returns a `BackgroundJob` you can `wait()` on or `kill()`. |

All four take `cwd` and `env`; `output()` also takes `input` for stdin.

```dart
await Find.path('lib').type('f').name('*.dart').writeTo(File('inventory.txt'));

final ShellResult framed = await Sed.expression('s/.*/[&]/').output(input: 'alpha\n');

final ShellResult scoped = await Git.status().porcelain().output(
  cwd: '/some/repo',
  env: <String, String>{'GIT_TERMINAL_PROMPT': '0'},
);
```

### A failure is a value

`output()` returns a `ShellResult` whatever happened. A command that fails is
something to inspect, not something to catch:

```dart
final ShellResult result = await Git.status().porcelain().output();

result.success;     // exit code was zero
result.failed;      // it was not
result.exitCode;
result.text;        // stdout, trailing newline dropped
result.lines;       // the non-blank lines, in order
result.error;       // stderr, trimmed
result.bytes;       // stdout undecoded: `openssl pkey -outform DER` writes a key, not a string
result.duration;
result.textOrNull;  // the text, or null if it failed or printed nothing
result.orThrow();   // the text, or a ShellException carrying the stderr
```

Output is kept as bytes and decoded on demand, so the same type carries text
and binary alike.

### Pipes

`|` starts every stage at once and wires each stdout into the next stdin.

```dart
final ShellResult errors = await (Grep.pattern('ERROR').file('server.log') |
        Sed.expression('s/^[0-9:]* ERROR //') |
        Grep.invertMatch().pattern('timeout'))
    .output();
```

The status is the one `set -o pipefail` gives: the rightmost stage that failed,
or zero when they all succeeded. Plain shell semantics, where only the last
stage counts, hide a broken first command behind a `grep` that happily matched
nothing.

### Chaining

Dart cannot overload `&&` and `||`: they short-circuit, which makes them syntax
rather than operators. So they are named instead:

```dart
await Mkdir.parents().path(release).and(Cp.recursive().source(src).destination(release)).execute();

await Grep.quiet().pattern('token').file(config)
    .or(Grep.quiet().pattern('token').file(fallback))
    .output();

await Rm.path(stale).then(Mkdir.parents().path(fresh)).execute();
```

A chain is deliberately not a pipe stage: a shell needs a subshell to pipe out
of one, and this package will not pretend otherwise. Pipe the stages, chain the
outcomes.

### Elevation

`asRoot()` marks the command rather than the run, so it survives being piped or
chained. Only the stage that needs the rights takes them.

```dart
await Systemctl.restart().unit('nginx').asRoot().execute();

await (Grep.pattern('Failed password').file('/var/log/auth.log').asRoot() | Grep.count().pattern('.')).output();
```

It adds `sudo` on Linux and leaves the command untouched elsewhere, because
that is where `sudo` is the answer.

### Rendering without running

`line` renders a command, a pipeline or a whole chain as a terminal would show
it, which is all a `--dry-run` flag has to be:

```dart
Ufw.allow().arg('443/tcp').asRoot().and(Ufw.reload().asRoot()).line;
// 'sudo ufw allow 443/tcp && sudo ufw reload'
```

One caveat: it joins the executable and its arguments with spaces, for a human
or a log file to read. It is not shell-quoted, so an argument containing a
space renders as two words. Read it, log it, show it behind a flag, but do not
build a shell command out of it.

## The catalogue

Wrappers are grouped first by where the tool exists, then by what family of
job it does. It grows as needs come up.

| Group | Family | Tools |
|-------|--------|-------|
| `common/` | `archives/` | tar |
| `common/` | `cloud/` | aws, az, gcloud |
| `common/` | `containers/` | docker, docker compose, helm, kubectl |
| `common/` | `databases/` | mysql, pg_dump, pg_restore, psql, redis-cli, sqlite3 |
| `common/` | `env/` | direnv |
| `common/` | `infrastructure/` | ansible-playbook, packer, terraform, tofu |
| `common/` | `network/` | curl, jq, wget, yq |
| `common/` | `remote/` | scp, ssh, ssh-keygen |
| `common/` | `runtimes/` | bun, deno, go, node, npm, pip, python3, ruby |
| `common/` | `security/` | age, gpg, openssl, vault |
| `common/` | `vcs/` | gh, git |
| `unix/` | `filesystem/` | basename, cp, dirname, du, find, install, ln, mkdir, readlink, rm, stat, touch |
| `unix/` | `network/` | nc |
| `unix/` | `permissions/` | chmod, chown |
| `unix/` | `pipeline/` | tee, xargs |
| `unix/` | `process/` | kill, lsof, nohup, ps, top |
| `unix/` | `shell/` | bash, env, sh |
| `unix/` | `system/` | date, df, uptime |
| `unix/` | `text/` | awk, cat, diff, grep, head, printf, sed, sort, tail, uniq, wc |
| `unix/` | `transfer/` | rsync |
| `linux/` | `firewall/` | iptables, ufw |
| `linux/` | `hardware/` | free, lscpu, nproc |
| `linux/` | `kernel/` | dmesg, lsmod, modprobe |
| `linux/` | `namespaces/` | chroot, nsenter, unshare |
| `linux/` | `networking/` | ethtool, ip, nmcli, ss, tcpdump, wg |
| `linux/` | `package_managers/` | apk, apt-get, dnf, pacman |
| `linux/` | `security/` | setenforce |
| `linux/` | `services/` | crontab, journalctl, loginctl, systemctl, timedatectl |
| `linux/` | `storage/` | blkid, fdisk, lsblk, mount |
| `linux/` | `system/` | groupadd, secret-tool, sysctl, useradd, usermod |
| `macos/` | `apps/` | open |
| `macos/` | `automation/` | osascript |
| `macos/` | `clipboard/` | pbcopy, pbpaste |
| `macos/` | `developer/` | qlmanage, xcode-select, xcrun |
| `macos/` | `media/` | say, screencapture |
| `macos/` | `networking/` | networksetup, scutil |
| `macos/` | `package_managers/` | brew |
| `macos/` | `power/` | caffeinate, pmset |
| `macos/` | `search/` | mdfind, mdls |
| `macos/` | `security/` | codesign, csrutil |
| `macos/` | `services/` | launchctl |
| `macos/` | `storage/` | diskutil, hdiutil, tmutil |
| `macos/` | `system/` | defaults, dscl, ioreg, plutil, profiles, security, softwareupdate, spctl, sw_vers, sysctl, system_profiler |
| `windows/` | `eventlog/` | wevtutil |
| `windows/` | `filesystem/` | attrib, robocopy, xcopy |
| `windows/` | `networking/` | ipconfig, netsh, netstat |
| `windows/` | `package_managers/` | scoop, winget |
| `windows/` | `permissions/` | icacls, takeown |
| `windows/` | `policy/` | gpresult, gpupdate |
| `windows/` | `power/` | shutdown |
| `windows/` | `process/` | taskkill, tasklist |
| `windows/` | `registry/` | reg |
| `windows/` | `security/` | certutil |
| `windows/` | `services/` | sc, schtasks |
| `windows/` | `shell/` | cmd, powershell |
| `windows/` | `storage/` | chkdsk, diskpart, fsutil |
| `windows/` | `system/` | bcdedit, dism, driverquery, sfc, systeminfo, whoami, wusa |

Every wrapper carries its own documentation: the traps of the tool, which
platform it exists on, and which options bite in automation. Read the class
comment before reaching for a flag: `security`, `dscl`, `netsh`, `launchctl`,
`shutdown`, `attrib`, `certutil`, `wevtutil`, `chkdsk`, `diskpart`, `dism`,
`bcdedit` and `csrutil` in particular have surprises worth knowing about
first.

Two helpers for the tools that may not be there at all:

```dart
if (await commandExists('docker')) { ... }

await waitUntil(<String>['pg_isready', '-h', 'localhost'], interval: 1, timeout: 30);
```

## Writing your own wrapper

The catalogue will never cover everything, and a wrapper is about twenty lines.
A class names itself as its own type argument, which is what keeps a chain
typed to the end:

```dart
class WcCmd extends CommandBuilder<WcCmd> {
  @override
  final String executable = 'wc';

  /// Counts lines (`-l`).
  WcCmd lines() => token('-l');

  /// Adds a path to count.
  WcCmd file(String path) => token(path);
}

/// `wc`, ready to take its first option.
// ignore: non_constant_identifier_names
WcCmd get Wc => WcCmd();
```

That is all. Pipes, chaining, elevation, background jobs and `line` come from
the base class:

```dart
final ShellResult count = await (Grep.pattern('ERROR').file(log) | Wc.lines()).output();
```

Four helpers cover the argument shapes tools use:

| Helper | Emits |
|--------|-------|
| `token('-l')` | a bare flag, or a subcommand, or a path |
| `pair('-C', path)` | two separate arguments |
| `joined('--max-count', '5')` | `--max-count=5` |
| `joinedAll('--allow-read', paths)` | `--allow-read=a,b` |

One thing to watch when naming options: `execute`, `output`, `writeTo`, `line`,
`asRoot`, `stages`, `token`, `pair`, `joined` and `joinedAll` belong to the base
class. Colliding with one is an invalid override, so it fails to compile rather
than misbehaving at runtime, which is how curl's `-o` ended up as
`outputFile()` here.

## Flutter desktop

The package is pure Dart and uses `dart:io`, so it works in a Flutter desktop
app as it does in a CLI. Two things to know:

**macOS sandboxing.** A Flutter macOS app is sandboxed by default, and a
sandboxed process cannot spawn arbitrary binaries. `Process` will fail on most
of them until `com.apple.security.app-sandbox` is removed from the
`.entitlements` files, which also means giving up Mac App Store distribution.

**Keep it off the UI isolate for long jobs.** `execute()` and `output()` are
async and do not block, but a job that produces a lot of output is still work on
the isolate that draws your frames. Reach for `background()`, or an isolate, when
that matters.

There is nothing here for Flutter web or mobile: `dart:io` process spawning does
not exist on the web, and neither Android nor iOS lets an app run arbitrary
binaries.

## Example

`example/` is a runnable tour in eight chapters, each a single file:

```console
cd example
dart pub get
dart run lib/example.dart        # the whole tour
dart run lib/example.dart 3 8    # just piping and custom wrappers
```

It runs in a throwaway temp directory, elevates nothing for real, and asks for
no password. See [example/README.md](example/README.md) for what each chapter
covers.

## Tests

```console
dart test
```

The suite covers the builders, `ShellResult`, the runners, pipelines, chaining
and background jobs. Chaining is tested with mockito: whether `or()` actually
skips its right-hand side is an assertion (`verifyNever`) rather than a guess at
what a second process left behind.

`test/catalogue_test.dart` reads the sources and guards the structural rules:
that every wrapper is exported from the barrel, names itself as its own type
argument, declares a usable executable, and offers a getter facade. It is what
catches a wrapper added without its `export` line, which compiles fine and
leaves the tool invisible to everyone importing the package.

Mocks are generated and committed, so `dart test` runs without a build step.
After changing a `@GenerateNiceMocks` annotation:

```console
dart run build_runner build
```

## Contributing a wrapper

1. Add `lib/src/commands/<group>/<family>/<tool>.dart`, following the shape
   above. Reuse an existing family when the tool fits one, in `## The
   catalogue` below; open a new family folder rather than stretch one whose
   name would no longer describe every tool in it.
2. Document the class: what the tool is, where it exists, and what bites in
   automation. That comment is the reason the wrapper is worth more than a raw
   `Process.start`.
3. Add the `export` line to `lib/fiber_shell.dart`, in alphabetical order.
4. Run `dart test`. `catalogue_test.dart` fails if step 3 was missed.
