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

/// `rsync`, the file-copying tool that transfers only what changed between two
/// trees. The modern samba.org rsync, protocol 31, the 3.x line most Linux
/// distributions and Homebrew ship. Not the ancient BSD reimplementation macOS
/// bundles at `/usr/bin/rsync`, which answers `rsync --version` with `openrsync`
/// and is missing most of what this wrapper covers.
///
/// ```dart
/// await Rsync
///     .archive()
///     .compress()
///     .delete()
///     .source('build/')
///     .destination('user@host:/var/www/site/')
///     .execute();
/// ```
///
/// **A real transfer needs two paths, source then destination, added last.**
/// Everything else is an option; [source] and [destination] are the same
/// bare-argument method under two names, kept apart so a chain reads in the
/// order rsync expects.
///
/// **A trailing slash on the source directory changes what gets copied.**
/// `source('build')` copies the directory itself into the destination,
/// `source('build/')` copies its contents into the destination instead. The two
/// produce different trees on the far side, and nothing in the chain flags
/// which one was written.
///
/// **[delete] only removes what rsync actually walks into.** Without
/// [recursive] or [archive] in the same chain, rsync never descends far enough
/// to see what the destination holds that the source does not, and the option
/// is silently a no-op.
///
/// **Local and remote invocations are the same chain, a different path
/// string.** `source('/local/path')` and `destination('/other/local/path')`
/// copy on this machine; giving either one the `user@host:path` form turns the
/// same command into an rsync-over-ssh transfer, with [rsh] choosing the shell
/// and [rsyncPath] the remote binary. A double colon, `host::module`, or an
/// `rsync://` URL instead talks to an rsync daemon directly and bypasses the
/// remote shell entirely.
class RsyncCmd extends CommandBuilder<RsyncCmd> {
  @override
  final String executable = 'rsync';

  /// Archive mode, equivalent to `-rlptgoD` (`--archive`).
  RsyncCmd archive() => token('--archive');

  /// Recurses into directories (`--recursive`).
  RsyncCmd recursive() => token('--recursive');

  /// Sends full path names to the destination rather than just the final
  /// component (`--relative`).
  RsyncCmd relative() => token('--relative');

  /// With [relative], stops the implied parent directories from carrying their
  /// own permissions and times (`--no-implied-dirs`).
  RsyncCmd noImpliedDirs() => token('--no-implied-dirs');

  /// Renames a file about to be replaced or deleted instead of removing it
  /// (`--backup`).
  RsyncCmd backup() => token('--backup');

  /// Stores backups made by [backup] under this directory instead of beside
  /// the original (`--backup-dir`).
  RsyncCmd backupDir(String dir) => pair('--backup-dir', dir);

  /// Overrides the backup suffix, `~` by default (`--suffix`).
  RsyncCmd suffix(String value) => pair('--suffix', value);

  /// Skips a file that is newer on the destination than on the source
  /// (`--update`).
  RsyncCmd update() => token('--update');

  /// Writes changed data directly into the destination file instead of
  /// building a new copy alongside it (`--inplace`).
  ///
  /// A transfer interrupted midway leaves the destination file corrupt rather
  /// than untouched, which is the trade this option makes for skipping the
  /// temporary-file dance.
  RsyncCmd inplace() => token('--inplace');

  /// Appends the missing tail onto a destination file that is shorter than the
  /// source, without checksumming the part already there (`--append`).
  RsyncCmd append() => token('--append');

  /// Like [append], but checksums the existing data too before trusting it
  /// (`--append-verify`).
  RsyncCmd appendVerify() => token('--append-verify');

  /// Transfers a directory itself without recursing into it (`--dirs`).
  RsyncCmd dirs() => token('--dirs');

  /// Creates the missing leading directories of the destination path before
  /// transferring into it (`--mkpath`).
  RsyncCmd mkpath() => token('--mkpath');

  /// Copies symlinks as symlinks (`--links`).
  RsyncCmd links() => token('--links');

  /// Copies what a symlink points to instead of the symlink itself
  /// (`--copy-links`).
  RsyncCmd copyLinks() => token('--copy-links');

  /// Like [copyLinks], but only for symlinks that point outside the tree being
  /// copied; in-tree symlinks stay symlinks (`--copy-unsafe-links`).
  RsyncCmd copyUnsafeLinks() => token('--copy-unsafe-links');

  /// Silently drops any symlink that points outside the tree being copied
  /// (`--safe-links`).
  RsyncCmd safeLinks() => token('--safe-links');

  /// Rewrites transferred symlinks so they cannot be dereferenced without
  /// rsync's help, a daemon-side guard against a client planting a symlink
  /// that escapes the module (`--munge-links`).
  RsyncCmd mungeLinks() => token('--munge-links');

  /// Treats a symlink to a directory on the sending side as if it were the
  /// directory itself (`--copy-dirlinks`).
  RsyncCmd copyDirlinks() => token('--copy-dirlinks');

  /// Treats a symlink to a directory on the receiving side as if it were the
  /// directory itself, when one already exists there (`--keep-dirlinks`).
  RsyncCmd keepDirlinks() => token('--keep-dirlinks');

  /// Preserves hard links, linking the copies back together on the destination
  /// (`--hard-links`).
  ///
  /// Costs extra memory and an extra pass, since rsync has to notice which
  /// source files share an inode before it can send any of them.
  RsyncCmd hardLinks() => token('--hard-links');

  /// Preserves permission bits (`--perms`).
  RsyncCmd perms() => token('--perms');

  /// Preserves only the executable bits, leaving the rest of the permissions
  /// alone (`--executability`).
  RsyncCmd executability() => token('--executability');

  /// Preserves ACLs, and implies [perms] (`--acls`).
  RsyncCmd acls() => token('--acls');

  /// Preserves extended attributes (`--xattrs`).
  RsyncCmd xattrs() => token('--xattrs');

  /// Applies a chmod-style rule to the permissions of transferred files, after
  /// every other permission option has run (`--chmod`).
  RsyncCmd chmod(String value) => pair('--chmod', value);

  /// Preserves the owner, which only takes effect when rsync is run as the
  /// super-user or under [asSuperUser]/[fakeSuper] (`--owner`).
  RsyncCmd owner() => token('--owner');

  /// Preserves the group (`--group`).
  RsyncCmd group() => token('--group');

  /// Preserves device files, super-user only (`--devices`).
  RsyncCmd devices() => token('--devices');

  /// Preserves special files: sockets and FIFOs (`--specials`).
  RsyncCmd specials() => token('--specials');

  /// Shorthand for [devices] and [specials] together (`-D`).
  RsyncCmd devicesAndSpecials() => token('-D');

  /// Preserves modification times (`--times`).
  ///
  /// Turning this off makes every later run treat every file as changed,
  /// since rsync's quick check leans on mod-time alongside size.
  RsyncCmd times() => token('--times');

  /// Preserves access times (`--atimes`).
  RsyncCmd atimes() => token('--atimes');

  /// Opens files with `O_NOATIME`, so reading them for the transfer does not
  /// itself change the access time [atimes] is trying to preserve
  /// (`--open-noatime`).
  RsyncCmd openNoAtime() => token('--open-noatime');

  /// Preserves creation times, on the filesystems that record one
  /// (`--crtimes`).
  RsyncCmd crtimes() => token('--crtimes');

  /// Skips setting times on directories (`--omit-dir-times`).
  RsyncCmd omitDirTimes() => token('--omit-dir-times');

  /// Skips setting times on symlinks (`--omit-link-times`).
  RsyncCmd omitLinkTimes() => token('--omit-link-times');

  /// Detects runs of zeroes and skips writing them, so a sparse destination
  /// file stays sparse (`--sparse`).
  RsyncCmd sparse() => token('--sparse');

  /// Preallocates a destination file to its final size before writing it
  /// (`--preallocate`).
  RsyncCmd preallocate() => token('--preallocate');

  /// Attempts privileged operations, owner and device files among them, even
  /// when not actually running as the super-user (`--super`).
  RsyncCmd asSuperUser() => token('--super');

  /// Like [asSuperUser], but records what a real super-user could not
  /// actually apply as extended attributes instead, so an unprivileged run can
  /// still produce a faithful backup (`--fake-super`).
  RsyncCmd fakeSuper() => token('--fake-super');

  /// Deletes files from the destination that are no longer on the source
  /// (`--delete`).
  ///
  /// See the class-level note: this only reaches directories that
  /// [recursive] or [archive] actually walks into.
  RsyncCmd delete() => token('--delete');

  /// Like [delete], but performed before the transfer starts rather than
  /// alongside it (`--delete-before`).
  RsyncCmd deleteBefore() => token('--delete-before');

  /// Like [delete], deletions interleaved with the transfer as each directory
  /// is finished, which is the default timing (`--delete-during`).
  RsyncCmd deleteDuring() => token('--delete-during');

  /// Like [delete], deletions computed during the transfer but held until it
  /// finishes (`--delete-delay`).
  RsyncCmd deleteDelay() => token('--delete-delay');

  /// Like [delete], but performed after the transfer completes
  /// (`--delete-after`).
  RsyncCmd deleteAfter() => token('--delete-after');

  /// Also deletes destination files that were excluded from the transfer by a
  /// filter rule (`--delete-excluded`).
  RsyncCmd deleteExcluded() => token('--delete-excluded');

  /// Skips a missing source argument instead of raising an error
  /// (`--ignore-missing-args`).
  RsyncCmd ignoreMissingArgs() => token('--ignore-missing-args');

  /// Like [ignoreMissingArgs], and also deletes the corresponding destination
  /// entry when a source argument is missing (`--delete-missing-args`).
  RsyncCmd deleteMissingArgs() => token('--delete-missing-args');

  /// Lets a deletion option keep going even after an I/O error
  /// (`--ignore-errors`).
  RsyncCmd ignoreErrors() => token('--ignore-errors');

  /// Deletes a non-empty directory that needs to be replaced, rather than
  /// refusing (`--force`).
  RsyncCmd force() => token('--force');

  /// Refuses to delete more than this many files or directories, a safety
  /// valve against a filter mistake wiping the destination
  /// (`--max-delete`).
  RsyncCmd maxDelete(String value) => pair('--max-delete', value);

  /// Skips a source file larger than this size (`--max-size`).
  RsyncCmd maxSize(String value) => pair('--max-size', value);

  /// Skips a source file smaller than this size (`--min-size`).
  RsyncCmd minSize(String value) => pair('--min-size', value);

  /// Caps the size of a single memory allocation rsync will make
  /// (`--max-alloc`).
  RsyncCmd maxAlloc(String value) => pair('--max-alloc', value);

  /// Keeps a partially transferred file instead of deleting it, so a later run
  /// can resume from it (`--partial`).
  RsyncCmd partial() => token('--partial');

  /// Puts a partial file made by [partial] under this directory instead of
  /// beside its destination (`--partial-dir`).
  RsyncCmd partialDir(String dir) => pair('--partial-dir', dir);

  /// Shorthand for [partial] and [progress] together (`-P`).
  RsyncCmd partialProgress() => token('-P');

  /// Stages every updated file in a temporary area and moves them into place
  /// only once the whole transfer has finished (`--delay-updates`).
  RsyncCmd delayUpdates() => token('--delay-updates');

  /// Removes an empty directory chain from the file list instead of creating
  /// it on the destination (`--prune-empty-dirs`).
  RsyncCmd pruneEmptyDirs() => token('--prune-empty-dirs');

  /// Keeps uid and gid as numbers instead of mapping them through user and
  /// group names, which matters when the two machines do not share the same
  /// accounts (`--numeric-ids`).
  RsyncCmd numericIds() => token('--numeric-ids');

  /// Remaps a transferred file's owner by name, `FROM1:TO1,FROM2:TO2`
  /// (`--usermap`).
  RsyncCmd usermap(List<String> mappings) => joinedAll('--usermap', mappings);

  /// Remaps a transferred file's group by name, the same shape as [usermap]
  /// (`--groupmap`).
  RsyncCmd groupmap(List<String> mappings) => joinedAll('--groupmap', mappings);

  /// Sets every transferred file's owner and group to `USER:GROUP`, a
  /// shorthand over [usermap] and [groupmap] (`--chown`).
  RsyncCmd chown(String userGroup) => pair('--chown', userGroup);

  /// Puts in-progress temporary files under this directory instead of beside
  /// their destination (`--temp-dir`).
  RsyncCmd tempDir(String dir) => pair('--temp-dir', dir);

  /// Re-checks every file's contents even when its size and mod-time already
  /// match, the opposite bias of [sizeOnly] (`--ignore-times`).
  RsyncCmd ignoreTimes() => token('--ignore-times');

  /// Skips a file whenever its size matches, ignoring mod-time entirely
  /// (`--size-only`).
  RsyncCmd sizeOnly() => token('--size-only');

  /// Allows this many seconds of slack when comparing mod-times, needed
  /// against filesystems with coarse timestamp resolution such as FAT's two
  /// seconds (`--modify-window`).
  RsyncCmd modifyWindow(String value) => pair('--modify-window', value);

  /// Excludes the same files CVS would, reading `.cvsignore` and the usual
  /// built-in patterns (`--cvs-exclude`).
  RsyncCmd cvsExclude() => token('--cvs-exclude');

  /// Excludes files matching this pattern (`--exclude`).
  RsyncCmd exclude(String pattern) => pair('--exclude', pattern);

  /// Reads patterns to [exclude] from a file, one per line (`--exclude-from`).
  RsyncCmd excludeFrom(String path) => pair('--exclude-from', path);

  /// Overrides a broader [exclude] for files matching this pattern
  /// (`--include`).
  RsyncCmd include(String pattern) => pair('--include', pattern);

  /// Reads patterns to [include] from a file, one per line (`--include-from`).
  RsyncCmd includeFrom(String path) => pair('--include-from', path);

  /// Reads the list of source files to transfer from a file, one per line,
  /// instead of walking the source tree (`--files-from`).
  RsyncCmd filesFrom(String path) => pair('--files-from', path);

  /// Separates entries in [filesFrom], [excludeFrom] and [includeFrom] with a
  /// NUL byte instead of a newline, so a name containing a newline stays intact
  /// (`--from0`).
  RsyncCmd from0() => token('--from0');

  /// Adds one general-purpose filtering rule; [exclude] and [include] are
  /// shorthand for the common cases this can express directly (`--filter`).
  RsyncCmd filter(String rule) => pair('--filter', rule);

  /// Merges the per-directory `.rsync-filter` files found while walking the
  /// tree (`-F`).
  ///
  /// Given twice, it also excludes `.rsync-filter` itself from the transfer,
  /// which is the usual way it is written; call this method twice for that.
  RsyncCmd filterShorthand() => token('-F');

  /// Only updates a destination file that already exists there, never creates
  /// a new one (`--existing`).
  RsyncCmd existing() => token('--existing');

  /// Only creates a destination file that is missing there, never updates one
  /// that already exists (`--ignore-existing`).
  RsyncCmd ignoreExisting() => token('--ignore-existing');

  /// Removes each source file once it has been transferred successfully;
  /// never removes a directory (`--remove-source-files`).
  RsyncCmd removeSourceFiles() => token('--remove-source-files');

  /// Refuses to cross into a different filesystem while recursing
  /// (`--one-file-system`).
  RsyncCmd oneFileSystem() => token('--one-file-system');

  /// Compresses file data for the transfer (`--compress`).
  RsyncCmd compress() => token('--compress');

  /// Sets the compression level explicitly (`--compress-level`).
  RsyncCmd compressLevel(String value) => pair('--compress-level', value);

  /// Skips compressing files whose suffix is in this list, for formats that
  /// are already compressed, `gz,jpg,mp4` and the like (`--skip-compress`).
  RsyncCmd skipCompress(List<String> suffixes) => joinedAll('--skip-compress', suffixes);

  /// Sends whole files instead of running the delta-transfer algorithm, the
  /// right choice once both sides are local and the network cost the
  /// algorithm saves does not exist (`--whole-file`).
  RsyncCmd wholeFile() => token('--whole-file');

  /// Compares files by checksum instead of by size and mod-time, catching a
  /// change that left the mod-time untouched at the cost of reading every byte
  /// on both sides (`--checksum`).
  RsyncCmd checksum() => token('--checksum');

  /// Picks the checksum algorithm (`--checksum-choice`).
  RsyncCmd checksumChoice(String value) => pair('--checksum-choice', value);

  /// Fixes the block size the delta-transfer algorithm uses, rather than
  /// letting rsync choose one from the file size (`--block-size`).
  RsyncCmd blockSize(String value) => pair('--block-size', value);

  /// Fixes the checksum seed, mostly so a batch written by [writeBatch] stays
  /// byte-identical across runs (`--checksum-seed`).
  RsyncCmd checksumSeed(String value) => pair('--checksum-seed', value);

  /// Caps socket I/O bandwidth (`--bwlimit`).
  RsyncCmd bwlimit(String value) => pair('--bwlimit', value);

  /// Sets stdout's buffering mode, `N` none, `L` line, `B` block
  /// (`--outbuf`).
  RsyncCmd outputBuffering(String value) => pair('--outbuf', value);

  /// The remote shell to run rsync over, `ssh -p 2222` and the like
  /// (`--rsh`).
  ///
  /// Only has an effect paired with a `user@host:path` source or destination;
  /// a purely local chain never opens a shell to ignore.
  RsyncCmd rsh(String command) => pair('--rsh', command);

  /// The rsync binary to run on the far end of [rsh], needed when it is not on
  /// that account's `$PATH` (`--rsync-path`).
  RsyncCmd rsyncPath(String value) => pair('--rsync-path', value);

  /// Sends this option to the remote-side rsync only, for the options where a
  /// local one would otherwise apply to both ends at once
  /// (`--remote-option`).
  RsyncCmd remoteOption(String value) => pair('--remote-option', value);

  /// The port to use when talking to an rsync daemon (`--port`).
  RsyncCmd port(String value) => pair('--port', value);

  /// The local address to bind before connecting to a daemon (`--address`).
  RsyncCmd address(String value) => pair('--address', value);

  /// Custom TCP socket options for the daemon connection (`--sockopts`).
  RsyncCmd sockopts(String value) => pair('--sockopts', value);

  /// Uses blocking I/O for the remote shell, which some `rsh` variants need
  /// (`--blocking-io`).
  RsyncCmd blockingIo() => token('--blocking-io');

  /// Gives up after this many seconds without any I/O (`--timeout`).
  RsyncCmd timeout(String value) => pair('--timeout', value);

  /// Gives up waiting to connect to a daemon after this many seconds
  /// (`--contimeout`).
  RsyncCmd contimeout(String value) => pair('--contimeout', value);

  /// Forces an older protocol version, for talking to an old rsync
  /// (`--protocol`).
  RsyncCmd protocol(String value) => pair('--protocol', value);

  /// Prefers IPv4 (`--ipv4`).
  RsyncCmd ipv4() => token('--ipv4');

  /// Prefers IPv6 (`--ipv6`).
  RsyncCmd ipv6() => token('--ipv6');

  /// Increases verbosity; repeat for more detail (`--verbose`).
  RsyncCmd verbose() => token('--verbose');

  /// Selects which informational messages print, `progress2` and the like
  /// (`--info`). Pass `help` to have rsync itself list the available flags.
  RsyncCmd info(String value) => pair('--info', value);

  /// Selects which debug messages print, the same shape as [info]
  /// (`--debug`).
  RsyncCmd debug(String value) => pair('--debug', value);

  /// Suppresses every non-error message (`--quiet`).
  RsyncCmd quiet() => token('--quiet');

  /// Prints a one-line change summary for every file touched, even without
  /// [verbose] (`--itemize-changes`).
  RsyncCmd itemizeChanges() => token('--itemize-changes');

  /// A custom per-file output format, using rsync's own escape sequences
  /// (`--out-format`).
  RsyncCmd outFormat(String value) => pair('--out-format', value);

  /// Logs activity to this file in addition to the console (`--log-file`).
  RsyncCmd logFile(String path) => pair('--log-file', path);

  /// The per-file format used inside [logFile], independent of [outFormat]
  /// (`--log-file-format`).
  RsyncCmd logFileFormat(String value) => pair('--log-file-format', value);

  /// Prints sizes with digit grouping and unit suffixes (`--human-readable`).
  ///
  /// rsync overloads the short form: bare `-h` means this everywhere except
  /// when it is the only argument on the command line, where it means [help]
  /// instead. This wrapper always emits the long flag, so which one runs never
  /// depends on where it sits in the chain.
  RsyncCmd humanReadable() => token('--human-readable');

  /// Shows per-file transfer progress (`--progress`).
  RsyncCmd progress() => token('--progress');

  /// Prints a summary of the transfer once it finishes (`--stats`).
  RsyncCmd stats() => token('--stats');

  /// Leaves high-bit characters unescaped in output instead of showing them as
  /// `\#nnn` (`--8-bit-output`).
  RsyncCmd eightBitOutput() => token('--8-bit-output');

  /// Lists what would be transferred instead of transferring it, turning the
  /// command into an `ls`-like listing (`--list-only`).
  RsyncCmd listOnly() => token('--list-only');

  /// Performs a trial run: reports what would happen without changing
  /// anything on the destination (`--dry-run`).
  ///
  /// Pair with [verbose] or [itemizeChanges], since a silent dry run reports
  /// nothing at all.
  RsyncCmd dryRun() => token('--dry-run');

  /// Prints the version and exits (`--version`).
  RsyncCmd version() => token('--version');

  /// Prints the help text and exits (`--help`).
  ///
  /// See the note on [humanReadable]: rsync's `-h` means this only when it is
  /// the sole argument on the line, and means [humanReadable] otherwise.
  /// Emitting the long flag here sidesteps the ambiguity rather than leaning on
  /// argument position.
  RsyncCmd help() => token('--help');

  /// Runs as an rsync daemon instead of a client (`--daemon`).
  RsyncCmd daemon() => token('--daemon');

  /// An alternate `rsyncd.conf` to read in [daemon] mode (`--config`).
  RsyncCmd config(String path) => pair('--config', path);

  /// Suppresses the daemon's message-of-the-day banner (`--no-motd`).
  RsyncCmd noMotd() => token('--no-motd');

  /// Reads the daemon-access password from a file instead of prompting for one
  /// (`--password-file`).
  RsyncCmd passwordFile(String path) => pair('--password-file', path);

  /// Feeds a file to the remote shell command's stdin before the rsync
  /// protocol starts (`--early-input`).
  RsyncCmd earlyInput(String path) => pair('--early-input', path);

  /// Uses the protocol-level argument-passing scheme instead of building a
  /// remote shell command line, so a filename with shell metacharacters is
  /// never re-interpreted by the far end's shell (`--secluded-args`).
  RsyncCmd secludedArgs() => token('--secluded-args');

  /// Disables [secludedArgs]-style protection and builds the classic remote
  /// shell command line, for an old remote rsync that chokes on the newer
  /// scheme (`--old-args`).
  RsyncCmd oldArgs() => token('--old-args');

  /// Trusts a remote sender's file list without rsync's usual sanity checks,
  /// for interoperating with a modified rsync build (`--trust-sender`).
  RsyncCmd trustSender() => token('--trust-sender');

  /// Runs as though invoked by this user, and optionally group,
  /// `USER` or `USER:GROUP`; root only (`--copy-as`).
  RsyncCmd copyAs(String value) => pair('--copy-as', value);

  /// Chooses which messages go to stderr versus stdout, `e`, `a` or `c`
  /// (`--stderr`).
  RsyncCmd stderr(String value) => pair('--stderr', value);

  /// Calls fsync on every file after writing it (`--fsync`).
  RsyncCmd fsync() => token('--fsync');

  /// When no destination file exists to use as a delta basis, looks for a
  /// similarly named one nearby instead of transferring the whole file
  /// (`--fuzzy`).
  RsyncCmd fuzzy() => token('--fuzzy');

  /// Also compares against files under this directory, without copying or
  /// linking an unchanged match (`--compare-dest`).
  RsyncCmd compareDest(String dir) => pair('--compare-dest', dir);

  /// Like [compareDest], but copies an unchanged match from that directory
  /// instead of retransferring it (`--copy-dest`).
  RsyncCmd copyDest(String dir) => pair('--copy-dest', dir);

  /// Like [compareDest], but hard-links an unchanged match from that directory
  /// instead of retransferring it (`--link-dest`).
  RsyncCmd linkDest(String dir) => pair('--link-dest', dir);

  /// Converts filenames between character sets across the transfer
  /// (`--iconv`).
  RsyncCmd iconv(String value) => pair('--iconv', value);

  /// Records the update as a batch file that can be replayed elsewhere
  /// (`--write-batch`).
  RsyncCmd writeBatch(String path) => pair('--write-batch', path);

  /// Like [writeBatch], but does not update the destination itself
  /// (`--only-write-batch`).
  RsyncCmd onlyWriteBatch(String path) => pair('--only-write-batch', path);

  /// Applies a batch file previously made by [writeBatch] (`--read-batch`).
  RsyncCmd readBatch(String path) => pair('--read-batch', path);

  /// Stops rsync after this many minutes have elapsed (`--stop-after`).
  RsyncCmd stopAfter(String minutes) => pair('--stop-after', minutes);

  /// Stops rsync at this point in time, `y-m-dTh:m` (`--stop-at`).
  RsyncCmd stopAt(String timestamp) => pair('--stop-at', timestamp);

  /// A local path or a `user@host:path`, added as the transfer's source.
  RsyncCmd source(String value) => token(value);

  /// A local path or a `user@host:path`, added as the transfer's destination.
  ///
  /// Add it last: rsync reads whichever path arrives after [source] as the
  /// destination, and there is only ever one of each.
  RsyncCmd destination(String value) => token(value);

  /// Adds a bare argument, an escape hatch for anything this wrapper has no
  /// named method for.
  RsyncCmd arg(String value) => token(value);
}

/// `rsync`, ready to take its first option.
// ignore: non_constant_identifier_names
RsyncCmd get Rsync => RsyncCmd();
