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

/// `tofu`, the CLI for OpenTofu. OpenTofu is a drop-in fork of Terraform, made
/// after Terraform's license change, and it kept the language, the state model
/// and almost the entire command grammar: a wrapper written for one reads like
/// a wrapper written for the other.
///
/// **This wrapper is a vocabulary, not a grammar.** Every subcommand `tofu -help`
/// lists is a method, and the flags shared across subcommands, `-var`, `-target`,
/// `-lock`, `-json` among them, are a single method each, reusable wherever
/// OpenTofu accepts them. Nothing validates that `-destroy` belongs to [plan]
/// rather than [validate]; OpenTofu will say so if you get it wrong.
///
/// ```dart
/// await Tofu.init().upgrade().execute();
/// final ShellResult planned = await Tofu.plan().out('tfplan').detailedExitcode().output();
/// if (planned.exitCode == 2) await Tofu.apply().autoApprove().arg('tfplan').execute();
/// ```
///
/// Three traps worth knowing. **State locking** stops two concurrent runs from
/// corrupting the same state file; [noLock] exists for the backends that cannot
/// lock at all, not as a way past a lock someone else is holding. **[autoApprove]
/// skips the plan confirmation entirely**, which is the safety net that lets a
/// human catch a plan about to destroy the wrong resource, so it belongs in a
/// pipeline and not at an interactive terminal. And **the `output` subcommand
/// collides with the base class's [CommandBuilder.output] execution method**, so
/// it is [showOutput] here.
class TofuCmd extends CommandBuilder<TofuCmd> {
  @override
  final String executable = 'tofu';

  /// Runs the subcommand as if started from this directory (`-chdir`).
  ///
  /// A global option: call it before the subcommand, never after.
  TofuCmd chdir(String path) => joined('-chdir', path);

  /// Prints the help for OpenTofu, or for the subcommand already chained (`-help`).
  TofuCmd helpFlag() => token('-help');

  /// Prints the version, the global alias for [version] (`-version`).
  TofuCmd versionFlag() => token('-version');

  /// Prepares the working directory: backend, modules, providers (`init`).
  TofuCmd init() => token('init');

  /// Checks the configuration for syntax and internal consistency (`validate`).
  ///
  /// Never touches remote state or provider APIs. [plan] validates too, in the
  /// context of real variables and a real workspace.
  TofuCmd validate() => token('validate');

  /// Computes what applying the configuration would change (`plan`).
  ///
  /// Changes nothing by itself. Pair with [out] to save the plan for a later
  /// [apply], and with [detailedExitcode] to tell a script "no changes" apart
  /// from "changes proposed" apart from "failed".
  TofuCmd plan() => token('plan');

  /// Creates or updates the infrastructure the configuration describes (`apply`).
  ///
  /// With no plan file argument it computes a plan first and asks for
  /// confirmation, unless [autoApprove] is chained. With one, it takes exactly
  /// the actions that plan recorded, no confirmation possible.
  TofuCmd apply() => token('apply');

  /// Destroys every object this configuration manages (`destroy`).
  ///
  /// A convenience alias for [apply] with [destroyMode], nothing more.
  TofuCmd destroy() => token('destroy');

  /// Opens an interactive prompt for trying OpenTofu expressions (`console`).
  ///
  /// Loads the current state and never modifies it. Not for a script: there is
  /// nothing here a pipeline can drive.
  TofuCmd console() => token('console');

  /// Rewrites configuration, variables and test files to the canonical style (`fmt`).
  ///
  /// Scans the current directory by default; chain [arg] with a path to scan a
  /// specific file or directory instead, and [recursive] to descend into it.
  TofuCmd fmt() => token('fmt');

  /// Releases a lock left on the state after a run that never got to unlock it (`force-unlock`).
  ///
  /// Takes the lock id as a positional argument, via [arg]. Not the same
  /// operation as [force], which only skips this command's own confirmation.
  TofuCmd forceUnlock() => token('force-unlock');

  /// Downloads and installs the modules the configuration needs (`get`).
  ///
  /// [init] already does this, so a standalone call is rarely needed outside of
  /// refreshing modules with [update].
  TofuCmd get() => token('get');

  /// Renders the dependency graph between configuration and state objects (`graph`).
  ///
  /// The output is DOT, for Graphviz or any tool that reads it.
  TofuCmd graph() => token('graph');

  /// Brings existing infrastructure under management, without creating it (`import`).
  ///
  /// Takes the resource address and the provider's own id as two positional
  /// arguments, via [arg]. Makes read-only network requests, never writes to
  /// the infrastructure itself.
  TofuCmd import() => token('import');

  /// Obtains and saves credentials for a remote host (`login`).
  ///
  /// Takes the hostname as a positional argument, via [arg].
  TofuCmd login() => token('login');

  /// Removes the locally-stored credentials for a remote host (`logout`).
  ///
  /// Only forgets the token locally; it stays valid until revoked on the
  /// server. Takes the hostname as a positional argument, via [arg].
  TofuCmd logout() => token('logout');

  /// Metadata-related subcommands, [functions] the only one today (`metadata`).
  TofuCmd metadata() => token('metadata');

  /// Prints every available function's signature and description (`functions`).
  ///
  /// The `functions` subcommand of [metadata]. Pair with [json] for a
  /// machine-readable signature list.
  TofuCmd functions() => token('functions');

  /// Prints the output values from the root module's state (`output`).
  ///
  /// Named [showOutput] because `output` collides with the base class's
  /// [CommandBuilder.output] execution method. Takes the output's name as an
  /// optional positional argument, via [arg]; with none, prints every output.
  TofuCmd showOutput() => token('output');

  /// Providers-related subcommands: [lock], [mirror] and [schema] (`providers`).
  ///
  /// Called bare, prints the tree of modules annotated with what each one
  /// requires. Takes an optional directory argument, via [arg].
  TofuCmd providers() => token('providers');

  /// Updates the dependency lock file from the origin registry (`lock`).
  ///
  /// The `lock` subcommand of [providers]. Needed when [init] alone leaves an
  /// incomplete lock file, typically because the providers came from a mirror.
  /// Takes zero or more provider source addresses, via [arg].
  TofuCmd lock() => token('lock');

  /// Populates a local directory with copies of the required provider plugins (`mirror`).
  ///
  /// The `mirror` subcommand of [providers]. Takes the target directory as a
  /// positional argument, via [arg].
  TofuCmd mirror() => token('mirror');

  /// Prints the schema of every provider the configuration uses (`schema`).
  ///
  /// The `schema` subcommand of [providers]. Always meant to be read with
  /// [json].
  TofuCmd schema() => token('schema');

  /// Updates the state to match what the remote objects actually look like (`refresh`).
  ///
  /// Never touches the infrastructure, only the recorded metadata, and that
  /// metadata can change what the next [plan] proposes.
  TofuCmd refresh() => token('refresh');

  /// Shows the current state, or a saved plan, in human-readable form (`show`).
  ///
  /// Also the `show` subcommand of [state], where it prints one resource's
  /// attributes, and of [workspace], where it prints the name of the current
  /// workspace. Which one applies follows whichever subcommand came before it
  /// in the chain.
  TofuCmd show() => token('show');

  /// Advanced state management: [list], [show], [mv], [rm], [pull], [push] and
  /// [replaceProvider] (`state`).
  TofuCmd state() => token('state');

  /// The `list` subcommand of [state] and [workspace] (`list`).
  ///
  /// Under [state], lists the resource instances the state tracks, optionally
  /// filtered by an address passed via [arg]. Under [workspace], lists every
  /// workspace.
  TofuCmd list() => token('list');

  /// Moves an item from one state address to another, possibly across state
  /// files (`mv`).
  ///
  /// The `mv` subcommand of [state]. Takes the source and destination
  /// addresses as two positional arguments, via [arg]. Always writes a backup
  /// first; there is no flag that disables it.
  TofuCmd mv() => token('mv');

  /// Removes one or more instances from the state without destroying them (`rm`).
  ///
  /// The `rm` subcommand of [state]. OpenTofu "forgets" the addresses passed
  /// via [arg]; the real infrastructure is left exactly as it was.
  TofuCmd rm() => token('rm');

  /// Pulls the current state and prints it to stdout, upgrading its format (`pull`).
  ///
  /// The `pull` subcommand of [state].
  TofuCmd pull() => token('pull');

  /// Overwrites the remote state with a local state file (`push`).
  ///
  /// The `push` subcommand of [state]. Takes the local file's path as a
  /// positional argument, via [arg]; `-` reads it from stdin instead. Refuses a
  /// lineage mismatch or an older serial unless [force] is chained.
  TofuCmd push() => token('push');

  /// Rewrites the provider recorded against resources already in the state (`replace-provider`).
  ///
  /// The `replace-provider` subcommand of [state]. Takes the source and target
  /// provider fully-qualified names as two positional arguments, via [arg].
  TofuCmd replaceProvider() => token('replace-provider');

  /// Marks a resource instance as not fully functional (`taint`).
  ///
  /// Writes nothing to the infrastructure; the next [plan] proposes to destroy
  /// and recreate the tainted instance instead. Takes the resource address as a
  /// positional argument, via [arg]. Reversed by [untaint].
  TofuCmd taint() => token('taint');

  /// Runs the `.tftest.hcl` test files against the configuration (`test`).
  ///
  /// Creates real infrastructure for the duration of the run and tears it back
  /// down. Watch the output: a cleanup that fails leaves that infrastructure
  /// behind.
  TofuCmd test() => token('test');

  /// Clears the tainted state from a resource instance (`untaint`).
  ///
  /// Writes nothing to the infrastructure; only stops the next [plan] from
  /// proposing to replace the instance. Takes the resource address as a
  /// positional argument, via [arg].
  TofuCmd untaint() => token('untaint');

  /// Prints the OpenTofu version and every installed plugin's (`version`).
  ///
  /// The subcommand; the global flag is [versionFlag].
  TofuCmd version() => token('version');

  /// Workspace management: [list], [newWorkspace], [select], [delete] and
  /// [show] (`workspace`).
  TofuCmd workspace() => token('workspace');

  /// Creates a workspace, the `new` subcommand of [workspace] (`new`).
  ///
  /// Named around the Dart keyword `new`. Takes the workspace's name as a
  /// positional argument, via [arg].
  TofuCmd newWorkspace() => token('new');

  /// Switches to a different workspace (`select`).
  ///
  /// The `select` subcommand of [workspace]. Takes the workspace's name as a
  /// positional argument, via [arg]. Chain [orCreate] to create it first if it
  /// does not exist yet.
  TofuCmd select() => token('select');

  /// Deletes a workspace, the `delete` subcommand of [workspace] (`delete`).
  ///
  /// Takes the workspace's name as a positional argument, via [arg]. Refuses a
  /// workspace still managing resources unless [force] is chained.
  TofuCmd delete() => token('delete');

  /// Sets one input variable for the root module (`-var 'name=value'`).
  ///
  /// Repeatable: chain it once per variable.
  TofuCmd variable(String assignment) => pair('-var', assignment);

  /// Loads variable values from a file, on top of any `.tfvars` OpenTofu
  /// already loads by default (`-var-file`).
  ///
  /// Repeatable, for more than one file.
  TofuCmd varFile(String path) => joined('-var-file', path);

  /// Disables interactive prompts (`-input=false`).
  ///
  /// An action that truly needs a prompt fails outright instead of hanging, so
  /// this is the flag a script always wants.
  TofuCmd noInput() => token('-input=false');

  /// Disables colored output (`-no-color`).
  TofuCmd noColor() => token('-no-color');

  /// Produces machine-readable JSON output, and disables color while at it (`-json`).
  TofuCmd json() => token('-json');

  /// Streams the same JSON [json] would print, but into a file instead of stdout
  /// (`-json-into`).
  ///
  /// Lets a caller keep the human-readable stream on the terminal while still
  /// capturing the detailed machine log.
  TofuCmd jsonInto(String path) => joined('-json-into', path);

  /// Shrinks warnings with no accompanying error down to their summary line
  /// (`-compact-warnings`).
  TofuCmd compactWarnings() => token('-compact-warnings');

  /// Stops OpenTofu from folding similar warnings together, so every location of
  /// every warning is listed (`-consolidate-warnings=false`).
  ///
  /// Warning consolidation is on by default; this is the flag that turns it
  /// back off.
  TofuCmd noConsolidateWarnings() => token('-consolidate-warnings=false');

  /// Folds similar errors into a single item (`-consolidate-errors`).
  ///
  /// Error consolidation is off by default; this is the flag that turns it on.
  TofuCmd consolidateErrors() => token('-consolidate-errors');

  /// Skips the state lock for this operation (`-lock=false`).
  ///
  /// Dangerous whenever someone else might run against the same workspace at
  /// the same time. Exists for the backends that cannot lock at all, not as a
  /// way past a lock someone else is holding.
  TofuCmd noLock() => token('-lock=false');

  /// How long to retry a state lock before giving up (`-lock-timeout`), such as
  /// `"30s"`.
  TofuCmd lockTimeout(String duration) => joined('-lock-timeout', duration);

  /// Limits the operation to this resource, module or instance and its
  /// dependencies (`-target`).
  ///
  /// Repeatable. Exceptional-use only, and cannot be combined with [exclude].
  TofuCmd target(String address) => joined('-target', address);

  /// The same as [target], but reads zero or more addresses from a file
  /// (`-target-file`).
  TofuCmd targetFile(String path) => joined('-target-file', path);

  /// Excludes this resource, module or instance, and everything that depends on
  /// it, from the operation (`-exclude`).
  ///
  /// Repeatable. Exceptional-use only, and cannot be combined with [target].
  TofuCmd exclude(String address) => joined('-exclude', address);

  /// The same as [exclude], but reads zero or more addresses from a file
  /// (`-exclude-file`).
  TofuCmd excludeFile(String path) => joined('-exclude-file', path);

  /// Forces replacement of a resource instance that would otherwise plan as an
  /// update or a no-op (`-replace`).
  ///
  /// Repeatable, for more than one instance.
  TofuCmd replace(String address) => joined('-replace', address);

  /// Plans in "refresh only" mode: checks for drift without proposing any
  /// action to correct it (`-refresh-only`).
  TofuCmd refreshOnly() => token('-refresh-only');

  /// Skips checking remote objects for drift while planning (`-refresh=false`).
  ///
  /// Faster, at the cost of planning against a record of the remote system that
  /// may already be stale.
  TofuCmd noRefresh() => token('-refresh=false');

  /// Selects "destroy" planning mode: plan to destroy everything this
  /// configuration manages (`-destroy`).
  ///
  /// The flag [destroy] is a shorthand for. Not the same as the [destroy]
  /// subcommand, which is that shorthand already applied.
  TofuCmd destroyMode() => token('-destroy');

  /// Writes the computed plan to this path, for a later [apply] to replay
  /// exactly (`-out`).
  TofuCmd out(String path) => joined('-out', path);

  /// Writes generated HCL for resources an import block would otherwise leave
  /// unconfigured (`-generate-config-out`). Experimental.
  ///
  /// The path must not already exist.
  TofuCmd generateConfigOut(String path) => joined('-generate-config-out', path);

  /// Returns exit code `2` for "changes proposed" instead of just `0` or `1`
  /// (`-detailed-exitcode`).
  ///
  /// The exit codes become `0` for no changes, `1` for a failed plan, `2` for a
  /// succeeded plan with changes. What a script polls instead of parsing the
  /// human output.
  TofuCmd detailedExitcode() => token('-detailed-exitcode');

  /// Silences the progress-related messages (`-concise`).
  TofuCmd concise() => token('-concise');

  /// Chooses which deprecation warnings to show: `all`, `local` or `none`
  /// (`-deprecation`), as `module:m`.
  TofuCmd deprecation(String value) => joined('-deprecation', value);

  /// Limits how many operations run concurrently (`-parallelism`). Defaults to
  /// 10.
  TofuCmd parallelism(int count) => joined('-parallelism', '$count');

  /// Displays sensitive values instead of redacting them (`-show-sensitive`).
  TofuCmd showSensitive() => token('-show-sensitive');

  /// Points at a state file to read, in the joined `-state=path` form.
  ///
  /// Not the [state] subcommand: this is the legacy flag several subcommands
  /// still accept for the local backend, or the path [showOutput] and
  /// [newWorkspace] read from.
  TofuCmd stateFile(String path) => joined('-state', path);

  /// Targets the latest state snapshot, the bare `-state` flag (`-state`).
  ///
  /// The `show` target-selection option, and the default target when neither it
  /// nor a [planFile] is given.
  TofuCmd stateTarget() => token('-state');

  /// Writes state to this path instead of the `-state` path (`-state-out`).
  ///
  /// Legacy, local backend only, and only ever the `apply` output side of
  /// [stateFile].
  TofuCmd stateOut(String path) => joined('-state-out', path);

  /// Backs up the existing state file to this path before modifying it
  /// (`-backup`).
  ///
  /// Pass `-` to disable the backup outright.
  TofuCmd backup(String path) => joined('-backup', path);

  /// Renders the graph, or shows the target, from this saved plan file instead
  /// of the configuration on disk (`-plan`).
  TofuCmd planFile(String path) => joined('-plan', path);

  /// Shows the current configuration instead of the state (`-config`).
  ///
  /// The `show` target-selection option; requires [json]. Not [configDir],
  /// which is a directory path for `import` rather than a bare flag.
  TofuCmd config() => token('-config');

  /// The directory of configuration files `import` uses to configure the
  /// provider (`-config`), defaulting to the working directory.
  TofuCmd configDir(String path) => joined('-config', path);

  /// Prints what would change without changing anything (`-dry-run`).
  ///
  /// The `state mv` and `state rm` rehearsal flag.
  TofuCmd dryRun() => token('-dry-run');

  /// Skips this command's own confirmation prompt (`-force`).
  ///
  /// Shared by `force-unlock`, `workspace delete` and `state push`; each reads
  /// it as "stop asking, do it."
  TofuCmd force() => token('-force');

  /// Skips interactive approval of the plan before applying it (`-auto-approve`).
  ///
  /// The safety net this removes is the one that lets a human catch a plan
  /// about to destroy the wrong resource. It belongs in a pipeline, never at an
  /// interactive terminal.
  TofuCmd autoApprove() => token('-auto-approve');

  /// Proceeds even when the local and remote OpenTofu versions look
  /// incompatible (`-ignore-remote-version`).
  ///
  /// A rare escape hatch for the remote and cloud backends. Can leave a
  /// workspace unusable; the backend documentation is the place to read before
  /// reaching for it.
  TofuCmd ignoreRemoteVersion() => token('-ignore-remote-version');

  /// Succeeds even when the addressed resource is already missing (`-allow-missing`).
  ///
  /// The `taint` and `untaint` flag for a resource that may have already been
  /// removed.
  TofuCmd allowMissing() => token('-allow-missing');

  /// Sets the directory OpenTofu searches for test files (`-test-directory`),
  /// defaulting to `tests`.
  TofuCmd testDirectory(String path) => joined('-test-directory', path);

  /// Skips validating the test files (`-no-tests`).
  ///
  /// The `validate` flag; `test` itself always validates them.
  TofuCmd noTests() => token('-no-tests');

  /// Filters `state list` to instances whose `id` attribute equals this value
  /// (`-id`).
  TofuCmd id(String value) => joined('-id', value);

  /// Creates the workspace first if `workspace select` finds it missing
  /// (`-or-create`).
  TofuCmd orCreate() => token('-or-create');

  /// Checks already-downloaded modules for updates, and installs the newest
  /// ones the constraints allow (`-update`).
  ///
  /// The `get` flag; without it, a module already on disk is left alone.
  TofuCmd update() => token('-update');

  /// Prints the plan or state of each test run block as `test` executes it
  /// (`-verbose`).
  TofuCmd verbose() => token('-verbose');

  /// Limits `test` to these test files (`-filter`), relative to the working
  /// directory.
  ///
  /// Repeatable, for more than one file.
  TofuCmd filter(String path) => joined('-filter', path);

  /// Reads checksums from this filesystem mirror instead of the origin
  /// registry (`-fs-mirror`).
  ///
  /// The `providers lock` flag for a provider available only through a mirror.
  TofuCmd fsMirror(String path) => joined('-fs-mirror', path);

  /// The same, from a network mirror given as a base URL (`-net-mirror`).
  TofuCmd netMirror(String url) => joined('-net-mirror', url);

  /// Targets a specific platform, as `os_arch` such as `linux_amd64`
  /// (`-platform`).
  ///
  /// Shared by `providers lock` and `providers mirror`. Repeatable, to cover
  /// more than one target system; without it, only the platform running the
  /// command is covered.
  TofuCmd platform(String value) => joined('-platform', value);

  /// Highlights any cycle found in the graph, to help diagnose it (`-draw-cycles`).
  TofuCmd drawCycles() => token('-draw-cycles');

  /// Chooses the kind of graph to render: `plan`, `plan-refresh-only`,
  /// `plan-destroy` or `apply` (`-type`).
  TofuCmd graphType(String value) => joined('-type', value);

  /// Limits how many levels of nested modules the graph shows (`-module-depth`).
  ///
  /// Deprecated by OpenTofu itself; kept here because `graph -help` still lists
  /// it.
  TofuCmd moduleDepth(int depth) => joined('-module-depth', '$depth');

  /// Merges this file or `key=value` pair into the configuration's `backend`
  /// block (`-backend-config`).
  ///
  /// Repeatable, for more than one file or pair. The backend type itself must
  /// still come from the configuration.
  TofuCmd backendConfig(String value) => joined('-backend-config', value);

  /// Skips backend or cloud initialization, reusing what was already
  /// initialized (`-backend=false`).
  TofuCmd noBackend() => token('-backend=false');

  /// Answers every confirmation prompt about copying state data with "yes"
  /// (`-force-copy`).
  TofuCmd forceCopy() => token('-force-copy');

  /// Copies a module's contents into the target directory before initializing
  /// it (`-from-module`).
  TofuCmd fromModule(String source) => joined('-from-module', source);

  /// Disables downloading modules during `init` (`-get=false`).
  TofuCmd noGet() => token('-get=false');

  /// Searches only this directory for plugin binaries, skipping every default
  /// path and any automatic install (`-plugin-dir`).
  ///
  /// Repeatable, for more than one directory.
  TofuCmd pluginDir(String path) => joined('-plugin-dir', path);

  /// Reconfigures the backend, ignoring any configuration OpenTofu already
  /// saved (`-reconfigure`).
  TofuCmd reconfigure() => token('-reconfigure');

  /// Reconfigures the backend and attempts to migrate the existing state into
  /// it (`-migrate-state`).
  TofuCmd migrateState() => token('-migrate-state');

  /// Installs the latest module and provider versions the constraints allow,
  /// instead of exactly what the lockfile recorded (`-upgrade`).
  TofuCmd upgrade() => token('-upgrade');

  /// Sets the dependency lockfile mode (`-lockfile`). Only `"readonly"` is
  /// valid today.
  TofuCmd lockfile(String mode) => joined('-lockfile', mode);

  /// Stops `fmt` from listing the files whose formatting differs
  /// (`-list=false`).
  ///
  /// Always disabled anyway when reading from stdin.
  TofuCmd noList() => token('-list=false');

  /// Stops `fmt` from writing the reformatted files back to disk
  /// (`-write=false`).
  ///
  /// Always disabled when reading from stdin or when [check] is chained.
  TofuCmd noWrite() => token('-write=false');

  /// Shows the formatting diff `fmt` would apply (`-diff`).
  TofuCmd diff() => token('-diff');

  /// Checks whether the input is already formatted, without writing anything
  /// (`-check`).
  ///
  /// Exits non-zero on the first file that is not, which is what makes it a CI
  /// check rather than a formatter.
  TofuCmd check() => token('-check');

  /// Also processes the files in subdirectories (`-recursive`).
  ///
  /// The `fmt` flag; by default only the given directory itself is scanned.
  TofuCmd recursive() => token('-recursive');

  /// Suppresses the error a destroy raises when it succeeds but leaves
  /// forgotten instances behind (`-suppress-forget-errors`).
  TofuCmd suppressForgetErrors() => token('-suppress-forget-errors');

  /// Reads the raw string form of an output value, when its type converts to
  /// one (`-raw`).
  ///
  /// Careful when stdout is a terminal: the value might carry control
  /// characters straight through.
  TofuCmd raw() => token('-raw');

  /// Adds a bare positional argument: an address, a name, a hostname, a path,
  /// a lock id, whatever the subcommand ahead of it expects next.
  TofuCmd arg(String value) => token(value);
}

/// `tofu`, ready to take its first option.
// ignore: non_constant_identifier_names
TofuCmd get Tofu => TofuCmd();
