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

/// `terraform`, HashiCorp's infrastructure-as-code CLI, and the tool [Tofu] is a
/// drop-in fork of after HashiCorp's 2023 license change moved Terraform itself
/// off an OSI-approved license. The two keep the same language, the same state
/// model and almost the entire command grammar, which is why this wrapper and
/// `tofu.dart` read as siblings.
///
/// **This wrapper is a vocabulary, not a grammar.** Every subcommand `terraform
/// -help` lists is a method, and the flags shared across subcommands, `-var`,
/// `-target`, `-lock`, `-json` among them, are a single method each, reusable
/// wherever Terraform accepts them. Nothing validates that `-destroy` belongs to
/// [plan] rather than [validate]; Terraform will say so if you get it wrong.
///
/// ```dart
/// await Terraform.init().upgrade().execute();
/// final ShellResult planned = await Terraform.plan().out('tfplan').detailedExitcode().output();
/// if (planned.exitCode == 2) await Terraform.apply().autoApprove().arg('tfplan').execute();
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
class TerraformCmd extends CommandBuilder<TerraformCmd> {
  @override
  final String executable = 'terraform';

  /// Runs the subcommand as if started from this directory (`-chdir`).
  ///
  /// A global option: call it before the subcommand, never after.
  TerraformCmd chdir(String path) => joined('-chdir', path);

  /// Prints the help for Terraform, or for the subcommand already chained (`-help`).
  TerraformCmd helpFlag() => token('-help');

  /// Prints the version, the global alias for [version] (`-version`).
  TerraformCmd versionFlag() => token('-version');

  /// Prepares the working directory: backend, modules, providers (`init`).
  TerraformCmd init() => token('init');

  /// Checks the configuration for syntax and internal consistency (`validate`).
  ///
  /// Never touches remote state or provider APIs. [plan] validates too, in the
  /// context of real variables and a real workspace.
  TerraformCmd validate() => token('validate');

  /// Computes what applying the configuration would change (`plan`).
  ///
  /// Changes nothing by itself. Pair with [out] to save the plan for a later
  /// [apply], and with [detailedExitcode] to tell a script "no changes" apart
  /// from "changes proposed" apart from "failed".
  TerraformCmd plan() => token('plan');

  /// Creates or updates the infrastructure the configuration describes (`apply`).
  ///
  /// With no plan file argument it computes a plan first and asks for
  /// confirmation, unless [autoApprove] is chained. With one, it takes exactly
  /// the actions that plan recorded, no confirmation possible.
  TerraformCmd apply() => token('apply');

  /// Destroys every object this configuration manages (`destroy`).
  ///
  /// A convenience alias for [apply] with [destroyMode], nothing more.
  TerraformCmd destroy() => token('destroy');

  /// Opens an interactive prompt for trying Terraform expressions (`console`).
  ///
  /// Loads the current state and never modifies it. Not for a script: there is
  /// nothing here a pipeline can drive.
  TerraformCmd console() => token('console');

  /// Rewrites configuration and variables files to the canonical style (`fmt`).
  ///
  /// Scans the current directory by default; chain [arg] with a path to scan a
  /// specific file or directory instead, and [recursive] to descend into it.
  TerraformCmd fmt() => token('fmt');

  /// Releases a lock left on the state after a run that never got to unlock it (`force-unlock`).
  ///
  /// Takes the lock id as a positional argument, via [arg]. Not the same
  /// operation as [force], which only skips this command's own confirmation.
  TerraformCmd forceUnlock() => token('force-unlock');

  /// Downloads and installs the modules the configuration needs (`get`).
  ///
  /// [init] already does this, so a standalone call is rarely needed outside of
  /// refreshing modules with [update].
  TerraformCmd get() => token('get');

  /// Renders the dependency graph between configuration and state objects (`graph`).
  ///
  /// The output is DOT, for Graphviz or any tool that reads it.
  TerraformCmd graph() => token('graph');

  /// Brings existing infrastructure under management, without creating it (`import`).
  ///
  /// Superseded by configuration `import` blocks in current Terraform, but still
  /// present. Takes the resource address and the provider's own id as two
  /// positional arguments, via [arg].
  TerraformCmd import() => token('import');

  /// Obtains and saves credentials for a remote host (`login`).
  ///
  /// Takes the hostname as a positional argument, via [arg].
  TerraformCmd login() => token('login');

  /// Removes the locally-stored credentials for a remote host (`logout`).
  ///
  /// Only forgets the token locally; it stays valid until revoked on the
  /// server. Takes the hostname as a positional argument, via [arg].
  TerraformCmd logout() => token('logout');

  /// Metadata-related subcommands, [functions] the only one today (`metadata`).
  TerraformCmd metadata() => token('metadata');

  /// Prints every available function's signature and description (`functions`).
  ///
  /// The `functions` subcommand of [metadata]. Pair with [json] for a
  /// machine-readable signature list.
  TerraformCmd functions() => token('functions');

  /// Prints the output values from the root module's state (`output`).
  ///
  /// Named [showOutput] because `output` collides with the base class's
  /// [CommandBuilder.output] execution method. Takes the output's name as an
  /// optional positional argument, via [arg]; with none, prints every output.
  TerraformCmd showOutput() => token('output');

  /// Providers-related subcommands: [lock], [mirror] and [schema] (`providers`).
  ///
  /// Called bare, prints the tree of modules annotated with what each one
  /// requires. Takes an optional directory argument, via [arg].
  TerraformCmd providers() => token('providers');

  /// Updates the dependency lock file from the origin registry (`lock`).
  ///
  /// The `lock` subcommand of [providers]. Needed when [init] alone leaves an
  /// incomplete lock file, typically because the providers came from a mirror.
  /// Takes zero or more provider source addresses, via [arg].
  TerraformCmd lock() => token('lock');

  /// Populates a local directory with copies of the required provider plugins (`mirror`).
  ///
  /// The `mirror` subcommand of [providers]. Takes the target directory as a
  /// positional argument, via [arg].
  TerraformCmd mirror() => token('mirror');

  /// Prints the schema of every provider the configuration uses (`schema`).
  ///
  /// The `schema` subcommand of [providers]. Always meant to be read with
  /// [json].
  TerraformCmd schema() => token('schema');

  /// Updates the state to match what the remote objects actually look like (`refresh`).
  ///
  /// Never touches the infrastructure, only the recorded metadata, and that
  /// metadata can change what the next [plan] proposes.
  TerraformCmd refresh() => token('refresh');

  /// Shows the current state, or a saved plan, in human-readable form (`show`).
  ///
  /// Also the `show` subcommand of [state], where it prints one resource's
  /// attributes, and of [workspace], where it prints the name of the current
  /// workspace. Which one applies follows whichever subcommand came before it
  /// in the chain.
  TerraformCmd show() => token('show');

  /// Advanced state management: [list], [show], [mv], [rm], [pull], [push] and
  /// [replaceProvider] (`state`).
  TerraformCmd state() => token('state');

  /// The `list` subcommand of [state] and [workspace] (`list`).
  ///
  /// Under [state], lists the resource instances the state tracks, optionally
  /// filtered by an address passed via [arg]. Under [workspace], lists every
  /// workspace.
  TerraformCmd list() => token('list');

  /// Moves an item from one state address to another, possibly across state
  /// files (`mv`).
  ///
  /// The `mv` subcommand of [state]. Takes the source and destination
  /// addresses as two positional arguments, via [arg]. Always writes a backup
  /// first; there is no flag that disables it.
  TerraformCmd mv() => token('mv');

  /// Removes one or more instances from the state without destroying them (`rm`).
  ///
  /// The `rm` subcommand of [state]. Terraform "forgets" the addresses passed
  /// via [arg]; the real infrastructure is left exactly as it was.
  TerraformCmd rm() => token('rm');

  /// Pulls the current state and prints it to stdout, upgrading its format (`pull`).
  ///
  /// The `pull` subcommand of [state].
  TerraformCmd pull() => token('pull');

  /// Overwrites the remote state with a local state file (`push`).
  ///
  /// The `push` subcommand of [state]. Takes the local file's path as a
  /// positional argument, via [arg]; `-` reads it from stdin instead. Refuses a
  /// lineage mismatch or an older serial unless [force] is chained.
  TerraformCmd push() => token('push');

  /// Rewrites the provider recorded against resources already in the state (`replace-provider`).
  ///
  /// The `replace-provider` subcommand of [state]. Takes the source and target
  /// provider fully-qualified names as two positional arguments, via [arg].
  TerraformCmd replaceProvider() => token('replace-provider');

  /// Marks a resource instance as not fully functional (`taint`).
  ///
  /// Writes nothing to the infrastructure; the next [plan] proposes to destroy
  /// and recreate the tainted instance instead. Takes the resource address as a
  /// positional argument, via [arg]. Reversed by [untaint]. Superseded in
  /// current Terraform by [replace] on `plan`/`apply`, but still present.
  TerraformCmd taint() => token('taint');

  /// Runs the `.tftest.hcl` test files against the configuration (`test`).
  ///
  /// Creates real infrastructure for the duration of the run and tears it back
  /// down. Watch the output: a cleanup that fails leaves that infrastructure
  /// behind.
  TerraformCmd test() => token('test');

  /// Clears the tainted state from a resource instance (`untaint`).
  ///
  /// Writes nothing to the infrastructure; only stops the next [plan] from
  /// proposing to replace the instance. Takes the resource address as a
  /// positional argument, via [arg].
  TerraformCmd untaint() => token('untaint');

  /// Prints the Terraform version and every installed plugin's (`version`).
  ///
  /// The subcommand; the global flag is [versionFlag].
  TerraformCmd version() => token('version');

  /// Workspace management: [list], [newWorkspace], [select], [delete] and
  /// [show] (`workspace`).
  TerraformCmd workspace() => token('workspace');

  /// Creates a workspace, the `new` subcommand of [workspace] (`new`).
  ///
  /// Named around the Dart keyword `new`. Takes the workspace's name as a
  /// positional argument, via [arg].
  TerraformCmd newWorkspace() => token('new');

  /// Switches to a different workspace (`select`).
  ///
  /// The `select` subcommand of [workspace]. Takes the workspace's name as a
  /// positional argument, via [arg]. Chain [orCreate] to create it first if it
  /// does not exist yet.
  TerraformCmd select() => token('select');

  /// Deletes a workspace, the `delete` subcommand of [workspace] (`delete`).
  ///
  /// Takes the workspace's name as a positional argument, via [arg]. Refuses a
  /// workspace still managing resources unless [force] is chained.
  TerraformCmd delete() => token('delete');

  /// Sets one input variable for the root module (`-var 'name=value'`).
  ///
  /// Repeatable: chain it once per variable.
  TerraformCmd variable(String assignment) => pair('-var', assignment);

  /// Loads variable values from a file, on top of any `.tfvars` Terraform
  /// already loads by default (`-var-file`).
  ///
  /// Repeatable, for more than one file.
  TerraformCmd varFile(String path) => joined('-var-file', path);

  /// Disables interactive prompts (`-input=false`).
  ///
  /// An action that truly needs a prompt fails outright instead of hanging, so
  /// this is the flag a script always wants.
  TerraformCmd noInput() => token('-input=false');

  /// Disables colored output (`-no-color`).
  TerraformCmd noColor() => token('-no-color');

  /// Produces machine-readable JSON output, and disables color while at it (`-json`).
  TerraformCmd json() => token('-json');

  /// Shrinks warnings with no accompanying error down to their summary line
  /// (`-compact-warnings`).
  TerraformCmd compactWarnings() => token('-compact-warnings');

  /// Skips the state lock for this operation (`-lock=false`).
  ///
  /// Dangerous whenever someone else might run against the same workspace at
  /// the same time. Exists for the backends that cannot lock at all, not as a
  /// way past a lock someone else is holding.
  TerraformCmd noLock() => token('-lock=false');

  /// How long to retry a state lock before giving up (`-lock-timeout`), such as
  /// `"30s"`.
  TerraformCmd lockTimeout(String duration) => joined('-lock-timeout', duration);

  /// Limits the operation to this resource, module or instance and its
  /// dependencies (`-target`).
  ///
  /// Repeatable. Exceptional-use only.
  TerraformCmd target(String address) => joined('-target', address);

  /// Forces replacement of a resource instance that would otherwise plan as an
  /// update or a no-op (`-replace`).
  ///
  /// Repeatable, for more than one instance. The current replacement for
  /// [taint] on `plan` and `apply`.
  TerraformCmd replace(String address) => joined('-replace', address);

  /// Plans in "refresh only" mode: checks for drift without proposing any
  /// action to correct it (`-refresh-only`).
  TerraformCmd refreshOnly() => token('-refresh-only');

  /// Skips checking remote objects for drift while planning (`-refresh=false`).
  ///
  /// Faster, at the cost of planning against a record of the remote system that
  /// may already be stale.
  TerraformCmd noRefresh() => token('-refresh=false');

  /// Selects "destroy" planning mode: plan to destroy everything this
  /// configuration manages (`-destroy`).
  ///
  /// The flag [destroy] is a shorthand for. Not the same as the [destroy]
  /// subcommand, which is that shorthand already applied.
  TerraformCmd destroyMode() => token('-destroy');

  /// Writes the computed plan to this path, for a later [apply] to replay
  /// exactly (`-out`).
  TerraformCmd out(String path) => joined('-out', path);

  /// Writes generated HCL for resources an import block would otherwise leave
  /// unconfigured (`-generate-config-out`). Experimental.
  ///
  /// The path must not already exist.
  TerraformCmd generateConfigOut(String path) => joined('-generate-config-out', path);

  /// Returns exit code `2` for "changes proposed" instead of just `0` or `1`
  /// (`-detailed-exitcode`).
  ///
  /// The exit codes become `0` for no changes, `1` for a failed plan, `2` for a
  /// succeeded plan with changes. What a script polls instead of parsing the
  /// human output.
  TerraformCmd detailedExitcode() => token('-detailed-exitcode');

  /// Limits how many operations run concurrently (`-parallelism`). Defaults to
  /// 10.
  TerraformCmd parallelism(int count) => joined('-parallelism', '$count');

  /// Points at a state file to read, in the joined `-state=path` form (`-state`).
  ///
  /// A legacy option for the local backend only.
  TerraformCmd stateFile(String path) => joined('-state', path);

  /// Writes state to this path instead of the `-state` path (`-state-out`).
  ///
  /// Legacy, local backend only, and only ever the `apply` output side of
  /// [stateFile].
  TerraformCmd stateOut(String path) => joined('-state-out', path);

  /// Backs up the existing state file to this path before modifying it
  /// (`-backup`).
  ///
  /// Pass `-` to disable the backup outright. Defaults to the [stateOut] path
  /// with a `.backup` extension.
  TerraformCmd backup(String path) => joined('-backup', path);

  /// Skips this command's own confirmation prompt (`-force`).
  ///
  /// Shared by `force-unlock`, `workspace delete` and `state push`; each reads
  /// it as "stop asking, do it."
  TerraformCmd force() => token('-force');

  /// Skips interactive approval of the plan before applying it (`-auto-approve`).
  ///
  /// The safety net this removes is the one that lets a human catch a plan
  /// about to destroy the wrong resource. It belongs in a pipeline, never at an
  /// interactive terminal.
  TerraformCmd autoApprove() => token('-auto-approve');

  /// Creates the workspace first if `workspace select` finds it missing
  /// (`-or-create`).
  TerraformCmd orCreate() => token('-or-create');

  /// Checks already-downloaded modules for updates, and installs the newest
  /// ones the constraints allow (`-update`).
  ///
  /// The `get` flag; without it, a module already on disk is left alone.
  TerraformCmd update() => token('-update');

  /// Merges this file or `key=value` pair into the configuration's `backend`
  /// block (`-backend-config`).
  ///
  /// Repeatable, for more than one file or pair. The backend type itself must
  /// still come from the configuration.
  TerraformCmd backendConfig(String value) => joined('-backend-config', value);

  /// Disables backend or Terraform Cloud initialization for this configuration,
  /// reusing what was previously initialized (`-backend=false`).
  TerraformCmd noBackend() => token('-backend=false');

  /// Answers every confirmation prompt about copying state data with "yes"
  /// (`-force-copy`).
  TerraformCmd forceCopy() => token('-force-copy');

  /// Copies a module's contents into the target directory before initializing
  /// it (`-from-module`).
  TerraformCmd fromModule(String source) => joined('-from-module', source);

  /// Disables downloading modules during `init` (`-get=false`).
  TerraformCmd noGet() => token('-get=false');

  /// Searches only this directory for plugin binaries, skipping every default
  /// path and any automatic install (`-plugin-dir`).
  ///
  /// Repeatable, for more than one directory.
  TerraformCmd pluginDir(String path) => joined('-plugin-dir', path);

  /// Reconfigures the backend, ignoring any configuration Terraform already
  /// saved (`-reconfigure`).
  TerraformCmd reconfigure() => token('-reconfigure');

  /// Reconfigures the backend and attempts to migrate the existing state into
  /// it (`-migrate-state`).
  TerraformCmd migrateState() => token('-migrate-state');

  /// Installs the latest module and provider versions the constraints allow,
  /// instead of exactly what the lockfile recorded (`-upgrade`).
  TerraformCmd upgrade() => token('-upgrade');

  /// Stops `fmt` from listing the files whose formatting differs
  /// (`-list=false`).
  ///
  /// Always disabled anyway when reading from stdin.
  TerraformCmd noList() => token('-list=false');

  /// Stops `fmt` from writing the reformatted files back to disk
  /// (`-write=false`).
  ///
  /// Always disabled when reading from stdin or when [check] is chained.
  TerraformCmd noWrite() => token('-write=false');

  /// Shows the formatting diff `fmt` would apply (`-diff`).
  TerraformCmd diff() => token('-diff');

  /// Checks whether the input is already formatted, without writing anything
  /// (`-check`).
  ///
  /// Exits non-zero on the first file that is not, which is what makes it a CI
  /// check rather than a formatter.
  TerraformCmd check() => token('-check');

  /// Also processes the files in subdirectories (`-recursive`).
  ///
  /// The `fmt` flag; by default only the given directory itself is scanned.
  TerraformCmd recursive() => token('-recursive');

  /// Adds a bare positional argument: an address, a name, a hostname, a path,
  /// a lock id, whatever the subcommand ahead of it expects next.
  TerraformCmd arg(String value) => token(value);
}

/// `terraform`, ready to take its first option.
// ignore: non_constant_identifier_names
TerraformCmd get Terraform => TerraformCmd();
