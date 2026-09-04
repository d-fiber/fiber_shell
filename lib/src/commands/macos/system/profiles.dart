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

/// `profiles`, the command-line tool for configuration, provisioning, MDM
/// enrollment and bootstrap-token profiles on macOS. macOS only.
///
/// ```dart
/// final ShellResult status = await Profiles.status().type('enrollment').output();
/// await Profiles.remove().identifier('com.example.profile').forced().asRoot().execute();
/// ```
///
/// Since macOS 11 (`profiles` tool 8.0+) this tool can no longer *install*
/// configuration profiles — that moved to the System Settings Profiles pane
/// — so [list], [show], [remove], [status], [sync], [renew] and [validate]
/// are what remain scriptable. Most verbs default to the `configuration`
/// profile [type] when none is given; pass `provisioning`, `bootstraptoken`
/// or `enrollment` explicitly for the others. [show] on the `enrollment`
/// type (the DEP/MDM server config) and [renew] are both rate-limited to 10
/// calls per 23 hours, after which they fall back to the local cache —
/// [cached] forces that fallback deliberately. Running without [user] uses
/// the current user, or the whole device's profiles when run as root.
class ProfilesCmd extends CommandBuilder<ProfilesCmd> {
  @override
  final String executable = 'profiles';

  /// Shows abbreviated help (`help`).
  ProfilesCmd help() => token('help');

  /// Lists profiles for a user, or the whole device as root (`list`).
  ProfilesCmd list() => token('list');

  /// Shows expanded information for profiles, or the current DEP server
  /// configuration for the `enrollment` type (`show`).
  ProfilesCmd show() => token('show');

  /// Removes profiles. Fails on a configuration profile that requires a
  /// removal password unless the correct one is supplied (`remove`).
  ProfilesCmd remove() => token('remove');

  /// Displays the status of profiles installed on this client, including
  /// enrollment approval state (`status`).
  ProfilesCmd status() => token('status');

  /// For configuration profiles, synchronizes the installed set with local
  /// users and removes profiles belonging to users that no longer exist
  /// (`sync`).
  ProfilesCmd sync() => token('sync');

  /// Renews certificates for a profile, or retries DEP enrollment
  /// (`renew`). Rate-limited; see the class doc.
  ProfilesCmd renew() => token('renew');

  /// Validates a provisioning profile at [path], or re-validates the
  /// installed DEP server information (`validate`).
  ProfilesCmd validate() => token('validate');

  /// Displays the current tool version (`version`).
  ProfilesCmd version() => token('version');

  /// The profile type to act on: `configuration` (default), `provisioning`,
  /// `bootstraptoken` or `enrollment` (`-type`).
  ProfilesCmd type(String profileType) => pair('-type', profileType);

  /// A file path, or `-` for stdout (`-path`).
  ProfilesCmd path(String filePathOrDash) => pair('-path', filePathOrDash);

  /// An Open Directory short username to act on; defaults to the current
  /// user, or the device when run as root with none given (`-user`).
  ProfilesCmd user(String userName) => pair('-user', userName);

  /// A profile's PayloadUUID, canonical form, for `remove` on a
  /// provisioning profile (`-uuid`).
  ProfilesCmd uuid(String canonicalUuid) => pair('-uuid', canonicalUuid);

  /// A profile's PayloadIdentifier (`-identifier`).
  ProfilesCmd identifier(String payloadIdentifier) => pair('-identifier', payloadIdentifier);

  /// Where to write output: a file path, `stdout`, or `stdout-xml` for XML
  /// on the console (`-output`).
  ProfilesCmd outputPath(String pathOrStdout) => pair('-output', pathOrStdout);

  /// The password for `remove` on a configuration profile that requires one
  /// (`-password`).
  ProfilesCmd password(String value) => pair('-password', value);

  /// Skips confirmation prompts, and ignores errors while removing all
  /// profiles for a user (`-forced`).
  ProfilesCmd forced() => token('-forced');

  /// For `list`/`show` as root, includes every profile on the system; for
  /// `remove`, removes every profile for the user or device (`-all`).
  ProfilesCmd all() => token('-all');

  /// Reads only from the local cache rather than contacting the server
  /// (`-cached`). Used with `show -type enrollment`.
  ProfilesCmd cached() => token('-cached');

  /// Prints additional information (`-verbose`).
  ProfilesCmd verbose() => token('-verbose');
}

/// `profiles`, ready to take its first verb.
// ignore: non_constant_identifier_names
ProfilesCmd get Profiles => ProfilesCmd();
