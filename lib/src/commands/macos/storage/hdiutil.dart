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

/// `hdiutil`, the DiskImages framework's command-line face: attaching,
/// creating, converting, verifying and burning disk images (`.dmg` and
/// friends). macOS only.
///
/// ```dart
/// final ShellResult attached = await Hdiutil.attach().nobrowse().readonly().image(path).plist().output();
/// await Hdiutil.detach().device('/dev/disk4').force().execute();
/// await Hdiutil.create().size('100m').fs('APFS').volname('Payload').plist().image('out.dmg').execute();
/// ```
///
/// "Attach" and "detach" are the disk-image analogues of a real disk's
/// connect/disconnect; "mount" and "unmount" are the filesystem-level
/// analogues, and the two pairs are not interchangeable — [mountvol] and
/// [unmount] act on a filesystem already inside an attached image, while
/// [attach] and [detach] act on the image itself. Prefer [plist] on anything
/// this wrapper's output will be parsed by, since the human-readable form is
/// consistent but not a documented format. [attach]'s output is stable
/// nonetheless: a `/dev` node, a tab, a content hint, a tab, and a mount
/// point, one line per mounted volume. A device attached with
/// [notRemovable] cannot be detached without a reboot; that flag needs root.
class HdiutilCmd extends CommandBuilder<HdiutilCmd> {
  @override
  final String executable = 'hdiutil';

  // Global / common options, valid across most verbs.

  /// Extra progress output and error diagnostics (`-verbose`).
  HdiutilCmd verbose() => token('-verbose');

  /// Closes stdout and stderr, leaving only the exit status (`-quiet`).
  /// Overridden by [verbose] and [debug].
  HdiutilCmd quiet() => token('-quiet');

  /// Maximum verbosity (`-debug`). Implies [verbose].
  HdiutilCmd debug() => token('-debug');

  /// Emits results as a plist rather than human-readable text (`-plist`).
  /// The documented way for another program to read `hdiutil`'s output.
  HdiutilCmd plist() => token('-plist');

  /// Emits progress output meant for another program to parse (`-puppetstrings`).
  HdiutilCmd puppetstrings() => token('-puppetstrings');

  /// A key/value pair for the disk image recognition system on the source
  /// image (`-srcimagekey`).
  HdiutilCmd srcImageKey(String key, String value) => pair('-srcimagekey', '$key=$value');

  /// A key/value pair applied to any image created (`-tgtimagekey`).
  HdiutilCmd tgtImageKey(String key, String value) => pair('-tgtimagekey', '$key=$value');

  /// A key/value pair for either the source or target image, whichever
  /// applies (`-imagekey`).
  HdiutilCmd imageKey(String key, String value) => pair('-imagekey', '$key=$value');

  /// The encryption algorithm to use: `AES-128` or `AES-256` (`-encryption`).
  /// Bare (no value) selects the default algorithm.
  HdiutilCmd encryption([String? algorithm]) =>
      algorithm == null ? token('-encryption') : pair('-encryption', algorithm);

  /// Reads a null-terminated passphrase from stdin, rather than prompting
  /// (`-stdinpass`). The secure replacement for the deprecated
  /// `-passphrase`, which leaks the password through `ps`.
  HdiutilCmd stdinPass() => token('-stdinpass');

  /// Forces prompting for a passphrase even when a public key is also given
  /// (`-agentpass`).
  HdiutilCmd agentPass() => token('-agentpass');

  /// A keychain holding the secret matching [certificate] (`-recover`).
  HdiutilCmd recover(String keychainFile) => pair('-recover', keychainFile);

  /// A secondary access certificate for an encrypted image, DER-encoded
  /// (`-certificate`).
  HdiutilCmd certificate(String certFile) => pair('-certificate', certFile);

  /// Public keys, by hexadecimal hash, to protect an image being created
  /// (`-pubkey`).
  HdiutilCmd pubkey(List<String> hashes) => joinedAll('-pubkey', hashes);

  /// A certificate authority certificate, PEM file or `c_rehash` directory
  /// (`-cacert`).
  HdiutilCmd cacert(String certOrDir) => pair('-cacert', certOrDir);

  /// Ignores SSL host validation failures (`-insecurehttp`).
  HdiutilCmd insecureHttp() => token('-insecurehttp');

  /// Redirects writes to a shadow file instead of the base image, or reads
  /// `image.shadow` when [path] is omitted (`-shadow`). Lets a read-only
  /// image be attached read/write without modifying the original.
  HdiutilCmd shadow([String? path]) => path == null ? token('-shadow') : pair('-shadow', path);

  // help

  /// Prints minimal usage information for every verb, or for one verb when
  /// [verb] is given (`help`).
  HdiutilCmd help([String? verb]) {
    token('help');
    return verb == null ? self : token(verb);
  }

  // attach / mount (a poorly-named synonym)

  /// Attaches a disk image as a device (`attach`).
  HdiutilCmd attach() => token('attach');

  /// Forces the resulting device to be read-only (`-readonly`).
  HdiutilCmd readonly() => token('-readonly');

  /// Attempts to override the framework's read-only decision (`-readwrite`).
  HdiutilCmd readwrite() => token('-readwrite');

  /// Attaches through a helper process, the default since 10.5 (`-nokernel`).
  HdiutilCmd nokernel() => token('-nokernel');

  /// Attaches without a helper process, failing if unsupported (`-kernel`).
  HdiutilCmd kernel() => token('-kernel');

  /// Prevents this image from being detached without a reboot; root only
  /// (`-notremovable`).
  HdiutilCmd notRemovable() => token('-notremovable');

  /// Whether filesystems in the image should mount: `required` (default),
  /// `optional` or `suppressed` (`-mount`).
  HdiutilCmd mount(String mode) => pair('-mount', mode);

  /// Suppresses mounting entirely, equivalent to `-mount suppressed`
  /// (`-nomount`).
  HdiutilCmd nomount() => token('-nomount');

  /// Mounts volumes under this directory instead of `/Volumes`
  /// (`-mountroot`).
  HdiutilCmd mountroot(String path) => pair('-mountroot', path);

  /// Like [mountroot], but the mount point name is randomized
  /// (`-mountrandom`).
  HdiutilCmd mountrandom(String path) => pair('-mountrandom', path);

  /// Mounts the (single) volume at this exact path instead of under
  /// `/Volumes` (`-mountpoint`).
  HdiutilCmd mountpoint(String path) => pair('-mountpoint', path);

  /// Hides any mounted volumes from applications like Finder (`-nobrowse`).
  HdiutilCmd nobrowse() => token('-nobrowse');

  /// Honours or ignores file owners on the attached filesystem: `on` or
  /// `off` (`-owners`).
  HdiutilCmd owners(String onOrOff) => pair('-owners', onOrOff);

  /// A key/value pair set on the device in the IOKit registry (`-drivekey`).
  HdiutilCmd driveKey(String key, String value) => pair('-drivekey', '$key=$value');

  /// Attaches only a subsection of the image, as `<offset>`, `<first-last>`
  /// or `<start,count>` in 0-based sectors (`-section`).
  HdiutilCmd section(String subspec) => pair('-section', subspec);

  /// Verifies (or, negated, skips verifying) the image before attaching
  /// (`-verify`/`-noverify`).
  HdiutilCmd verify([bool enabled = true]) => token(enabled ? '-verify' : '-noverify');

  /// Aborts (or, negated, ignores) bad checksums (`-ignorebadchecksums`/
  /// `-noignorebadchecksums`).
  HdiutilCmd ignoreBadChecksums([bool enabled = true]) =>
      token(enabled ? '-ignorebadchecksums' : '-noignorebadchecksums');

  /// Auto-opens (or, negated, does not open) mounted volumes in Finder
  /// (`-autoopen`/`-noautoopen`). Defaults to off.
  HdiutilCmd autoOpen([bool enabled = true]) => token(enabled ? '-autoopen' : '-noautoopen');

  /// Forces (or skips) automatic fsck before mounting (`-autofsck`/
  /// `-noautofsck`).
  HdiutilCmd autoFsck([bool enabled = true]) => token(enabled ? '-autofsck' : '-noautofsck');

  // detach / eject

  /// Detaches a disk image and terminates any associated process (`detach`).
  /// `eject` is a synonym for the same verb.
  HdiutilCmd detach() => token('detach');

  /// Ignores open files on mounted volumes when detaching (`-force`).
  HdiutilCmd force() => token('-force');

  /// The image, device (`disk1`, a mountpoint, or a `/dev` entry), depending
  /// on the verb.
  HdiutilCmd image(String pathOrDevice) => token(pathOrDevice);

  /// The `/dev` node or mountpoint to act on, an alias for [image] that
  /// reads clearer under `detach`/`unmount`.
  HdiutilCmd device(String devNodeOrMountpoint) => token(devNodeOrMountpoint);

  // create

  /// Creates a new image (`create`).
  HdiutilCmd create() => token('create');

  /// The image size, `mkfile`-style: `??b|??k|??m|??g|??t|??p|??e` (`-size`).
  HdiutilCmd size(String spec) => pair('-size', spec);

  /// The image size in 512-byte sectors (`-sectors`).
  HdiutilCmd sectors(String countOrMin) => pair('-sectors', countOrMin);

  /// The image size in megabytes (`-megabytes`).
  HdiutilCmd megabytes(int size) => pair('-megabytes', '$size');

  /// Copies a source directory's contents file-by-file into a fresh
  /// filesystem (`-srcfolder`). Repeatable.
  HdiutilCmd srcfolder(String source) => pair('-srcfolder', source);

  /// Uses the blocks of a device to create the image, matching its size
  /// (`-srcdevice`).
  HdiutilCmd srcdevice(String device) => pair('-srcdevice', device);

  /// The alignment, in bytes, of the final data partition (`-align`).
  /// Defaults to 4K.
  HdiutilCmd align(int bytes) => pair('-align', '$bytes');

  /// The type of empty read/write image to create: `UDIF` (default),
  /// `SPARSE` or `SPARSEBUNDLE` (`-type`).
  HdiutilCmd type(String value) => pair('-type', value);

  /// The filesystem to write: `HFS+`, `HFS+J`, `HFSX`, `JHFS+X`, `APFS`
  /// (default), `FAT32`, `ExFAT`, `UDF` and others (`-fs`).
  HdiutilCmd fs(String filesystem) => pair('-fs', filesystem);

  /// The name of the newly-created filesystem (`-volname`).
  HdiutilCmd volname(String name) => pair('-volname', name);

  /// The numeric owner of the new volume's root (`-uid`).
  HdiutilCmd uid(int userId) => pair('-uid', '$userId');

  /// The numeric group of the new volume's root (`-gid`).
  HdiutilCmd gid(int groupId) => pair('-gid', '$groupId');

  /// The octal mode of the new volume's root (`-mode`).
  HdiutilCmd mode(String octal) => pair('-mode', octal);

  /// Suppresses (or, negated, allows) automatic backwards-compatible
  /// stretchable volumes (`-autostretch`/`-noautostretch`).
  HdiutilCmd autostretch([bool enabled = true]) => token(enabled ? '-autostretch' : '-noautostretch');

  /// Initializes the filesystem so it can later be stretched on older
  /// systems, up to this maximum size (`-stretch`).
  HdiutilCmd stretch(String maxSize) => pair('-stretch', maxSize);

  /// Extra arguments passed through to the underlying `newfs` program
  /// (`-fsargs`).
  HdiutilCmd fsargs(String args) => pair('-fsargs', args);

  /// The partition layout, e.g. `GPTSPUD` (default), `SPUD`, `MBRSPUD`,
  /// `ISOCD`, or `NONE` for no partition map (`-layout`).
  HdiutilCmd layout(String value) => pair('-layout', value);

  /// An alternate layout library bundle, in place of MediaKit's default
  /// (`-library`).
  HdiutilCmd library(String bundle) => pair('-library', bundle);

  /// Changes the partition type of a single-partition image
  /// (`-partitionType`).
  HdiutilCmd partitionType(String value) => pair('-partitionType', value);

  /// Overwrites an existing output file, which otherwise fails
  /// (`-ov`).
  HdiutilCmd overwrite() => token('-ov');

  /// Attaches the newly-created image right away (`-attach`).
  HdiutilCmd attachAfterCreate() => token('-attach');

  /// The final image format when a source was given: any [convert] format
  /// (`-format`). Defaults to `UDZO`.
  HdiutilCmd format(String value) => pair('-format', value);

  // convert

  /// Converts an image to another format (`convert`).
  HdiutilCmd convert() => token('convert');

  /// Writes the result to this path (`-o`). Used by `convert`, `burn`'s
  /// `makehybrid`, and `segment`.
  HdiutilCmd outputFile(String path) => pair('-o', path);

  /// Adds (or, negated, omits) a partition map on conversion (`-pmap`/
  /// `-nopmap`).
  HdiutilCmd pmapFlag([bool enabled = true]) => token(enabled ? '-pmap' : '-nopmap');

  /// The number of threads used when compressing during conversion
  /// (`-tasks`).
  HdiutilCmd tasks(int count) => pair('-tasks', '$count');

  // burn

  /// Burns an image to optical media in an attached burner (`burn`).
  HdiutilCmd burn() => token('burn');

  /// The burning device to use, from [listDevices] (`-device`).
  HdiutilCmd burnDevice(String device) => pair('-device', device);

  /// Simulates a burn without turning on the laser (`-testburn`).
  HdiutilCmd testburn() => token('-testburn');

  /// Allows burning to devices not qualified by Apple (`-anydevice`).
  HdiutilCmd anydevice() => token('-anydevice');

  /// Ejects (or, negated, leaves in the drive) the disc after burning
  /// (`-eject`/`-noeject`). Defaults to ejecting.
  HdiutilCmd eject([bool enabled = true]) => token(enabled ? '-eject' : '-noeject');

  /// Verifies (or, negated, skips verifying) the disc after burning
  /// (`-verifyburn`/`-noverifyburn`). Defaults to verifying.
  HdiutilCmd verifyBurn([bool enabled = true]) => token(enabled ? '-verifyburn' : '-noverifyburn');

  /// The burn speed, an x-factor or `max` (default) (`-speed`).
  HdiutilCmd speed(String xFactorOrMax) => pair('-speed', xFactorOrMax);

  /// Calculates the disc space required without burning anything, in
  /// sectors (`-sizequery`).
  HdiutilCmd sizeQuery() => token('-sizequery');

  /// Prompts for media and quickly erases it before burning (`-erase`).
  HdiutilCmd erase() => token('-erase');

  /// Erases every sector of the disc, slower than [erase] (`-fullerase`).
  HdiutilCmd fullErase() => token('-fullerase');

  /// Lists burning devices with paths suitable for [burnDevice] (`-list`).
  HdiutilCmd listDevices() => token('-list');

  // makehybrid

  /// Generates a potentially-hybrid read-only filesystem image
  /// (`makehybrid`). Requires [outputFile] and a source via [image].
  HdiutilCmd makehybrid() => token('makehybrid');

  /// Includes an HFS+ filesystem in a `makehybrid` image (`-hfs`).
  HdiutilCmd hfs() => token('-hfs');

  /// Includes an ISO9660 Level 2 filesystem with Rock Ridge extensions in a
  /// `makehybrid` image (`-iso`).
  HdiutilCmd iso() => token('-iso');

  /// Includes Joliet extensions to ISO9660 in a `makehybrid` image
  /// (`-joliet`).
  HdiutilCmd joliet() => token('-joliet');

  /// Includes a UDF filesystem in a `makehybrid` image (`-udf`).
  HdiutilCmd udf() => token('-udf');

  /// The default volume name for every filesystem in a `makehybrid` image,
  /// unless overridden per-filesystem (`-default-volume-name`).
  HdiutilCmd defaultVolumeName(String name) => pair('-default-volume-name', name);

  // compact

  /// Reclaims unused space in a sparse (SPARSE/SPARSEBUNDLE) image
  /// (`compact`).
  HdiutilCmd compact() => token('compact');

  /// Allows compacting while running on battery power (`-batteryallowed`).
  HdiutilCmd batteryAllowed() => token('-batteryallowed');

  /// Allows idle sleep during compacting, which cancels the operation
  /// (`-sleepallowed`).
  HdiutilCmd sleepAllowed() => token('-sleepallowed');

  // resize

  /// Resizes a disk image or the container/filesystem within it (`resize`).
  HdiutilCmd resize() => token('resize');

  /// Resizes only the image file, not its partitions or filesystems
  /// (`-imageonly`).
  HdiutilCmd imageOnly() => token('-imageonly');

  /// Resizes only a partition/filesystem inside the image, not the image
  /// itself (`-partitiononly`).
  HdiutilCmd partitionOnly() => token('-partitiononly');

  /// Which 1-based partition to resize, UDIF images only (`-partitionID`).
  HdiutilCmd partitionId(int id) => pair('-partitionID', '$id');

  /// Allows resize to eliminate the trailing free partition entirely
  /// (`-nofinalgap`).
  HdiutilCmd noFinalGap() => token('-nofinalgap');

  /// Displays the minimum, current and maximum sizes without modifying the
  /// image (`-limits`).
  HdiutilCmd limits() => token('-limits');

  // verify / checksum / imageinfo / isencrypted / info / plugins / mountvol / unmount / pmap

  /// Computes and checks an image's checksum against its stored value
  /// (`verify`). Read/write images have no checksum and cannot be verified.
  HdiutilCmd verifyImage() => token('verify');

  /// Calculates a checksum of the image data: `CRC32`, `MD5`, `SHA`, `SHA1`,
  /// `SHA256`, `SHA384`, `SHA512`, `UDIF-CRC32` or `UDIF-MD5` (`checksum`
  /// with `-type`).
  HdiutilCmd checksum(String type) {
    token('checksum');
    return pair('-type', type);
  }

  /// Prints information about DiskImages.framework, the driver, and any
  /// attached images (`info`).
  HdiutilCmd info() => token('info');

  /// Prints information about a disk image (`imageinfo`).
  HdiutilCmd imageinfo() => token('imageinfo');

  /// Restricts [imageinfo] to just the image format (`-format` under
  /// `imageinfo`; same flag name as [format], scoped by verb).
  HdiutilCmd imageinfoFormat() => token('-format');

  /// Restricts [imageinfo] to just the checksum (`-checksum`).
  HdiutilCmd imageinfoChecksum() => token('-checksum');

  /// Prints whether an image is encrypted, with details if so
  /// (`isencrypted`).
  HdiutilCmd isEncrypted() => token('isencrypted');

  /// Prints information about DiskImages framework plugins (`plugins`).
  HdiutilCmd plugins() => token('plugins');

  /// Mounts the filesystem in a device via Disk Arbitration, re-mounting a
  /// volume [unmount] took offline (`mountvol`).
  HdiutilCmd mountvol() => token('mountvol');

  /// Unmounts a mounted volume without detaching its image (`unmount`).
  HdiutilCmd unmount() => token('unmount');

  /// Displays the partition map of an image or device (`pmap`).
  HdiutilCmd pmap() => token('pmap');

  /// A minimal `pmap` report: types, names and human-readable sizes
  /// (`-simple`).
  HdiutilCmd pmapSimple() => token('-simple');

  /// The default `pmap` report: adds offsets and 512-byte sectors
  /// (`-standard`).
  HdiutilCmd pmapStandard() => token('-standard');

  /// A comprehensive `pmap` report: end offsets, significant free space
  /// (`-complete`).
  HdiutilCmd pmapComplete() => token('-complete');

  /// A diagnostic `pmap` report covering every partition scheme encountered;
  /// useful for Boot Camp troubleshooting (`-diagnostic`).
  HdiutilCmd pmapDiagnostic() => token('-diagnostic');
}

/// `hdiutil`, ready to take its first verb.
// ignore: non_constant_identifier_names
HdiutilCmd get Hdiutil => HdiutilCmd();
