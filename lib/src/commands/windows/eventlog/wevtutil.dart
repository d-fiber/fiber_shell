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

/// `wevtutil`, the Windows Event Log command line: enumerate logs and
/// publishers, query events, export, archive and clear logs. Windows only,
/// and the portable counterpart of `journalctl` on Linux.
///
/// ```dart
/// final ShellResult errors = await Wevtutil
///     .queryEvents()
///     .logName('System')
///     .query(r'*[System[(Level=2)]]')
///     .count(20)
///     .reverse()
///     .format('text')
///     .output();
/// ```
///
/// [queryEvents] takes a log name via [logName] and narrows it with [query],
/// an XPath filter — that pair is how "every System error" becomes something
/// specific. [logFile] switches [logName] from a live log's name to the path
/// of an exported `.evtx` file instead.
///
/// **[clearLog] is destructive and irreversible**: it empties the named log
/// immediately, with nothing to catch a typo'd log name beyond [backup]
/// writing the cleared events out first. [exportLog] to a `.evtx` file ahead
/// of time if the events might matter later — `wevtutil` itself never asks
/// for confirmation.
///
/// **Watch the overloaded flag letters.** `/l:` means the level filter under
/// [setLogInfo] but the locale under [locale] ([queryEvents], [archiveLog]);
/// `/c:` means the config-file path under [configFile] ([setLogInfo]) but the
/// event count under [count] ([queryEvents]); `/e:` means enabled/disabled
/// under [enabled] ([setLogInfo]) but the XML root element under
/// [rootElement] ([queryEvents]). Each method here is named for what it
/// actually does, not the raw letter, precisely so these are not mixed up.
///
/// Every documented subcommand: `el`, `gl`, `sl`, `ep`, `gp`, `im`, `um`,
/// `qe`, `gli`, `epl`, `al`, `cl`. Every documented option: `/f`, `/e`
/// (both meanings), `/i`, `/lfn`, `/rt`, `/ab`, `/ms`, `/l` (both meanings),
/// `/k`, `/ca`, `/c` (both meanings), `/ge`, `/gm`, `/lf`, `/sq`, `/q`,
/// `/bm`, `/sbm`, `/rd`, `/ow`, `/bu`, `/r`, `/u`, `/p`, `/a`, `/uni`, `/rf`,
/// `/mf`, `/pf`.
class WevtutilCmd extends CommandBuilder<WevtutilCmd> {
  @override
  final String executable = 'wevtutil';

  /// Lists the names of every log (`el`, enum-logs).
  WevtutilCmd enumLogs() => token('el');

  /// Prints a log's configuration: enabled state, retention, max size, path
  /// (`gl`, get-log).
  WevtutilCmd getLogInfo() => token('gl');

  /// Changes a log's configuration (`sl`, set-log).
  WevtutilCmd setLogInfo() => token('sl');

  /// Lists the event publishers on the local machine (`ep`, enum-publishers).
  WevtutilCmd enumPublishers() => token('ep');

  /// Prints an event publisher's configuration (`gp`, get-publisher).
  WevtutilCmd getPublisherInfo() => token('gp');

  /// Installs publishers and logs from an event manifest (`im`,
  /// install-manifest). No remote form.
  WevtutilCmd installManifest() => token('im');

  /// Uninstalls every publisher and log listed in an event manifest (`um`,
  /// uninstall-manifest). No remote form.
  WevtutilCmd uninstallManifest() => token('um');

  /// Queries events out of a live log, a `.evtx` file, or a structured
  /// query (`qe`, query-events). Pair with [logName] and, optionally,
  /// [query] or [structuredQuery].
  WevtutilCmd queryEvents() => token('qe');

  /// Prints status information about a log or log file (`gli`,
  /// get-loginfo).
  WevtutilCmd getLogStatus() => token('gli');

  /// Exports events from a log, log file, or structured query to a file
  /// (`epl`, export-log).
  WevtutilCmd exportLog() => token('epl');

  /// Archives a log file into a self-contained, locale-independent form
  /// (`al`, archive-log). The destination directory must be trusted: nothing
  /// stops it overwriting files through an untrusted symlink or junction.
  WevtutilCmd archiveLog() => token('al');

  /// **Empties a log.** Irreversible; [backup] is the only way to keep what
  /// was cleared (`cl`, clear-log).
  WevtutilCmd clearLog() => token('cl');

  /// The log name, log-file path, publisher name, or manifest/export/archive
  /// path a subcommand acts on. Comes right after the subcommand.
  WevtutilCmd logName(String value) => token(value);

  /// The destination path for [exportLog], or a second bare argument for any
  /// other two-argument subcommand.
  WevtutilCmd destination(String path) => token(path);

  /// The output format: `text` (default) or `xml` (`/f:`). [getLogInfo],
  /// [getPublisherInfo] and [queryEvents].
  WevtutilCmd format(String value) => joined('/f:', value);

  /// Enables or disables the log, `true`/`false` (`/e:`). [setLogInfo] only.
  WevtutilCmd enabled(bool value) => joined('/e:', '$value');

  /// The log's isolation mode: `system`, `application` or `custom` (`/i:`).
  /// `custom` needs [accessPermissions] too. [setLogInfo] only.
  WevtutilCmd isolation(String value) => joined('/i:', value);

  /// The full path to the file the Event Log service stores this log's
  /// events in (`/lfn:`). [setLogInfo] only.
  WevtutilCmd logFileName(String path) => joined('/lfn:', path);

  /// The log's retention mode, `true`/`false` — `true` keeps existing events
  /// and discards new ones once full, `false` overwrites the oldest (`/rt:`).
  /// [setLogInfo] only.
  WevtutilCmd retention(bool value) => joined('/rt:', '$value');

  /// Backs the log up automatically once it reaches its maximum size,
  /// `true`/`false`; needs [retention] set `true` too (`/ab:`). [setLogInfo]
  /// only.
  WevtutilCmd autoBackup(bool value) => joined('/ab:', '$value');

  /// The log's maximum size in bytes; rounded to the nearest 64 KB multiple,
  /// 1048576 minimum (`/ms:`). [setLogInfo] only.
  WevtutilCmd maxSize(int bytes) => joined('/ms:', '$bytes');

  /// The log's level filter, for logs with a dedicated session; `0` removes
  /// it (`/l:`). [setLogInfo] only — see [locale] for `qe`/`al`'s different
  /// `/l:`.
  WevtutilCmd level(int value) => joined('/l:', '$value');

  /// The log's keyword filter, a 64-bit mask, for logs with a dedicated
  /// session (`/k:`). [setLogInfo] only.
  WevtutilCmd keywords(String mask) => joined('/k:', mask);

  /// The log's access permissions, an SDDL security descriptor (`/ca:`).
  /// Required when [isolation] is `custom`. [setLogInfo] only.
  WevtutilCmd accessPermissions(String sddl) => joined('/ca:', sddl);

  /// Reads the log's properties from this configuration file instead of the
  /// command line; do not pass [logName] alongside it, the name is read from
  /// the file (`/c:`). [setLogInfo] only — see [count] for `qe`'s different
  /// `/c:`.
  WevtutilCmd configFile(String path) => joined('/c:', path);

  /// Also fetches metadata for the events this publisher can raise,
  /// `true`/`false` (`/ge:`). [getPublisherInfo] only.
  WevtutilCmd includeEventMetadata(bool value) => joined('/ge:', '$value');

  /// Shows the actual message text instead of a numeric message id,
  /// `true`/`false` (`/gm:`). [getPublisherInfo] only.
  WevtutilCmd includeMessage(bool value) => joined('/gm:', '$value');

  /// Treats [logName] as a path to a `.evtx` file rather than a live log
  /// name, `true`/`false` (`/lf:`). [queryEvents], [getLogStatus] and
  /// [exportLog].
  WevtutilCmd logFile([bool value = true]) => joined('/lf:', '$value');

  /// Treats [logName] as a path to a file containing a structured query,
  /// `true`/`false`; not usable alongside [query] (`/sq:`). [queryEvents]
  /// and [exportLog].
  WevtutilCmd structuredQuery([bool value = true]) => joined('/sq:', '$value');

  /// An XPath filter narrowing the events read or exported, e.g.
  /// `*[System[(Level=2)]]`; not usable alongside [structuredQuery] (`/q:`).
  /// [queryEvents] and [exportLog].
  WevtutilCmd query(String xpath) => joined('/q:', xpath);

  /// The path to a file holding a bookmark saved by a previous [saveBookmark]
  /// query, to resume from (`/bm:`). [queryEvents] only.
  WevtutilCmd bookmark(String path) => joined('/bm:', path);

  /// The path to save this query's bookmark to, `.xml` by convention
  /// (`/sbm:`). [queryEvents] only.
  WevtutilCmd saveBookmark(String path) => joined('/sbm:', path);

  /// The read direction, `true`/`false` — `true` returns the most recent
  /// events first (`/rd:`). [queryEvents] only.
  WevtutilCmd reverse([bool value = true]) => joined('/rd:', '$value');

  /// A locale string events are printed in, text format only (`/l:`).
  /// [queryEvents] and [archiveLog] — see [level] for [setLogInfo]'s
  /// different `/l:`.
  WevtutilCmd locale(String value) => joined('/l:', value);

  /// The maximum number of events to read (`/c:`). [queryEvents] only — see
  /// [configFile] for [setLogInfo]'s different `/c:`.
  WevtutilCmd count(int value) => joined('/c:', '$value');

  /// Wraps XML output in a root element named [tag] (`/e:`). [queryEvents]
  /// only — see [enabled] for [setLogInfo]'s different `/e:`.
  WevtutilCmd rootElement(String tag) => joined('/e:', tag);

  /// Overwrites the export file without asking if it already exists,
  /// `true`/`false` (`/ow:`). [exportLog] only.
  WevtutilCmd overwrite([bool value = true]) => joined('/ow:', '$value');

  /// The path to save the cleared events to before emptying the log; include
  /// the `.evtx` extension (`/bu:`). [clearLog] only.
  WevtutilCmd backup(String path) => joined('/bu:', path);

  /// Runs the command against this remote machine (`/r:`). Not usable with
  /// [installManifest] or [uninstallManifest].
  WevtutilCmd remote(String value) => joined('/r:', value);

  /// The user to authenticate as on [remote], `domain\user` or `user`
  /// (`/u:`).
  WevtutilCmd username(String value) => joined('/u:', value);

  /// That user's password; omit the value or pass `*` to be prompted instead
  /// of putting it on the command line (`/p:`). Needs [username].
  WevtutilCmd password(String value) => joined('/p:', value);

  /// The authentication type for [remote]: `Default`, `Negotiate` (the
  /// default), `Kerberos` or `NTLM` (`/a:`).
  WevtutilCmd authType(String value) => joined('/a:', value);

  /// Prints output in Unicode, `true`/`false` (`/uni:`).
  WevtutilCmd unicode([bool value = true]) => joined('/uni:', '$value');

  /// The manifest's resource file path, overriding the one it declares
  /// (`/rf:`). [installManifest] only.
  WevtutilCmd resourceFilePath(String path) => joined('/rf:', path);

  /// The manifest's message file path, overriding the one it declares
  /// (`/mf:`). [installManifest] only.
  WevtutilCmd messageFilePath(String path) => joined('/mf:', path);

  /// The manifest's parameter file path, overriding the one it declares
  /// (`/pf:`). [installManifest] only.
  WevtutilCmd parameterFilePath(String path) => joined('/pf:', path);
}

/// `wevtutil`, ready to take its first subcommand.
// ignore: non_constant_identifier_names
WevtutilCmd get Wevtutil => WevtutilCmd();
