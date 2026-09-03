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

/// `pg_dump`, the PostgreSQL backup tool. Ships in the client package alongside
/// `psql`, so the same caveat applies: present on all three platforms, installed
/// separately, and often reached through the database container instead.
///
/// ```dart
/// await PgDump
///     .format('c')
///     .noOwner()
///     .noPrivileges()
///     .database('koko')
///     .username('postgres')
///     .file(backup.path)
///     .execute();
/// ```
///
/// Pick the format deliberately. `p`, the default, writes plain SQL you can read
/// and pipe into `psql`; `c` writes the custom archive that [PgRestore] can
/// restore selectively and in parallel. Anything you intend to restore
/// automatically wants `c`.
///
/// A dump takes a consistent snapshot, so it is safe on a live database, but it
/// holds a lock that blocks `ALTER TABLE` for as long as it runs. See
/// [lockWaitTimeout] if that matters.
///
/// The password comes from `PGPASSWORD` in the environment, never from a flag.
class PgDumpCmd extends CommandBuilder<PgDumpCmd> {
  @override
  final String executable = 'pg_dump';

  /// The output file or directory (`--file`).
  PgDumpCmd file(String path) => pair('--file', path);

  /// The output format: `c` custom, `d` directory, `t` tar, `p` plain (`--format`).
  PgDumpCmd format(String value) => pair('--format', value);

  /// How many tables to dump at once (`--jobs`). Directory format only.
  PgDumpCmd jobs(String count) => pair('--jobs', count);

  /// Reports progress on stderr (`--verbose`).
  PgDumpCmd verbose() => token('--verbose');

  /// Prints the version and exits (`--version`).
  PgDumpCmd version() => token('--version');

  /// Compresses the output, `method[:level]` (`--compress`).
  PgDumpCmd compress(String value) => pair('--compress', value);

  /// Gives up after waiting this long for a table lock (`--lock-wait-timeout`).
  PgDumpCmd lockWaitTimeout(String value) => pair('--lock-wait-timeout', value);

  /// Returns without waiting for the file to reach the disk (`--no-sync`).
  PgDumpCmd noSync() => token('--no-sync');

  /// Prints the usage summary (`--help`).
  PgDumpCmd help() => token('--help');

  /// The rows without the schema (`--data-only`).
  PgDumpCmd dataOnly() => token('--data-only');

  /// Includes the large objects (`--large-objects`).
  PgDumpCmd largeObjects() => token('--large-objects');

  /// Leaves the large objects out (`--no-large-objects`).
  PgDumpCmd noLargeObjects() => token('--no-large-objects');

  /// Emits the DROP statements before the CREATE ones (`--clean`).
  PgDumpCmd clean() => token('--clean');

  /// Emits a CREATE DATABASE first (`--create`).
  PgDumpCmd create() => token('--create');

  /// Only the extensions matching this pattern (`--extension`).
  PgDumpCmd extension(String pattern) => pair('--extension', pattern);

  /// Dumps the data in this encoding (`--encoding`).
  PgDumpCmd encoding(String value) => pair('--encoding', value);

  /// Only the schemas matching this pattern (`--schema`).
  PgDumpCmd schema(String pattern) => pair('--schema', pattern);

  /// Everything but the schemas matching this pattern (`--exclude-schema`).
  PgDumpCmd excludeSchema(String pattern) => pair('--exclude-schema', pattern);

  /// Leaves the ownership out (`--no-owner`).
  ///
  /// What lets a dump restore into a database whose roles have different names.
  PgDumpCmd noOwner() => token('--no-owner');

  /// The schema without the rows (`--schema-only`).
  PgDumpCmd schemaOnly() => token('--schema-only');

  /// The superuser name to use in plain-text output (`--superuser`).
  PgDumpCmd superuser(String name) => pair('--superuser', name);

  /// Only the tables matching this pattern (`--table`).
  PgDumpCmd table(String pattern) => pair('--table', pattern);

  /// Everything but the tables matching this pattern (`--exclude-table`).
  PgDumpCmd excludeTable(String pattern) => pair('--exclude-table', pattern);

  /// Leaves the grants and revokes out (`--no-privileges`).
  PgDumpCmd noPrivileges() => token('--no-privileges');

  /// For the upgrade utilities only (`--binary-upgrade`).
  PgDumpCmd binaryUpgrade() => token('--binary-upgrade');

  /// Writes the data as INSERT statements naming their columns (`--column-inserts`).
  PgDumpCmd columnInserts() => token('--column-inserts');

  /// Quotes with the SQL standard rather than dollars (`--disable-dollar-quoting`).
  PgDumpCmd disableDollarQuoting() => token('--disable-dollar-quoting');

  /// Turns the triggers off during a data-only restore (`--disable-triggers`).
  PgDumpCmd disableTriggers() => token('--disable-triggers');

  /// Dumps only the rows row-level security lets you read (`--enable-row-security`).
  PgDumpCmd enableRowSecurity() => token('--enable-row-security');

  /// Excludes a table with its partitions and children (`--exclude-table-and-children`).
  PgDumpCmd excludeTableAndChildren(String pattern) => pair('--exclude-table-and-children', pattern);

  /// Excludes the data of a table, keeping its definition (`--exclude-table-data`).
  PgDumpCmd excludeTableData(String pattern) => pair('--exclude-table-data', pattern);

  /// The same, partitions and children included (`--exclude-table-data-and-children`).
  PgDumpCmd excludeTableDataAndChildren(String pattern) => pair('--exclude-table-data-and-children', pattern);

  /// Overrides `extra_float_digits` (`--extra-float-digits`).
  PgDumpCmd extraFloatDigits(String value) => pair('--extra-float-digits', value);

  /// Uses IF EXISTS when dropping (`--if-exists`). Pointless without [clean].
  PgDumpCmd ifExists() => token('--if-exists');

  /// Includes the data of the matching foreign tables (`--include-foreign-data`).
  PgDumpCmd includeForeignData(String pattern) => pair('--include-foreign-data', pattern);

  /// Writes the data as INSERT statements rather than COPY (`--inserts`).
  ///
  /// Far slower to restore, and the only thing another database will accept.
  PgDumpCmd inserts() => token('--inserts');

  /// Loads the partitions through the root table (`--load-via-partition-root`).
  PgDumpCmd loadViaPartitionRoot() => token('--load-via-partition-root');

  /// Leaves the comments out (`--no-comments`).
  PgDumpCmd noComments() => token('--no-comments');

  /// Leaves the publications out (`--no-publications`).
  PgDumpCmd noPublications() => token('--no-publications');

  /// Leaves the security labels out (`--no-security-labels`).
  PgDumpCmd noSecurityLabels() => token('--no-security-labels');

  /// Leaves the subscriptions out (`--no-subscriptions`).
  PgDumpCmd noSubscriptions() => token('--no-subscriptions');

  /// Leaves the table access methods out (`--no-table-access-method`).
  PgDumpCmd noTableAccessMethod() => token('--no-table-access-method');

  /// Leaves the tablespace assignments out (`--no-tablespaces`).
  PgDumpCmd noTablespaces() => token('--no-tablespaces');

  /// Leaves the TOAST compression settings out (`--no-toast-compression`).
  PgDumpCmd noToastCompression() => token('--no-toast-compression');

  /// Leaves the rows of unlogged tables out (`--no-unlogged-table-data`).
  PgDumpCmd noUnloggedTableData() => token('--no-unlogged-table-data');

  /// Adds ON CONFLICT DO NOTHING to the INSERTs (`--on-conflict-do-nothing`).
  PgDumpCmd onConflictDoNothing() => token('--on-conflict-do-nothing');

  /// Quotes every identifier, keyword or not (`--quote-all-identifiers`).
  PgDumpCmd quoteAllIdentifiers() => token('--quote-all-identifiers');

  /// The key for the psql restrict directive (`--restrict-key`).
  PgDumpCmd restrictKey(String value) => pair('--restrict-key', value);

  /// How many rows per INSERT (`--rows-per-insert`). Implies [inserts].
  PgDumpCmd rowsPerInsert(String count) => pair('--rows-per-insert', count);

  /// One section only: `pre-data`, `data` or `post-data` (`--section`).
  PgDumpCmd section(String value) => pair('--section', value);

  /// Waits until the dump can run without serialization anomalies (`--serializable-deferrable`).
  PgDumpCmd serializableDeferrable() => token('--serializable-deferrable');

  /// Dumps from an existing snapshot (`--snapshot`).
  PgDumpCmd snapshot(String value) => pair('--snapshot', value);

  /// Fails when an include pattern matches nothing (`--strict-names`).
  ///
  /// Turns a typo in a table name from a silently empty dump into an error.
  PgDumpCmd strictNames() => token('--strict-names');

  /// A table with its partitions and children (`--table-and-children`).
  PgDumpCmd tableAndChildren(String pattern) => pair('--table-and-children', pattern);

  /// Sets ownership with SET SESSION AUTHORIZATION (`--use-set-session-authorization`).
  PgDumpCmd useSetSessionAuthorization() => token('--use-set-session-authorization');

  /// The database to dump (`--dbname`). Also takes a full connection URI.
  PgDumpCmd database(String name) => pair('--dbname', name);

  /// The server host, or the socket directory (`--host`).
  PgDumpCmd host(String value) => pair('--host', value);

  /// The server port (`--port`).
  PgDumpCmd port(String value) => pair('--port', value);

  /// The database user (`--username`).
  PgDumpCmd username(String value) => pair('--username', value);

  /// Never prompts for a password (`--no-password`).
  PgDumpCmd noPassword() => token('--no-password');

  /// Forces the password prompt (`--password`).
  PgDumpCmd password() => token('--password');

  /// Runs SET ROLE before dumping (`--role`).
  PgDumpCmd role(String name) => pair('--role', name);

  /// Adds a bare argument, the database name when given positionally.
  PgDumpCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
PgDumpCmd get PgDump => PgDumpCmd();
