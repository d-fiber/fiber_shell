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

/// `codesign`, which creates, checks and displays macOS code signatures.
/// macOS only, and distinct from [SecurityCmd]: `security` manages the
/// keychain that holds a signing identity, `codesign` is what actually
/// applies it to a binary or bundle.
///
/// ```dart
/// await Codesign.sign('Developer ID Application: Example Inc').force()
///     .options('runtime').entitlements(entitlementsPlist).arg(bundlePath).execute();
///
/// final ShellResult ok = await Codesign.verify().deep().arg(bundlePath).output();
/// ```
///
/// [sign] with the identity `-` is ad-hoc signing: no certificate at all,
/// good only for satisfying a local Gatekeeper check on your own machine,
/// never for distribution. [verify] alone checks internal integrity and the
/// binary's own designated requirement; it says nothing about Gatekeeper,
/// notarization or any other policy layer, which is what [SpctlCmd] and
/// [checkNotarization] are for. [deep] is deprecated for signing since macOS
/// 13 — it blindly reapplies every option to all nested content, which is
/// rarely what anyone wants — but remains the correct way to *verify* nested
/// code recursively.
class CodesignCmd extends CommandBuilder<CodesignCmd> {
  @override
  final String executable = 'codesign';

  /// Signs the given paths with this identity (`-s`, `--sign`). A dash `-`
  /// signs ad-hoc, with no certificate. See SIGNING IDENTITIES in
  /// `man codesign` for how a name, a preference or a SHA-1 hash resolves.
  CodesignCmd sign(String identity) => pair('-s', identity);

  /// Verifies the code signatures on the given paths (`-v`, `--verify`),
  /// or — combined with another action like [sign] or [display] —
  /// increases verbosity instead. Repeatable to raise the level further.
  CodesignCmd verbose() => token('-v');

  /// Displays the signature on the given paths (`-d`, `--display`).
  /// Increasing verbosity shows more.
  CodesignCmd display() => token('-d');

  /// Constructs and prints the hosting chain for the given running
  /// processes (`-h`, `--hosting`).
  CodesignCmd hosting() => token('-h');

  /// Checks that the constraint plists at the given paths are structurally
  /// valid (`--validate-constraint`).
  CodesignCmd validateConstraint() => token('--validate-constraint');

  /// Verifies every architecture in a universal binary separately
  /// (`--all-architectures`). The default for verification unless
  /// [architecture] overrides it.
  CodesignCmd allArchitectures() => token('--all-architectures');

  /// Selects one Mach-O architecture to verify or display, by name or
  /// number (`-a`, `--architecture`).
  CodesignCmd architecture(String value) => pair('-a', value);

  /// For a versioned bundle such as a framework, the version to operate on
  /// (`--bundle-version`). Defaults to the bundle's own default version.
  CodesignCmd bundleVersion(String version) => pair('--bundle-version', version);

  /// Forces an online check for a notarization ticket during verification
  /// (`--check-notarization`).
  CodesignCmd checkNotarization() => token('--check-notarization');

  /// Writes (or, when verifying, reads) a detached signature at this path
  /// rather than embedding it in the code (`-D`, `--detached`).
  CodesignCmd detached(String path) => pair('-D', path);

  /// Recursively signs nested helpers, frameworks and plug-ins found in a
  /// bundle's `Contents` layout (`--deep`). Deprecated for signing since
  /// macOS 13; still valid for recursive [verify]. See the class docs.
  CodesignCmd deep() => token('--deep');

  /// Writes the detached signature to the system signature database
  /// instead of a file (`--detached-database`). Requires elevated
  /// privileges.
  CodesignCmd detachedDatabase() => token('--detached-database');

  /// Replaces an existing signature instead of failing on one (`-f`,
  /// `--force`).
  CodesignCmd force() => token('-f');

  /// Forces entitlements to be embedded in library signatures, not only the
  /// main executable (`--force-library-entitlements`). Off by default since
  /// macOS 15.
  CodesignCmd forceLibraryEntitlements() => token('--force-library-entitlements');

  /// Embeds the entitlements as DER alongside XML in the signature
  /// (`--generate-entitlement-der`). Default behaviour since macOS 12.
  CodesignCmd generateEntitlementDer() => token('--generate-entitlement-der');

  /// Explicitly sets the unique identifier embedded in the signature
  /// (`-i`, `--identifier`). Otherwise derived from the `Info.plist` or the
  /// executable's filename.
  CodesignCmd identifier(String value) => pair('-i', value);

  /// Sets the signature's option flags, a comma-separated list of names
  /// such as `runtime`, or a raw numeric mask (`-o`, `--options`).
  CodesignCmd options(String flags) => pair('-o', flags);

  /// The granularity, in bytes, at which code is separately signed and
  /// verified; must be a power of two, `0` for the whole file as one page
  /// (`-P`, `--pagesize`).
  CodesignCmd pagesize(String value) => pair('-P', value);

  /// Strips the current signature from the given paths (`--remove-signature`).
  CodesignCmd removeSignature() => token('--remove-signature');

  /// Embeds these internal requirements when signing, or writes the code's
  /// internal requirements out when displaying — `-r-` for stdout (`-r`,
  /// `--requirements`).
  CodesignCmd requirements(String value) => pair('-r', value);

  /// During verification, checks the code against this requirement in
  /// addition to its own designated requirement (`-R`, `--test-requirement`).
  CodesignCmd testRequirement(String value) => pair('-R', value);

  /// Keeps processing the remaining paths after one fails, deferring exit
  /// until all have been considered (`--continue`).
  CodesignCmd continueOnFailure() => token('--continue');

  /// Performs a signing run without writing the result anywhere
  /// (`--dryrun`). Signatures are still generated and access control checks
  /// still fire; only the write is skipped.
  CodesignCmd dryRun() => token('--dryrun');

  /// When signing, embeds this entitlements plist in the signature; when
  /// displaying, extracts the embedded entitlements to this path, `-` for
  /// stdout (`--entitlements`).
  CodesignCmd entitlements(String path) => pair('--entitlements', path);

  /// Requires supplied constraints to be structurally valid for this macOS
  /// version rather than merely warning (`--enforce-constraint-validity`).
  CodesignCmd enforceConstraintValidity() => token('--enforce-constraint-validity');

  /// Extracts the embedded certificate chain to files named with this
  /// prefix, `0` the leaf certificate (`--extract-certificates`).
  CodesignCmd extractCertificates(String prefix) => pair('--extract-certificates', prefix);

  /// Writes the list of files touched by signing or display to this path,
  /// `-` for stdout (`--file-list`).
  CodesignCmd fileList(String path) => pair('--file-list', path);

  /// Skips validating the code's resources during static validation
  /// (`--ignore-resources`). Faster on large bundles, at the cost of not
  /// noticing corrupted or mis-signed resources.
  CodesignCmd ignoreResources() => token('--ignore-resources');

  /// Restricts the search for the signing identity to this keychain file
  /// (`--keychain`). The full keychain search list is still used to build
  /// the certificate chain.
  CodesignCmd keychain(String path) => pair('--keychain', path);

  /// Prefixes this string to an implicitly generated identifier that
  /// contains no dot, the conventional `com.domain.` form (`--prefix`).
  /// Ignored when [identifier] is given, or when the implicit identifier
  /// already has a dot.
  CodesignCmd prefix(String value) => pair('--prefix', value);

  /// When re-signing, carries these fields over from the previous
  /// signature: a comma-separated list drawn from `identifier`,
  /// `entitlements`, `requirements`, `flags`, `runtime`,
  /// `launch-constraints`, `library-constraints` (`--preserve-metadata`).
  /// Requires [force].
  CodesignCmd preserveMetadata(String list) => joined('--preserve-metadata', list);

  /// Applies extra validation checks beyond the defaults: a comma-separated
  /// list drawn from `symlinks`, `sideband` (`--strict`).
  CodesignCmd strict(String options) => joined('--strict', options);

  /// The same as [strict] with no list, meaning as strict as possible
  /// (`--strict`).
  CodesignCmd strictAll() => token('--strict');

  /// Requests a default Apple timestamp authority when signing
  /// (`--timestamp`).
  CodesignCmd timestamp() => token('--timestamp');

  /// Requests a timestamp from this specific authority URL (`--timestamp=URL`).
  CodesignCmd timestampServer(String url) => joined('--timestamp', url);

  /// Explicitly disables timestamping (`--timestamp=none`).
  CodesignCmd noTimestamp() => joined('--timestamp', 'none');

  /// Explicitly sets the hardened runtime version stored in the signature
  /// (`--runtime-version`). Only meaningful alongside the `runtime` option
  /// flag; see [options].
  CodesignCmd runtimeVersion(String version) => pair('--runtime-version', version);

  /// Embeds this plist as a launch constraint on the executable itself
  /// (`--launch-constraint-self`).
  CodesignCmd launchConstraintSelf(String path) => pair('--launch-constraint-self', path);

  /// Embeds this plist as a launch constraint on the executable's parent
  /// process (`--launch-constraint-parent`).
  CodesignCmd launchConstraintParent(String path) => pair('--launch-constraint-parent', path);

  /// Embeds this plist as a launch constraint on the executable's
  /// responsible process (`--launch-constraint-responsible`).
  CodesignCmd launchConstraintResponsible(String path) => pair('--launch-constraint-responsible', path);

  /// Embeds this plist as a constraint on the libraries the process may
  /// load (`--library-constraint`). Cannot restrict system libraries.
  CodesignCmd libraryConstraint(String path) => pair('--library-constraint', path);

  /// Strips extended attributes such as `com.apple.FinderInfo` and
  /// `com.apple.ResourceFork` that would otherwise interfere with signing
  /// (`--strip-disallowed-xattrs`).
  CodesignCmd stripDisallowedXattrs() => token('--strip-disallowed-xattrs');

  /// Builds the resource seal on a single thread instead of in parallel
  /// (`--single-threaded-signing`).
  CodesignCmd singleThreadedSigning() => token('--single-threaded-signing');

  /// A path to sign, verify or display, or a decimal process ID for dynamic
  /// validation.
  CodesignCmd arg(String value) => token(value);
}

/// `codesign`, ready to take its first option.
// ignore: non_constant_identifier_names
CodesignCmd get Codesign => CodesignCmd();
