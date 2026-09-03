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

/// `pacman`, the Arch Linux package tool. Arch and its derivatives only,
/// Manjaro included; a Fedora box has `dnf` and a Debian one `apt-get`.
///
/// pacman's grammar is unusual among the three: it takes exactly one
/// *operation* ([sync], [remove], [query], [upgrade], [database], [files],
/// [deptest], [versionFlag] or [helpFlag]), then the flags that operation
/// understands, then the targets.
///
/// ```dart
/// await Pacman.sync().refresh().sysupgrade().noconfirm().asRoot().execute();
/// await Pacman.sync().search().arg('neovim').output();
/// await Pacman.query().arg('neovim').output();
/// ```
///
/// **This wrapper is a vocabulary, not a grammar.** [search], [info] and
/// [list] each read as one method because pacman spells them the same way
/// under [sync] (`-Ss`, `-Si`, `-Sl`) and under [query] (`-Qs`, `-Qi`, `-Ql`);
/// nothing stops pairing [search] with [remove], and pacman will say so.
///
/// [refresh] and [clean] are repeatable, and pacman gives the repeat its own
/// meaning: `-Sy` refreshes the databases pacman thinks are stale, `-Syy`
/// forces the refresh regardless; `-Sc` trims the cache to what is
/// installed, `-Scc` empties it outright. Call the method twice to get the
/// doubled flag.
///
/// pacman almost always needs `asRoot()` for [sync], [remove], [upgrade] and
/// [database], since those write to `/var/lib/pacman` and to the system
/// itself. [query] never does: it only reads the local database.
class PacmanCmd extends CommandBuilder<PacmanCmd> {
  @override
  final String executable = 'pacman';

  /// Installs packages from the sync repositories, or acts on that database (`-S`).
  PacmanCmd sync() => token('-S');

  /// Removes installed packages (`-R`).
  PacmanCmd remove() => token('-R');

  /// Reads the local package database (`-Q`). With no target, lists everything installed.
  PacmanCmd query() => token('-Q');

  /// Installs a package from a local file or a URL (`-U`).
  PacmanCmd upgrade() => token('-U');

  /// Edits the installed-package database directly, `--asdeps` and `--asexplicit` chief among its uses (`-D`).
  PacmanCmd database() => token('-D');

  /// Reads the files database, which package owns which path (`-F`).
  PacmanCmd files() => token('-F');

  /// Checks whether the given dependency strings are satisfied (`-T`).
  ///
  /// What `makepkg` calls internally to decide what is still missing.
  PacmanCmd deptest() => token('-T');

  /// Prints the version and exits (`-V`). The flag, not a query for one package.
  PacmanCmd versionFlag() => token('-V');

  /// Prints the help for the chosen operation, or the general help with none (`-h`).
  PacmanCmd helpFlag() => token('-h');

  /// Downloads a fresh copy of the sync databases (`--refresh`).
  ///
  /// Repeatable: see the class documentation for what a second [refresh] means.
  PacmanCmd refresh() => token('--refresh');

  /// Upgrades every out-of-date package (`--sysupgrade`).
  ///
  /// Repeatable: a second [sysupgrade] additionally allows packages to be
  /// downgraded when a sync repository now carries an older build.
  PacmanCmd sysupgrade() => token('--sysupgrade');

  /// Skips a target already at the requested version (`--needed`).
  ///
  /// What keeps a reinstall-everything script from reinstalling everything.
  PacmanCmd needed() => token('--needed');

  /// Answers every `Are you sure?` prompt with yes (`--noconfirm`).
  PacmanCmd noconfirm() => token('--noconfirm');

  /// Searches names and descriptions for a pattern (`--search`).
  ///
  /// Searches the sync databases under [sync], the local database under [query].
  PacmanCmd search() => token('--search');

  /// Prints the full detail of a package (`--info`).
  ///
  /// Reads the sync databases under [sync], the local database under [query].
  PacmanCmd info() => token('--info');

  /// Lists packages (`--list`).
  ///
  /// Lists a repository's packages under [sync], a package's files under [query].
  PacmanCmd list() => token('--list');

  /// Removes stale files from the package cache (`--clean`).
  ///
  /// Repeatable: see the class documentation for what a second [clean] means.
  PacmanCmd clean() => token('--clean');

  /// Fetches packages without installing them (`--downloadonly`).
  PacmanCmd downloadonly() => token('--downloadonly');

  /// Lists the members of a package group (`--groups`).
  PacmanCmd groups() => token('--groups');

  /// Records the targets as installed for a dependency, not by request (`--asdeps`).
  PacmanCmd asdeps() => token('--asdeps');

  /// Records the targets as explicitly installed (`--asexplicit`).
  ///
  /// What keeps `-Qdt` from later offering a package for removal as an orphan.
  PacmanCmd asexplicit() => token('--asexplicit');

  /// Refuses to upgrade this package even when one is available (`--ignore`).
  PacmanCmd ignore(String pkg) => joined('--ignore', pkg);

  /// The same, for every package in a group (`--ignoregroup`).
  PacmanCmd ignoregroup(String group) => joined('--ignoregroup', group);

  /// Installs over files pacman would otherwise refuse to touch (`--overwrite`).
  ///
  /// Takes a glob, so `--overwrite '*'` is the usual escape hatch for a file
  /// conflict that is known to be safe.
  PacmanCmd overwrite(String glob) => joined('--overwrite', glob);

  /// Removes a target's dependencies too, if nothing else needs them (`--recursive`).
  PacmanCmd recursive() => token('--recursive');

  /// Leaves configuration files on disk instead of the usual `.pacsave` (`--nosave`).
  PacmanCmd nosave() => token('--nosave');

  /// Also removes every package that depends on a target (`--cascade`).
  PacmanCmd cascade() => token('--cascade');

  /// Removes the installed packages nothing depends on any more, no target needed (`--unneeded`).
  PacmanCmd unneeded() => token('--unneeded');

  /// Narrows a query to which package owns the given file (`--owns`).
  PacmanCmd owns() => token('--owns');

  /// Narrows a query to explicitly installed packages (`--explicit`).
  PacmanCmd explicit() => token('--explicit');

  /// Narrows a query to packages installed as a dependency (`--deps`).
  PacmanCmd deps() => token('--deps');

  /// Narrows a query to packages nothing installed requires (`--unrequired`).
  ///
  /// Pair with [deps] for the orphan list a cleanup script removes.
  PacmanCmd unrequired() => token('--unrequired');

  /// Narrows a query to packages a sync would upgrade (`--upgrades`).
  PacmanCmd upgrades() => token('--upgrades');

  /// Narrows a query to packages no sync repository carries any more (`--foreign`).
  ///
  /// Where an AUR-built package always shows up, since pacman never tracked it.
  PacmanCmd foreign() => token('--foreign');

  /// Narrows a query to packages a sync repository does carry (`--native`).
  PacmanCmd native() => token('--native');

  /// Verifies every file of the given packages is present on disk (`--check`).
  PacmanCmd check() => token('--check');

  /// Prints extra detail: the root, the config file, the database and cache paths (`--verbose`).
  PacmanCmd verbose() => token('--verbose');

  /// Drops the progress bar, leaving output fit for a log (`--noprogressbar`).
  PacmanCmd noprogressbar() => token('--noprogressbar');

  /// Reads this configuration file instead of `/etc/pacman.conf` (`--config`).
  PacmanCmd config(String path) => joined('--config', path);

  /// Reads and writes the package database at this path instead of `/var/lib/pacman` (`--dbpath`).
  PacmanCmd dbpath(String path) => joined('--dbpath', path);

  /// Treats this path as the filesystem root instead of `/` (`--root`).
  PacmanCmd root(String path) => joined('--root', path);

  /// Downloads packages into this directory instead of `/var/cache/pacman/pkg` (`--cachedir`).
  PacmanCmd cachedir(String path) => joined('--cachedir', path);

  /// When to colour the output: `always`, `never` or `auto` (`--color`).
  PacmanCmd color(String when) => joined('--color', when);

  /// Runs as if the machine were a different architecture (`--arch`).
  PacmanCmd arch(String value) => joined('--arch', value);

  /// Prints the targets the operation would act on and changes nothing (`--print`).
  PacmanCmd printTargets() => token('--print');

  /// The `printf`-like format [printTargets] renders each target with (`--print-format`).
  PacmanCmd printFormat(String format) => joined('--print-format', format);

  /// Adds a package name, a group name, a file path or a URL, depending on the operation.
  PacmanCmd arg(String value) => token(value);
}

/// `pacman`, ready to take its first operation.
// ignore: non_constant_identifier_names
PacmanCmd get Pacman => PacmanCmd();
