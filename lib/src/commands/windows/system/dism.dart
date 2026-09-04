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

/// `dism`, Deployment Image Servicing and Management: installs, uninstalls,
/// configures and updates Windows features, packages, drivers and settings —
/// against the running OS ([online]) or an offline `.wim`/`.vhd`/`.vhdx`/
/// `.ffu` image ([image]). Windows only, and needs an elevated
/// (Administrators-group) prompt.
///
/// ```dart
/// final ShellResult mounted = await Dism.image(r'C:\test\offline').getFeatures().output();
///
/// await Dism
///     .online()
///     .enableFeature()
///     .featureName('TFTP')
///     .all()
///     .asRoot()
///     .execute();
///
/// await Dism.mountImage().imageFile(r'C:\wim\install.wim').index('1').mountDir(r'C:\mnt').asRoot().execute();
/// // ... service the mounted files under C:\mnt ...
/// await Dism.unmountImage().mountDir(r'C:\mnt').commit().asRoot().execute();
/// ```
///
/// **Every command needs [online] or [image] first** — `dism` refuses to run
/// without knowing which OS it's servicing.
///
/// **Mounting is stateful and easy to leave dangling.** [mountImage] claims a
/// directory and a scratch area; if a process crashes or a script exits
/// between [mountImage] and [unmountImage], the mount survives and the
/// backing file stays locked. [getMountedImageInfo] lists what's currently
/// mounted, and [cleanupMountpoints] clears orphaned mounts that
/// [remountImage] can't recover — that pairing is the way out of a stuck
/// mount, not [unmountImage] on a directory that no longer resolves.
/// [unmountImage] itself requires [commit] or [discard] — there is no
/// implicit choice.
///
/// This wrapper gives full, individually documented parameter methods to the
/// three areas actually verified against Microsoft's own reference: the
/// general/global options, image mounting and management, and Windows
/// optional-feature management. DISM's remaining surface — package
/// servicing (`/Add-Package`, `/Get-Packages`, …), driver servicing
/// (`/Add-Driver`, `/Get-Drivers`, …), component-store cleanup
/// (`/Cleanup-Image`, `/StartComponentCleanup`, …), image health
/// (`/CheckHealth`, `/ScanHealth`, `/RestoreHealth`), edition servicing
/// (`/Set-Edition`, `/Get-CurrentEdition`, …), and provisioned Appx packages
/// — is named at the verb level below (so [arg] is never needed just to
/// reach a verb this class doesn't know by name) but routes its own
/// parameters through [arg], in the order `dism /<verb> /?` shows for that
/// verb, the same escape hatch `Certutil` uses for its deepest CA-admin
/// verbs.
class DismCmd extends CommandBuilder<DismCmd> {
  @override
  final String executable = 'dism';

  // --- General options ------------------------------------------------------

  /// Services the currently running operating system (`/Online`).
  DismCmd online() => token('/Online');

  /// Services an offline image mounted or extracted at this path
  /// (`/Image:<path>`).
  DismCmd image(String path) => token('/Image:$path');

  /// Prints general help, or help for a specific command with [arg]
  /// (`/Get-Help`, `/?`).
  DismCmd getHelp() => token('/Get-Help');

  /// Forces English-language output on a localized build (`/English`).
  DismCmd english() => token('/English');

  /// The output format for informational commands: `Table` or `List`
  /// (`/Format:<value>`).
  DismCmd format(String value) => token('/Format:$value');

  /// Suppresses the automatic restart DISM would otherwise trigger
  /// (`/NoRestart`).
  DismCmd noRestart() => token('/NoRestart');

  /// Suppresses most console output (`/Quiet`).
  DismCmd quiet() => token('/Quiet');

  /// Where to write the log file, instead of the default location
  /// (`/LogPath:<path>`).
  DismCmd logPath(String path) => token('/LogPath:$path');

  /// The logging detail level, `1`–`4` (`/LogLevel:<level>`).
  DismCmd logLevel(String level) => token('/LogLevel:$level');

  /// The directory for temporary files DISM creates while it works
  /// (`/ScratchDir:<path>`).
  DismCmd scratchDir(String path) => token('/ScratchDir:$path');

  // --- Image management ------------------------------------------------------

  /// Mounts an image from a `.wim`/`.ffu`/`.vhd`/`.vhdx` file for servicing
  /// (`/Mount-Image`). The mount directory must already exist and be empty.
  DismCmd mountImage() => token('/Mount-Image');

  /// Applies changes made to a mounted image, which stays mounted until
  /// [unmountImage] runs (`/Commit-Image`).
  DismCmd commitImage() => token('/Commit-Image');

  /// Unmounts a mounted image (`/Unmount-Image`). Requires [commit] or
  /// [discard].
  DismCmd unmountImage() => token('/Unmount-Image');

  /// With [unmountImage]: applies the changes made while mounted (`/Commit`).
  DismCmd commit() => token('/Commit');

  /// With [unmountImage]: discards the changes made while mounted
  /// (`/Discard`).
  DismCmd discard() => token('/Discard');

  /// Remounts an image that became inaccessible, making it available for
  /// servicing again (`/Remount-Image`).
  DismCmd remountImage() => token('/Remount-Image');

  /// Deletes the resources of a mounted image that got corrupted, without
  /// touching images that [remountImage] could still recover
  /// (`/Cleanup-Mountpoints`).
  DismCmd cleanupMountpoints() => token('/Cleanup-Mountpoints');

  /// Lists every `.ffu`/`.vhd`/`.vhdx`/`.wim` image currently mounted, with
  /// its mount location and read/write state (`/Get-MountedImageInfo`).
  DismCmd getMountedImageInfo() => token('/Get-MountedImageInfo');

  /// Adds another image to an existing `.wim` file, deduplicating shared
  /// files against it (`/Append-Image`).
  DismCmd appendImage() => token('/Append-Image');

  /// Captures a directory's contents into a new `.wim` file
  /// (`/Capture-Image`). Cannot capture an empty directory.
  DismCmd captureImage() => token('/Capture-Image');

  /// Applies a `.wim`/`.swm` image to a target directory, or a `.ffu` image
  /// to a physical drive (`/Apply-Image`).
  DismCmd applyImage() => token('/Apply-Image');

  /// Exports one image from a `.wim` file into another file, optionally
  /// recompressing and dropping unneeded resources along the way
  /// (`/Export-Image`).
  DismCmd exportImage() => token('/Export-Image');

  /// Splits an existing `.wim` file into multiple read-only `.swm` parts
  /// (`/Split-Image`).
  DismCmd splitImage() => token('/Split-Image');

  /// Deletes one volume image's metadata from a multi-image `.wim` file,
  /// without reclaiming the underlying stream data (`/Delete-Image`).
  DismCmd deleteImage() => token('/Delete-Image');

  /// Lists the files and folders inside a specified image (`/List-Image`).
  DismCmd listImage() => token('/List-Image');

  /// Prints information about the image(s) inside a `.wim`/`.ffu`/`.vhd`/
  /// `.vhdx` file (`/Get-ImageInfo`).
  DismCmd getImageInfo() => token('/Get-ImageInfo');

  /// Runs last, before an image ships, to reduce the online configuration
  /// time it takes at boot (`/Optimize-Image`).
  DismCmd optimizeImage() => token('/Optimize-Image');

  /// With most image-management verbs above: the image file to act on
  /// (`/ImageFile:<path>`).
  DismCmd imageFile(String path) => token('/ImageFile:$path');

  /// With most image-management verbs above: the image inside [imageFile]
  /// to act on, by number (`/Index:<n>`).
  DismCmd index(String value) => token('/Index:$value');

  /// With most image-management verbs above: the image inside [imageFile]
  /// to act on, by name, instead of [index] (`/Name:<value>`).
  DismCmd name(String value) => token('/Name:$value');

  /// With [mountImage]/[unmountImage]/[commitImage]/[remountImage]: the
  /// directory the image is mounted at (`/MountDir:<path>`).
  DismCmd mountDir(String path) => token('/MountDir:$path');

  /// With [appendImage]/[captureImage]: the directory to capture from
  /// (`/CaptureDir:<path>`).
  DismCmd captureDir(String path) => token('/CaptureDir:$path');

  /// With [applyImage]: the directory to apply into (`/ApplyDir:<path>`).
  DismCmd applyDir(String path) => token('/ApplyDir:$path');

  /// With [mountImage]: mounts read-only (`/ReadOnly`).
  DismCmd readOnly() => token('/ReadOnly');

  /// With [captureImage]/[exportImage]: the compression to use — `max`,
  /// `fast`, `none`, or (export only) `recovery` (`/Compress:<value>`).
  DismCmd compress(String value) => token('/Compress:$value');

  /// With most image-management verbs above: detects and tracks `.wim`
  /// corruption for the operation (`/CheckIntegrity`).
  DismCmd checkIntegrity() => token('/CheckIntegrity');

  // --- Windows optional features --------------------------------------------

  /// Lists the Windows features available in the [online]/[image] target
  /// (`/Get-Features`).
  DismCmd getFeatures() => token('/Get-Features');

  /// Prints details about one feature, named with [featureName]
  /// (`/Get-FeatureInfo`).
  DismCmd getFeatureInfo() => token('/Get-FeatureInfo');

  /// Enables a Windows feature (`/Enable-Feature`).
  DismCmd enableFeature() => token('/Enable-Feature');

  /// Disables a Windows feature (`/Disable-Feature`).
  DismCmd disableFeature() => token('/Disable-Feature');

  /// With the four feature verbs above: the feature to act on
  /// (`/FeatureName:<value>`).
  DismCmd featureName(String value) => token('/FeatureName:$value');

  /// With [getFeatures]: filters by the features a specific package
  /// provides (`/PackagePath:<path>`). With [enableFeature]/[disableFeature]:
  /// see [packagePath] under package servicing.
  DismCmd packagePath(String path) => token('/PackagePath:$path');

  /// With [enableFeature]: also enables every parent feature needed, in the
  /// same call (`/All`).
  DismCmd all() => token('/All');

  /// With [enableFeature]: where to find the files needed to enable the
  /// feature, if not found in the default repair-source location. Repeatable
  /// (`/Source:<path>`).
  DismCmd source(String path) => token('/Source:$path');

  /// With [enableFeature]: never falls back to Windows Update for missing
  /// files (`/LimitAccess`).
  DismCmd limitAccess() => token('/LimitAccess');

  /// With [disableFeature]: also removes the feature's payload, not just its
  /// manifest — the on-demand-install path (`/Remove`).
  DismCmd remove() => token('/Remove');

  // --- Package, driver, health, edition and appx servicing (verb-level) -----

  /// Adds one or more `.cab`/`.msu` packages (`/Add-Package`).
  DismCmd addPackage() => token('/Add-Package');

  /// Removes an installed package (`/Remove-Package`).
  DismCmd removePackage() => token('/Remove-Package');

  /// Lists the packages installed in the target (`/Get-Packages`).
  DismCmd getPackages() => token('/Get-Packages');

  /// Prints details about one installed package (`/Get-PackageInfo`).
  DismCmd getPackageInfo() => token('/Get-PackageInfo');

  /// Adds one or more drivers (`.inf`) to an offline image (`/Add-Driver`).
  DismCmd addDriver() => token('/Add-Driver');

  /// Removes a driver from an offline image (`/Remove-Driver`).
  DismCmd removeDriver() => token('/Remove-Driver');

  /// Lists the third-party drivers in the target (`/Get-Drivers`).
  DismCmd getDrivers() => token('/Get-Drivers');

  /// Exports every third-party driver out of the target into a destination
  /// folder (`/Export-Driver`).
  DismCmd exportDriver() => token('/Export-Driver');

  /// Reclaims disk space from superseded component versions, optionally
  /// removing the ability to uninstall the current ones
  /// (`/Cleanup-Image`, with `/StartComponentCleanup` / `/ResetBase` via
  /// [arg]).
  DismCmd cleanupImage() => token('/Cleanup-Image');

  /// Checks for a flag that the component store may be corrupted, without
  /// scanning the store itself (`/CheckHealth`).
  DismCmd checkHealth() => token('/CheckHealth');

  /// Scans the component store for corruption (`/ScanHealth`).
  DismCmd scanHealth() => token('/ScanHealth');

  /// Scans the component store and repairs any corruption found, from
  /// Windows Update or a source given via [arg] (`/RestoreHealth`).
  DismCmd restoreHealth() => token('/RestoreHealth');

  /// Prints the current Windows edition (`/Get-CurrentEdition`).
  DismCmd getCurrentEdition() => token('/Get-CurrentEdition');

  /// Lists the editions an image can be upgraded to (`/Get-TargetEditions`).
  DismCmd getTargetEditions() => token('/Get-TargetEditions');

  /// Changes the Windows edition of an offline image (`/Set-Edition`).
  DismCmd setEdition() => token('/Set-Edition');

  /// Lists provisioned (per-new-user) Appx packages (`/Get-ProvisionedAppxPackages`).
  DismCmd getProvisionedAppxPackages() => token('/Get-ProvisionedAppxPackages');

  /// Adds a provisioned Appx package (`/Add-ProvisionedAppxPackage`).
  DismCmd addProvisionedAppxPackage() => token('/Add-ProvisionedAppxPackage');

  /// Removes a provisioned Appx package (`/Remove-ProvisionedAppxPackage`).
  DismCmd removeProvisionedAppxPackage() => token('/Remove-ProvisionedAppxPackage');

  // --- Escape hatch ----------------------------------------------------------

  /// Adds a bare positional argument or `/Switch:value` pair, for a verb's
  /// own parameters this wrapper names but doesn't give dedicated methods to
  /// — in the order `dism /<verb> /?` documents them.
  DismCmd arg(String value) => token(value);
}

/// `dism`, ready to take `/Online` or `/Image:<path>`.
// ignore: non_constant_identifier_names
DismCmd get Dism => DismCmd();
