// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

/// `deno`, the JavaScript and TypeScript runtime. One self-contained binary on
/// every platform, which is why the whole backend runs on it.
///
/// ```dart
/// await Deno.test().allowEnv().allowSys().allowNet().noCheck().envFile(envFile).scriptArg('tests/')
///     .execute(cwd: functionsDir);
/// ```
///
/// The permission flags are the part worth being deliberate about. Bare
/// [allowNet] opens every host; [allowNetHosts] takes the list you actually need
/// and writes `--allow-net=a,b`. Every permission has that pair, plus a `deny`
/// twin that wins over any grant, so [allowRead] with [denyReadPaths] on the
/// secrets directory is a real pattern, not a contradiction.
///
/// The subcommand goes first, then the flags, then the script, then the script's
/// own arguments. Anything after [separator] belongs to the script and not to deno.
class DenoCmd extends CommandBuilder<DenoCmd> {
  @override
  final String executable = 'deno';

  /// Runs a program or a task (`run`).
  DenoCmd run() => token('run');

  /// Runs a server, so a module with a default `fetch` export (`serve`).
  DenoCmd serve() => token('serve');

  /// Runs a task from the config file (`task`).
  DenoCmd task() => token('task');

  /// Opens the interactive prompt (`repl`).
  DenoCmd repl() => token('repl');

  /// Evaluates a script given on the command line (`eval`).
  DenoCmd evalCode() => token('eval');

  /// Adds dependencies to the config file (`add`).
  DenoCmd add() => token('add');

  /// Installs the dependencies, or a script into the bin directory (`install`).
  DenoCmd install() => token('install');

  /// Removes a dependency or an installed script (`uninstall`).
  DenoCmd uninstall() => token('uninstall');

  /// Reports the dependencies that have moved on (`outdated`).
  DenoCmd outdated() => token('outdated');

  /// Approves npm lifecycle scripts (`approve-scripts`).
  DenoCmd approveScripts() => token('approve-scripts');

  /// Removes dependencies from the config file (`remove`).
  DenoCmd remove() => token('remove');

  /// Runs the benchmarks (`bench`).
  DenoCmd bench() => token('bench');

  /// Type-checks without running (`check`).
  DenoCmd check() => token('check');

  /// Empties the cache directory (`clean`).
  DenoCmd clean() => token('clean');

  /// Builds a self-contained executable (`compile`).
  DenoCmd compile() => token('compile');

  /// Turns collected coverage data into a report (`coverage`).
  DenoCmd coverage() => token('coverage');

  /// Manages and publishes to Deno Deploy (`deploy`).
  DenoCmd deploy() => token('deploy');

  /// Generates documentation for a module (`doc`).
  DenoCmd doc() => token('doc');

  /// Formats source files (`fmt`).
  DenoCmd fmt() => token('fmt');

  /// Prints what deno knows about a module or the cache (`info`).
  DenoCmd info() => token('info');

  /// Runs the Jupyter kernel (`jupyter`).
  DenoCmd jupyter() => token('jupyter');

  /// Lints source files (`lint`).
  DenoCmd lint() => token('lint');

  /// Creates a new project (`init`).
  DenoCmd init() => token('init');

  /// Runs the tests (`test`).
  DenoCmd test() => token('test');

  /// Publishes the package or workspace (`publish`).
  DenoCmd publish() => token('publish');

  /// Upgrades the deno binary itself (`upgrade`).
  DenoCmd upgrade() => token('upgrade');

  /// Prints the help (`--help`).
  DenoCmd help() => token('--help');

  /// Prints the version and exits (`--version`).
  DenoCmd version() => token('--version');

  /// Allows npm lifecycle scripts (`--allow-scripts`). Needs a `node_modules` directory.
  DenoCmd allowScripts() => token('--allow-scripts');

  /// Allows them for these packages only (`--allow-scripts=a,b`).
  DenoCmd allowScriptsFor(List<String> packages) => joinedAll('--allow-scripts', packages);

  /// Loads a certificate authority from a PEM file (`--cert`).
  DenoCmd cert(String file) => pair('--cert', file);

  /// Custom conditions for npm package exports (`--conditions`).
  DenoCmd conditions(String value) => pair('--conditions', value);

  /// The `deno.json` to use, when the automatic lookup is not what you want (`--config`).
  DenoCmd config(String file) => pair('--config', file);

  /// Loads no config file at all (`--no-config`).
  DenoCmd noConfig() => token('--no-config');

  /// Collects coverage into `coverage/` (`--coverage`).
  DenoCmd collectCoverage() => token('--coverage');

  /// Collects it into this directory instead (`--coverage=DIR`).
  DenoCmd coverageDir(String dir) => joined('--coverage', dir);

  /// Collects the raw data without producing a report (`--coverage-raw-data-only`).
  DenoCmd coverageRawDataOnly() => token('--coverage-raw-data-only');

  /// Starts the V8 CPU profiler and writes the profile on exit (`--cpu-prof`).
  DenoCmd cpuProf() => token('--cpu-prof');

  /// Where the CPU profiles go (`--cpu-prof-dir`). Implies [cpuProf].
  DenoCmd cpuProfDir(String dir) => pair('--cpu-prof-dir', dir);

  /// Writes an SVG flamegraph next to the profile (`--cpu-prof-flamegraph`).
  DenoCmd cpuProfFlamegraph() => token('--cpu-prof-flamegraph');

  /// The sampling interval in microseconds (`--cpu-prof-interval`). Defaults to 1000.
  DenoCmd cpuProfInterval(int microseconds) => pair('--cpu-prof-interval', '$microseconds');

  /// Writes a readable markdown report next to the profile (`--cpu-prof-md`).
  DenoCmd cpuProfMarkdown() => token('--cpu-prof-md');

  /// The filename of the CPU profile (`--cpu-prof-name`).
  DenoCmd cpuProfName(String name) => pair('--cpu-prof-name', name);

  /// Loads environment variables from this file (`--env-file=FILE`).
  ///
  /// Existing process variables win, and within the file the first declaration wins.
  DenoCmd envFile(String path) => joined('--env-file', path);

  /// The same, from the default `.env` (`--env-file`).
  DenoCmd defaultEnvFile() => token('--env-file');

  /// Forces the content type of the file: `ts`, `tsx`, `js`, `jsx`, `mts`, `mjs`, `cts`, `cjs` (`--ext`).
  DenoCmd ext(String value) => pair('--ext', value);

  /// The value of `globalThis.location` (`--location`).
  DenoCmd location(String href) => pair('--location', href);

  /// Refuses dependencies published more recently than this (`--minimum-dependency-age`).
  ///
  /// A cheap guard against a freshly published malicious version. Unstable.
  DenoCmd minimumDependencyAge(String value) => pair('--minimum-dependency-age', value);

  /// Turns the V8 code cache off (`--no-code-cache`).
  DenoCmd noCodeCache() => token('--no-code-cache');

  /// Runs this file before the main module (`--preload`).
  DenoCmd preload(String file) => pair('--preload', file);

  /// Suppresses the diagnostic output (`--quiet`).
  DenoCmd quiet() => token('--quiet');

  /// Runs this CommonJS module before the main one (`--require`).
  DenoCmd require(String file) => pair('--require', file);

  /// Seeds the random number generator, so a run repeats (`--seed`).
  DenoCmd seed(int value) => pair('--seed', '$value');

  /// Opens a tunnel to Deno Deploy for the run (`--tunnel`).
  DenoCmd tunnel() => token('--tunnel');

  /// The old blanket flag (`--unstable`). Deprecated; use [unstableFeature].
  DenoCmd unstable() => token('--unstable');

  /// Turns one unstable feature on (`--unstable-<name>`).
  DenoCmd unstableFeature(String name) => token('--unstable-$name');

  /// Passes flags straight to V8 (`--v8-flags`).
  DenoCmd v8Flags(String flags) => joined('--v8-flags', flags);

  /// Type-checks the local modules (`--check`).
  DenoCmd typeCheck() => token('--check');

  /// Type-checks the remote ones too (`--check=all`).
  DenoCmd typeCheckAll() => joined('--check', 'all');

  /// Skips type checking altogether (`--no-check`).
  ///
  /// Worth it for a test run whose types the editor already checks; it is most of the startup cost.
  DenoCmd noCheck() => token('--no-check');

  /// Checks the local modules but ignores the remote diagnostics (`--no-check=remote`).
  DenoCmd noCheckRemote() => joined('--no-check', 'remote');

  /// Restarts on a file change (`--watch`).
  DenoCmd watch() => token('--watch');

  /// Watches these paths as well as the module graph (`--watch=a,b`).
  DenoCmd watchPaths(List<String> paths) => joinedAll('--watch', paths);

  /// Hot-replaces modules instead of restarting, falling back to a restart (`--watch-hmr`).
  DenoCmd watchHmr() => token('--watch-hmr');

  /// Keeps these paths out of the watch (`--watch-exclude=a,b`).
  DenoCmd watchExclude(List<String> paths) => joinedAll('--watch-exclude', paths);

  /// Leaves the terminal alone between watch runs (`--no-clear-screen`).
  DenoCmd noClearScreen() => token('--no-clear-screen');

  /// Opens the inspector on `127.0.0.1:9229` (`--inspect`).
  DenoCmd inspect() => token('--inspect');

  /// Opens it on this host and port (`--inspect=HOST:PORT`). Port `0` picks a free one.
  DenoCmd inspectHost(String hostPort) => joined('--inspect', hostPort);

  /// Opens the inspector and breaks before the first line (`--inspect-brk`).
  DenoCmd inspectBrk() => token('--inspect-brk');

  /// The same on this host and port (`--inspect-brk=HOST:PORT`).
  DenoCmd inspectBrkHost(String hostPort) => joined('--inspect-brk', hostPort);

  /// Opens the inspector and waits for a debugger before running (`--inspect-wait`).
  DenoCmd inspectWait() => token('--inspect-wait');

  /// The same on this host and port (`--inspect-wait=HOST:PORT`).
  DenoCmd inspectWaitHost(String hostPort) => joined('--inspect-wait', hostPort);

  /// Refuses to fetch: everything remote must already be cached (`--cached-only`).
  DenoCmd cachedOnly() => token('--cached-only');

  /// Fails when the lockfile is out of date (`--frozen`).
  DenoCmd frozen() => token('--frozen');

  /// Lets the lockfile be updated (`--frozen=false`).
  DenoCmd noFrozen() => joined('--frozen', 'false');

  /// Loads an import map, local or remote (`--import-map`).
  DenoCmd importMap(String file) => pair('--import-map', file);

  /// Checks against `./deno.lock` (`--lock`).
  DenoCmd lock() => token('--lock');

  /// Checks against this lockfile instead (`--lock FILE`).
  DenoCmd lockFile(String file) => pair('--lock', file);

  /// Skips the lockfile lookup (`--no-lock`).
  DenoCmd noLock() => token('--no-lock');

  /// Refuses to resolve `npm:` specifiers (`--no-npm`).
  DenoCmd noNpm() => token('--no-npm');

  /// Refuses to resolve remote modules (`--no-remote`).
  DenoCmd noRemote() => token('--no-remote');

  /// Materialises a `node_modules` directory (`--node-modules-dir`).
  DenoCmd nodeModulesDir() => token('--node-modules-dir');

  /// Which mode to do that in: `auto`, `manual` or `none` (`--node-modules-dir=MODE`).
  DenoCmd nodeModulesDirMode(String mode) => joined('--node-modules-dir', mode);

  /// Refetches everything, cache be damned (`--reload`).
  DenoCmd reload() => token('--reload');

  /// Refetches only these specifiers (`--reload=a,b`).
  DenoCmd reloadOnly(List<String> modules) => joinedAll('--reload', modules);

  /// Keeps remote modules in a local `vendor/` folder (`--vendor`).
  DenoCmd vendor() => token('--vendor');

  /// Ignores the vendor folder (`--vendor=false`).
  DenoCmd noVendor() => joined('--vendor', 'false');

  /// Grants every permission (`--allow-all`).
  ///
  /// Convenient, and the reason the sandbox stops being a sandbox. Prefer the narrow flags.
  DenoCmd allowAll() => token('--allow-all');

  /// Loads a named permission set from the config file (`--permission-set=NAME`).
  DenoCmd permissionSet(String name) => joined('--permission-set', name);

  /// Throws on a missing permission instead of asking (`--no-prompt`).
  ///
  /// What any non-interactive run wants, otherwise it hangs on a prompt nobody sees.
  DenoCmd noPrompt() => token('--no-prompt');

  /// Grants read access to the whole filesystem (`--allow-read`).
  DenoCmd allowRead() => token('--allow-read');

  /// Grants it for these paths only (`--allow-read=a,b`).
  DenoCmd allowReadPaths(List<String> paths) => joinedAll('--allow-read', paths);

  /// Grants write access to the whole filesystem (`--allow-write`).
  DenoCmd allowWrite() => token('--allow-write');

  /// Grants it for these paths only (`--allow-write=a,b`).
  DenoCmd allowWritePaths(List<String> paths) => joinedAll('--allow-write', paths);

  /// Allows importing from the default trusted hosts (`--allow-import`).
  DenoCmd allowImport() => token('--allow-import');

  /// Allows importing from these hosts only (`--allow-import=a,b`).
  DenoCmd allowImportHosts(List<String> hosts) => joinedAll('--allow-import', hosts);

  /// Grants network access to every host (`--allow-net`).
  DenoCmd allowNet() => token('--allow-net');

  /// Grants it for these hosts and ports only (`--allow-net=a,b`).
  DenoCmd allowNetHosts(List<String> hosts) => joinedAll('--allow-net', hosts);

  /// Grants access to every environment variable (`--allow-env`).
  DenoCmd allowEnv() => token('--allow-env');

  /// Grants access to these variables only (`--allow-env=A,B`).
  DenoCmd allowEnvVars(List<String> names) => joinedAll('--allow-env', names);

  /// Grants access to the OS information APIs (`--allow-sys`).
  DenoCmd allowSys() => token('--allow-sys');

  /// Grants access to these APIs only, by function name (`--allow-sys=a,b`).
  DenoCmd allowSysApis(List<String> names) => joinedAll('--allow-sys', names);

  /// Allows spawning any subprocess (`--allow-run`).
  ///
  /// Worth reading twice: a program that can spawn anything has every other permission too.
  DenoCmd allowRun() => token('--allow-run');

  /// Allows spawning these programs only (`--allow-run=a,b`).
  DenoCmd allowRunPrograms(List<String> names) => joinedAll('--allow-run', names);

  /// Allows loading dynamic libraries (`--allow-ffi`). Unstable.
  DenoCmd allowFfi() => token('--allow-ffi');

  /// Allows loading these ones only (`--allow-ffi=a,b`).
  DenoCmd allowFfiPaths(List<String> paths) => joinedAll('--allow-ffi', paths);

  /// Denies all filesystem reads (`--deny-read`). A deny beats any grant.
  DenoCmd denyRead() => token('--deny-read');

  /// Denies reads under these paths (`--deny-read=a,b`).
  DenoCmd denyReadPaths(List<String> paths) => joinedAll('--deny-read', paths);

  /// Denies all filesystem writes (`--deny-write`).
  DenoCmd denyWrite() => token('--deny-write');

  /// Denies writes under these paths (`--deny-write=a,b`).
  DenoCmd denyWritePaths(List<String> paths) => joinedAll('--deny-write', paths);

  /// Denies all network access (`--deny-net`).
  DenoCmd denyNet() => token('--deny-net');

  /// Denies these hosts (`--deny-net=a,b`).
  DenoCmd denyNetHosts(List<String> hosts) => joinedAll('--deny-net', hosts);

  /// Denies all environment access (`--deny-env`).
  DenoCmd denyEnv() => token('--deny-env');

  /// Denies these variables (`--deny-env=A,B`).
  DenoCmd denyEnvVars(List<String> names) => joinedAll('--deny-env', names);

  /// Denies all OS information access (`--deny-sys`).
  DenoCmd denySys() => token('--deny-sys');

  /// Denies these APIs (`--deny-sys=a,b`).
  DenoCmd denySysApis(List<String> names) => joinedAll('--deny-sys', names);

  /// Denies spawning subprocesses (`--deny-run`).
  DenoCmd denyRun() => token('--deny-run');

  /// Denies spawning these programs (`--deny-run=a,b`).
  DenoCmd denyRunPrograms(List<String> names) => joinedAll('--deny-run', names);

  /// Denies loading dynamic libraries (`--deny-ffi`).
  DenoCmd denyFfi() => token('--deny-ffi');

  /// Denies loading these ones (`--deny-ffi=a,b`).
  DenoCmd denyFfiPaths(List<String> paths) => joinedAll('--deny-ffi', paths);

  /// Denies importing from remote hosts (`--deny-import`).
  DenoCmd denyImport() => token('--deny-import');

  /// Denies these hosts (`--deny-import=a,b`).
  DenoCmd denyImportHosts(List<String> hosts) => joinedAll('--deny-import', hosts);

  /// Empties the coverage directory before the run (`--clean`).
  ///
  /// Racy when two runs share a coverage directory; give them separate ones.
  DenoCmd cleanCoverage() => token('--clean');

  /// Runs the code blocks found in JSDoc and Markdown (`--doc`).
  DenoCmd docTests() => token('--doc');

  /// Stops at the first failure (`--fail-fast`).
  DenoCmd failFast() => token('--fail-fast');

  /// Stops after this many failures (`--fail-fast=N`).
  DenoCmd failFastAfter(int errors) => joined('--fail-fast', '$errors');

  /// Runs only the tests whose name matches (`--filter`).
  DenoCmd filter(String value) => pair('--filter', value);

  /// Reports failures without the stack traces (`--hide-stacktraces`).
  DenoCmd hideStacktraces() => token('--hide-stacktraces');

  /// Leaves these files out (`--ignore=a,b`).
  DenoCmd ignore(List<String> paths) => joinedAll('--ignore', paths);

  /// Writes a JUnit XML report here, `-` for stdout (`--junit-path`).
  DenoCmd junitPath(String path) => pair('--junit-path', path);

  /// Caches the test modules without running them (`--no-run`).
  DenoCmd noRun() => token('--no-run');

  /// Runs the test modules in parallel (`--parallel`). Sized by `DENO_JOBS` or the cpu count.
  DenoCmd parallel() => token('--parallel');

  /// Exits zero when no test file was found (`--permit-no-files`).
  DenoCmd permitNoFiles() => token('--permit-no-files');

  /// Which reporter to use: `pretty`, `dot`, `junit` or `tap` (`--reporter`).
  DenoCmd reporter(String value) => pair('--reporter', value);

  /// Randomises the order of the tests (`--shuffle`).
  DenoCmd shuffle() => token('--shuffle');

  /// Randomises it from this seed, so it repeats (`--shuffle=N`).
  DenoCmd shuffleSeed(int value) => joined('--shuffle', '$value');

  /// Traces leaking ops, at a real cost in run time (`--trace-leaks`).
  DenoCmd traceLeaks() => token('--trace-leaks');

  /// Ends the deno options, so the rest belongs to the script (`--`).
  DenoCmd separator() => token('--');

  /// The module to run, a path or a URL.
  DenoCmd file(String path) => token(path);

  /// Adds an argument for the script, landing in its `Deno.args`.
  DenoCmd scriptArg(String value) => token(value);
}

/// `deno`, ready to take its subcommand.
// ignore: non_constant_identifier_names
DenoCmd get Deno => DenoCmd();
