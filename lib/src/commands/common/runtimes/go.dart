// Copyright (C) 2026 Fiber
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at https://mozilla.org/MPL/2.0/.
//
// What you may do:
// - Use this software for any purpose, including commercially, and build and
//   sell your own products on top of it.
// - Change it, and create new works based on it.
// - Distribute copies of it, with or without your changes.
// - Combine it with files under any other licence, proprietary ones included,
//   and licence that larger work on your own terms.
//
// What you must do in return:
// - Keep this notice on every file you received it on.
// - Publish, under these same terms, the source of every file covered by them
//   that you distribute, including the ones you changed, so that whoever
//   receives your version can obtain that source.
// - Leave Fiber out of it: the name "Fiber", its branding, its logos and its
//   trademarks may not be used to endorse or promote what you build, and this
//   licence grants no right to them.
//
// Disclaimer:
// AS FAR AS THE LAW ALLOWS, THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
// OR CONDITION OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
// NON-INFRINGEMENT. IN NO EVENT SHALL FIBER BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT
// LIMITED TO LOSS OF USE, DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT
// OF OR RELATED TO THESE TERMS OR THE USE OR NATURE OF THE SOFTWARE, UNDER ANY
// KIND OF LEGAL CLAIM.
//
// This header is a summary written for convenience. Where it differs from the
// LICENSE file, the LICENSE file governs.

import '../../../builder.dart';

/// `go`, the Go toolchain: build, test, run, format and manage modules, all
/// through one binary.
///
/// **This wrapper is a vocabulary, not a grammar**, the way [GhCmd] is for the
/// GitHub CLI: every subcommand is a method, and a flag shared by several of
/// them, [race], [verboseFlag], [modFlag], is one method reused wherever `go`
/// accepts it. Nothing validates that [testFlag]'s options only follow
/// [testCommand]; `go` says so itself if a flag lands somewhere it does not
/// apply.
///
/// ```dart
/// await Go.build().outputPath('bin/server').ldflags('-s -w').arg('./cmd/server').execute();
///
/// final ShellResult results = await Go.testCommand().verboseFlag().run('TestParse').arg('./...').output();
///
/// await Go.mod().tidy().execute();
/// ```
///
/// The build flags ([race], [tags], [ldflags], [trimpath] and the rest) are
/// shared by `build`, `clean`, `get`, `install`, `list`, `run` and `test` — add
/// them after the subcommand, same as the real CLI. [outputPath] is named to
/// avoid colliding with [CommandBuilder.output], the runner that captures a
/// result; the real flag is bare `-o`.
class GoCmd extends CommandBuilder<GoCmd> {
  @override
  final String executable = 'go';

  // Subcommands.

  /// Starts a bug report (`bug`).
  GoCmd bug() => token('bug');

  /// Compiles packages and their dependencies (`build`).
  GoCmd build() => token('build');

  /// Removes object files and cached files (`clean`).
  GoCmd clean() => token('clean');

  /// Shows documentation for a package or symbol (`doc`).
  GoCmd doc() => token('doc');

  /// Prints Go environment information (`env`).
  GoCmd env() => token('env');

  /// Updates packages to use new APIs (`fix`).
  GoCmd fix() => token('fix');

  /// Reformats package sources with `gofmt` (`fmt`).
  GoCmd fmt() => token('fmt');

  /// Generates Go files by processing source directives (`generate`).
  GoCmd generate() => token('generate');

  /// Adds dependencies to the current module and installs them (`get`).
  GoCmd get() => token('get');

  /// Compiles and installs packages and dependencies (`install`).
  GoCmd install() => token('install');

  /// Lists packages or modules (`list`).
  GoCmd list() => token('list');

  /// Runs module-maintenance subcommands (`mod`).
  GoCmd mod() => token('mod');

  /// Runs workspace-maintenance subcommands (`work`).
  GoCmd work() => token('work');

  /// Compiles and runs a Go program (`run`).
  GoCmd run() => token('run');

  /// Manages telemetry data and settings (`telemetry`).
  GoCmd telemetry() => token('telemetry');

  /// Tests packages (`test`). Named to avoid colliding with the base class's own [CommandBuilder.token].
  GoCmd testCommand() => token('test');

  /// Runs a specified Go tool (`tool`).
  GoCmd tool() => token('tool');

  /// Prints the Go version (`version`).
  GoCmd version() => token('version');

  /// Reports likely mistakes in packages (`vet`).
  GoCmd vet() => token('vet');

  // `go mod` subcommands.

  /// Initializes a new module in the current directory (`mod init`).
  GoCmd init(String modulePath) => token('init')..token(modulePath);

  /// Adds missing and removes unused module requirements (`mod tidy`).
  GoCmd tidy() => token('tidy');

  /// Resets the main module's vendor directory to match `go.mod` (`mod vendor`).
  GoCmd vendor() => token('vendor');

  /// Downloads modules to the local cache (`mod download`).
  GoCmd download() => token('download');

  /// Prints the module requirement graph (`mod graph`).
  GoCmd graph() => token('graph');

  /// Checks that dependencies match `go.sum` (`mod verify`).
  GoCmd verify() => token('verify');

  /// Edits `go.mod` from tools or scripts (`mod edit`).
  GoCmd edit() => token('edit');

  /// Explains why a package or module is needed (`mod why`).
  GoCmd why() => token('why');

  // Shared build flags (`build`, `clean`, `get`, `install`, `list`, `run`, `test`).

  /// Changes to a directory before running the command; must be the first flag if used (`-C`).
  GoCmd dir(String directory) => pair('-C', directory);

  /// Writes the resulting binary or object to this file or directory, instead of the default location (`-o`).
  ///
  /// Named [outputPath] to avoid colliding with [CommandBuilder.output].
  GoCmd outputPath(String path) => pair('-o', path);

  /// Forces rebuilding of packages that are already up to date (`-a`).
  GoCmd forceRebuild() => token('-a');

  /// Prints the commands but does not run them (`-n`).
  GoCmd dryRun() => token('-n');

  /// The number of programs that may run in parallel; defaults to `GOMAXPROCS` (`-p`).
  GoCmd parallel(int n) => pair('-p', '$n');

  /// Enables the data-race detector (`-race`).
  GoCmd race() => token('-race');

  /// Enables interoperation with the memory sanitizer (`-msan`).
  GoCmd msan() => token('-msan');

  /// Enables interoperation with the address sanitizer (`-asan`).
  GoCmd asan() => token('-asan');

  /// Enables code-coverage instrumentation (`-cover`).
  GoCmd cover() => token('-cover');

  /// Sets the coverage-analysis mode: `set`, `count` or `atomic` (`-covermode`).
  GoCmd covermode(String mode) => pair('-covermode', mode);

  /// Applies coverage analysis to packages matching these patterns, for a `main`-package build (`-coverpkg`).
  GoCmd coverpkg(String patterns) => pair('-coverpkg', patterns);

  /// Prints package names as they compile (`-v`). Shared with several subcommands' own verbose flags.
  GoCmd verboseFlag() => token('-v');

  /// Prints the temporary work directory and keeps it after exiting, instead of deleting it (`-work`).
  GoCmd keepWorkDir() => token('-work');

  /// Prints the exact commands run (`-x`).
  GoCmd xFlag() => token('-x');

  /// Arguments passed to every `go tool asm` invocation (`-asmflags`).
  GoCmd asmflags(String args) => pair('-asmflags', args);

  /// The build mode to use — see `go help buildmode` (`-buildmode`).
  GoCmd buildmode(String mode) => pair('-buildmode', mode);

  /// Whether to stamp binaries with version-control info: `true`, `false` or `auto` (`-buildvcs`).
  GoCmd buildvcs(String value) => pair('-buildvcs', value);

  /// The compiler to use: `gc` or `gccgo` (`-compiler`).
  GoCmd compiler(String name) => pair('-compiler', name);

  /// Arguments passed to every `gccgo` compiler/linker invocation (`-gccgoflags`).
  GoCmd gccgoflags(String args) => pair('-gccgoflags', args);

  /// Arguments passed to every `go tool compile` invocation (`-gcflags`).
  GoCmd gcflags(String args) => pair('-gcflags', args);

  /// A suffix for the package-installation directory name, to separate output from default builds (`-installsuffix`).
  GoCmd installsuffix(String suffix) => pair('-installsuffix', suffix);

  /// Emits build output as JSON, suitable for automated processing (`-json`).
  GoCmd jsonFlag() => token('-json');

  /// Arguments passed to every `go tool link` invocation (`-ldflags`).
  GoCmd ldflags(String args) => pair('-ldflags', args);

  /// Builds code meant to link against shared libraries built with `-buildmode=shared` (`-linkshared`).
  GoCmd linkshared() => token('-linkshared');

  /// The module-download mode: `readonly`, `vendor` or `mod` (`-mod`).
  GoCmd modFlag(String mode) => pair('-mod', mode);

  /// Leaves newly created module-cache directories read-write instead of read-only (`-modcacherw`).
  GoCmd modcacherw() => token('-modcacherw');

  /// Reads (and possibly writes) an alternate `go.mod` file (`-modfile`).
  GoCmd modfile(String path) => pair('-modfile', path);

  /// A JSON config file that overlays disk files with alternate content for the build (`-overlay`).
  GoCmd overlay(String path) => pair('-overlay', path);

  /// The profile-guided-optimization file to apply, or `auto`/`off` (`-pgo`).
  GoCmd pgo(String value) => pair('-pgo', value);

  /// Installs and loads all packages from this directory instead of the usual locations (`-pkgdir`).
  GoCmd pkgdir(String dir) => pair('-pkgdir', dir);

  /// A comma-separated list of extra build tags to satisfy during the build (`-tags`).
  GoCmd tags(String list) => pair('-tags', list);

  /// Removes file-system paths from the resulting executable (`-trimpath`).
  GoCmd trimpath() => token('-trimpath');

  /// A program to wrap every toolchain invocation (`asm`, `vet`, ...) with (`-toolexec`).
  GoCmd toolexec(String cmd) => pair('-toolexec', cmd);

  // `go test`-specific flags (in addition to the shared build flags above).

  /// Runs only the tests and examples matching this regular expression (`-run`).
  GoCmd runPattern(String pattern) => pair('-run', pattern);

  /// Runs only the benchmarks matching this regular expression, alongside the tests (`-bench`).
  GoCmd bench(String pattern) => pair('-bench', pattern);

  /// The number of times to run each benchmark, for more stable timings (`-benchtime`).
  GoCmd benchtime(String value) => pair('-benchtime', value);

  /// Fails a test if it takes longer than this duration; `0` disables the timeout (`-timeout`).
  GoCmd timeout(String duration) => pair('-timeout', duration);

  /// Tells long-running tests to skip themselves via `testing.Short()` (`-short`).
  GoCmd shortFlag() => token('-short');

  /// Runs each test and benchmark this many times (`-count`).
  GoCmd count(int n) => pair('-count', '$n');

  /// The maximum number of tests run in parallel within a package (`-parallel`).
  GoCmd testParallel(int n) => pair('-parallel', '$n');

  /// Writes a CPU profile to this file (`-cpuprofile`).
  GoCmd cpuprofile(String path) => pair('-cpuprofile', path);

  /// Writes a memory profile to this file (`-memprofile`).
  GoCmd memprofile(String path) => pair('-memprofile', path);

  /// Caches successful test results and skips re-running them unless `-count=1` is set — disable with `off` (`-vet`).
  GoCmd vetFlag(String mode) => pair('-vet', mode);

  /// Writes a machine-readable test log to this file, for `go tool test2json` (`-json`).
  GoCmd testJson(String path) => pair('-json', path);

  // Positional / escape hatch.

  /// A bare positional argument: a package pattern, a source file, or a flag this wrapper has no named method for.
  GoCmd arg(String value) => token(value);
}

/// `go`, ready to take its first subcommand.
// ignore: non_constant_identifier_names
GoCmd get Go => GoCmd();
