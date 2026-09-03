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

/// `pg_restore`, the other half of [PgDump]. It only reads the archive formats
/// (custom, directory and tar), so a plain-SQL dump goes back in through `psql`,
/// not through here.
///
/// ```dart
/// await PgRestore
///     .database('koko')
///     .clean()
///     .ifExists()
///     .noOwner()
///     .singleTransaction()
///     .arg(backup.path)
///     .execute();
/// ```
///
/// [exitOnError] is worth thinking about: by default pg_restore prints the errors
/// and carries on, so a restore can "succeed" having skipped half the objects.
/// [singleTransaction] implies it, and gives you all-or-nothing on top.
///
/// The password comes from `PGPASSWORD` in the environment, never from a flag.
class PgRestoreCmd extends CommandBuilder<PgRestoreCmd> {
  @override
  final String executable = 'pg_restore';

  /// The database to restore into (`--dbname`).
  ///
  /// Without it pg_restore writes the SQL to stdout instead of connecting.
  PgRestoreCmd database(String name) => pair('--dbname', name);

  /// Writes the SQL to this file rather than a database, `-` for stdout (`--file`).
  PgRestoreCmd file(String path) => pair('--file', path);

  /// The archive format, normally detected on its own (`--format`).
  PgRestoreCmd format(String value) => pair('--format', value);

  /// Prints the table of contents of the archive (`--list`).
  ///
  /// Pairs with [useList] to restore a hand-picked subset.
  PgRestoreCmd listContents() => token('--list');

  /// Reports progress on stderr (`--verbose`).
  PgRestoreCmd verbose() => token('--verbose');

  /// Prints the version and exits (`--version`).
  PgRestoreCmd version() => token('--version');

  /// Prints the usage summary (`--help`).
  PgRestoreCmd help() => token('--help');

  /// The rows without the schema (`--data-only`).
  PgRestoreCmd dataOnly() => token('--data-only');

  /// Drops each object before recreating it (`--clean`).
  PgRestoreCmd clean() => token('--clean');

  /// Creates the target database first (`--create`).
  ///
  /// It connects to the database named by [database] to issue the CREATE, so that
  /// one has to already exist.
  PgRestoreCmd create() => token('--create');

  /// Stops at the first error rather than carrying on (`--exit-on-error`).
  PgRestoreCmd exitOnError() => token('--exit-on-error');

  /// Restores one named index (`--index`).
  PgRestoreCmd index(String name) => pair('--index', name);

  /// How many objects to restore at once (`--jobs`). Custom and directory formats only.
  PgRestoreCmd jobs(String count) => pair('--jobs', count);

  /// Restores exactly what this table of contents file lists (`--use-list`).
  PgRestoreCmd useList(String path) => pair('--use-list', path);

  /// Only the objects in this schema (`--schema`).
  PgRestoreCmd schema(String name) => pair('--schema', name);

  /// Everything but the objects in this schema (`--exclude-schema`).
  PgRestoreCmd excludeSchema(String name) => pair('--exclude-schema', name);

  /// Leaves the ownership alone, so everything ends up owned by the connecting role (`--no-owner`).
  PgRestoreCmd noOwner() => token('--no-owner');

  /// Restores one named function, signature included (`--function`).
  PgRestoreCmd function(String signature) => pair('--function', signature);

  /// The schema without the rows (`--schema-only`).
  PgRestoreCmd schemaOnly() => token('--schema-only');

  /// The superuser to use when disabling triggers (`--superuser`).
  PgRestoreCmd superuser(String name) => pair('--superuser', name);

  /// Restores one named relation (`--table`).
  PgRestoreCmd table(String name) => pair('--table', name);

  /// Restores one named trigger (`--trigger`).
  PgRestoreCmd trigger(String name) => pair('--trigger', name);

  /// Leaves the grants and revokes out (`--no-privileges`).
  PgRestoreCmd noPrivileges() => token('--no-privileges');

  /// Wraps the whole restore in one transaction (`--single-transaction`).
  ///
  /// All or nothing, and it implies [exitOnError]. Rules out [jobs].
  PgRestoreCmd singleTransaction() => token('--single-transaction');

  /// Turns the triggers off during a data-only restore (`--disable-triggers`).
  PgRestoreCmd disableTriggers() => token('--disable-triggers');

  /// Leaves row-level security on (`--enable-row-security`).
  PgRestoreCmd enableRowSecurity() => token('--enable-row-security');

  /// Uses IF EXISTS when dropping (`--if-exists`).
  ///
  /// [clean] without it fails on the first object that was not there.
  PgRestoreCmd ifExists() => token('--if-exists');

  /// Leaves the comments out (`--no-comments`).
  PgRestoreCmd noComments() => token('--no-comments');

  /// Skips the data of the tables that could not be created (`--no-data-for-failed-tables`).
  PgRestoreCmd noDataForFailedTables() => token('--no-data-for-failed-tables');

  /// Leaves the publications out (`--no-publications`).
  PgRestoreCmd noPublications() => token('--no-publications');

  /// Leaves the security labels out (`--no-security-labels`).
  PgRestoreCmd noSecurityLabels() => token('--no-security-labels');

  /// Leaves the subscriptions out (`--no-subscriptions`).
  PgRestoreCmd noSubscriptions() => token('--no-subscriptions');

  /// Leaves the table access methods out (`--no-table-access-method`).
  PgRestoreCmd noTableAccessMethod() => token('--no-table-access-method');

  /// Leaves the tablespace assignments out (`--no-tablespaces`).
  PgRestoreCmd noTablespaces() => token('--no-tablespaces');

  /// The key for the psql restrict directive (`--restrict-key`).
  PgRestoreCmd restrictKey(String value) => pair('--restrict-key', value);

  /// One section only: `pre-data`, `data` or `post-data` (`--section`).
  PgRestoreCmd section(String value) => pair('--section', value);

  /// Fails when an include pattern matches nothing (`--strict-names`).
  PgRestoreCmd strictNames() => token('--strict-names');

  /// Sets ownership with SET SESSION AUTHORIZATION (`--use-set-session-authorization`).
  PgRestoreCmd useSetSessionAuthorization() => token('--use-set-session-authorization');

  /// The server host, or the socket directory (`--host`).
  PgRestoreCmd host(String value) => pair('--host', value);

  /// The server port (`--port`).
  PgRestoreCmd port(String value) => pair('--port', value);

  /// The database user (`--username`).
  PgRestoreCmd username(String value) => pair('--username', value);

  /// Never prompts for a password (`--no-password`).
  PgRestoreCmd noPassword() => token('--no-password');

  /// Forces the password prompt (`--password`).
  PgRestoreCmd password() => token('--password');

  /// Runs SET ROLE before restoring (`--role`).
  PgRestoreCmd role(String name) => pair('--role', name);

  /// Adds a bare argument, the archive file above all.
  PgRestoreCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
PgRestoreCmd get PgRestore => PgRestoreCmd();
