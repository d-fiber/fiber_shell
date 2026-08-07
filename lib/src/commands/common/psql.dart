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

/// `psql`, the PostgreSQL terminal. Part of the client package rather than the
/// server, so it exists on all three platforms, but installed separately, and a
/// machine running Postgres in a container often has no client at all, which is
/// why the stack usually reaches it through `docker compose exec`.
///
/// ```dart
/// final ShellResult version = await Psql
///     .noPsqlrc()
///     .tuplesOnly()
///     .noAlign()
///     .command('select version()')
///     .username('postgres')
///     .database('postgres')
///     .output();
/// ```
///
/// Four flags belong on every scripted call. [noPsqlrc] keeps a developer's
/// `~/.psqlrc` from injecting settings into your session, [tuplesOnly] and
/// [noAlign] strip the header and the column padding, and [variable] with
/// `ON_ERROR_STOP=1` makes a failing statement fail the process; without it psql
/// happily reports success after an error in the middle of a script.
///
/// The password never belongs on the command line: psql has no flag for it, and
/// reads `PGPASSWORD` from the environment instead. Pass it through the `env`
/// argument of [execute] or [output].
class PsqlCmd extends CommandBuilder<PsqlCmd> {
  @override
  final String executable = 'psql';

  /// Runs one command and exits (`--command`). SQL, or a backslash command.
  PsqlCmd command(String sql) => pair('--command', sql);

  /// The database to connect to (`--dbname`). Also takes a full connection URI.
  PsqlCmd database(String name) => pair('--dbname', name);

  /// Runs the statements in this file and exits (`--file`).
  PsqlCmd file(String path) => pair('--file', path);

  /// Lists the databases and exits (`--list`).
  PsqlCmd listDatabases() => token('--list');

  /// Sets a psql variable, `NAME=value` (`--set`).
  ///
  /// `ON_ERROR_STOP=1` is the one that matters: it turns a failed statement into a
  /// non-zero exit instead of a message nobody reads.
  PsqlCmd variable(String assignment) => pair('--set', assignment);

  /// Prints the version and exits (`--version`).
  PsqlCmd version() => token('--version');

  /// Skips `~/.psqlrc` (`--no-psqlrc`).
  PsqlCmd noPsqlrc() => token('--no-psqlrc');

  /// Wraps the whole script in one transaction (`--single-transaction`).
  PsqlCmd singleTransaction() => token('--single-transaction');

  /// Prints the usage summary (`--help`).
  PsqlCmd help() => token('--help');

  /// Echoes everything read from a script (`--echo-all`).
  PsqlCmd echoAll() => token('--echo-all');

  /// Echoes the statements that failed (`--echo-errors`).
  PsqlCmd echoErrors() => token('--echo-errors');

  /// Echoes each statement as it is sent (`--echo-queries`).
  PsqlCmd echoQueries() => token('--echo-queries');

  /// Echoes the queries the backslash commands generate (`--echo-hidden`).
  PsqlCmd echoHidden() => token('--echo-hidden');

  /// Writes a session log to this file (`--log-file`).
  PsqlCmd logFile(String path) => pair('--log-file', path);

  /// Turns readline off (`--no-readline`).
  PsqlCmd noReadline() => token('--no-readline');

  /// Sends the query results to this file (`--output`).
  PsqlCmd resultsTo(String path) => pair('--output', path);

  /// Prints the results and nothing else (`--quiet`).
  PsqlCmd quiet() => token('--quiet');

  /// Confirms each statement before running it (`--single-step`). Interactive.
  PsqlCmd singleStep() => token('--single-step');

  /// Ends a statement at the newline rather than the semicolon (`--single-line`).
  PsqlCmd singleLine() => token('--single-line');

  /// Drops the column padding (`--no-align`).
  PsqlCmd noAlign() => token('--no-align');

  /// Prints CSV (`--csv`). The format to parse when a value may contain the separator.
  PsqlCmd csv() => token('--csv');

  /// The field separator for unaligned output (`--field-separator`).
  PsqlCmd fieldSeparator(String value) => pair('--field-separator', value);

  /// Prints an HTML table (`--html`).
  PsqlCmd html() => token('--html');

  /// Sets a printing option, the `\pset` names (`--pset`).
  PsqlCmd printSetting(String assignment) => pair('--pset', assignment);

  /// The record separator for unaligned output (`--record-separator`).
  PsqlCmd recordSeparator(String value) => pair('--record-separator', value);

  /// Prints the rows without the header or the row count (`--tuples-only`).
  PsqlCmd tuplesOnly() => token('--tuples-only');

  /// The attributes of the HTML table tag (`--table-attr`).
  PsqlCmd tableAttribute(String value) => pair('--table-attr', value);

  /// Prints one field per line (`--expanded`). Readable when the rows are wide.
  PsqlCmd expanded() => token('--expanded');

  /// Separates the fields with a NUL byte (`--field-separator-zero`).
  PsqlCmd fieldSeparatorZero() => token('--field-separator-zero');

  /// Separates the records with a NUL byte (`--record-separator-zero`).
  PsqlCmd recordSeparatorZero() => token('--record-separator-zero');

  /// The server host, or the socket directory (`--host`).
  PsqlCmd host(String value) => pair('--host', value);

  /// The server port (`--port`).
  PsqlCmd port(String value) => pair('--port', value);

  /// The database user (`--username`).
  PsqlCmd username(String value) => pair('--username', value);

  /// Never prompts for a password (`--no-password`).
  ///
  /// What keeps an automated run from hanging on a prompt nobody can answer.
  PsqlCmd noPassword() => token('--no-password');

  /// Forces the password prompt (`--password`).
  PsqlCmd password() => token('--password');

  /// Adds a bare argument, the database name or the user when given positionally.
  PsqlCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
PsqlCmd get Psql => PsqlCmd();
