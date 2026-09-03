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

/// `bun`, the JavaScript runtime, package manager, bundler and test runner
/// shipped as one binary.
///
/// ```dart
/// await Bun.install().frozenLockfile().execute(cwd: projectDir);
/// await Bun.run().script('build').forceBun().execute();
/// ```
///
/// [run] resolves a name in this order: a `package.json` script first, then a
/// source file, then a binary one of the installed packages exposes, and only
/// with `bun run` itself, last, whatever a shell would find on `$PATH`. A CLI
/// installed as a dependency usually carries a `#!/usr/bin/env node` shebang,
/// which bun honours by handing the process to `node`; [forceBun] overrides
/// that and keeps it inside Bun's own runtime.
///
/// `bun.lock` is bun's lockfile, text-based since 1.2 and read in place of
/// both `package-lock.json` and `yarn.lock`. [yarn] writes a `yarn.lock`
/// alongside it for tooling that still expects one; [saveTextLockfile] is
/// what upgrades a pre-1.2 binary `bun.lockb` once, after which the flag is
/// no longer needed. [frozenLockfile] is the one to reach for in CI: bun
/// installs exactly what the lockfile says and exits with an error the
/// moment `package.json` disagrees with it, rather than silently updating
/// anything.
///
/// [x] is `bunx`: it installs the package into a shared global cache the
/// first time it is asked for a binary not already in `node_modules/.bin`,
/// the same role `npx` plays for npm.
class BunCmd extends CommandBuilder<BunCmd> {
  @override
  final String executable = 'bun';

  /// Executes a file, a `package.json` script, or a project binary (`run`).
  ///
  /// Bare `bun <script>` works too for a `package.json` script, but `run` is
  /// the only spelling that also falls back to a shell command on `$PATH`.
  BunCmd run() => token('run');

  /// Installs every dependency `package.json` declares (`install`, aliased `bun i`).
  BunCmd install() => token('install');

  /// Adds a dependency to `package.json` and installs it (`add`, aliased `bun a`).
  BunCmd add() => token('add');

  /// Removes a dependency from `package.json` and uninstalls it (`remove`, aliased `bun rm`/`bun r`).
  BunCmd remove() => token('remove');

  /// Updates dependencies within the ranges `package.json` already declares (`update`, aliased `bun up`).
  ///
  /// Add [latest] to ignore those ranges and jump to the newest release of each.
  BunCmd update() => token('update');

  /// Registers this directory as linkable, or links a registered package into it (`link`).
  BunCmd link() => token('link');

  /// Unregisters this directory as a linkable package (`unlink`).
  BunCmd unlink() => token('unlink');

  /// Publishes the package to the npm registry (`publish`).
  BunCmd publish() => token('publish');

  /// Lists the dependencies with a newer version than the one installed (`outdated`).
  BunCmd outdated() => token('outdated');

  /// Reaches the package manager utilities: [pmPack], [pmLs], [pmWhy] and the rest (`pm`).
  BunCmd pm() => token('pm');

  /// Starts an empty project, writing `package.json`, `tsconfig.json` and `bunfig.toml` (`init`).
  BunCmd init() => token('init');

  /// Scaffolds a new project from a template or a GitHub repository (`create`, aliased `bun c`).
  BunCmd create() => token('create');

  /// Runs the test files bun's test runner finds (`test`).
  BunCmd test() => token('test');

  /// Bundles one or more entry points into a single output (`build`).
  BunCmd build() => token('build');

  /// Installs the latest stable release of bun itself (`upgrade`).
  ///
  /// [canary] switches the channel to the most recent canary build instead.
  BunCmd upgrade() => token('upgrade');

  /// Runs a package binary, installing it into the shared cache first if needed (`x`, the `bunx` entry point).
  BunCmd x() => token('x');

  /// Prepares an installed package for local edits, or commits those edits as a patch (`patch`).
  BunCmd patch() => token('patch');

  /// Restarts the process on every file change (`--watch`).
  BunCmd watch() => token('--watch');

  /// The signal `--watch` sends the old process before restarting it (`--watch-kill-signal`).
  BunCmd watchKillSignal(String signal) => joined('--watch-kill-signal', signal);

  /// Leaves the previous frame on screen across a `--watch` or `--hot` reload (`--no-clear-screen`).
  BunCmd noClearScreen() => token('--no-clear-screen');

  /// Reloads the affected modules in place instead of restarting the process (`--hot`).
  BunCmd hot() => token('--hot');

  /// Trades speed for a smaller heap by collecting more eagerly (`--smol`).
  BunCmd smol() => token('--smol');

  /// Activates the debugger, at the given URL or port when one is given (`--inspect`).
  BunCmd inspect([String? value]) => value == null ? token('--inspect') : joined('--inspect', value);

  /// The same, but stops on the first line and waits for a client before running anything (`--inspect-brk`).
  BunCmd inspectBrk([String? value]) => value == null ? token('--inspect-brk') : joined('--inspect-brk', value);

  /// Runs [script] instead of a file or a `package.json` script (`-e`, `--eval`).
  BunCmd eval(String script) => joined('--eval', script);

  /// The same, then prints whatever the script's last expression evaluated to (`-p`, `--print`).
  BunCmd printResult(String script) => joined('--print', script);

  /// Runs the CLI with Bun's own runtime instead of the `node` its shebang asks for (`-b`, `--bun`).
  ///
  /// See the class documentation: most published CLIs carry `#!/usr/bin/env node`, and bun
  /// honours it unless this flag says otherwise.
  BunCmd forceBun() => token('--bun');

  /// Loads environment variables from this file instead of the `.env` bun finds on its own (`--env-file`).
  BunCmd envFile(String path) => joined('--env-file', path);

  /// Turns off bun's automatic `.env` loading (`--no-env-file`).
  BunCmd noEnvFile() => token('--no-env-file');

  /// Substitutes `key` for `value` while parsing, e.g. `process.env.NODE_ENV` for `"production"` (`-d`, `--define`).
  ///
  /// `value` is parsed as JSON, so a string substitution needs its own quotes: `define('DEBUG', 'false')`
  /// inlines the bare identifier `false`, while `define('DEBUG', '"false"')` inlines the string `"false"`.
  BunCmd define(String key, String value) => joined('--define', '$key:$value');

  /// The intended execution environment for a bundle: `browser`, `bun` or `node` (`--target`).
  BunCmd target(String value) => joined('--target', value);

  /// Overrides which `tsconfig.json` bun reads, instead of the one in [cwd] (`--tsconfig-override`).
  BunCmd tsconfigOverride(String path) => joined('--tsconfig-override', path);

  /// Prints nothing but the command's own output (`--silent`).
  BunCmd silent() => token('--silent');

  /// Resolves files and entry points from this directory instead of the process's own (`--cwd`).
  BunCmd cwd(String path) => joined('--cwd', path);

  /// The bun config file to read instead of `$cwd/bunfig.toml` (`-c`, `--config`).
  BunCmd config(String path) => joined('--config', path);

  /// Restricts the command to the workspaces matching this pattern (`-F`, `--filter`). Repeatable.
  BunCmd filter(String pattern) => joined('--filter', pattern);

  /// Runs across every workspace named in the root `package.json` (`--workspaces`).
  BunCmd workspaces() => token('--workspaces');

  /// Exits quietly instead of failing when the entry point does not exist (`--if-present`).
  BunCmd ifPresent() => token('--if-present');

  /// Imports this module before anything else runs (`-r`, `--preload`).
  BunCmd preload(String module) => joined('--preload', module);

  /// Sets the default port `Bun.serve` listens on (`--port`).
  BunCmd port(int value) => joined('--port', '$value');

  /// Passes custom export conditions to module resolution (`--conditions`).
  BunCmd conditions(String value) => joined('--conditions', value);

  /// Parses files whose extension is not bun's default with this loader, `ext:loader` (`-l`, `--loader`).
  BunCmd loader(String spec) => joined('--loader', spec);

  /// How many lines of a `--filter` script's output to show before eliding the rest (`--elide-lines`).
  BunCmd elideLines(int count) => joined('--elide-lines', '$count');

  /// Runs the scripts named on the command line concurrently, Foreman-style (`--parallel`).
  ///
  /// This is `bun run`'s own flag, a bare switch. [test]'s `--parallel` takes a worker count
  /// instead; that one is [parallelWorkers].
  BunCmd parallel() => token('--parallel');

  /// Runs them one after another instead (`--sequential`).
  BunCmd sequential() => token('--sequential');

  /// With [parallel] or [sequential], keeps going after one script fails (`--no-exit-on-error`).
  BunCmd noExitOnError() => token('--no-exit-on-error');

  /// Disables bun's automatic dependency install while running a script (`--no-install`).
  BunCmd noInstall() => token('--no-install');

  /// Configures automatic install during `run`: `auto`, `fallback` or `force` (`--install`).
  BunCmd installMode(String mode) => joined('--install', mode);

  /// Installs only the packages missing from `node_modules`, equivalent to `--install=fallback` (`-i`).
  BunCmd autoInstall() => token('-i');

  /// Skips devDependencies (`-p`, `--production`).
  BunCmd production() => token('--production');

  /// Fails instead of touching the lockfile when it disagrees with `package.json` (`--frozen-lockfile`).
  ///
  /// The one to run in CI: see the class documentation.
  BunCmd frozenLockfile() => token('--frozen-lockfile');

  /// Adds the dependency to `devDependencies` (`-d`, `--dev`).
  BunCmd dev() => token('--dev');

  /// Adds it to `optionalDependencies` (`--optional`).
  BunCmd optional() => token('--optional');

  /// Adds it to `peerDependencies` (`--peer`).
  BunCmd peer() => token('--peer');

  /// Records the exact resolved version instead of a `^` range (`-E`, `--exact`).
  BunCmd exact() => token('--exact');

  /// Acts on the global install rather than this project (`-g`, `--global`).
  BunCmd global() => token('--global');

  /// Skips writing `package.json` or the lockfile (`--no-save`).
  BunCmd noSave() => token('--no-save');

  /// Writes them, which is already the default (`--save`).
  BunCmd save() => token('--save');

  /// Re-requests the latest versions from the registry and reinstalls everything (`-f`, `--force`).
  BunCmd force() => token('--force');

  /// Reports what would happen without changing anything (`--dry-run`).
  BunCmd dryRun() => token('--dry-run');

  /// Talks to this registry instead of the one `.npmrc` or `bunfig.toml` names (`--registry`).
  BunCmd registry(String url) => joined('--registry', url);

  /// Also writes a `yarn.lock` (yarn v1) alongside `bun.lock` (`-y`, `--yarn`).
  BunCmd yarn() => token('--yarn');

  /// Runs the lifecycle scripts of an otherwise untrusted dependency and adds it to `trustedDependencies` (`--trust`).
  BunCmd trust() => token('--trust');

  /// A Certificate Authority signing certificate, inline (`--ca`).
  BunCmd ca(String value) => joined('--ca', value);

  /// The same, read from a file (`--cafile`).
  BunCmd caFile(String path) => joined('--cafile', path);

  /// Stores and loads cached package data from this directory (`--cache-dir`).
  BunCmd cacheDir(String path) => joined('--cache-dir', path);

  /// Ignores the manifest cache entirely (`--no-cache`).
  BunCmd noCache() => token('--no-cache');

  /// Prints only the tarball name while packing (`--quiet`).
  BunCmd quiet() => token('--quiet');

  /// Logs excessively (`--verbose`).
  BunCmd verbose() => token('--verbose');

  /// Disables the progress bar (`--no-progress`).
  BunCmd noProgress() => token('--no-progress');

  /// Skips the install summary (`--no-summary`).
  BunCmd noSummary() => token('--no-summary');

  /// Skips verifying the integrity of newly downloaded packages (`--no-verify`).
  BunCmd noVerify() => token('--no-verify');

  /// Skips every lifecycle script in the project's own `package.json` (`--ignore-scripts`).
  ///
  /// A dependency's install script still never runs on its own; this only covers the project's.
  BunCmd ignoreScripts() => token('--ignore-scripts');

  /// The platform-specific strategy for laying files into `node_modules` (`--backend`).
  ///
  /// One of `clonefile` (the default), `hardlink`, `symlink` or `copyfile`.
  BunCmd backend(String value) => joined('--backend', value);

  /// The maximum concurrent lifecycle-script jobs, default twice the CPU count (`--concurrent-scripts`).
  BunCmd concurrentScripts(int count) => joined('--concurrent-scripts', '$count');

  /// The maximum concurrent network requests, default 48 (`--network-concurrency`).
  BunCmd networkConcurrency(int count) => joined('--network-concurrency', '$count');

  /// Writes the lockfile in bun's text format (`--save-text-lockfile`).
  ///
  /// The one-time migration off a pre-1.2 binary `bun.lockb`: see the class documentation.
  BunCmd saveTextLockfile() => token('--save-text-lockfile');

  /// Excludes a dependency type from the install: `dev`, `optional` or `peer` (`--omit`).
  BunCmd omit(String value) => joined('--omit', value);

  /// Generates the lockfile without touching `node_modules` (`--lockfile-only`).
  BunCmd lockfileOnly() => token('--lockfile-only');

  /// The linker strategy: `isolated` or `hoisted` (`--linker`).
  BunCmd linker(String value) => joined('--linker', value);

  /// Refuses to install a package published less than this many seconds ago (`--minimum-release-age`).
  ///
  /// A security control against a package that turns malicious minutes after release.
  BunCmd minimumReleaseAge(int seconds) => joined('--minimum-release-age', '$seconds');

  /// Overrides the CPU architecture used to resolve optional dependencies (`--cpu`).
  BunCmd cpu(String value) => joined('--cpu', value);

  /// Overrides the operating system used to resolve optional dependencies (`--os`).
  BunCmd os(String value) => joined('--os', value);

  /// Adds the resolved version to the root `package.json` catalog and depends on `catalog:` (`--catalog`).
  BunCmd catalog() => token('--catalog');

  /// The same, into a named catalog rather than the default one (`--catalog`).
  BunCmd catalogNamed(String name) => joined('--catalog', name);

  /// Adds to `package.json` only the dependencies not already listed there (`--only-missing`).
  BunCmd onlyMissing() => token('--only-missing');

  /// Recursively analyzes the files given as arguments and installs what they import (`-a`, `--analyze`).
  BunCmd analyze() => token('--analyze');

  /// Ignores the ranges in `package.json` and updates to each package's latest release (`-L`, `--latest`).
  BunCmd latest() => token('--latest');

  /// Shows an interactive list of outdated packages to choose which to update (`-i`, `--interactive`).
  BunCmd interactive() => token('--interactive');

  /// Applies the command to every workspace (`-r`, `--recursive`).
  BunCmd recursive() => token('--recursive');

  /// Leaves `optionalDependencies` out of an update (`--no-optional`).
  BunCmd noOptional() => token('--no-optional');

  /// The access level of a published scoped package: `public` or `restricted` (`--access`).
  BunCmd access(String value) => joined('--access', value);

  /// The dist-tag to publish under, or to install from, default `latest` (`--tag`).
  BunCmd tag(String value) => joined('--tag', value);

  /// A one-time password for registry authentication (`--otp`).
  BunCmd otp(String value) => joined('--otp', value);

  /// How the one-time password is obtained, default `web` (`--auth-type`).
  BunCmd authType(String value) => joined('--auth-type', value);

  /// The gzip compression level applied while packing, 0-9, default 9 (`--gzip-level`).
  BunCmd gzipLevel(int level) => joined('--gzip-level', '$level');

  /// Exits 0 instead of failing when republishing over a version that already exists (`--tolerate-republish`).
  BunCmd tolerateRepublish() => token('--tolerate-republish');

  /// Updates the recorded snapshots instead of failing against them (`-u`, `--update-snapshots`).
  BunCmd updateSnapshots() => token('--update-snapshots');

  /// Re-runs each test file this many times, to catch a flake or a leak between runs (`--rerun-each`).
  BunCmd rerunEach(int count) => joined('--rerun-each', '$count');

  /// The default retry count for a test that fails, unless it sets its own (`--retry`).
  BunCmd retry(int count) => joined('--retry', '$count');

  /// Includes the tests marked `test.todo()` (`--todo`).
  BunCmd todo() => token('--todo');

  /// Runs only the tests and suites marked `.only()` (`--only`).
  BunCmd only() => token('--only');

  /// Exits 0 instead of failing when no test file matches (`--pass-with-no-tests`).
  BunCmd passWithNoTests() => token('--pass-with-no-tests');

  /// Treats every test as if it called `test.concurrent()` (`--concurrent`).
  BunCmd concurrent() => token('--concurrent');

  /// Runs the tests in a random order (`--randomize`).
  BunCmd randomize() => token('--randomize');

  /// The random seed behind [randomize], for a reproducible shuffle (`--seed`).
  BunCmd seed(int value) => joined('--seed', '$value');

  /// Generates a coverage profile for the run (`--coverage`).
  BunCmd coverage() => token('--coverage');

  /// Which coverage report to write, `text` and/or `lcov`, default `text` (`--coverage-reporter`).
  BunCmd coverageReporter(String value) => joined('--coverage-reporter', value);

  /// Where coverage files are written, default `coverage` (`--coverage-dir`).
  BunCmd coverageDir(String path) => joined('--coverage-dir', path);

  /// Stops the suite after this many failures, default 1 when no count is given (`--bail`).
  BunCmd bail() => token('--bail');

  /// The same, with an explicit failure count (`--bail`).
  BunCmd bailAfter(int count) => joined('--bail', '$count');

  /// Runs only the tests whose name matches this regular expression (`-t`, `--test-name-pattern`).
  BunCmd testNamePattern(String regex) => joined('--test-name-pattern', regex);

  /// The test output format: `junit` (needs [reporterOutfile]) or `dots` (`--reporter`).
  BunCmd reporter(String value) => joined('--reporter', value);

  /// Where [reporter] writes its report (`--reporter-outfile`).
  BunCmd reporterOutfile(String path) => joined('--reporter-outfile', path);

  /// Shorthand for `reporter=dots` (`--dots`).
  BunCmd dots() => token('--dots');

  /// Hides the passing tests, showing only the failures (`--only-failures`).
  BunCmd onlyFailures() => token('--only-failures');

  /// The most tests run at once, default 20 (`--max-concurrency`).
  BunCmd maxConcurrency(int count) => joined('--max-concurrency', '$count');

  /// Glob patterns for test file paths to skip (`--path-ignore-patterns`).
  BunCmd pathIgnorePatterns(String pattern) => joined('--path-ignore-patterns', pattern);

  /// Runs only the test files affected by what changed in git since `HEAD` (`--changed`).
  BunCmd changed() => token('--changed');

  /// The same, compared against this commit or branch instead (`--changed`).
  BunCmd changedSince(String ref) => joined('--changed', ref);

  /// Runs every test file in a fresh global object, so one file's leaked handles cannot reach another (`--isolate`).
  BunCmd isolate() => token('--isolate');

  /// With [parallelWorkers], lets each worker reuse one global and module registry across its files (`--no-isolate`).
  ///
  /// Faster, at the cost of files that can see each other's leftovers.
  BunCmd noIsolate() => token('--no-isolate');

  /// Runs test files across this many worker processes, implying [isolate] (`--parallel`).
  ///
  /// [test]'s own `--parallel`; `bun run`'s bare switch of the same name is [parallel].
  BunCmd parallelWorkers(int count) => joined('--parallel', '$count');

  /// How long, in milliseconds, the first [parallelWorkers] worker must stay busy before the rest spawn (`--parallel-delay`).
  BunCmd parallelDelay(int milliseconds) => joined('--parallel-delay', '$milliseconds');

  /// Runs one slice of the test files, `N/M`, for splitting a suite across CI jobs (`--shard`).
  BunCmd shard(String value) => joined('--shard', value);

  /// A JSON file of measured per-file durations, read to balance [shard] and order [parallelWorkers] (`--timings`).
  ///
  /// Repeatable: several files, one per CI shard, are merged.
  BunCmd timings(String path) => joined('--timings', path);

  /// After the run, writes the measured durations to the first [timings] file (`--update-timings`).
  BunCmd updateTimings() => token('--update-timings');

  /// The per-test timeout in milliseconds, default 5000 (`--timeout`).
  BunCmd timeout(int milliseconds) => joined('--timeout', '$milliseconds');

  /// Where a multi-file build is written, default `dist` (`--outdir`).
  BunCmd outdir(String path) => joined('--outdir', path);

  /// Where a single-file build is written (`--outfile`).
  BunCmd outfile(String path) => joined('--outfile', path);

  /// The module format of the output: `esm` (the default), `cjs` or `iife` (`--format`).
  BunCmd format(String value) => joined('--format', value);

  /// Splits the output into shared chunks instead of one bundle per entry point (`--splitting`).
  BunCmd splitting() => token('--splitting');

  /// Enables every minification pass (`--minify`).
  BunCmd minify() => token('--minify');

  /// Minifies syntax and inlines constants, without touching names or whitespace (`--minify-syntax`).
  BunCmd minifySyntax() => token('--minify-syntax');

  /// Minifies whitespace only (`--minify-whitespace`).
  BunCmd minifyWhitespace() => token('--minify-whitespace');

  /// Minifies identifiers only (`--minify-identifiers`).
  BunCmd minifyIdentifiers() => token('--minify-identifiers');

  /// Keeps original function and class names even under [minifyIdentifiers] (`--keep-names`).
  BunCmd keepNames() => token('--keep-names');

  /// Builds a sourcemap: `linked`, `inline`, `external` or `none` (`--sourcemap`).
  BunCmd sourcemap(String value) => joined('--sourcemap', value);

  /// Excludes a module from bundling, wildcards allowed (`-e`, `--external`).
  BunCmd external(String spec) => joined('--external', spec);

  /// Whether to bundle or externalize the project's own dependencies: `external` or `bundle` (`--packages`).
  BunCmd packages(String value) => joined('--packages', value);

  /// A prefix prepended to the import paths left in the bundled code (`--public-path`).
  BunCmd publicPath(String value) => joined('--public-path', value);

  /// Text prepended to the bundle, such as a `"use client"` directive (`--banner`).
  BunCmd banner(String value) => joined('--banner', value);

  /// Text appended to the bundle (`--footer`).
  BunCmd footer(String value) => joined('--footer', value);

  /// The root directory used to lay out multiple entry points (`--root`).
  BunCmd root(String path) => joined('--root', path);

  /// The naming pattern for entry point files, default `[dir]/[name].[ext]` (`--entry-naming`).
  BunCmd entryNaming(String pattern) => joined('--entry-naming', pattern);

  /// The naming pattern for split chunk files, default `[name]-[hash].[ext]` (`--chunk-naming`).
  BunCmd chunkNaming(String pattern) => joined('--chunk-naming', pattern);

  /// The naming pattern for emitted asset files, default `[name]-[hash].[ext]` (`--asset-naming`).
  BunCmd assetNaming(String pattern) => joined('--asset-naming', pattern);

  /// Caches a bytecode representation of the output alongside it (`--bytecode`).
  BunCmd bytecode() => token('--bytecode');

  /// Bundles into a standalone executable that carries the Bun runtime with it (`--compile`).
  ///
  /// Implies [production].
  BunCmd compile() => token('--compile');

  /// Transpiles the entry point without bundling its imports (`--no-bundle`).
  BunCmd noBundle() => token('--no-bundle');

  /// Inlines matching environment variables into the bundle as `process.env.NAME`, default disabled (`--env`).
  ///
  /// A prefix like `FOO_PUBLIC_*` inlines only the variables it matches.
  BunCmd inlineEnv(String value) => joined('--env', value);

  /// Writes a JSON file describing the module graph the build produced (`--metafile`).
  BunCmd metafile(String path) => joined('--metafile', path);

  /// Accepts every default option without prompting (`-y`, `--yes`).
  BunCmd yes() => token('--yes');

  /// Writes only the TypeScript type definitions, skipping the rest of a full project (`-m`, `--minimal`).
  BunCmd minimal() => token('--minimal');

  /// Scaffolds a React project (`-r`, `--react`).
  BunCmd react() => token('--react');

  /// The same, with a template added on top: `tailwind` or `shadcn` (`--react`).
  BunCmd reactTemplate(String template) => joined('--react', template);

  /// Runs `x`'s target with Bun's runtime rather than Node's (`--bun`).
  ///
  /// Distinct method from [forceBun] only because `bunx --help` lists it on its own; the flag is
  /// the same `--bun`.
  BunCmd xForceBun() => token('--bun');

  /// Installs under this package name when the binary name does not match the package (`-p`, `--package`).
  BunCmd packageOption(String name) => joined('--package', name);

  /// Installs the canary channel instead of the latest stable release (`--canary`).
  BunCmd canary() => token('--canary');

  /// Applies the edits made under `--commit`'s target directory as a saved patch file (`--commit`).
  BunCmd commit() => token('--commit');

  /// Where [commit] writes the patch file, instead of the project's default patches directory (`--patches-dir`).
  BunCmd patchesDir(String path) => joined('--patches-dir', path);

  /// Scans every package the lockfile names for known vulnerabilities (`scan`, under [pm]).
  BunCmd pmScan() => token('scan');

  /// Builds a tarball of the current workspace, the way `publish` would (`pack`, under [pm]).
  BunCmd pmPack() => token('pack');

  /// The directory [pmPack] writes its tarball into (`--destination`).
  BunCmd destination(String path) => joined('--destination', path);

  /// The file name [pmPack] gives the tarball (`--filename`).
  BunCmd filename(String name) => joined('--filename', name);

  /// Prints the path to the `.bin` folder (`bin`, under [pm]).
  ///
  /// Add [global] for the global one rather than the project's own.
  BunCmd pmBin() => token('bin');

  /// Lists the dependency tree the current lockfile describes (`ls`, under [pm]).
  ///
  /// Add [all] for the entire tree, or [trustedOnly] for only the trusted dependencies.
  BunCmd pmLs() => token('ls');

  /// Every entry, not only the top level (`--all`).
  BunCmd all() => token('--all');

  /// Only the dependencies already marked trusted (`--trusted`).
  BunCmd trustedOnly() => token('--trusted');

  /// Explains why a package is present in the tree, and by which dependency it was pulled in (`why`, under [pm]).
  BunCmd pmWhy() => token('why');

  /// Lists every installed package grouped by its declared license (`licenses`, under [pm]).
  BunCmd pmLicenses() => token('licenses');

  /// Prints as JSON instead of prose (`--json`).
  BunCmd json() => token('--json');

  /// Also prints the author, description and homepage of each package (`--long`).
  BunCmd long() => token('--long');

  /// Prints the currently authenticated npm username (`whoami`, under [pm]).
  BunCmd pmWhoami() => token('whoami');

  /// Views a package's registry metadata (`view`, under [pm]).
  ///
  /// `bun info` is the newer, standalone spelling of the same lookup.
  BunCmd pmView() => token('view');

  /// Bumps the version in `package.json` and creates a matching git tag (`version`, under [pm]).
  ///
  /// Takes `patch`, `minor`, `major`, `prepatch`, `preminor`, `premajor`, `prerelease`, `from-git`,
  /// or an explicit version, as a bare argument.
  BunCmd pmVersion() => token('version');

  /// Reads and writes fields of `package.json` directly (`pkg`, under [pm]).
  BunCmd pmPkg() => token('pkg');

  /// Reads one or more keys (`get`, under [pmPkg]).
  BunCmd pmPkgGet() => token('get');

  /// Writes one or more `key=value` pairs (`set`, under [pmPkg]).
  BunCmd pmPkgSet() => token('set');

  /// Removes one or more keys (`delete`, under [pmPkg]).
  BunCmd pmPkgDelete() => token('delete');

  /// Auto-corrects the common mistakes a hand-edited `package.json` accumulates (`fix`, under [pmPkg]).
  BunCmd pmPkgFix() => token('fix');

  /// Prints the hash of the current lockfile (`hash`, under [pm]).
  BunCmd pmHash() => token('hash');

  /// Prints the string that hash is computed from (`hash-string`, under [pm]).
  BunCmd pmHashString() => token('hash-string');

  /// Prints the hash already stored inside the lockfile (`hash-print`, under [pm]).
  BunCmd pmHashPrint() => token('hash-print');

  /// Prints the path to bun's package cache folder (`cache`, under [pm]).
  BunCmd pmCache() => token('cache');

  /// Deletes everything in the package cache (`rm`, under [pmCache]).
  BunCmd pmCacheClear() => token('rm');

  /// Reads another package manager's lockfile and rewrites it as bun's, installing nothing (`migrate`, under [pm]).
  BunCmd pmMigrate() => token('migrate');

  /// Lists the dependencies that carry install scripts bun has not yet trusted to run (`untrusted`, under [pm]).
  BunCmd pmUntrusted() => token('untrusted');

  /// Runs the scripts of the named untrusted dependencies and records them as trusted (`trust`, under [pm]).
  ///
  /// Add [all] to trust every untrusted dependency at once.
  BunCmd pmTrustDependencies() => token('trust');

  /// Prints the dependencies bun trusts to run install scripts without being asked (`default-trusted`, under [pm]).
  BunCmd pmDefaultTrusted() => token('default-trusted');

  /// Adds a package spec, `name`, `name@version`, a GitHub repo, or a URL.
  BunCmd packageSpec(String value) => token(value);

  /// The name of the `package.json` script, after [run].
  BunCmd script(String name) => token(name);

  /// Adds a bare argument, for anything this wrapper has no named option for.
  BunCmd arg(String value) => token(value);
}

/// `bun`, ready to take its first option.
// ignore: non_constant_identifier_names
BunCmd get Bun => BunCmd();
