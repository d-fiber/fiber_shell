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

/// `git`. Everywhere a developer works, and missing from plenty of the slim
/// container images a CI job runs in, so `commandExists` before a command that
/// would otherwise fail confusingly.
///
/// **This wrapper is a vocabulary, not a grammar.** Every subcommand `git help -a`
/// lists is a method, and the flags shared across subcommands are a single method
/// each, reusable wherever git accepts them. Nothing validates that `--autostash`
/// goes with `pull` rather than `commit`; git will say so if you get it wrong.
///
/// ```dart
/// final ShellResult inside = await Git.repo(root).revParse().isInsideWorkTree().output();
/// if (inside.success) await Git.repo(root).pull().rebase().autostash().execute();
/// ```
///
/// Watch three names where a subcommand and a flag share a word. [rebase] is the
/// `--rebase` flag of `git pull`, and the subcommand is [rebaseCommand]; [prune],
/// [version], [add], [list], [merge] and [help] are the subcommands, and their
/// flags carry a `Flag` suffix. [switchBranch] exists because `switch` is a
/// reserved word in Dart.
///
/// [repo] first, always, when the command is not meant for the current directory:
/// `git -C <path>` beats changing the process working directory.
class GitCmd extends CommandBuilder<GitCmd> {
  @override
  final String executable = 'git';

  /// Runs as if git had started in this directory (`-C`).
  GitCmd repo(String path) => pair('-C', path);

  /// Overrides one config key for this command only (`-c key=value`).
  GitCmd configOverride(String key, String value) => pair('-c', '$key=$value');

  /// The `.git` directory to use (`--git-dir`).
  GitCmd gitDir(String path) => joined('--git-dir', path);

  /// The working tree to use (`--work-tree`).
  GitCmd workTree(String path) => joined('--work-tree', path);

  /// The ref namespace to work in (`--namespace`).
  GitCmd namespace(String value) => joined('--namespace', value);

  /// Treats the repository as bare (`--bare`).
  GitCmd bare() => token('--bare');

  /// Sends the output straight through, no pager (`--no-pager`).
  ///
  /// Redundant when git is not on a terminal, and harmless insurance when it is.
  GitCmd noPager() => token('--no-pager');

  /// Forces the pager on (`--paginate`).
  GitCmd paginate() => token('--paginate');

  /// Where the git helper programs live (`--exec-path`).
  GitCmd execPath(String path) => joined('--exec-path', path);

  /// Treats the pathspecs literally, no globbing, no magic (`--literal-pathspecs`).
  GitCmd literalPathspecs() => token('--literal-pathspecs');

  /// Turns glob magic on for every pathspec (`--glob-pathspecs`).
  GitCmd globPathspecs() => token('--glob-pathspecs');

  /// Turns it off (`--noglob-pathspecs`).
  GitCmd noglobPathspecs() => token('--noglob-pathspecs');

  /// Matches pathspecs without regard to case (`--icase-pathspecs`).
  GitCmd icasePathspecs() => token('--icase-pathspecs');

  /// Ignores the replacement refs (`--no-replace-objects`).
  GitCmd noReplaceObjects() => token('--no-replace-objects');

  /// Skips the operations that would take a lock, so a read stays read-only (`--no-optional-locks`).
  GitCmd noOptionalLocks() => token('--no-optional-locks');

  /// Prints the version (`--version`).
  GitCmd versionFlag() => token('--version');

  /// Prints the help (`--help`).
  GitCmd helpFlag() => token('--help');

  /// Stages file contents (`add`).
  GitCmd add() => token('add');

  /// Applies a mailbox of patches (`am`).
  GitCmd am() => token('am');

  /// Makes an archive of a tree (`archive`).
  GitCmd archive() => token('archive');

  /// Downloads the objects a partial clone left behind (`backfill`).
  GitCmd backfill() => token('backfill');

  /// Binary-searches the history for the commit that broke something (`bisect`).
  GitCmd bisect() => token('bisect');

  /// Lists, creates or deletes branches (`branch`).
  GitCmd branch() => token('branch');

  /// Moves objects and refs through an archive file (`bundle`).
  GitCmd bundle() => token('bundle');

  /// Switches branches, or restores files (`checkout`).
  GitCmd checkout() => token('checkout');

  /// Replays the changes of existing commits (`cherry-pick`).
  GitCmd cherryPick() => token('cherry-pick');

  /// Removes the untracked files (`clean`).
  GitCmd clean() => token('clean');

  /// Clones a repository into a new directory (`clone`).
  GitCmd clone() => token('clone');

  /// Records the staged changes (`commit`).
  GitCmd commit() => token('commit');

  /// Names a commit after the nearest tag (`describe`).
  GitCmd describe() => token('describe');

  /// Shows changes between commits, trees or the working tree (`diff`).
  GitCmd diff() => token('diff');

  /// Downloads objects and refs from another repository (`fetch`).
  GitCmd fetch() => token('fetch');

  /// Prepares patches for email (`format-patch`).
  GitCmd formatPatch() => token('format-patch');

  /// Tidies up and repacks the repository (`gc`).
  GitCmd gc() => token('gc');

  /// Searches the tracked files (`grep`).
  GitCmd grep() => token('grep');

  /// Creates a repository, or reinitialises one (`init`).
  GitCmd init() => token('init');

  /// Shows the commit history (`log`).
  GitCmd log() => token('log');

  /// Runs the background maintenance tasks (`maintenance`).
  GitCmd maintenance() => token('maintenance');

  /// Joins two histories (`merge`).
  GitCmd merge() => token('merge');

  /// Moves or renames a tracked path (`mv`).
  GitCmd mv() => token('mv');

  /// Adds or reads the notes attached to objects (`notes`).
  GitCmd notes() => token('notes');

  /// Fetches and integrates (`pull`).
  GitCmd pull() => token('pull');

  /// Sends refs and objects to a remote (`push`).
  GitCmd push() => token('push');

  /// Compares two ranges of commits (`range-diff`).
  GitCmd rangeDiff() => token('range-diff');

  /// Replays commits on a new base (`rebase`). The subcommand, not the [rebase] flag.
  GitCmd rebaseCommand() => token('rebase');

  /// Moves HEAD, and optionally the index and the working tree (`reset`).
  GitCmd reset() => token('reset');

  /// Restores files from a commit or the index (`restore`).
  GitCmd restore() => token('restore');

  /// Records a commit that undoes another (`revert`).
  GitCmd revert() => token('revert');

  /// Removes files from the working tree and the index (`rm`).
  GitCmd rm() => token('rm');

  /// Manages a very large repository (`scalar`).
  GitCmd scalar() => token('scalar');

  /// Summarises the log by author (`shortlog`).
  GitCmd shortlog() => token('shortlog');

  /// Shows an object of any kind (`show`).
  GitCmd show() => token('show');

  /// Narrows the working tree to part of the tree (`sparse-checkout`).
  GitCmd sparseCheckout() => token('sparse-checkout');

  /// Puts the dirty working tree aside (`stash`).
  GitCmd stash() => token('stash');

  /// Shows what is staged, changed and untracked (`status`).
  GitCmd status() => token('status');

  /// Initialises, updates or inspects submodules (`submodule`).
  GitCmd submodule() => token('submodule');

  /// Switches branches (`switch`). Named around the Dart keyword.
  GitCmd switchBranch() => token('switch');

  /// Creates, lists, deletes or verifies tags (`tag`).
  GitCmd tag() => token('tag');

  /// Manages the linked working trees (`worktree`).
  GitCmd worktree() => token('worktree');

  /// Reads and writes configuration (`config`).
  GitCmd config() => token('config');

  /// Exports the history in fast-import format (`fast-export`).
  GitCmd fastExport() => token('fast-export');

  /// Imports a fast-import stream (`fast-import`).
  GitCmd fastImport() => token('fast-import');

  /// Rewrites the history (`filter-branch`). Slow; `git filter-repo` is the modern answer.
  GitCmd filterBranch() => token('filter-branch');

  /// Opens the configured tool on the conflicts (`mergetool`).
  GitCmd mergetool() => token('mergetool');

  /// Packs the refs for faster lookup (`pack-refs`).
  GitCmd packRefs() => token('pack-refs');

  /// Removes the unreachable objects (`prune`).
  GitCmd prune() => token('prune');

  /// Reads and expires the reflog (`reflog`). Where a lost commit is usually still findable.
  GitCmd reflog() => token('reflog');

  /// Low-level access to the refs (`refs`).
  GitCmd refs() => token('refs');

  /// Manages the tracked repositories (`remote`).
  GitCmd remote() => token('remote');

  /// Repacks the loose objects (`repack`).
  GitCmd repack() => token('repack');

  /// Creates and lists the refs that replace objects (`replace`).
  GitCmd replace() => token('replace');

  /// Annotates each line with its commit (`annotate`).
  GitCmd annotate() => token('annotate');

  /// Shows who last changed each line (`blame`).
  GitCmd blame() => token('blame');

  /// Collects the information a git bug report needs (`bugreport`).
  GitCmd bugreport() => token('bugreport');

  /// Counts the loose objects and the space they take (`count-objects`).
  GitCmd countObjects() => token('count-objects');

  /// Zips up diagnostic information (`diagnose`).
  GitCmd diagnose() => token('diagnose');

  /// Shows the diff in the configured tool (`difftool`).
  GitCmd difftool() => token('difftool');

  /// Checks the object database for damage (`fsck`).
  GitCmd fsck() => token('fsck');

  /// Prints help about git or one command (`help`).
  GitCmd help() => token('help');

  /// Serves the repository through gitweb (`instaweb`).
  GitCmd instaweb() => token('instaweb');

  /// Merges without touching the index or the working tree (`merge-tree`).
  GitCmd mergeTree() => token('merge-tree');

  /// Reuses a recorded conflict resolution (`rerere`).
  GitCmd rerere() => token('rerere');

  /// Shows the branches and their commits side by side (`show-branch`).
  GitCmd showBranch() => token('show-branch');

  /// Checks the GPG signature of a commit (`verify-commit`).
  GitCmd verifyCommit() => token('verify-commit');

  /// Checks the GPG signature of a tag (`verify-tag`).
  GitCmd verifyTag() => token('verify-tag');

  /// Prints the version (`version`). The subcommand; the flag is [versionFlag].
  GitCmd version() => token('version');

  /// The log with the diff of each commit (`whatchanged`).
  GitCmd whatchanged() => token('whatchanged');

  /// Summarises the pending changes for a pull request email (`request-pull`).
  GitCmd requestPull() => token('request-pull');

  /// Sends patches as email (`send-email`).
  GitCmd sendEmail() => token('send-email');

  /// Applies a patch to the files or the index (`apply`).
  GitCmd apply() => token('apply');

  /// Prints the content or the type of an object (`cat-file`).
  GitCmd catFile() => token('cat-file');

  /// Says which gitattributes apply to a path (`check-attr`).
  GitCmd checkAttr() => token('check-attr');

  /// Says which ignore rule excludes a path (`check-ignore`).
  GitCmd checkIgnore() => token('check-ignore');

  /// Copies files out of the index (`checkout-index`).
  GitCmd checkoutIndex() => token('checkout-index');

  /// Finds the commits not yet applied upstream (`cherry`).
  GitCmd cherry() => token('cherry');

  /// Writes and verifies the commit-graph file (`commit-graph`).
  GitCmd commitGraph() => token('commit-graph');

  /// Creates a commit object by hand (`commit-tree`).
  GitCmd commitTree() => token('commit-tree');

  /// Talks to the credential helpers (`credential`).
  GitCmd credential() => token('credential');

  /// Compares the working tree with the index (`diff-files`).
  GitCmd diffFiles() => token('diff-files');

  /// Compares a tree with the index or the working tree (`diff-index`).
  GitCmd diffIndex() => token('diff-index');

  /// Compares two trees (`diff-tree`).
  GitCmd diffTree() => token('diff-tree');

  /// Prints a formatted line per ref (`for-each-ref`). The scriptable way to list refs.
  GitCmd forEachRef() => token('for-each-ref');

  /// Computes the id of a file, and optionally stores it (`hash-object`).
  GitCmd hashObject() => token('hash-object');

  /// Builds the index of a pack file (`index-pack`).
  GitCmd indexPack() => token('index-pack');

  /// Reads and edits the trailers of a commit message (`interpret-trailers`).
  GitCmd interpretTrailers() => token('interpret-trailers');

  /// Lists the files git knows about (`ls-files`).
  GitCmd lsFiles() => token('ls-files');

  /// Lists the refs of a remote without cloning (`ls-remote`).
  GitCmd lsRemote() => token('ls-remote');

  /// Lists the contents of a tree object (`ls-tree`).
  GitCmd lsTree() => token('ls-tree');

  /// Finds the common ancestor of two commits (`merge-base`).
  GitCmd mergeBase() => token('merge-base');

  /// Runs a three-way merge on files (`merge-file`).
  GitCmd mergeFile() => token('merge-file');

  /// Runs the merge for the files that need it (`merge-index`).
  GitCmd mergeIndex() => token('merge-index');

  /// Creates a tag object, with validation (`mktag`).
  GitCmd mktag() => token('mktag');

  /// Builds a tree object from `ls-tree` output (`mktree`).
  GitCmd mktree() => token('mktree');

  /// Writes and verifies the multi-pack index (`multi-pack-index`).
  GitCmd multiPackIndex() => token('multi-pack-index');

  /// Names a commit after a reachable ref (`name-rev`).
  GitCmd nameRev() => token('name-rev');

  /// Creates a pack file (`pack-objects`).
  GitCmd packObjects() => token('pack-objects');

  /// Computes an id for a patch, ignoring line numbers (`patch-id`).
  GitCmd patchId() => token('patch-id');

  /// Removes the loose objects already in a pack (`prune-packed`).
  GitCmd prunePacked() => token('prune-packed');

  /// Reads a tree into the index (`read-tree`).
  GitCmd readTree() => token('read-tree');

  /// Replays commits on a new base, bare repositories included (`replay`). Experimental.
  GitCmd replay() => token('replay');

  /// Lists commit ids (`rev-list`).
  GitCmd revList() => token('rev-list');

  /// Turns arguments into the ids and paths git uses internally (`rev-parse`).
  GitCmd revParse() => token('rev-parse');

  /// Prints the contents of a pack index (`show-index`).
  GitCmd showIndex() => token('show-index');

  /// Lists the refs and their ids (`show-ref`).
  GitCmd showRef() => token('show-ref');

  /// Cleans up whitespace the way git does for messages (`stripspace`).
  GitCmd stripspace() => token('stripspace');

  /// Reads and writes a symbolic ref, `HEAD` above all (`symbolic-ref`).
  GitCmd symbolicRef() => token('symbolic-ref');

  /// Unpacks the objects out of a pack (`unpack-objects`).
  GitCmd unpackObjects() => token('unpack-objects');

  /// Registers file contents in the index (`update-index`).
  GitCmd updateIndex() => token('update-index');

  /// Moves a ref, safely (`update-ref`).
  GitCmd updateRef() => token('update-ref');

  /// Checks a pack file (`verify-pack`).
  GitCmd verifyPack() => token('verify-pack');

  /// Creates a tree object from the index (`write-tree`).
  GitCmd writeTree() => token('write-tree');

  /// Applies the top stash and drops it (`pop`).
  GitCmd pop() => token('pop');

  /// Discards a stash entry (`drop`).
  GitCmd drop() => token('drop');

  /// The `list` subcommand of `stash`, `worktree`, `remote` and friends.
  GitCmd list() => token('list');

  /// Discards every stash entry (`clear`). No reflog for these; they are gone.
  GitCmd clear() => token('clear');

  /// Creates a stash commit without touching the working tree (`create`).
  GitCmd create() => token('create');

  /// Stores a stash commit made by [create] (`store`).
  GitCmd store() => token('store');

  /// The old spelling of `git stash push` (`save`). Deprecated.
  GitCmd save() => token('save');

  /// The `remove` subcommand of `remote` and `worktree`.
  GitCmd remove() => token('remove');

  /// The `rename` subcommand of `remote` and `branch`.
  GitCmd rename() => token('rename');

  /// The `update` subcommand of `remote` and `submodule`.
  GitCmd update() => token('update');

  /// Rewrites the URL of a remote (`set-url`).
  GitCmd setUrl() => token('set-url');

  /// Prints the URL of a remote (`get-url`).
  GitCmd getUrl() => token('get-url');

  /// Rewrites the list of branches a remote tracks (`set-branches`).
  GitCmd setBranches() => token('set-branches');

  /// Sets what the remote HEAD points at (`set-head`).
  GitCmd setHead() => token('set-head');

  /// Rebases instead of merging, the `git pull` flag (`--rebase`).
  ///
  /// The subcommand is [rebaseCommand]. This spelling is kept so the wrapper matches the copy in `scripts/kernel-cli`.
  GitCmd rebase() => token('--rebase');

  /// Merges instead (`--no-rebase`).
  GitCmd noRebase() => token('--no-rebase');

  /// Stashes the dirty tree before and restores it after (`--autostash`).
  GitCmd autostash() => token('--autostash');

  /// Refuses to run on a dirty tree (`--no-autostash`).
  GitCmd noAutostash() => token('--no-autostash');

  /// Asks whether this is a working tree (`--is-inside-work-tree`).
  ///
  /// The cheap "is this a repository" check: the status carries the answer, so pair it with [output].
  GitCmd isInsideWorkTree() => token('--is-inside-work-tree');

  /// Asks whether this is inside the `.git` directory (`--is-inside-git-dir`).
  GitCmd isInsideGitDir() => token('--is-inside-git-dir');

  /// Asks whether the repository is bare (`--is-bare-repository`).
  GitCmd isBareRepository() => token('--is-bare-repository');

  /// Prints the root of the working tree (`--show-toplevel`).
  GitCmd showToplevel() => token('--show-toplevel');

  /// Prints the path from the root down to here (`--show-prefix`).
  GitCmd showPrefix() => token('--show-prefix');

  /// Prints the `../` chain back up to the root (`--show-cdup`).
  GitCmd showCdup() => token('--show-cdup');

  /// Prints the path of the `.git` directory (`--git-dir`).
  GitCmd gitDirFlag() => token('--git-dir');

  /// Prints it absolute (`--absolute-git-dir`).
  GitCmd absoluteGitDir() => token('--absolute-git-dir');

  /// Prints a ref short, so `main` rather than `refs/heads/main` (`--abbrev-ref`).
  GitCmd abbrevRef() => token('--abbrev-ref');

  /// Prints the full symbolic name of a ref (`--symbolic-full-name`).
  GitCmd symbolicFullName() => token('--symbolic-full-name');

  /// Requires the argument to be a valid object, failing rather than echoing it (`--verify`).
  GitCmd verify() => token('--verify');

  /// Every ref, every branch, everything, depending on the subcommand (`--all`).
  GitCmd all() => token('--all');

  /// Overrides the check that would otherwise stop the command (`--force`).
  GitCmd force() => token('--force');

  /// Force-pushes only if the remote is where you last saw it (`--force-with-lease`).
  ///
  /// The one to reach for: plain [force] will happily drop commits somebody else pushed.
  GitCmd forceWithLease() => token('--force-with-lease');

  /// Says less (`--quiet`).
  GitCmd quiet() => token('--quiet');

  /// Says more (`--verbose`).
  GitCmd verbose() => token('--verbose');

  /// Reports what would happen and changes nothing (`--dry-run`).
  GitCmd dryRun() => token('--dry-run');

  /// Forces the progress meter on even when not on a terminal (`--progress`).
  GitCmd progress() => token('--progress');

  /// Prints without colour (`--no-color`).
  GitCmd noColor() => token('--no-color');

  /// When to colour: `always`, `auto` or `never` (`--color`).
  GitCmd color(String when) => joined('--color', when);

  /// The commit or tag message (`--message`).
  GitCmd message(String value) => pair('--message', value);

  /// Reads the message from this file (`--file`).
  GitCmd file(String path) => pair('--file', path);

  /// Rewrites the previous commit instead of adding one (`--amend`).
  GitCmd amend() => token('--amend');

  /// Opens the editor on the message (`--edit`).
  GitCmd edit() => token('--edit');

  /// Keeps the message as is, no editor (`--no-edit`).
  GitCmd noEdit() => token('--no-edit');

  /// Allows a commit that changes nothing (`--allow-empty`).
  GitCmd allowEmpty() => token('--allow-empty');

  /// Skips the pre-commit and commit-msg hooks (`--no-verify`).
  GitCmd noVerify() => token('--no-verify');

  /// Adds a `Signed-off-by` trailer (`--signoff`).
  GitCmd signoff() => token('--signoff');

  /// Signs the commit or tag (`--gpg-sign`).
  GitCmd gpgSign() => token('--gpg-sign');

  /// Does not sign, whatever the config says (`--no-gpg-sign`).
  GitCmd noGpgSign() => token('--no-gpg-sign');

  /// Overrides the author (`--author`).
  GitCmd author(String value) => joined('--author', value);

  /// Overrides the author date (`--date`).
  GitCmd date(String value) => joined('--date', value);

  /// Records the pushed branch as the upstream (`--set-upstream`).
  GitCmd setUpstream() => token('--set-upstream');

  /// Points the current branch at this upstream (`--set-upstream-to`).
  GitCmd setUpstreamTo(String value) => joined('--set-upstream-to', value);

  /// Sets up tracking for the new branch (`--track`).
  GitCmd track() => token('--track');

  /// Does not (`--no-track`).
  GitCmd noTrack() => token('--no-track');

  /// Includes the tags (`--tags`).
  GitCmd tags() => token('--tags');

  /// Excludes them (`--no-tags`).
  GitCmd noTags() => token('--no-tags');

  /// Pushes the annotated tags that point at pushed commits (`--follow-tags`).
  GitCmd followTags() => token('--follow-tags');

  /// Deletes the remote-tracking refs whose remote branch is gone (`--prune`).
  GitCmd pruneFlag() => token('--prune');

  /// The same for tags (`--prune-tags`).
  GitCmd pruneTags() => token('--prune-tags');

  /// Truncates the history to this many commits (`--depth`).
  GitCmd depth(int value) => joined('--depth', '$value');

  /// Truncates it at this date (`--shallow-since`).
  GitCmd shallowSince(String value) => joined('--shallow-since', value);

  /// Fetches the rest of the history of a shallow clone (`--unshallow`).
  GitCmd unshallow() => token('--unshallow');

  /// Clones or fetches one branch only (`--single-branch`).
  GitCmd singleBranch() => token('--single-branch');

  /// Takes them all (`--no-single-branch`).
  GitCmd noSingleBranch() => token('--no-single-branch');

  /// Recurses into the submodules (`--recurse-submodules`).
  GitCmd recurseSubmodules() => token('--recurse-submodules');

  /// Leaves them alone (`--no-recurse-submodules`).
  GitCmd noRecurseSubmodules() => token('--no-recurse-submodules');

  /// Fast-forwards when possible (`--ff`).
  GitCmd ff() => token('--ff');

  /// Fast-forwards or fails, never a merge commit (`--ff-only`).
  GitCmd ffOnly() => token('--ff-only');

  /// Always makes a merge commit (`--no-ff`).
  GitCmd noFf() => token('--no-ff');

  /// Stages the merge result without committing or recording the merge (`--squash`).
  GitCmd squash() => token('--squash');

  /// Merges without committing (`--no-commit`).
  GitCmd noCommit() => token('--no-commit');

  /// The merge strategy (`--strategy`).
  GitCmd strategy(String name) => joined('--strategy', name);

  /// An option for the strategy, `ours` or `theirs` (`--strategy-option`).
  GitCmd strategyOption(String value) => joined('--strategy-option', value);

  /// Carries on after the conflicts are resolved (`--continue`).
  GitCmd continueOperation() => token('--continue');

  /// Puts everything back the way it was (`--abort`).
  GitCmd abort() => token('--abort');

  /// Skips the current commit and moves on (`--skip`).
  GitCmd skip() => token('--skip');

  /// Stops without restoring anything (`--quit`).
  GitCmd quit() => token('--quit');

  /// Runs interactively (`--interactive`). Not for a script.
  GitCmd interactive() => token('--interactive');

  /// The commit to replay onto (`--onto`).
  GitCmd onto(String value) => pair('--onto', value);

  /// Includes the very first commit in the rebase (`--root`).
  GitCmd root() => token('--root');

  /// Applies the `fixup!` and `squash!` commits automatically (`--autosquash`).
  GitCmd autosquash() => token('--autosquash');

  /// Keeps the merge commits instead of flattening them (`--rebase-merges`).
  GitCmd rebaseMerges() => token('--rebase-merges');

  /// Takes our side of the conflict (`--ours`).
  GitCmd ours() => token('--ours');

  /// Takes their side (`--theirs`).
  GitCmd theirs() => token('--theirs');

  /// Resets the index and the working tree (`--hard`). Uncommitted work is gone.
  GitCmd hard() => token('--hard');

  /// Moves HEAD and leaves index and working tree alone (`--soft`).
  GitCmd soft() => token('--soft');

  /// Resets the index but keeps the working tree (`--mixed`). The default.
  GitCmd mixed() => token('--mixed');

  /// Resets, but refuses when it would lose a local change (`--keep`).
  GitCmd keep() => token('--keep');

  /// Resets while keeping the local changes merged in (`--merge`).
  GitCmd mergeFlag() => token('--merge');

  /// Works on the index (`--staged`).
  GitCmd staged() => token('--staged');

  /// Works on the index, the older spelling (`--cached`).
  GitCmd cached() => token('--cached');

  /// The commit to restore the files from (`--source`).
  GitCmd source(String value) => joined('--source', value);

  /// Creates a branch and checks it out (`-b`).
  GitCmd newBranch(String name) => pair('-b', name);

  /// The same, resetting the branch if it exists (`-B`).
  GitCmd newBranchForce(String name) => pair('-B', name);

  /// Checks out in detached HEAD (`--detach`).
  GitCmd detach() => token('--detach');

  /// Starts a branch with no history at all (`--orphan`).
  GitCmd orphan(String name) => pair('--orphan', name);

  /// Deletes the branch or the tag (`--delete`).
  GitCmd deleteBranch() => token('--delete');

  /// Renames the branch (`--move`).
  GitCmd moveBranch() => token('--move');

  /// Copies the branch with its reflog (`--copy`).
  GitCmd copyBranch() => token('--copy');

  /// Lists rather than acts (`--list`).
  GitCmd listFlag() => token('--list');

  /// Acts on the remote-tracking branches (`--remotes`).
  GitCmd remotes() => token('--remotes');

  /// Local and remote branches both (`-a`).
  GitCmd allBranches() => token('-a');

  /// Only the branches containing this commit (`--contains`).
  GitCmd contains(String commit) => joined('--contains', commit);

  /// Only the branches already merged into this one (`--merged`).
  GitCmd merged(String commit) => joined('--merged', commit);

  /// Only those not merged (`--no-merged`).
  GitCmd noMerged(String commit) => joined('--no-merged', commit);

  /// The short form of the output (`--short`).
  GitCmd short() => token('--short');

  /// The stable machine-readable format (`--porcelain`).
  ///
  /// The one to parse: it is contractually stable, unlike the human output.
  GitCmd porcelain() => token('--porcelain');

  /// That format in a specific version (`--porcelain=v2`).
  GitCmd porcelainVersion(String value) => joined('--porcelain', value);

  /// Adds the branch and tracking line to the status (`--branch`).
  GitCmd branchStatus() => token('--branch');

  /// How much of the untracked files to show: `no`, `normal` or `all` (`--untracked-files`).
  GitCmd untrackedFiles(String mode) => joined('--untracked-files', mode);

  /// Shows the ignored files too (`--ignored`).
  GitCmd ignored() => token('--ignored');

  /// Reports a rename as a delete and an add (`--no-renames`).
  GitCmd noRenames() => token('--no-renames');

  /// Stashes the untracked files as well (`--include-untracked`).
  GitCmd includeUntracked() => token('--include-untracked');

  /// Leaves the staged changes staged while stashing (`--keep-index`).
  GitCmd keepIndex() => token('--keep-index');

  /// Includes directories, for `git clean` (`-d`).
  GitCmd directories() => token('-d');

  /// Removes the ignored files too (`-x`).
  GitCmd removeIgnored() => token('-x');

  /// Removes only the ignored files (`-X`).
  GitCmd onlyIgnored() => token('-X');

  /// Adds an exclude pattern (`--exclude`).
  GitCmd exclude(String pattern) => joined('--exclude', pattern);

  /// The user config, `~/.gitconfig` (`--global`).
  GitCmd global() => token('--global');

  /// The repository config, `.git/config` (`--local`).
  GitCmd local() => token('--local');

  /// The system config (`--system`).
  GitCmd system() => token('--system');

  /// The config of this working tree (`--worktree`).
  GitCmd worktreeScope() => token('--worktree');

  /// Reads one config value (`--get`).
  GitCmd getValue(String key) => pair('--get', key);

  /// Reads every value of a multi-valued key (`--get-all`).
  GitCmd getAll(String key) => pair('--get-all', key);

  /// Reads the keys matching a pattern (`--get-regexp`).
  GitCmd getRegexp(String pattern) => pair('--get-regexp', pattern);

  /// Removes one value (`--unset`).
  GitCmd unset(String key) => pair('--unset', key);

  /// Removes them all (`--unset-all`).
  GitCmd unsetAll(String key) => pair('--unset-all', key);

  /// Adds a value without replacing the existing ones (`--add`).
  GitCmd addFlag() => token('--add');

  /// Replaces every value of the key (`--replace-all`).
  GitCmd replaceAll() => token('--replace-all');

  /// Reads the value as a boolean (`--bool`).
  GitCmd boolType() => token('--bool');

  /// Reads it as an integer (`--int`).
  GitCmd intType() => token('--int');

  /// Reads it as a path, expanding `~` (`--path`).
  GitCmd pathType() => token('--path');

  /// One line per commit (`--oneline`).
  GitCmd oneline() => token('--oneline');

  /// Draws the history as an ASCII graph (`--graph`).
  GitCmd graph() => token('--graph');

  /// Adds the ref names to each commit (`--decorate`).
  GitCmd decorate() => token('--decorate');

  /// Leaves them out (`--no-decorate`).
  GitCmd noDecorate() => token('--no-decorate');

  /// The commit format, by name or a format string (`--pretty`).
  GitCmd pretty(String format) => joined('--pretty', format);

  /// The output format (`--format`). What `for-each-ref` and `log` are scripted with.
  GitCmd format(String value) => joined('--format', value);

  /// Shortens the commit ids (`--abbrev-commit`).
  GitCmd abbrevCommit() => token('--abbrev-commit');

  /// At most this many commits (`--max-count`).
  GitCmd maxCount(int value) => joined('--max-count', '$value');

  /// Skips this many first (`--skip`).
  GitCmd skipCount(int value) => joined('--skip', '$value');

  /// Only the commits after this date (`--since`).
  GitCmd since(String value) => joined('--since', value);

  /// Only those before it (`--until`).
  GitCmd until(String value) => joined('--until', value);

  /// Only the commits whose message matches (`--grep`).
  GitCmd grepMessage(String pattern) => joined('--grep', pattern);

  /// The names of the changed files, nothing else (`--name-only`).
  GitCmd nameOnly() => token('--name-only');

  /// Those names with their status letter (`--name-status`).
  GitCmd nameStatus() => token('--name-status');

  /// A diffstat (`--stat`).
  GitCmd stat() => token('--stat');

  /// The diffstat as numbers, for a machine (`--numstat`).
  GitCmd numstat() => token('--numstat');

  /// The last line of the diffstat only (`--shortstat`).
  GitCmd shortstat() => token('--shortstat');

  /// The patch itself (`--patch`).
  GitCmd patch() => token('--patch');

  /// Suppresses it (`--no-patch`).
  GitCmd noPatch() => token('--no-patch');

  /// How many lines of context in the diff (`--unified`).
  GitCmd unified(int lines) => joined('--unified', '$lines');

  /// Diffs by word rather than by line (`--word-diff`).
  GitCmd wordDiff() => token('--word-diff');

  /// Reverses the order of the commits (`--reverse`).
  GitCmd reverse() => token('--reverse');

  /// Follows a file through its renames (`--follow`).
  GitCmd follow() => token('--follow');

  /// Follows only the first parent of each merge (`--first-parent`).
  GitCmd firstParent() => token('--first-parent');

  /// Only the merge commits (`--merges`).
  GitCmd mergesOnly() => token('--merges');

  /// Everything but the merges (`--no-merges`).
  GitCmd noMerges() => token('--no-merges');

  /// Makes the paths relative to this directory (`--relative`).
  GitCmd relative(String path) => joined('--relative', path);

  /// Ends the revisions, so what follows is a path (`--`).
  ///
  /// What saves you when a branch and a file share a name.
  GitCmd separator() => token('--');

  /// Adds a revision: a branch, a tag, a commit id, a range.
  GitCmd ref(String value) => token(value);

  /// Adds a branch name.
  GitCmd branchName(String value) => token(value);

  /// Adds a remote name.
  GitCmd remoteName(String value) => token(value);

  /// Adds a path. Put [separator] first when it could be read as a revision.
  GitCmd path(String value) => token(value);

  /// Adds a bare argument, for the subcommands this wrapper has no named option for.
  GitCmd arg(String value) => token(value);
}

/// `git`, ready to take its first option.
// ignore: non_constant_identifier_names
GitCmd get Git => GitCmd();
