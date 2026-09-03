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

/// `ansible-playbook`, which runs a YAML playbook against an inventory over
/// SSH (or `local` for the control node itself). A separate install from the
/// `ansible` package on every platform; `commandExists` first.
///
/// ```dart
/// final ShellResult result = await AnsiblePlaybook
///     .inventory('hosts.ini')
///     .limit('web')
///     .extraVars('env=prod')
///     .diff()
///     .arg('site.yml')
///     .output();
/// if (result.failed) print(result.error);
/// ```
///
/// Three habits belong on almost every scripted run. [check] plus [diff] is
/// the dry-run pass worth running before the real one: `--check` predicts what
/// would change without touching anything, and `--diff` shows the file and
/// template contents that would change alongside it. [becomePasswordFile] and
/// [vaultPasswordFile] keep `sudo` and Vault passwords out of both argv, where
/// `ps` can read them, and interactive prompts, which hang a non-interactive
/// run forever. And [forks] is the concurrency knob: the default of five hosts
/// at once is conservative for anything past a handful of machines.
class AnsiblePlaybookCmd extends CommandBuilder<AnsiblePlaybookCmd> {
  @override
  final String executable = 'ansible-playbook';

  /// Prints the usage summary (`-h`).
  AnsiblePlaybookCmd help() => token('-h');

  /// Prints the version, config file location and module search paths (`--version`).
  AnsiblePlaybookCmd version() => token('--version');

  /// Talks more about what it is doing (`-v`). Repeatable, each `v` adding detail.
  AnsiblePlaybookCmd verbose() => token('-v');

  /// The private key file to authenticate the SSH connection with (`--private-key`).
  AnsiblePlaybookCmd privateKey(String file) => pair('--private-key', file);

  /// The remote user to connect as (`-u`).
  AnsiblePlaybookCmd user(String value) => pair('-u', value);

  /// The connection plugin to use, `ssh` unless told otherwise (`-c`).
  AnsiblePlaybookCmd connection(String type) => pair('-c', type);

  /// Overrides the connection timeout, in seconds (`-T`).
  AnsiblePlaybookCmd timeout(int seconds) => pair('-T', '$seconds');

  /// Extra arguments passed to both `sftp` and `scp` (`--ssh-common-args`).
  AnsiblePlaybookCmd sshCommonArgs(String value) => pair('--ssh-common-args', value);

  /// Extra arguments passed to `sftp` only (`--sftp-extra-args`).
  AnsiblePlaybookCmd sftpExtraArgs(String value) => pair('--sftp-extra-args', value);

  /// Extra arguments passed to `scp` only (`--scp-extra-args`).
  AnsiblePlaybookCmd scpExtraArgs(String value) => pair('--scp-extra-args', value);

  /// Extra arguments passed to `ssh` only (`--ssh-extra-args`).
  AnsiblePlaybookCmd sshExtraArgs(String value) => pair('--ssh-extra-args', value);

  /// Prompts for the SSH connection password (`-k`). Interactive; hangs a script.
  AnsiblePlaybookCmd askPass() => token('-k');

  /// Reads the SSH connection password from this file instead of prompting (`--connection-password-file`).
  AnsiblePlaybookCmd connectionPasswordFile(String file) => pair('--connection-password-file', file);

  /// Runs every handler that would fire, even after a task fails (`--force-handlers`).
  ///
  /// Ordinarily a failed task skips the handlers it would have notified.
  AnsiblePlaybookCmd forceHandlers() => token('--force-handlers');

  /// Runs tasks with privilege escalation, `sudo` by default (`-b`).
  AnsiblePlaybookCmd become() => token('-b');

  /// The privilege escalation method to use, `sudo` unless told otherwise (`--become-method`).
  AnsiblePlaybookCmd becomeMethod(String value) => pair('--become-method', value);

  /// The user to escalate to, `root` unless told otherwise (`--become-user`).
  AnsiblePlaybookCmd becomeUser(String value) => pair('--become-user', value);

  /// Prompts for the privilege escalation password (`-K`). Interactive; hangs a script.
  AnsiblePlaybookCmd askBecomePass() => token('-K');

  /// Reads the privilege escalation password from this file instead of prompting (`--become-password-file`).
  ///
  /// The unattended-run alternative to [askBecomePass]; keeps the password out of argv and off a terminal prompt.
  AnsiblePlaybookCmd becomePasswordFile(String file) => pair('--become-password-file', file);

  /// Runs only the plays and tasks tagged with these values (`-t`). Comma-separated.
  AnsiblePlaybookCmd tags(String values) => pair('-t', values);

  /// Skips the plays and tasks tagged with these values (`--skip-tags`). Comma-separated.
  AnsiblePlaybookCmd skipTags(String values) => pair('--skip-tags', values);

  /// Predicts what would change without making any changes (`-C`).
  ///
  /// Not every module supports check mode; one that does not runs for real regardless.
  AnsiblePlaybookCmd check() => token('-C');

  /// Shows file and template differences when combined with [check] (`-D`).
  AnsiblePlaybookCmd diff() => token('-D');

  /// The inventory source: a path, or a comma-separated host list (`-i`). Repeatable.
  AnsiblePlaybookCmd inventory(String path) => pair('-i', path);

  /// Prints the hosts that would be targeted, without running anything (`--list-hosts`).
  AnsiblePlaybookCmd listHosts() => token('--list-hosts');

  /// Further restricts the selected hosts to this pattern (`-l`).
  AnsiblePlaybookCmd limit(String pattern) => pair('-l', pattern);

  /// Clears the cached facts for every host in the inventory (`--flush-cache`).
  AnsiblePlaybookCmd flushCache() => token('--flush-cache');

  /// Sets extra variables, `key=value`, `@file.yml`, or an inline JSON/YAML document (`-e`). Repeatable.
  AnsiblePlaybookCmd extraVars(String value) => pair('-e', value);

  /// The Vault identity to use when more than one vault password is configured (`--vault-id`).
  AnsiblePlaybookCmd vaultId(String value) => pair('--vault-id', value);

  /// Prompts for the Vault password (`-J`). Interactive; hangs a script.
  AnsiblePlaybookCmd askVaultPass() => token('-J');

  /// Reads the Vault password from this file instead of prompting (`--vault-password-file`).
  ///
  /// The unattended-run alternative to [askVaultPass].
  AnsiblePlaybookCmd vaultPasswordFile(String file) => pair('--vault-password-file', file);

  /// How many hosts to run in parallel (`-f`). Defaults to 5, conservative past a handful of machines.
  AnsiblePlaybookCmd forks(int count) => pair('-f', '$count');

  /// Prepends this path to the module search path (`-M`). Repeatable, colon-separated.
  AnsiblePlaybookCmd modulePath(String path) => pair('-M', path);

  /// Checks the playbook for syntax errors without running it (`--syntax-check`).
  AnsiblePlaybookCmd syntaxCheck() => token('--syntax-check');

  /// Lists every task that would run, without running any of them (`--list-tasks`).
  AnsiblePlaybookCmd listTasks() => token('--list-tasks');

  /// Lists every tag available in the playbook (`--list-tags`).
  AnsiblePlaybookCmd listTags() => token('--list-tags');

  /// Confirms each task before running it (`--step`). Interactive; not for a script.
  AnsiblePlaybookCmd step() => token('--step');

  /// Starts the playbook at the task matching this name, skipping everything before it (`--start-at-task`).
  AnsiblePlaybookCmd startAtTask(String name) => pair('--start-at-task', name);

  /// Adds a bare positional argument: the playbook file, or another one to run alongside it.
  AnsiblePlaybookCmd arg(String value) => token(value);
}

/// `ansible-playbook`, ready to take its first option.
// ignore: non_constant_identifier_names
AnsiblePlaybookCmd get AnsiblePlaybook => AnsiblePlaybookCmd();
