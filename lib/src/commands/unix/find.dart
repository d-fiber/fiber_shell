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

/// `find`, the file walker. On every Unix, absent from Windows.
///
/// ```dart
/// final ShellResult stale = await Find
///     .path(cache.path)
///     .type('f')
///     .modifiedTime('+30')
///     .print0()
///     .output();
/// ```
///
/// **The paths come before the expression**, and an option written after a test
/// is read as part of the expression, which usually means find quietly does
/// nothing. [maxDepth] and its neighbours belong right after the paths.
///
/// [print0] pairs with `xargs -0`: filenames may contain spaces and newlines,
/// and the default newline-separated output cannot express that. Dart's own
/// `Directory.list` is better still when the result stays inside the process:
/// no quoting question at all.
///
/// The flavours differ. BSD wants the paths before the options and has
/// [acl], [flags] and [extendedAttributes]; GNU accepts either order and has
/// `-printf`, which BSD does not. [name], [type], [maxDepth], [delete] and
/// [exec] behave the same on both.
class FindCmd extends CommandBuilder<FindCmd> {
  @override
  final String executable = 'find';

  /// Follows no symlink, which is the default (`-P`).
  FindCmd noFollowLinks() => token('-P');

  /// Follows the symlinks named on the command line (`-H`).
  FindCmd followCommandLineLinks() => token('-H');

  /// Follows every symlink (`-L`).
  FindCmd followLinks() => token('-L');

  /// Reads the patterns as extended regular expressions (`-E`).
  FindCmd extendedRegex() => token('-E');

  /// Visits the contents of a directory before the directory (`-depth`).
  ///
  /// What [delete] needs, and sets on its own, since a directory cannot be
  /// removed before what is inside it.
  FindCmd depthFirst() => token('-depth');

  /// Stays on one filesystem (`-x`).
  FindCmd noCrossMounts() => token('-x');

  /// How deep to descend (`-maxdepth`). `0` means the named paths only.
  FindCmd maxDepth(String value) => pair('-maxdepth', value);

  /// How deep to start reporting (`-mindepth`).
  FindCmd minDepth(String value) => pair('-mindepth', value);

  /// Matches the name against a glob (`-name`).
  FindCmd name(String pattern) => pair('-name', pattern);

  /// The same, ignoring case (`-iname`).
  FindCmd nameIgnoreCase(String pattern) => pair('-iname', pattern);

  /// Matches the whole path against a glob (`-path`).
  FindCmd path_(String pattern) => pair('-path', pattern);

  /// Matches the whole path against a regular expression (`-regex`).
  FindCmd regex(String pattern) => pair('-regex', pattern);

  /// The kind of entry: `f` file, `d` directory, `l` symlink, `s` socket (`-type`).
  FindCmd type(String value) => pair('-type', value);

  /// Matches the permission bits (`-perm`).
  FindCmd perm(String value) => pair('-perm', value);

  /// Matches the owner (`-user`).
  FindCmd user(String value) => pair('-user', value);

  /// Matches the group (`-group`).
  FindCmd group(String value) => pair('-group', value);

  /// Matches the size, `+10M` and the like (`-size`).
  FindCmd size(String value) => pair('-size', value);

  /// Matches the modification age in days, `+30` for older than (`-mtime`).
  FindCmd modifiedTime(String value) => pair('-mtime', value);

  /// The same in minutes (`-mmin`).
  FindCmd modifiedMinutes(String value) => pair('-mmin', value);

  /// Matches the access age in days (`-atime`).
  FindCmd accessTime(String value) => pair('-atime', value);

  /// Matches the inode change age in days (`-ctime`).
  FindCmd changeTime(String value) => pair('-ctime', value);

  /// Modified more recently than this file (`-newer`).
  FindCmd newerThan(String path) => pair('-newer', path);

  /// Matches nothing but empty files and directories (`-empty`).
  FindCmd empty() => token('-empty');

  /// Matches the BSD file flags (`-flags`). BSD only.
  FindCmd flags(String value) => pair('-flags', value);

  /// Matches entries carrying an ACL (`-acl`). BSD only.
  FindCmd acl() => token('-acl');

  /// Matches entries carrying extended attributes (`-xattr`). BSD only.
  FindCmd extendedAttributes() => token('-xattr');

  /// Matches the filesystem type (`-fstype`).
  FindCmd fstype(String value) => pair('-fstype', value);

  /// Matches the link count (`-links`).
  FindCmd links(String value) => pair('-links', value);

  /// Prints the path, which is the default (`-print`).
  FindCmd print_() => token('-print');

  /// Prints the paths separated by NUL rather than newline (`-print0`).
  FindCmd print0() => token('-print0');

  /// Lists the entries as `ls -l` would (`-ls`).
  FindCmd listLong() => token('-ls');

  /// Deletes what matched (`-delete`).
  ///
  /// Say it last. Written before a test it deletes everything it walked over,
  /// and there is no confirmation and no undo.
  FindCmd delete() => token('-delete');

  /// Runs a command on each match (`-exec`).
  ///
  /// `{}` is the path, and the expression ends with `;`, or with `+` to pass
  /// several paths per invocation, which is much faster.
  FindCmd exec() => token('-exec');

  /// The same, from inside the directory holding the match (`-execdir`).
  FindCmd execInDirectory() => token('-execdir');

  /// Asks before each command (`-ok`). Interactive.
  FindCmd okExec() => token('-ok');

  /// Skips the contents of a matching directory (`-prune`).
  FindCmd prune() => token('-prune');

  /// Stops at the first match (`-quit`).
  FindCmd quit() => token('-quit');

  /// Negates the test that follows (`-not`).
  FindCmd not() => token('-not');

  /// Ends an [exec] expression, one path per run (`;`).
  FindCmd endExec() => token(';');

  /// Ends an [exec] expression, several paths per run (`+`).
  FindCmd endExecBatched() => token('+');

  /// Adds a path to walk. Comes before the expression.
  FindCmd path(String value) => token(value);

  /// Adds a bare argument, a word of an [exec] expression above all.
  FindCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
FindCmd get Find => FindCmd();
