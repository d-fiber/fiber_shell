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

/// `node`. Not preinstalled anywhere; `commandExists` first, and expect the
/// version to vary wildly between machines unless something like `nvm` pins it,
/// since Node breaks compatibility across major versions more often than the
/// other runtimes this directory wraps.
///
/// ```dart
/// final ShellResult version = await Node.evalCode('console.log(process.version)').output();
/// await Node.testMode().testReporter('tap').arg('test/').execute();
/// ```
///
/// Three things worth knowing before scripting it. [checkSyntax] parses a file
/// without running it, the fast way to validate a generated script. The test
/// runner built into Node itself, [testMode] and its siblings, needs no
/// separate package for a project with no other test framework opinions. And
/// [unhandledRejections] set to `strict` is what turns a swallowed promise
/// rejection into a hard failure instead of a message nobody reads; the
/// runtime default only warns.
class NodeCmd extends CommandBuilder<NodeCmd> {
  @override
  final String executable = 'node';

  /// Reads the script from stdin (`-`). The default when no filename is given and stdin is not a terminal.
  NodeCmd stdin() => token('-');

  /// Ends node's own options, so anything after belongs to the script (`--`).
  NodeCmd separator() => token('--');

  /// Checks a script for syntax errors without executing it (`-c`, `--check`).
  NodeCmd checkSyntax() => token('--check');

  /// The program, passed as a string (`-e`, `--eval`). Ends the options.
  NodeCmd evalCode(String code) => pair('--eval', code);

  /// Evaluates a script and prints the result (`-p`, `--print`). Ends the options.
  NodeCmd printResult(String code) => pair('--print', code);

  /// Always enters the REPL, even when stdin is not a terminal (`-i`, `--interactive`).
  NodeCmd interactive() => token('--interactive');

  /// Preloads a CommonJS module before running the script (`-r`, `--require`). Repeatable.
  NodeCmd require(String module) => pair('--require', module);

  /// Preloads an ES module before running the script (`--import`). Repeatable.
  NodeCmd import(String module) => pair('--import', module);

  /// The module system assumed for a string given to [evalCode] or [printResult] (`--input-type`).
  NodeCmd inputType(String type) => pair('--input-type', type);

  /// Forces conditional exports/imports to also match this custom condition (`-C`, `--conditions`). Repeatable.
  NodeCmd conditions(String value) => pair('--conditions', value);

  /// Prints the current Node.js command-line options (`-h`, `--help`).
  NodeCmd help() => token('--help');

  /// Prints the Node.js version (`-v`, `--version`).
  NodeCmd version() => token('--version');

  /// Prints the V8 engine's own command-line options (`--v8-options`).
  NodeCmd v8Options() => token('--v8-options');

  /// Sets environment variables from this file before the script runs (`--env-file`).
  NodeCmd envFile(String path) => pair('--env-file', path);

  /// The same as [envFile], but silently does nothing if the file is missing (`--env-file-if-exists`).
  NodeCmd envFileIfExists(String path) => pair('--env-file-if-exists', path);

  /// Watches the script and its dependencies, restarting on change (`--watch`).
  NodeCmd watch() => token('--watch');

  /// Restricts [watch] to this path instead of the whole dependency graph (`--watch-path`).
  NodeCmd watchPath(String path) => pair('--watch-path', path);

  /// Keeps a watched process's console output across restarts instead of clearing it (`--watch-preserve-output`).
  NodeCmd watchPreserveOutput() => token('--watch-preserve-output');

  /// Runs the built-in test runner (`--test`).
  NodeCmd testMode() => token('--test');

  /// How many test files the runner executes in parallel (`--test-concurrency`).
  NodeCmd testConcurrency(int count) => pair('--test-concurrency', '$count');

  /// Forces the test runner to exit once tests complete, even with handles still open (`--test-force-exit`).
  NodeCmd testForceExit() => token('--test-force-exit');

  /// Only runs tests whose name matches this regular expression (`--test-name-pattern`).
  NodeCmd testNamePattern(String pattern) => pair('--test-name-pattern', pattern);

  /// Runs only the tests marked `{ only: true }` (`--test-only`).
  NodeCmd testOnly() => token('--test-only');

  /// The reporter the test runner writes output with, `tap`, `spec` or `dot` among them (`--test-reporter`).
  NodeCmd testReporter(String reporter) => pair('--test-reporter', reporter);

  /// Where [testReporter] writes to, a file path or `stdout`/`stderr` (`--test-reporter-destination`).
  NodeCmd testReporterDestination(String value) => pair('--test-reporter-destination', value);

  /// Runs only this shard of the test suite, `index/total` (`--test-shard`).
  NodeCmd testShard(String value) => pair('--test-shard', value);

  /// Caps how long a single test may run before it is marked failed (`--test-timeout`).
  NodeCmd testTimeout(String milliseconds) => pair('--test-timeout', milliseconds);

  /// Enables code coverage collection in the test runner (`--experimental-test-coverage`).
  NodeCmd experimentalTestCoverage() => token('--experimental-test-coverage');

  /// Activates the inspector on `host:port`, default `127.0.0.1:9229` (`--inspect`).
  NodeCmd inspect([String? hostPort]) => hostPort == null ? token('--inspect') : joined('--inspect', hostPort);

  /// Activates the inspector and pauses at the first line of the script (`--inspect-brk`).
  NodeCmd inspectBrk([String? hostPort]) =>
      hostPort == null ? token('--inspect-brk') : joined('--inspect-brk', hostPort);

  /// Activates the inspector and waits for a debugger to attach before running anything (`--inspect-wait`).
  NodeCmd inspectWait([String? hostPort]) =>
      hostPort == null ? token('--inspect-wait') : joined('--inspect-wait', hostPort);

  /// Sets the inspector's `host:port` without activating it by itself (`--inspect-port`, `--debug-port`).
  NodeCmd inspectPort(String hostPort) => joined('--inspect-port', hostPort);

  /// Where the inspector's process id is published: `stderr`, `http` or both, comma-separated (`--inspect-publish-uid`).
  NodeCmd inspectPublishUid(String value) => joined('--inspect-publish-uid', value);

  /// The maximum size of HTTP headers node will accept, in bytes (`--max-http-header-size`).
  NodeCmd maxHttpHeaderSize(int bytes) => joined('--max-http-header-size', '$bytes');

  /// Accepts invalid HTTP headers instead of rejecting the connection (`--insecure-http-parser`).
  NodeCmd insecureHttpParser() => token('--insecure-http-parser');

  /// Disables loading native addons entirely (`--no-addons`).
  NodeCmd noAddons() => token('--no-addons');

  /// Silences deprecation warnings (`--no-deprecation`).
  NodeCmd noDeprecation() => token('--no-deprecation');

  /// Emits pending deprecation warnings that are otherwise silent (`--pending-deprecation`).
  NodeCmd pendingDeprecation() => token('--pending-deprecation');

  /// Silences every process warning (`--no-warnings`).
  NodeCmd noWarnings() => token('--no-warnings');

  /// Writes warnings to this file instead of stderr (`--redirect-warnings`).
  NodeCmd redirectWarnings(String path) => joined('--redirect-warnings', path);

  /// Prints a stack trace alongside every deprecation warning (`--trace-deprecation`).
  NodeCmd traceDeprecation() => token('--trace-deprecation');

  /// Prints a stack trace for every process warning (`--trace-warnings`).
  NodeCmd traceWarnings() => token('--trace-warnings');

  /// Turns process warnings into thrown exceptions instead of printed messages (`--throw-deprecation`).
  NodeCmd throwDeprecation() => token('--throw-deprecation');

  /// How an unhandled promise rejection is treated: `strict`, `throw`, `warn` or `none` (`--unhandled-rejections`).
  ///
  /// The runtime default only warns; `strict` is what turns a swallowed rejection into a hard failure worth noticing.
  NodeCmd unhandledRejections(String mode) => joined('--unhandled-rejections', mode);

  /// Preserves symbolic links when resolving modules (`--preserve-symlinks`).
  NodeCmd preserveSymlinks() => token('--preserve-symlinks');

  /// The same, restricted to the entry module (`--preserve-symlinks-main`).
  NodeCmd preserveSymlinksMain() => token('--preserve-symlinks-main');

  /// Disables the global module search paths entirely (`--no-global-search-paths`).
  NodeCmd noGlobalSearchPaths() => token('--no-global-search-paths');

  /// Ensures the security policy's contents match this integrity value (`--policy-integrity`).
  NodeCmd policyIntegrity(String value) => joined('--policy-integrity', value);

  /// Enables the experimental permission model (`--experimental-permission`).
  NodeCmd experimentalPermission() => token('--experimental-permission');

  /// Under the permission model, allows filesystem reads at this path (`--allow-fs-read`). Repeatable.
  NodeCmd allowFsRead(String path) => joined('--allow-fs-read', path);

  /// Under the permission model, allows filesystem writes at this path (`--allow-fs-write`). Repeatable.
  NodeCmd allowFsWrite(String path) => joined('--allow-fs-write', path);

  /// Under the permission model, allows spawning child processes (`--allow-child-process`).
  NodeCmd allowChildProcess() => token('--allow-child-process');

  /// Under the permission model, allows worker threads (`--allow-worker`).
  NodeCmd allowWorker() => token('--allow-worker');

  /// Under the permission model, allows loading native addons (`--allow-addons`).
  NodeCmd allowAddons() => token('--allow-addons');

  /// Under the permission model, allows WASI (`--allow-wasi`).
  NodeCmd allowWasi() => token('--allow-wasi');

  /// The maximum old-generation heap size, in megabytes (`--max-old-space-size`). A V8 flag, but the one reached for most.
  NodeCmd maxOldSpaceSize(int megabytes) => joined('--max-old-space-size', '$megabytes');

  /// Raises the default maximum heap size on machines with 16GB of memory or more (`--huge-max-old-generation-size`).
  NodeCmd hugeMaxOldGenerationSize() => token('--huge-max-old-generation-size');

  /// Exposes the `gc()` extension for manual garbage collection (`--expose-gc`).
  NodeCmd exposeGc() => token('--expose-gc');

  /// Starts the CPU profiler and writes a `.cpuprofile` on exit (`--cpu-prof`).
  NodeCmd cpuProf() => token('--cpu-prof');

  /// The directory `--cpu-prof` writes its output to (`--cpu-prof-dir`).
  NodeCmd cpuProfDir(String path) => joined('--cpu-prof-dir', path);

  /// The sampling interval for `--cpu-prof`, in microseconds (`--cpu-prof-interval`).
  NodeCmd cpuProfInterval(int microseconds) => joined('--cpu-prof-interval', '$microseconds');

  /// Starts the heap profiler and writes a heap profile on exit (`--heap-prof`).
  NodeCmd heapProf() => token('--heap-prof');

  /// The directory `--heap-prof` writes its output to (`--heap-prof-dir`).
  NodeCmd heapProfDir(String path) => joined('--heap-prof-dir', path);

  /// Generates a legacy V8 profiler log (`--prof`).
  NodeCmd prof() => token('--prof');

  /// Processes a log produced by [prof] into a readable report (`--prof-process`).
  NodeCmd profProcess() => token('--prof-process');

  /// Enables source map support in stack traces (`--enable-source-maps`).
  NodeCmd enableSourceMaps() => token('--enable-source-maps');

  /// Generates a diagnostic report on an uncaught exception (`--report-uncaught-exception`).
  NodeCmd reportUncaughtException() => token('--report-uncaught-exception');

  /// Generates a diagnostic report on a fatal internal error (`--report-on-fatalerror`).
  NodeCmd reportOnFatalerror() => token('--report-on-fatalerror');

  /// Generates a diagnostic report when the given signal is received, `SIGUSR2` by default; not supported on Windows (`--report-on-signal`).
  NodeCmd reportOnSignal() => token('--report-on-signal');

  /// The signal [reportOnSignal] triggers on (`--report-signal`).
  NodeCmd reportSignal(String signal) => joined('--report-signal', signal);

  /// The directory diagnostic reports are written to (`--report-directory`).
  NodeCmd reportDirectory(String path) => joined('--report-directory', path);

  /// The filename a diagnostic report is written under (`--report-filename`).
  NodeCmd reportFilename(String name) => joined('--report-filename', name);

  /// Writes a diagnostic report as compact single-line JSON (`--report-compact`).
  NodeCmd reportCompact() => token('--report-compact');

  /// Leaves network interface details out of a diagnostic report (`--report-exclude-network`).
  NodeCmd reportExcludeNetwork() => token('--report-exclude-network');

  /// Runs with the legacy OpenSSL 3.0 provider enabled (`--openssl-legacy-provider`).
  NodeCmd opensslLegacyProvider() => token('--openssl-legacy-provider');

  /// Loads OpenSSL configuration from this file, overriding `OPENSSL_CONF` (`--openssl-config`).
  NodeCmd opensslConfig(String path) => joined('--openssl-config', path);

  /// The total size of the OpenSSL secure heap (`--secure-heap`).
  NodeCmd secureHeap(int bytes) => joined('--secure-heap', '$bytes');

  /// The minimum allocation size from the OpenSSL secure heap (`--secure-heap-min`).
  NodeCmd secureHeapMin(int bytes) => joined('--secure-heap-min', '$bytes');

  /// The TLS cipher suite list (`--tls-cipher-list`).
  NodeCmd tlsCipherList(String list) => joined('--tls-cipher-list', list);

  /// Sets the TLS minimum protocol version, `TLSv1`, `TLSv1.1`, `TLSv1.2` or `TLSv1.3` (`--tls-min-v1.2` and siblings).
  NodeCmd tlsMinVersion(String version) => token('--tls-min-v$version');

  /// Sets the TLS maximum protocol version, the same way as [tlsMinVersion] (`--tls-max-v1.2` and siblings).
  NodeCmd tlsMaxVersion(String version) => token('--tls-max-v$version');

  /// Uses the bundled CA store instead of the system one (`--use-bundled-ca`).
  NodeCmd useBundledCa() => token('--use-bundled-ca');

  /// Uses OpenSSL's default CA store, the default behaviour (`--use-openssl-ca`).
  NodeCmd useOpensslCa() => token('--use-openssl-ca');

  /// Disallows `eval` and the `Function` constructor from compiling strings into code (`--disallow-code-generation-from-strings`).
  NodeCmd disallowCodeGenerationFromStrings() => token('--disallow-code-generation-from-strings');

  /// Disables `Object.prototype.__proto__` entirely, or replaces it with a warning (`--disable-proto`).
  NodeCmd disableProto(String mode) => joined('--disable-proto', mode);

  /// Runs without runtime-allocated executable memory, disabling the JIT (`--jitless`).
  NodeCmd jitless() => token('--jitless');

  /// Disables trap-handler-based WebAssembly bounds checks, trading a slowdown for fewer inline checks (`--disable-wasm-trap-handler`).
  NodeCmd disableWasmTrapHandler() => token('--disable-wasm-trap-handler');

  /// Overrides the default order `dns.lookup` resolves addresses in: `ipv4first`, `ipv6first` or `verbatim` (`--dns-result-order`).
  NodeCmd dnsResultOrder(String order) => joined('--dns-result-order', order);

  /// Sets a comma-separated list of core modules to print debug information for (`--debug`, `NODE_DEBUG`).
  NodeCmd debugModules(String modules) => joined('--debug', modules);

  /// Sets the process title shown by `ps` (`--title`).
  NodeCmd title(String value) => joined('--title', value);

  /// Sets V8's internal thread pool size, also settable via `UV_THREADPOOL_SIZE` (`--v8-pool-size`).
  NodeCmd v8PoolSize(int size) => joined('--v8-pool-size', '$size');

  /// The default module type when Node cannot tell CommonJS from ESM (`--experimental-default-type`).
  NodeCmd experimentalDefaultType(String type) => joined('--experimental-default-type', type);

  /// A custom ES module loader hook (`--experimental-loader`, `--loader`). Repeatable.
  NodeCmd experimentalLoader(String module) => joined('--experimental-loader', module);

  /// Enables `import.meta.resolve()`'s `parentURL` argument (`--experimental-import-meta-resolve`).
  NodeCmd experimentalImportMetaResolve() => token('--experimental-import-meta-resolve');

  /// Enables `https:` imports in the ES module loader (`--experimental-network-imports`).
  NodeCmd experimentalNetworkImports() => token('--experimental-network-imports');

  /// Enables ES module support inside `vm` module contexts (`--experimental-vm-modules`).
  NodeCmd experimentalVmModules() => token('--experimental-vm-modules');

  /// Zero-fills every newly allocated `Buffer` and `SlowBuffer`, at a performance cost (`--zero-fill-buffers`).
  NodeCmd zeroFillBuffers() => token('--zero-fill-buffers');

  /// Aborts on an uncaught exception, generating a core dump, instead of exiting cleanly (`--abort-on-uncaught-exception`).
  NodeCmd abortOnUncaughtException() => token('--abort-on-uncaught-exception');

  /// Generates a heap snapshot blob to embed into a single executable application (`--experimental-sea-config`).
  NodeCmd experimentalSeaConfig(String path) => joined('--experimental-sea-config', path);

  /// Restores application state from this V8 startup snapshot blob (`--snapshot-blob`).
  NodeCmd snapshotBlob(String path) => joined('--snapshot-blob', path);

  /// Adds a bare argument, landing in the script's own `process.argv`.
  NodeCmd arg(String value) => token(value);

  /// The script file to run.
  NodeCmd file(String path) => token(path);
}

/// `node`, ready to take its first option.
// ignore: non_constant_identifier_names
NodeCmd get Node => NodeCmd();
