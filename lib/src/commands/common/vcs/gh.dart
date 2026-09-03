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

/// `gh`, the GitHub CLI: pull requests, issues, releases, Actions and the raw
/// API, all authenticated against whatever `gh auth login` last set up.
///
/// **This wrapper is a vocabulary, not a grammar.** Every subcommand `gh help`
/// lists is a method, and a word that means the same flag or subcommand across
/// several of them, `list`, `view`, `delete`, `--json`, `--web`, is a single
/// method reused wherever `gh` accepts it. Nothing validates that `download`
/// goes with `release` rather than `run`; `gh` will say so if you get it wrong.
///
/// ```dart
/// await Gh.pr().create().title('Fix the flaky test').body('See #42').web().execute();
/// final ShellResult runs = await Gh.run().list().statusFilter('failure').jsonFields('databaseId,name').output();
/// ```
///
/// Most commands need `gh auth login` first, or `GH_TOKEN`/`GITHUB_TOKEN` in
/// the environment; a call against a private repository without either fails
/// with an authentication error rather than a missing-repository one. Anything
/// that lists or searches supports [jsonFields] for machine-readable output,
/// narrowed further by [jq]. Actions API calls are rate limited by GitHub
/// itself; a burst of [run] or [workflow] calls can hit it well before the
/// general REST limit does.
///
/// Watch the names where a subcommand and a flag share a word: the top-level
/// `repo` command is [repoCommand] because [repo] is the `-R`/`--repo` flag;
/// `label` the command is [labelCommand] because [label] is the `--label`
/// flag; `auth token` is [tokenCommand] because [token] is the base class's
/// own runner. [checkoutFlag], [watchFlag], [statusFilter], [templateRepository]
/// and a few others exist for the same reason, next to a bare-word method that
/// already owns the shorter name.
class GhCmd extends CommandBuilder<GhCmd> {
  @override
  final String executable = 'gh';

  /// Targets a repository other than the one in the current directory (`-R, --repo`).
  GhCmd repo(String value) => pair('-R', value);

  /// Targets a GitHub Enterprise host instead of `github.com` (`--hostname`).
  GhCmd hostname(String value) => pair('--hostname', value);

  /// Prints the help for whatever precedes it (`--help`).
  GhCmd helpFlag() => token('--help');

  /// Prints the installed `gh` version (`--version`).
  GhCmd versionFlag() => token('--version');

  /// Works with repositories (`repo`). The flag with the same word is [repo].
  GhCmd repoCommand() => token('repo');

  /// Works with pull requests (`pr`).
  GhCmd pr() => token('pr');

  /// Works with issues (`issue`).
  GhCmd issue() => token('issue');

  /// Works with releases (`release`).
  GhCmd release() => token('release');

  /// Works with GitHub Actions workflows (`workflow`).
  GhCmd workflow() => token('workflow');

  /// Works with GitHub Actions workflow runs (`run`). Also the `workflow run` subcommand.
  GhCmd run() => token('run');

  /// Works with gists (`gist`).
  GhCmd gist() => token('gist');

  /// Authenticates `gh` and `git` with GitHub (`auth`).
  GhCmd auth() => token('auth');

  /// Makes an authenticated raw request to the GitHub API (`api`).
  ///
  /// Add the endpoint with [arg]: `Gh.api().arg('repos/{owner}/{repo}/releases')`.
  /// `{owner}`, `{repo}` and `{branch}` in the endpoint expand from the current directory's repository.
  GhCmd api() => token('api');

  /// Opens something in the browser (`browse`). Also the `extension browse` subcommand.
  GhCmd browse() => token('browse');

  /// Prints a summary of assigned issues, review requests and mentions (`status`).
  ///
  /// Also `pr status` and `issue status`, which print the same kind of summary scoped to one repository.
  GhCmd status() => token('status');

  /// Searches across all of GitHub (`search`). Also the `extension search` subcommand.
  GhCmd search() => token('search');

  /// Works with labels (`label`). The flag with the same word is [label].
  GhCmd labelCommand() => token('label');

  /// Works with Actions secrets (`secret`).
  GhCmd secret() => token('secret');

  /// Works with Actions variables (`variable`).
  GhCmd variable() => token('variable');

  /// Works with Actions caches (`cache`).
  GhCmd cache() => token('cache');

  /// Views repository or organization rulesets (`ruleset`).
  GhCmd ruleset() => token('ruleset');

  /// Connects to and manages codespaces (`codespace`).
  GhCmd codespace() => token('codespace');

  /// Manages installed `gh` extensions (`extension`).
  GhCmd extension() => token('extension');

  /// Manages command shortcuts (`alias`).
  GhCmd alias() => token('alias');

  /// Reads or writes `gh`'s own configuration (`config`).
  GhCmd config() => token('config');

  /// Prints a shell completion script (`completion`).
  GhCmd completion() => token('completion');

  /// Creates the thing the parent command manages (`create`).
  GhCmd create() => token('create');

  /// Lists the things the parent command manages (`list`).
  GhCmd list() => token('list');

  /// Shows one thing in detail (`view`).
  GhCmd view() => token('view');

  /// Edits an existing thing (`edit`).
  GhCmd edit() => token('edit');

  /// Deletes a thing (`delete`).
  GhCmd delete() => token('delete');

  /// Closes a pull request or issue (`close`).
  GhCmd close() => token('close');

  /// Reopens a closed pull request or issue (`reopen`).
  GhCmd reopen() => token('reopen');

  /// Adds a comment (`comment`). The boolean review flag with the same word is [commentAction].
  GhCmd comment() => token('comment');

  /// Locks the conversation on a pull request or issue (`lock`).
  GhCmd lock() => token('lock');

  /// Unlocks it (`unlock`).
  GhCmd unlock() => token('unlock');

  /// Creates or updates a secret, variable or alias (`set`).
  GhCmd set() => token('set');

  /// Reads one variable or one config key (`get`).
  GhCmd get() => token('get');

  /// Downloads a release asset, a run artifact or a codespace's file (`download`).
  GhCmd download() => token('download');

  /// Clones a repository, a gist or a set of labels locally (`clone`).
  GhCmd clone() => token('clone');

  /// Renames a repository, a gist file or a label (`rename`).
  GhCmd rename() => token('rename');

  /// Installs a `gh` extension (`install`).
  GhCmd install() => token('install');

  /// Removes an installed extension (`remove`).
  GhCmd remove() => token('remove');

  /// Upgrades installed extensions (`upgrade`).
  GhCmd upgrade() => token('upgrade');

  /// Runs an installed extension whose name collides with a core command (`exec`).
  GhCmd exec() => token('exec');

  /// Imports aliases from a YAML file (`import`).
  GhCmd importAliases() => token('import');

  /// Clears the `gh` CLI's own HTTP cache (`clear-cache`).
  GhCmd clearCache() => token('clear-cache');

  /// Enables a workflow so it can run and shows up in listings (`enable`).
  GhCmd enable() => token('enable');

  /// Disables a workflow (`disable`).
  GhCmd disable() => token('disable');

  /// Watches a run until it completes (`watch`). The `pr checks` flag with the same word is [watchFlag].
  GhCmd watch() => token('watch');

  /// Reruns an entire run, its failed jobs, or one job (`rerun`).
  GhCmd rerun() => token('rerun');

  /// Cancels a running workflow run (`cancel`).
  GhCmd cancel() => token('cancel');

  /// Pins an issue to the repository (`pin`).
  GhCmd pin() => token('pin');

  /// Unpins it (`unpin`).
  GhCmd unpin() => token('unpin');

  /// Transfers an issue to another repository (`transfer`).
  GhCmd transfer() => token('transfer');

  /// Manages the linked branches of an issue (`develop`).
  GhCmd develop() => token('develop');

  /// SSHes into a codespace (`ssh`).
  GhCmd ssh() => token('ssh');

  /// Opens a codespace in Visual Studio Code, or searches code (`code`).
  GhCmd code() => token('code');

  /// Stops a running codespace (`stop`).
  GhCmd stop() => token('stop');

  /// Reads codespace logs (`logs`).
  GhCmd logs() => token('logs');

  /// Lists the ports forwarded from a codespace (`ports`).
  GhCmd ports() => token('ports');

  /// Rebuilds a codespace's container (`rebuild`).
  GhCmd rebuild() => token('rebuild');

  /// Copies files between the local machine and a codespace (`cp`).
  GhCmd cp() => token('cp');

  /// Opens a codespace in JupyterLab (`jupyter`).
  GhCmd jupyter() => token('jupyter');

  /// Logs in to a GitHub host (`login`).
  GhCmd login() => token('login');

  /// Logs out of one (`logout`).
  GhCmd logout() => token('logout');

  /// Expands or fixes the scopes of the stored credentials (`refresh`).
  GhCmd refresh() => token('refresh');

  /// Prints the stored authentication token (`token`). Named around the base class's own [CommandBuilder.token].
  GhCmd tokenCommand() => token('token');

  /// Configures git to use `gh` as its credential helper (`setup-git`).
  GhCmd setupGit() => token('setup-git');

  /// Switches the active account for a host (`switch`). Named around the Dart keyword.
  GhCmd switchAccount() => token('switch');

  /// Fast-forwards or hard-resets a repository from its parent (`sync`).
  GhCmd sync() => token('sync');

  /// Forks a repository (`fork`).
  GhCmd fork() => token('fork');

  /// Archives a repository (`archive`).
  GhCmd archive() => token('archive');

  /// Sets or shows the default repository for the current directory (`set-default`).
  GhCmd setDefault() => token('set-default');

  /// Manages a repository's deploy keys (`deploy-key`).
  GhCmd deployKey() => token('deploy-key');

  /// Manages a repository's autolink references (`autolink`).
  GhCmd autolink() => token('autolink');

  /// Checks out a pull request's branch locally (`checkout`).
  GhCmd checkout() => token('checkout');

  /// Views the diff of a pull request (`diff`).
  GhCmd diff() => token('diff');

  /// Adds a review to a pull request (`review`).
  GhCmd review() => token('review');

  /// Marks a draft pull request as ready for review (`ready`).
  GhCmd ready() => token('ready');

  /// Shows the CI status of a pull request (`checks`).
  GhCmd checks() => token('checks');

  /// Reverts a merged pull request (`revert`).
  GhCmd revert() => token('revert');

  /// Updates a pull request's branch from its base (`update-branch`).
  GhCmd updateBranch() => token('update-branch');

  /// Merges a pull request (`merge`). The merge-strategy flag with the same word is [mergeStrategy].
  GhCmd merge() => token('merge');

  /// Uploads assets to a release (`upload`).
  GhCmd upload() => token('upload');

  /// Deletes one asset from a release (`delete-asset`).
  GhCmd deleteAsset() => token('delete-asset');

  /// Verifies the attestation for a release (`verify`).
  GhCmd verify() => token('verify');

  /// Verifies that an asset came from a given release (`verify-asset`).
  GhCmd verifyAsset() => token('verify-asset');

  /// Shows the rules that apply to a branch (`ruleset check`).
  GhCmd check() => token('check');

  /// Searches for repositories (`search repos`).
  GhCmd repos() => token('repos');

  /// Searches for issues (`search issues`).
  GhCmd issues() => token('issues');

  /// Searches for pull requests (`search prs`).
  GhCmd prs() => token('prs');

  /// Searches for commits (`search commits`).
  GhCmd commits() => token('commits');

  /// Adds a deploy key or an autolink to a repository (`add`).
  GhCmd add() => token('add');

  /// Requests machine-readable output for these fields (`--json`).
  ///
  /// Pass a comma-separated list, matching the `JSON FIELDS` section of the
  /// command's own `--help`. Narrow it further with [jq].
  GhCmd jsonFields(String fields) => pair('--json', fields);

  /// Filters the JSON output with a `jq` expression (`--jq`).
  GhCmd jq(String expression) => pair('--jq', expression);

  /// Formats output with a Go template, a template file, or names a template repository, depending on the command (`--template`).
  GhCmd template(String value) => pair('--template', value);

  /// Opens the browser instead of printing to the terminal (`--web`).
  GhCmd web() => token('--web');

  /// Caps how many items are fetched (`--limit`).
  GhCmd limit(int count) => pair('--limit', '$count');

  /// Filters by state, `open`, `closed`, `merged` or `all` depending on the command (`--state`).
  GhCmd state(String value) => pair('--state', value);

  /// Runs a raw search query alongside the other filters (`--search`).
  GhCmd searchQuery(String query) => pair('--search', query);

  /// Marks something as a draft, or filters to drafts only (`--draft`).
  GhCmd draft() => token('--draft');

  /// Includes everything rather than a filtered subset (`--all`).
  GhCmd all() => token('--all');

  /// Overrides the check that would otherwise stop the command (`--force`).
  GhCmd force() => token('--force');

  /// Skips the confirmation prompt (`--yes`).
  GhCmd yes() => token('--yes');

  /// Overwrites an existing asset or alias of the same name (`--clobber`).
  GhCmd clobber() => token('--clobber');

  /// Restricts to names matching a glob pattern (`--pattern`). Repeatable.
  GhCmd pattern(String glob) => pair('--pattern', glob);

  /// Writes a single downloaded asset to this file, `-` for standard output (`--output`).
  ///
  /// Named around the base class's own [CommandBuilder.output].
  GhCmd outputFile(String path) => pair('--output', path);

  /// Prints more detail: job steps, or the full HTTP exchange, depending on the command (`--verbose`).
  GhCmd verbose() => token('--verbose');

  /// Fetches every page of results rather than the first (`--paginate`).
  GhCmd paginate() => token('--paginate');

  /// Suppresses the response body, keeping only the exit code (`--silent`).
  GhCmd silent() => token('--silent');

  /// Adds a raw HTTP request header, `key:value` (`--header`).
  GhCmd header(String value) => pair('--header', value);

  /// Includes the HTTP status line and headers in the output (`--include`).
  GhCmd includeResponse() => token('--include');

  /// Sets the HTTP method for a raw API request (`--method`).
  GhCmd method(String value) => pair('--method', value);

  /// Adds a typed request parameter, `key=value`, with `@file` and placeholder expansion (`--field`).
  GhCmd field(String value) => pair('--field', value);

  /// Adds a plain string request parameter, `key=value` (`--raw-field`).
  GhCmd rawField(String value) => pair('--raw-field', value);

  /// Caches the response for a duration such as `"3600s"` or `"1h"` (`--cache`).
  GhCmd cacheFor(String duration) => pair('--cache', duration);

  /// Opts into a named, feature-flagged API preview (`--preview`).
  GhCmd preview(String name) => pair('--preview', name);

  /// Wraps every paginated page into one outer JSON array (`--slurp`).
  GhCmd slurp() => token('--slurp');

  /// Prints terminal escape sequences verbatim instead of neutralising them (`--allow-escape-sequences`).
  GhCmd allowEscapeSequences() => token('--allow-escape-sequences');

  /// Reads the request body from this file, `-` for standard input (`--input`).
  GhCmd inputFile(String path) => pair('--input', path);

  /// Scopes the command to an organization (`--org`).
  GhCmd org(String value) => pair('--org', value);

  /// Filters or targets by user login (`--user`).
  ///
  /// A boolean toggle in some commands instead; see [userScope].
  GhCmd user(String value) => pair('--user', value);

  /// Leaves out entries matching this value, a repository or a glob pattern depending on the command (`--exclude`).
  GhCmd exclude(String value) => pair('--exclude', value);

  /// Sorts fetched results by this field (`--sort`).
  GhCmd sort(String value) => pair('--sort', value);

  /// Sets or filters by visibility, `public`, `private` or `internal` (`--visibility`).
  GhCmd visibility(String value) => pair('--visibility', value);

  /// Names a source path or a source repository, depending on the command (`--source`).
  ///
  /// A boolean "non-forks only" filter in `repo list` instead; see [sourceOnly].
  GhCmd source(String path) => pair('--source', path);

  /// Orders fetched results, `asc` or `desc` (`--order`).
  GhCmd order(String value) => pair('--order', value);

  /// Sets a description (`--description`).
  GhCmd description(String value) => pair('--description', value);

  /// Sets a label's colour, a six-character hex value (`--color`). Also the diff colour mode on `pr diff`.
  GhCmd color(String value) => pair('--color', value);

  /// Includes the comments when viewing a pull request (`--comments`).
  GhCmd comments() => token('--comments');

  /// Reports what would happen without doing it (`--dry-run`).
  GhCmd dryRun() => token('--dry-run');

  /// Sets the title (`--title`).
  GhCmd title(String value) => pair('--title', value);

  /// Sets the body text (`--body`).
  GhCmd body(String value) => pair('--body', value);

  /// Reads the body text from a file, `-` for standard input (`--body-file`).
  GhCmd bodyFile(String path) => pair('--body-file', path);

  /// Assigns by login, `@me` to self-assign, `@copilot` for Copilot (`--assignee`).
  GhCmd assignee(String login) => pair('--assignee', login);

  /// Sets or filters the base branch (`--base`).
  GhCmd base(String branch) => pair('--base', branch);

  /// Sets or filters the head branch (`--head`).
  GhCmd head(String branch) => pair('--head', branch);

  /// Adds or filters by label name (`--label`). Repeatable.
  GhCmd label(String name) => pair('--label', name);

  /// Adds to or filters by milestone (`--milestone`).
  GhCmd milestone(String name) => pair('--milestone', name);

  /// Requests a review from a person or team (`--reviewer`).
  GhCmd reviewer(String handle) => pair('--reviewer', handle);

  /// Fills the title and body from the commits (`--fill`).
  GhCmd fill() => token('--fill');

  /// Fills them from the first commit only (`--fill-first`).
  GhCmd fillFirst() => token('--fill-first');

  /// Fills the body from every commit's message and body (`--fill-verbose`).
  GhCmd fillVerbose() => token('--fill-verbose');

  /// Opens the text editor to write the title and body, or the comment body (`--editor`).
  GhCmd editor() => token('--editor');

  /// Disallows maintainers from pushing to the pull request's branch (`--no-maintainer-edit`).
  GhCmd noMaintainerEdit() => token('--no-maintainer-edit');

  /// Adds to or removes from a project by title (`--project`).
  GhCmd project(String title) => pair('--project', title);

  /// Recovers the input from a previous failed `create` (`--recover`).
  GhCmd recover(String value) => pair('--recover', value);

  /// Filters by author login (`--author`).
  GhCmd author(String value) => pair('--author', value);

  /// Filters by GitHub App author, or selects a secret/variable application (`--app`).
  GhCmd app(String value) => pair('--app', value);

  /// Filters issues that mention this user (`--mention`).
  GhCmd mention(String value) => pair('--mention', value);

  /// Displays the merge conflict status of each pull request (`--conflict-status`).
  GhCmd conflictStatus() => token('--conflict-status');

  /// Adds an assignee to an existing pull request or issue (`--add-assignee`).
  GhCmd addAssignee(String login) => pair('--add-assignee', login);

  /// Removes one (`--remove-assignee`).
  GhCmd removeAssignee(String login) => pair('--remove-assignee', login);

  /// Adds a label to an existing pull request or issue (`--add-label`).
  GhCmd addLabel(String name) => pair('--add-label', name);

  /// Removes one (`--remove-label`).
  GhCmd removeLabel(String name) => pair('--remove-label', name);

  /// Adds or re-requests a reviewer (`--add-reviewer`).
  GhCmd addReviewer(String login) => pair('--add-reviewer', login);

  /// Removes a review request (`--remove-reviewer`).
  GhCmd removeReviewer(String login) => pair('--remove-reviewer', login);

  /// Adds an existing pull request or issue to a project (`--add-project`).
  GhCmd addProject(String title) => pair('--add-project', title);

  /// Removes it from one (`--remove-project`).
  GhCmd removeProject(String title) => pair('--remove-project', title);

  /// Clears the milestone association (`--remove-milestone`).
  GhCmd removeMilestone() => token('--remove-milestone');

  /// Merges with administrator privileges, bypassing a merge queue (`--admin`).
  GhCmd adminFlag() => token('--admin');

  /// Sets the merge commit author's email (`--author-email`).
  GhCmd authorEmail(String value) => pair('--author-email', value);

  /// Merges automatically once requirements are met (`--auto`).
  GhCmd auto() => token('--auto');

  /// Disables auto-merge for the pull request (`--disable-auto`).
  GhCmd disableAuto() => token('--disable-auto');

  /// Deletes the local and remote branch once the pull request is merged or closed (`--delete-branch`).
  GhCmd deleteBranch() => token('--delete-branch');

  /// Refuses to merge unless the head is exactly this commit (`--match-head-commit`).
  GhCmd matchHeadCommit(String sha) => pair('--match-head-commit', sha);

  /// Merges with a merge commit (`--merge`). The subcommand with the same word is [merge].
  GhCmd mergeStrategy() => token('--merge');

  /// Rebases the commits onto the base branch instead (`--rebase`).
  GhCmd rebaseStrategy() => token('--rebase');

  /// Squashes the commits into one (`--squash`).
  GhCmd squash() => token('--squash');

  /// Sets the merge commit's subject line (`--subject`).
  GhCmd subject(String value) => pair('--subject', value);

  /// Names the local branch a checkout should create, or filters runs by branch (`--branch`).
  GhCmd branch(String value) => pair('--branch', value);

  /// Checks out with a detached `HEAD` (`--detach`).
  GhCmd detach() => token('--detach');

  /// Updates submodules after checking out (`--recurse-submodules`).
  GhCmd recurseSubmodules() => token('--recurse-submodules');

  /// Prints only the names of the changed files (`--name-only`).
  GhCmd nameOnly() => token('--name-only');

  /// Prints the diff in patch format (`--patch`).
  GhCmd patch() => token('--patch');

  /// Approves the pull request (`--approve`).
  GhCmd approve() => token('--approve');

  /// Requests changes on the pull request (`--request-changes`).
  GhCmd requestChanges() => token('--request-changes');

  /// Leaves a plain review comment, no approval either way (`--comment`).
  ///
  /// Named around the [comment] subcommand, which is a bare word rather than a flag.
  GhCmd commentAction() => token('--comment');

  /// Creates a new comment if `--edit-last` found none (`--create-if-none`).
  GhCmd createIfNone() => token('--create-if-none');

  /// Deletes the current user's last comment (`--delete-last`).
  GhCmd deleteLast() => token('--delete-last');

  /// Edits the current user's last comment instead of adding a new one (`--edit-last`).
  GhCmd editLast() => token('--edit-last');

  /// Leaves a comment while closing, reopening or locking (`--comment`).
  GhCmd closingComment(String text) => pair('--comment', text);

  /// Gives a reason: a close reason, or a lock reason (`--reason`).
  GhCmd reason(String value) => pair('--reason', value);

  /// Closes the issue as a duplicate of another, by number or URL (`--duplicate-of`).
  GhCmd duplicateOf(String value) => pair('--duplicate-of', value);

  /// Stops watching checks at the first failure (`--fail-fast`).
  GhCmd failFast() => token('--fail-fast');

  /// Shows only the checks marked required (`--required`).
  GhCmd required() => token('--required');

  /// Watches the checks until they finish (`--watch`). The subcommand with the same word is [watch].
  GhCmd watchFlag() => token('--watch');

  /// Sets the refresh interval, in seconds, for a watch loop (`--interval`).
  GhCmd interval(int seconds) => pair('--interval', '$seconds');

  /// Marks the new issue as blocked by these issue numbers or URLs (`--blocked-by`).
  GhCmd blockedBy(String numbers) => pair('--blocked-by', numbers);

  /// Marks it as blocking these issue numbers or URLs (`--blocking`).
  GhCmd blocking(String numbers) => pair('--blocking', numbers);

  /// Sets the parent issue by number or URL (`--parent`).
  GhCmd parent(String number) => pair('--parent', number);

  /// Sets or filters the issue type by name (`--type`).
  GhCmd issueType(String name) => pair('--type', name);

  /// Removes the issue type (`--remove-type`).
  GhCmd removeType() => token('--remove-type');

  /// Adds a `blocked by` relationship, by issue number or URL (`--add-blocked-by`).
  GhCmd addBlockedBy(String number) => pair('--add-blocked-by', number);

  /// Adds a `blocking` relationship (`--add-blocking`).
  GhCmd addBlocking(String number) => pair('--add-blocking', number);

  /// Removes a `blocked by` relationship (`--remove-blocked-by`).
  GhCmd removeBlockedBy(String number) => pair('--remove-blocked-by', number);

  /// Removes a `blocking` relationship (`--remove-blocking`).
  GhCmd removeBlocking(String number) => pair('--remove-blocking', number);

  /// Adds a sub-issue by number or URL (`--add-sub-issue`).
  GhCmd addSubIssue(String number) => pair('--add-sub-issue', number);

  /// Removes one (`--remove-sub-issue`).
  GhCmd removeSubIssue(String number) => pair('--remove-sub-issue', number);

  /// Clears the parent issue (`--remove-parent`).
  GhCmd removeParent() => token('--remove-parent');

  /// Checks out the linked branch after creating it (`--checkout`). Named around the [checkout] subcommand.
  GhCmd checkoutFlag() => token('--checkout');

  /// Names the repository to create the linked branch in, if not this one (`--branch-repo`).
  GhCmd branchRepo(String value) => pair('--branch-repo', value);

  /// Names the branch to create, or the artifact to download (`--name`).
  GhCmd name(String value) => pair('--name', value);

  /// Lists the linked branches instead of creating one (`--list`). Named around the [list] subcommand.
  GhCmd listFlag() => token('--list');

  /// Sets the release notes (`--notes`).
  GhCmd notes(String value) => pair('--notes', value);

  /// Reads the release notes from a file, `-` for standard input (`--notes-file`).
  GhCmd notesFile(String path) => pair('--notes-file', path);

  /// Takes the release notes from the tag's own annotation or commit message (`--notes-from-tag`).
  GhCmd notesFromTag() => token('--notes-from-tag');

  /// Sets the starting tag for auto-generated release notes (`--notes-start-tag`).
  GhCmd notesStartTag(String tag) => pair('--notes-start-tag', tag);

  /// Auto-generates the title and notes via the GitHub Release Notes API (`--generate-notes`).
  GhCmd generateNotes() => token('--generate-notes');

  /// Sets the target branch or commit for a new tag (`--target`).
  GhCmd target(String branch) => pair('--target', branch);

  /// Marks the release as a prerelease (`--prerelease`).
  GhCmd prerelease() => token('--prerelease');

  /// Marks the release as `Latest` (`--latest`).
  GhCmd latest() => token('--latest');

  /// Aborts if the git tag does not already exist on the remote (`--verify-tag`).
  GhCmd verifyTag() => token('--verify-tag');

  /// Fails if there are no commits since the last release (`--fail-on-no-commits`).
  GhCmd failOnNoCommits() => token('--fail-on-no-commits');

  /// Starts a discussion in this category when the release publishes (`--discussion-category`).
  GhCmd discussionCategory(String name) => pair('--discussion-category', name);

  /// Renames the tag a release edit points at (`--tag`).
  GhCmd tagName(String value) => pair('--tag', value);

  /// Leaves out draft releases (`--exclude-drafts`).
  GhCmd excludeDrafts() => token('--exclude-drafts');

  /// Leaves out prereleases (`--exclude-pre-releases`).
  GhCmd excludePreReleases() => token('--exclude-pre-releases');

  /// Downloads the source archive in this format, `zip` or `tar.gz` (`--archive`).
  GhCmd archiveFormat(String format) => pair('--archive', format);

  /// Sets the directory to download into (`--dir`).
  GhCmd dir(String path) => pair('--dir', path);

  /// Skips a download when a file of the same name already exists (`--skip-existing`).
  GhCmd skipExisting() => token('--skip-existing');

  /// Also deletes the release's git tag (`--cleanup-tag`).
  GhCmd cleanupTag() => token('--cleanup-tag');

  /// Names the branch or tag holding the workflow file version to use (`--ref`). Also a cache filter.
  GhCmd ref(String value) => pair('--ref', value);

  /// Reads the workflow's inputs as JSON from standard input (`--json`).
  ///
  /// A boolean toggle, unlike the value-taking [jsonFields] most other commands use.
  GhCmd jsonStdin() => token('--json');

  /// Views the workflow's raw YAML instead of its summary (`--yaml`).
  GhCmd yamlFlag() => token('--yaml');

  /// Filters runs by their status (`--status`).
  GhCmd statusFilter(String value) => pair('--status', value);

  /// Filters runs by workflow name or file (`--workflow`).
  GhCmd workflowFilter(String value) => pair('--workflow', value);

  /// Selects a specific attempt number of a run (`--attempt`).
  GhCmd attempt(int n) => pair('--attempt', '$n');

  /// Exits non-zero if the run or the watched checks failed (`--exit-status`).
  GhCmd exitStatus() => token('--exit-status');

  /// Selects one job by its database id (`--job`).
  GhCmd job(String id) => pair('--job', id);

  /// Prints the full log of a run or job (`--log`).
  GhCmd log() => token('--log');

  /// Prints the log only for the steps that failed (`--log-failed`).
  GhCmd logFailed() => token('--log-failed');

  /// Shows only the relevant or failed steps while watching (`--compact`).
  GhCmd compact() => token('--compact');

  /// Reruns with debug logging turned on, or logs the ssh session to a file (`--debug`).
  GhCmd debugFlag() => token('--debug');

  /// Reruns only the failed jobs, including their dependencies (`--failed`).
  GhCmd failed() => token('--failed');

  /// Sets a gist's description (`--desc`).
  GhCmd desc(String value) => pair('--desc', value);

  /// Selects a single gist file to view or edit, or names the file read from standard input (`--filename`).
  GhCmd filename(String value) => pair('--filename', value);

  /// Makes a new repository or gist publicly listed (`--public`).
  GhCmd publicFlag() => token('--public');

  /// Filters gists with a regular expression against their description, file names, or content (`--filter`).
  GhCmd filter(String expression) => pair('--filter', expression);

  /// Includes file content when filtering gists (`--include-content`).
  GhCmd includeContent() => token('--include-content');

  /// Shows only secret gists (`--secret`).
  GhCmd secretFlag() => token('--secret');

  /// Prints the raw gist content instead of the rendered form (`--raw`).
  GhCmd raw() => token('--raw');

  /// Lists a gist's file names instead of its content (`--files`).
  GhCmd filesFlag() => token('--files');

  /// Adds a new file to a gist (`--add`).
  GhCmd addFile(String path) => pair('--add', path);

  /// Removes a file from a gist (`--remove`).
  GhCmd removeFile(String name) => pair('--remove', name);

  /// Copies the one-time OAuth device code to the clipboard (`--clipboard`).
  GhCmd clipboard() => token('--clipboard');

  /// Sets the git protocol to use for this host, `ssh` or `https` (`--git-protocol`).
  GhCmd gitProtocol(String value) => pair('--git-protocol', value);

  /// Stores the credential in plain text instead of the system credential store (`--insecure-storage`).
  GhCmd insecureStorage() => token('--insecure-storage');

  /// Requests additional OAuth scopes (`--scopes`).
  GhCmd scopes(String value) => pair('--scopes', value);

  /// Skips the prompt to generate or upload an SSH key (`--skip-ssh-key`).
  GhCmd skipSshKey() => token('--skip-ssh-key');

  /// Removes these scopes from the stored credentials (`--remove-scopes`).
  GhCmd removeScopes(String value) => pair('--remove-scopes', value);

  /// Resets the stored credentials to the default minimum scopes (`--reset-scopes`).
  GhCmd resetScopes() => token('--reset-scopes');

  /// Shows only the active account (`--active`).
  GhCmd active() => token('--active');

  /// Prints the auth token in plain text alongside the status (`--show-token`).
  GhCmd showToken() => token('--show-token');

  /// Selects a codespace by name (`--codespace`).
  GhCmd codespaceName(String value) => pair('--codespace', value);

  /// Filters codespace selection by the owner of the repository (`--repo-owner`).
  GhCmd repoOwner(String value) => pair('--repo-owner', value);

  /// Sets the codespace's hardware specification (`--machine`).
  GhCmd machine(String value) => pair('--machine', value);

  /// Sets a codespace's display name, 48 characters or fewer (`--display-name`).
  GhCmd displayName(String value) => pair('--display-name', value);

  /// Sets how long a codespace may sit idle before it stops, `"10m"`, `"1h"` (`--idle-timeout`).
  GhCmd idleTimeout(String value) => pair('--idle-timeout', value);

  /// Sets how long a stopped codespace waits before it is deleted, up to 30 days (`--retention-period`).
  GhCmd retentionPeriod(String value) => pair('--retention-period', value);

  /// Shows the status of the post-create command and dotfiles while creating (`--status`).
  GhCmd statusFlag() => token('--status');

  /// Performs a full rebuild, also clearing cached Docker images (`--full`).
  GhCmd full() => token('--full');

  /// Uses the Insiders build of Visual Studio Code (`--insiders`).
  GhCmd insiders() => token('--insiders');

  /// Tails and follows codespace logs (`--follow`).
  GhCmd follow() => token('--follow');

  /// Copies directories, not just files (`--recursive`).
  GhCmd recursive() => token('--recursive');

  /// Expands remote file names as a shell expression before copying (`--expand`).
  GhCmd expand() => token('--expand');

  /// Pins an extension to a release tag or commit ref (`--pin`).
  GhCmd pinVersion(String value) => pair('--pin', value);

  /// Chooses how a created extension is precompiled, `go` or `other` (`--precompiled`).
  GhCmd precompiled(String value) => pair('--precompiled', value);

  /// Declares an alias to be passed through a shell interpreter (`--shell`).
  ///
  /// A boolean toggle here, unlike the value-taking [shell] `gh completion` expects.
  GhCmd shellFlag() => token('--shell');

  /// Reads or writes a per-host configuration value (`--host`).
  GhCmd hostFlag(String value) => pair('--host', value);

  /// Names the shell to generate a completion script for, `bash`, `zsh`, `fish` or `powershell` (`--shell`).
  GhCmd shell(String value) => pair('--shell', value);

  /// Adds a README to a new repository (`--add-readme`).
  GhCmd addReadme() => token('--add-readme');

  /// Clones the new repository, or the fork, locally (`--clone`).
  GhCmd cloneFlag() => token('--clone');

  /// Disables issues on a new repository (`--disable-issues`).
  GhCmd disableIssues() => token('--disable-issues');

  /// Disables the wiki on a new repository (`--disable-wiki`).
  GhCmd disableWiki() => token('--disable-wiki');

  /// Picks a `.gitignore` template for a new repository (`--gitignore`).
  GhCmd gitignoreTemplate(String value) => pair('--gitignore', value);

  /// Sets the repository's home page URL (`--homepage`).
  GhCmd homepage(String value) => pair('--homepage', value);

  /// Includes every branch from the template repository, not just the default (`--include-all-branches`).
  GhCmd includeAllBranches() => token('--include-all-branches');

  /// Makes a new repository internal (`--internal`).
  GhCmd internal() => token('--internal');

  /// Makes a new repository private (`--private`).
  GhCmd privateFlag() => token('--private');

  /// Pushes local commits to the newly created repository (`--push`).
  GhCmd push() => token('--push');

  /// Names the git remote for a newly created repository (`--remote`).
  ///
  /// A boolean "add a remote for the fork" toggle in `repo fork` instead; see [addRemote].
  GhCmd remoteFlag(String value) => pair('--remote', value);

  /// Grants access to this organization team when creating a repository (`--team`).
  GhCmd team(String value) => pair('--team', value);

  /// Adds a git remote for a fork (`--remote`).
  GhCmd addRemote() => token('--remote');

  /// Names the new remote a fork creates (`--remote-name`).
  GhCmd remoteNameOption(String value) => pair('--remote-name', value);

  /// Renames the forked repository (`--fork-name`).
  GhCmd forkName(String value) => pair('--fork-name', value);

  /// Forks only the default branch (`--default-branch-only`).
  GhCmd defaultBranchOnly() => token('--default-branch-only');

  /// Names the upstream remote a clone of a fork creates (`--upstream-remote-name`).
  GhCmd upstreamRemoteName(String value) => pair('--upstream-remote-name', value);

  /// Skips adding an upstream remote when cloning a fork (`--no-upstream`).
  GhCmd noUpstream() => token('--no-upstream');

  /// Enables issues on an existing repository (`--enable-issues`).
  GhCmd enableIssues() => token('--enable-issues');

  /// Enables its wiki (`--enable-wiki`).
  GhCmd enableWiki() => token('--enable-wiki');

  /// Enables projects (`--enable-projects`).
  GhCmd enableProjects() => token('--enable-projects');

  /// Enables discussions (`--enable-discussions`).
  GhCmd enableDiscussions() => token('--enable-discussions');

  /// Allows merging pull requests via a merge commit (`--enable-merge-commit`).
  GhCmd enableMergeCommit() => token('--enable-merge-commit');

  /// Allows merging via a squashed commit (`--enable-squash-merge`).
  GhCmd enableSquashMerge() => token('--enable-squash-merge');

  /// Allows merging via rebase (`--enable-rebase-merge`).
  GhCmd enableRebaseMerge() => token('--enable-rebase-merge');

  /// Enables auto-merge on the repository (`--enable-auto-merge`).
  GhCmd enableAutoMerge() => token('--enable-auto-merge');

  /// Enables GitHub Advanced Security (`--enable-advanced-security`).
  GhCmd enableAdvancedSecurity() => token('--enable-advanced-security');

  /// Enables secret scanning (`--enable-secret-scanning`).
  GhCmd enableSecretScanning() => token('--enable-secret-scanning');

  /// Enables secret scanning push protection, once scanning itself is on (`--enable-secret-scanning-push-protection`).
  GhCmd enableSecretScanningPushProtection() => token('--enable-secret-scanning-push-protection');

  /// Allows forking an organization repository (`--allow-forking`).
  GhCmd allowForking() => token('--allow-forking');

  /// Allows updating a pull request's branch when it falls behind its base (`--allow-update-branch`).
  GhCmd allowUpdateBranch() => token('--allow-update-branch');

  /// Deletes a pull request's head branch once merged (`--delete-branch-on-merge`).
  GhCmd deleteBranchOnMerge() => token('--delete-branch-on-merge');

  /// Sets the repository's default branch name (`--default-branch`).
  GhCmd defaultBranchName(String value) => pair('--default-branch', value);

  /// Adds a repository topic (`--add-topic`).
  GhCmd addTopic(String value) => pair('--add-topic', value);

  /// Removes one (`--remove-topic`).
  GhCmd removeTopic(String value) => pair('--remove-topic', value);

  /// Sets the default squash merge commit message form (`--squash-merge-commit-message`).
  GhCmd squashMergeCommitMessage(String value) => pair('--squash-merge-commit-message', value);

  /// Makes the repository available as a template repository (`--template`).
  ///
  /// Named around [template], which takes the template's name as a value instead.
  GhCmd templateRepository() => token('--template');

  /// Accepts the consequences of changing a repository's visibility (`--accept-visibility-change-consequences`).
  ///
  /// Required alongside [visibility] on `repo edit`.
  GhCmd acceptVisibilityChangeConsequences() => token('--accept-visibility-change-consequences');

  /// Shows only archived repositories (`--archived`).
  GhCmd archivedOnly() => token('--archived');

  /// Leaves out archived repositories (`--no-archived`).
  GhCmd noArchived() => token('--no-archived');

  /// Shows only forks (`--fork`).
  GhCmd forksOnly() => token('--fork');

  /// Shows only non-forks (`--source`).
  ///
  /// Named around [source], which takes a source path or repository as a value instead.
  GhCmd sourceOnly() => token('--source');

  /// Filters repositories by primary coding language (`--language`).
  GhCmd language(String value) => pair('--language', value);

  /// Filters repositories by topic (`--topic`).
  GhCmd topic(String value) => pair('--topic', value);

  /// Clears the default repository instead of setting one (`--unset`).
  GhCmd unset() => token('--unset');

  /// Prints the current default repository instead of setting one (`--view`).
  ///
  /// Named around the [view] subcommand.
  GhCmd viewFlag() => token('--view');

  /// Sets a deployment environment for a secret or variable (`--env`).
  GhCmd env(String value) => pair('--env', value);

  /// Loads secret or variable names and values from a dotenv-formatted file (`--env-file`).
  GhCmd envFile(String path) => pair('--env-file', path);

  /// Lists the repositories that may access an organization or user secret or variable (`--repos`).
  ///
  /// Named around the [repos] `search repos` subcommand.
  GhCmd selectedRepos(String value) => pair('--repos', value);

  /// Leaves an organization secret visible to no repositories (`--no-repos-selected`).
  GhCmd noReposSelected() => token('--no-repos-selected');

  /// Prints the encrypted value instead of storing it on GitHub (`--no-store`).
  GhCmd noStore() => token('--no-store');

  /// Scopes a secret to the current user, for Codespaces (`--user`).
  ///
  /// A boolean toggle here, unlike the value-taking [user] most other commands use.
  GhCmd userScope() => token('--user');

  /// Filters caches by key prefix, or selects one to delete (`--key`).
  GhCmd key(String value) => pair('--key', value);

  /// Returns success even when `--all` finds no caches to delete (`--succeed-on-no-caches`).
  GhCmd succeedOnNoCaches() => token('--succeed-on-no-caches');

  /// Includes rulesets configured at higher levels that also apply (`--parents`).
  GhCmd parents() => token('--parents');

  /// Checks the rules that apply to the default branch (`--default`).
  GhCmd defaultBranchFlag() => token('--default');

  /// Adds a bare positional argument: a number, an id, a tag, a query, an endpoint, a path.
  GhCmd arg(String value) => token(value);
}

/// `gh`, ready to take its first option.
// ignore: non_constant_identifier_names
GhCmd get Gh => GhCmd();
