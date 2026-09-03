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

/// `tmutil`, the command-line face of Time Machine: configuring
/// destinations, driving backups, and inspecting or restoring what is
/// already there. macOS only.
///
/// ```dart
/// final ShellResult last = await Tmutil.latestBackup().asRoot().output();
/// await Tmutil.startBackup().block().asRoot().execute();
/// ```
///
/// Most verbs need both root and Full Disk Access for the calling terminal
/// (Privacy & Security → Full Disk Access); [latestBackup], [listBackups],
/// [machineDirectory] and [isExcluded] are the readable exceptions, and even
/// those still want root in practice once Full Disk Access is not granted.
/// [asRoot] only ever adds `sudo`, never the TCC grant, so a script that
/// fails with a permissions error despite running as root is missing Full
/// Disk Access, not privilege.
///
/// The subcommand comes first, then its options, and several single letters
/// are reused with unrelated meanings across verbs the way `security`'s are:
/// `-v` means "verbose" for [restore] and "volume exclusion" for
/// [addExclusion], `-d` takes a mount point for [latestBackup] but is a bare
/// "compare data forks" flag under [compare]. Distinct methods exist for
/// each so the collision never shows up in a chain.
class TmutilCmd extends CommandBuilder<TmutilCmd> {
  @override
  final String executable = 'tmutil';

  // --- Verbs ---------------------------------------------------------

  /// Adds to, or replaces, the list of backup destinations (`setdestination`).
  /// Requires root and Full Disk Access.
  TmutilCmd setDestination() => token('setdestination');

  /// Prints the configured backup destinations: name, kind, URL, mount
  /// point and ID (`destinationinfo`).
  TmutilCmd destinationInfo() => token('destinationinfo');

  /// Sets a destination's quota, in gigabytes (`setquota`). Takes the
  /// destination ID and the quota as [arg]s. Requires root and Full Disk
  /// Access.
  TmutilCmd setQuota() => token('setquota');

  /// Removes a destination by ID (`removedestination`). Requires root and
  /// Full Disk Access.
  TmutilCmd removeDestination() => token('removedestination');

  /// Excludes a file, directory or volume from future backups
  /// (`addexclusion`). See [fixedPath] and [volumeExclusion] for the two
  /// non-default exclusion kinds.
  TmutilCmd addExclusion() => token('addexclusion');

  /// Reverses [addExclusion] (`removeexclusion`).
  TmutilCmd removeExclusion() => token('removeexclusion');

  /// Reports whether an item is excluded from backups (`isexcluded`).
  TmutilCmd isExcluded() => token('isexcluded');

  /// Turns on automatic backups (`enable`). Requires root and Full Disk
  /// Access.
  TmutilCmd enable() => token('enable');

  /// Turns off automatic backups (`disable`). Requires root and Full Disk
  /// Access.
  TmutilCmd disable() => token('disable');

  /// Starts a backup if one is not already running (`startbackup`).
  TmutilCmd startBackup() => token('startbackup');

  /// Cancels a backup in progress (`stopbackup`).
  TmutilCmd stopBackup() => token('stopbackup');

  /// Diffs the computer against a backup, or two backups against each other
  /// (`compare`). With no path arguments, compares against the latest
  /// backup.
  TmutilCmd compare() => token('compare');

  /// Verifies the checksums Time Machine recorded for files copied into a
  /// backup (`verifychecksums`). Only meaningful for backups made since OS X
  /// 10.11.
  TmutilCmd verifyChecksums() => token('verifychecksums');

  /// Restores an item out of a backup to a destination, `cp`-style
  /// (`restore`). Takes one or more source paths followed by a destination
  /// as [arg]s. May require root and Full Disk Access.
  TmutilCmd restore() => token('restore');

  /// Deletes backups by timestamp, or a specific path within one
  /// (`delete`). Requires root and Full Disk Access.
  TmutilCmd delete() => token('delete');

  /// Deletes every in-progress backup for a machine directory
  /// (`deleteinprogress`). On APFS, reverts the destination to the last
  /// completed backup. Requires root and Full Disk Access.
  TmutilCmd deleteInProgress() => token('deleteinprogress');

  /// Lists the computer's most recent completed backup (`latestbackup`).
  TmutilCmd latestBackup() => token('latestbackup');

  /// Lists every completed backup for the computer (`listbackups`).
  TmutilCmd listBackups() => token('listbackups');

  /// Prints the path to the current machine directory (`machinedirectory`).
  TmutilCmd machineDirectory() => token('machinedirectory');

  /// Analyzes the backups in an HFS+ machine directory and reports the
  /// average change between them (`calculatedrift`).
  TmutilCmd calculateDrift() => token('calculatedrift');

  /// Reports how much of a backed-up path exists only in that one backup,
  /// not shared with any other (`uniquesize`).
  TmutilCmd uniqueSize() => token('uniquesize');

  /// Claims a machine directory or sparsebundle for this machine
  /// (`inheritbackup`). Requires root and Full Disk Access.
  TmutilCmd inheritBackup() => token('inheritbackup');

  /// Rebinds a volume store to a local disk after the disk was erased and
  /// restored outside Time Machine, so the backup history is not lost
  /// (`associatedisk`). Requires root and Full Disk Access.
  TmutilCmd associateDisk() => token('associatedisk');

  /// Creates a local APFS snapshot of every volume in the backup set
  /// (`localsnapshot`).
  TmutilCmd localSnapshot() => token('localsnapshot');

  /// Lists the local snapshots of a volume (`listlocalsnapshots`). Takes
  /// the mount point as an [arg].
  TmutilCmd listLocalSnapshots() => token('listlocalsnapshots');

  /// Lists the creation dates of every local snapshot, `YYYY-MM-DD-HHMMSS`
  /// (`listlocalsnapshotdates`).
  TmutilCmd listLocalSnapshotDates() => token('listlocalsnapshotdates');

  /// Deletes the local snapshots for a disk, or every disk's snapshot for a
  /// given date (`deletelocalsnapshots`).
  TmutilCmd deleteLocalSnapshots() => token('deletelocalsnapshots');

  /// Thins local snapshots for a volume to reclaim space, optionally to a
  /// target byte amount at a given urgency, 1 to 4 (`thinlocalsnapshots`).
  TmutilCmd thinLocalSnapshots() => token('thinlocalsnapshots');

  // --- setdestination ---------------------------------------------------

  /// Adds the given destination rather than replacing the list
  /// (`setdestination -a`).
  TmutilCmd addToList() => token('-a');

  /// Prompts for the destination password at a non-echoing prompt instead
  /// of taking it inline in the URL (`setdestination -p`). Keeps the
  /// password out of `ps`.
  TmutilCmd promptForPassword() => token('-p');

  // --- addexclusion / removeexclusion ------------------------------------

  /// Targets a fixed path rather than the default location-independent
  /// exclusion (`addexclusion -p` / `removeexclusion -p`). Requires root and
  /// Full Disk Access.
  TmutilCmd fixedPath() => token('-p');

  /// Targets a volume, tracked by file system UUID, rather than a file or
  /// directory (`addexclusion -v` / `removeexclusion -v`). The only
  /// supported way to exclude or include a whole volume. Requires root and
  /// Full Disk Access.
  TmutilCmd volumeExclusion() => token('-v');

  // --- destinationinfo / isexcluded / compare (shared) -------------------

  /// Prints the result as an XML property list (`-X`). Shared by
  /// [destinationInfo], [isExcluded] and [compare].
  TmutilCmd asXml() => token('-X');

  // --- startbackup ---------------------------------------------------

  /// Runs the backup the way a system-scheduled one would (`--auto`).
  TmutilCmd auto() => token('--auto');

  /// Blocks until the backup finishes before returning (`--block`).
  TmutilCmd block() => token('--block');

  /// Allows Time Machine to rotate to a different destination during this
  /// backup (`--rotation`).
  TmutilCmd rotation() => token('--rotation');

  /// Backs up to this destination ID specifically (`--destination`).
  TmutilCmd toDestination(String destinationId) => pair('--destination', destinationId);

  // --- compare -------------------------------------------------------

  /// Compares every supported metadata field (`compare -a`).
  TmutilCmd compareAll() => token('-a');

  /// Compares no metadata at all, path presence only (`compare -n`).
  TmutilCmd compareNone() => token('-n');

  /// Compares extended attributes (`compare -@`).
  TmutilCmd compareExtendedAttributes() => token('-@');

  /// Compares creation times (`compare -c`).
  TmutilCmd compareCreationTimes() => token('-c');

  /// Compares file data forks (`compare -d`).
  TmutilCmd compareDataForks() => token('-d');

  /// Compares ACLs (`compare -e`).
  TmutilCmd compareAcls() => token('-e');

  /// Compares file flags (`compare -f`).
  TmutilCmd compareFileFlags() => token('-f');

  /// Compares GIDs (`compare -g`).
  TmutilCmd compareGids() => token('-g');

  /// Compares file modes (`compare -m`).
  TmutilCmd compareModes() => token('-m');

  /// Compares sizes (`compare -s`).
  TmutilCmd compareSizes() => token('-s');

  /// Compares modification times (`compare -t`).
  TmutilCmd compareModificationTimes() => token('-t');

  /// Compares UIDs (`compare -u`).
  TmutilCmd compareUids() => token('-u');

  /// Limits traversal to this many levels deep (`compare -D`).
  TmutilCmd compareDepth(int levels) => pair('-D', '$levels');

  /// Ignores backup exclusions when comparing items inside a volume
  /// (`compare -E`).
  TmutilCmd compareIgnoringExclusions() => token('-E');

  /// Skips any path component matching this name during traversal
  /// (`compare -I`). Repeatable.
  TmutilCmd compareIgnorePathComponent(String name) => pair('-I', name);

  /// Ignores volume UUIDs when comparing a local volume directly to a
  /// volume store (`compare -U`).
  TmutilCmd compareIgnoreVolumeUuid() => token('-U');

  // --- latestbackup / listbackups / delete -------------------------------

  /// Lists backups from this destination volume rather than the default
  /// (`-d`). Shared by [latestBackup], [listBackups] and, as the disk to
  /// delete from, [delete].
  TmutilCmd fromDestination(String mountPoint) => pair('-d', mountPoint);

  /// Attempts to mount the matched backups and list their mounted paths
  /// (`-m`). Shared by [latestBackup] and [listBackups].
  TmutilCmd mountBackups() => token('-m');

  /// Prints only the backup timestamp rather than the full name or path
  /// (`-t`). Shared by [latestBackup] and [listBackups]; requires
  /// [mountBackups] on [latestBackup].
  TmutilCmd timestampOnly() => token('-t');

  // --- delete ----------------------------------------------------------

  /// Deletes the backup with this timestamp (`delete -t`). Repeatable to
  /// delete several.
  TmutilCmd atTimestamp(String timestamp) => pair('-t', timestamp);

  /// Under [delete], limits the deletion to this specific path within the
  /// matched backups, HFS+ destinations only (`delete -p`).
  TmutilCmd atPath(String path) => pair('-p', path);

  // --- restore -----------------------------------------------------------

  /// Reports progress while restoring (`restore -v`).
  TmutilCmd verboseRestore() => token('-v');

  // --- associatedisk -------------------------------------------------

  /// Associates every volume store in the machine directory matching the
  /// given one's identity, not just the one named (`associatedisk -a`).
  TmutilCmd allMatching() => token('-a');

  // --- generic ---------------------------------------------------------

  /// A bare argument: a destination URL, a backup or item path, a quota in
  /// gigabytes, a destination ID, a machine directory, or anything else a
  /// verb takes positionally.
  TmutilCmd arg(String value) => token(value);
}

/// `tmutil`, ready to take its verb.
// ignore: non_constant_identifier_names
TmutilCmd get Tmutil => TmutilCmd();
