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

/// `sqlite3`, the bundled command-line shell for SQLite: opens a database file
/// (creating it if it is missing), runs SQL against it, and prints the result.
///
/// ```dart
/// final ShellResult rows = await Sqlite3.json().cmd('select * from users').file('app.db').output();
///
/// // A one-shot query with no file, run entirely in memory.
/// await Sqlite3.cmd('create table t(x)').output();
/// ```
///
/// With no [file], the database is `:memory:` — every change vanishes when the
/// process exits, which is exactly what a throwaway test fixture wants and a
/// migration script does not. SQL passed as trailing arguments (via [sql]) runs
/// once and the shell exits; without it, `sqlite3` reads from stdin, which
/// [CommandBuilder.output]'s `input` parameter can feed. The dot-commands
/// (`.tables`, `.schema`, `.mode`) that an interactive session relies on belong
/// in that SQL/stdin stream, not as flags here — [cmd] runs one before stdin is
/// read, which is the scriptable equivalent of typing it first.
class Sqlite3Cmd extends CommandBuilder<Sqlite3Cmd> {
  @override
  final String executable = 'sqlite3';

  /// Treats no further arguments as options, so a filename or SQL starting with `-` is read literally (`--`).
  Sqlite3Cmd endOfOptions() => token('--');

  /// Runs `.archive ARGS` and exits (`-A`).
  Sqlite3Cmd archive(List<String> args) {
    token('-A');
    for (final String arg in args) {
      token(arg);
    }
    return self;
  }

  /// Appends the database to the end of the file, for a self-extracting archive (`-append`).
  Sqlite3Cmd append() => token('-append');

  /// Sets the output mode to `ascii`, unit- and record-separated (`-ascii`).
  Sqlite3Cmd ascii() => token('-ascii');

  /// Stops after the first error instead of continuing (`-bail`).
  Sqlite3Cmd bail() => token('-bail');

  /// Forces batch (non-interactive) I/O even when stdin is a terminal (`-batch`).
  Sqlite3Cmd batch() => token('-batch');

  /// Sets the output mode to `box`, a Unicode-drawn table (`-box`).
  Sqlite3Cmd box() => token('-box');

  /// Sets the output mode to `column`, left-aligned columns (`-column`).
  Sqlite3Cmd column() => token('-column');

  /// Runs a command before reading stdin (`-cmd`). Repeatable; each runs in order.
  Sqlite3Cmd cmd(String command) => pair('-cmd', command);

  /// Sets the output mode to `csv` (`-csv`).
  Sqlite3Cmd csv() => token('-csv');

  /// Opens the database via `sqlite3_deserialize()`, entirely in memory (`-deserialize`).
  Sqlite3Cmd deserialize() => token('-deserialize');

  /// Prints each input line before it runs, useful when piping a script (`-echo`).
  Sqlite3Cmd echo() => token('-echo');

  /// Sets the control-character escape style for `box`/`column`/`table` modes: `symbol`, `ascii` or `off` (`-escape`).
  Sqlite3Cmd escape(String style) => pair('-escape', style);

  /// Reads and runs a file of SQL/dot-commands before the main input (`-init`).
  Sqlite3Cmd init(String path) => pair('-init', path);

  /// Turns column headers on or off in the current output mode (`-header` / `-noheader`).
  Sqlite3Cmd header(bool value) => token(value ? '-header' : '-noheader');

  /// Prints the usage summary and exits (`-help`).
  Sqlite3Cmd help() => token('-help');

  /// Sets a hexadecimal encryption key, for the SEE (SQLite Encryption Extension) build (`-hexkey`).
  Sqlite3Cmd hexkey(String hex) => pair('-hexkey', hex);

  /// Sets the output mode to `html`, one `<TR>` per row (`-html`).
  Sqlite3Cmd html() => token('-html');

  /// Forces interactive I/O even when stdin is not a terminal (`-interactive`).
  Sqlite3Cmd interactive() => token('-interactive');

  /// Sets a raw (binary) encryption key, for the SEE build (`-key`).
  Sqlite3Cmd key(String raw) => pair('-key', raw);

  /// Sets the output mode to `json`, one array of objects (`-json`).
  Sqlite3Cmd json() => token('-json');

  /// Sets the output mode to `line`, one `column = value` per line (`-line`).
  Sqlite3Cmd lineMode() => token('-line');

  /// Sets the output mode to `list`, values separated by [separator] (`-list`).
  Sqlite3Cmd list() => token('-list');

  /// Reserves N entries of SIZE bytes each for lookaside memory allocation (`-lookaside SIZE N`).
  Sqlite3Cmd lookaside(int size, int n) {
    token('-lookaside');
    token('$size');
    return token('$n');
  }

  /// Sets the output mode to `markdown`, a GitHub-flavoured table (`-markdown`).
  Sqlite3Cmd markdown() => token('-markdown');

  /// Caps the size of a `-deserialize`'d database, in bytes (`-maxsize`).
  Sqlite3Cmd maxsize(int bytes) => pair('-maxsize', '$bytes');

  /// Traces every memory allocation and deallocation, for debugging the library itself (`-memtrace`).
  Sqlite3Cmd memtrace() => token('-memtrace');

  /// Sets the row separator for `list`/raw output; the default is a newline (`-newline`).
  Sqlite3Cmd newline(String separator) => pair('-newline', separator);

  /// Refuses to open a database file reached through a symbolic link (`-nofollow`).
  Sqlite3Cmd noFollow() => token('-nofollow');

  /// Disables `rowid`-in-view handling via `sqlite3_config()` (`-no-rowid-in-view`).
  Sqlite3Cmd noRowidInView() => token('-no-rowid-in-view');

  /// Sets the safe-mode escape nonce, the one string that lifts `-safe`'s restrictions for one statement (`-nonce`).
  Sqlite3Cmd nonce(String value) => pair('-nonce', value);

  /// Sets the text printed for a `NULL` value; the default is an empty string (`-nullvalue`).
  Sqlite3Cmd nullValue(String text) => pair('-nullvalue', text);

  /// Reserves N slots of SIZE bytes each for page-cache memory (`-pagecache SIZE N`).
  Sqlite3Cmd pagecache(int size, int n) {
    token('-pagecache');
    token('$size');
    return token('$n');
  }

  /// Traces every page-cache operation, for debugging the library itself (`-pcachetrace`).
  Sqlite3Cmd pcachetrace() => token('-pcachetrace');

  /// Sets the output mode to `quote`, values quoted the way SQL literals are (`-quote`).
  Sqlite3Cmd quote() => token('-quote');

  /// Opens the database file read-only (`-readonly`).
  Sqlite3Cmd readonly() => token('-readonly');

  /// Enables safe mode, which disables commands that write outside the database or run external programs (`-safe`).
  Sqlite3Cmd safe() => token('-safe');

  /// Sets the column separator for `list`/raw output; the default is `|` (`-separator`).
  Sqlite3Cmd separator(String value) => pair('-separator', value);

  /// Prints memory-usage statistics before each statement finalizes (`-stats`).
  Sqlite3Cmd stats() => token('-stats');

  /// Sets a passphrase to be hashed into the encryption key, for the SEE build (`-textkey`).
  Sqlite3Cmd textkey(String passphrase) => pair('-textkey', passphrase);

  /// Sets the output mode to `table`, an ASCII-drawn box (`-table`).
  Sqlite3Cmd table() => token('-table');

  /// Sets the output mode to `tabs`, tab-separated values (`-tabs`).
  Sqlite3Cmd tabs() => token('-tabs');

  /// Allows unsafe commands and modes meant only for the SQLite test suite (`-unsafe-testing`).
  Sqlite3Cmd unsafeTesting() => token('-unsafe-testing');

  /// Prints the SQLite library version and exits (`-version`).
  Sqlite3Cmd version() => token('-version');

  /// Uses a named VFS (virtual file system) implementation instead of the default (`-vfs`).
  Sqlite3Cmd vfs(String name) => pair('-vfs', name);

  /// Traces every VFS-layer call, for debugging the library itself (`-vfstrace`).
  Sqlite3Cmd vfstrace() => token('-vfstrace');

  /// Opens the file as a ZIP archive rather than an SQLite database (`-zip`).
  Sqlite3Cmd zip() => token('-zip');

  /// The database file to open. Created if it does not exist; omit for a throwaway `:memory:` database.
  Sqlite3Cmd file(String path) => token(path);

  /// One statement of SQL to run against [file] after any [init]/[cmd], then exit. Repeat for several statements.
  Sqlite3Cmd sql(String statement) => token(statement);
}

/// `sqlite3`, ready to take its first option.
// ignore: non_constant_identifier_names
Sqlite3Cmd get Sqlite3 => Sqlite3Cmd();
