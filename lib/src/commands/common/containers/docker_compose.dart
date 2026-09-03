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

/// `docker compose`, the multi-container runner. Part of the docker install
/// rather than a separate binary these days, so it exists wherever the docker
/// client does, but it is a plugin, and an install missing it answers `unknown
/// command`, which is worth checking for once rather than debugging twice.
///
/// ```dart
/// await DockerCompose.composeFile(stack.path).projectName('koko').up().detach().execute();
/// ```
///
/// The executable is `docker`; the wrapper seeds `compose` for you, so a chain
/// starts at the first option. **The global options come before the subcommand**:
/// [composeFile], [projectName], [envFile] and [projectDirectory] first, then
/// [up], [down] and the rest.
class DockerComposeCmd extends CommandBuilder<DockerComposeCmd> {
  DockerComposeCmd() {
    token('compose');
  }

  @override
  final String executable = 'docker';

  /// Adds a compose file (`--file`). Repeat to layer overrides in order.
  DockerComposeCmd composeFile(String path) => pair('--file', path);

  /// The project name, which prefixes every container and network (`--project-name`).
  DockerComposeCmd projectName(String value) => pair('--project-name', value);

  /// Activates a service profile (`--profile`).
  DockerComposeCmd profile(String value) => pair('--profile', value);

  /// The `.env` to read (`--env-file`).
  DockerComposeCmd envFile(String path) => pair('--env-file', path);

  /// The directory relative paths resolve against (`--project-directory`).
  ///
  /// Without it compose uses the directory of the first compose file, which is
  /// rarely what you want once those files live in a subdirectory.
  DockerComposeCmd projectDirectory(String path) => pair('--project-directory', path);

  /// How progress is printed: `auto`, `tty`, `plain`, `json` or `quiet` (`--progress`).
  DockerComposeCmd progress(String value) => pair('--progress', value);

  /// How many operations may run at once, `-1` for unlimited (`--parallel`).
  DockerComposeCmd parallel(String value) => pair('--parallel', value);

  /// When to emit ANSI control characters: `never`, `always` or `auto` (`--ansi`).
  DockerComposeCmd ansi(String value) => pair('--ansi', value);

  /// Reports what would happen and touches nothing (`--dry-run`).
  DockerComposeCmd dryRun() => token('--dry-run');

  /// Runs in backward compatibility mode (`--compatibility`).
  DockerComposeCmd compatibility() => token('--compatibility');

  /// Includes the resources no service references (`--all-resources`).
  DockerComposeCmd allResources() => token('--all-resources');

  /// Creates and starts everything (`up`).
  DockerComposeCmd up() => token('up');

  /// Stops and removes the containers and networks (`down`).
  DockerComposeCmd down() => token('down');

  /// Builds the service images (`build`).
  DockerComposeCmd build() => token('build');

  /// Prints the merged compose file in canonical form (`config`).
  ///
  /// The cheapest validation there is: it fails on a bad file without starting
  /// anything.
  DockerComposeCmd config() => token('config');

  /// Creates the containers without starting them (`create`).
  DockerComposeCmd create() => token('create');

  /// Copies between a service container and the filesystem (`cp`).
  DockerComposeCmd cp() => token('cp');

  /// Streams the events of the project (`events`).
  DockerComposeCmd events() => token('events');

  /// Runs a command in a running service container (`exec`).
  DockerComposeCmd exec() => token('exec');

  /// Lists the images the services use (`images`).
  DockerComposeCmd images() => token('images');

  /// Kills the service containers (`kill`).
  DockerComposeCmd kill() => token('kill');

  /// Streams the service logs (`logs`).
  DockerComposeCmd logs() => token('logs');

  /// Lists the compose projects running (`ls`).
  DockerComposeCmd ls() => token('ls');

  /// Pauses the services (`pause`).
  DockerComposeCmd pause() => token('pause');

  /// Prints the public port behind a service port (`port`).
  DockerComposeCmd port() => token('port');

  /// Lists the containers of the project (`ps`).
  DockerComposeCmd ps() => token('ps');

  /// Pulls the service images (`pull`).
  DockerComposeCmd pull() => token('pull');

  /// Pushes the service images (`push`).
  DockerComposeCmd push() => token('push');

  /// Restarts the services (`restart`).
  DockerComposeCmd restart() => token('restart');

  /// Removes the stopped service containers (`rm`).
  DockerComposeCmd rm() => token('rm');

  /// Runs a one-off command on a service (`run`).
  DockerComposeCmd run() => token('run');

  /// Changes the number of containers of a service (`scale`).
  DockerComposeCmd scale() => token('scale');

  /// Starts the existing containers (`start`).
  DockerComposeCmd start() => token('start');

  /// Streams the resource usage (`stats`).
  DockerComposeCmd stats() => token('stats');

  /// Stops the services without removing them (`stop`).
  DockerComposeCmd stop() => token('stop');

  /// Lists the processes running in the services (`top`).
  DockerComposeCmd top() => token('top');

  /// Unpauses the services (`unpause`).
  DockerComposeCmd unpause() => token('unpause');

  /// Prints the compose version (`version`).
  DockerComposeCmd version() => token('version');

  /// Blocks until the services stop (`wait`).
  DockerComposeCmd waitFor() => token('wait');

  /// Rebuilds the containers as the sources change (`watch`).
  DockerComposeCmd watch() => token('watch');

  /// Lists the volumes of the project (`volumes`).
  DockerComposeCmd volumes() => token('volumes');

  /// Starts in the background and returns (`--detach`).
  DockerComposeCmd detach() => token('--detach');

  /// Builds the images before starting (`--build`).
  DockerComposeCmd buildFirst() => token('--build');

  /// Recreates the containers even when nothing changed (`--force-recreate`).
  DockerComposeCmd forceRecreate() => token('--force-recreate');

  /// Keeps the existing containers even when the config changed (`--no-recreate`).
  DockerComposeCmd noRecreate() => token('--no-recreate');

  /// Starts nothing else the service depends on (`--no-deps`).
  DockerComposeCmd noDeps() => token('--no-deps');

  /// Waits until the services report healthy before returning (`--wait`).
  ///
  /// The honest alternative to sleeping and hoping; it needs a healthcheck in the
  /// compose file to mean anything.
  DockerComposeCmd waitHealthy() => token('--wait');

  /// How long [waitHealthy] may wait, in seconds (`--wait-timeout`).
  DockerComposeCmd waitTimeout(String seconds) => pair('--wait-timeout', seconds);

  /// Removes the named volumes as well (`--volumes`). The data goes with them.
  DockerComposeCmd removeVolumes() => token('--volumes');

  /// Removes the images too: `all` or `local` (`--rmi`).
  DockerComposeCmd removeImages(String value) => pair('--rmi', value);

  /// Removes the containers of services no longer in the file (`--remove-orphans`).
  DockerComposeCmd removeOrphans() => token('--remove-orphans');

  /// Removes the container once the one-off command exits (`--rm`).
  DockerComposeCmd removeOnExit() => token('--rm');

  /// Keeps stdin open (`--interactive`).
  DockerComposeCmd interactive() => token('--interactive');

  /// Allocates a pseudo-tty (`--tty`). Leave it off when capturing the output.
  DockerComposeCmd tty() => token('--tty');

  /// Runs without a tty, the compose spelling (`--no-TTY`).
  DockerComposeCmd noTty() => token('--no-TTY');

  /// Sets an environment variable for the command, `NAME=value` (`--env`).
  DockerComposeCmd env(String value) => pair('--env', value);

  /// The user to run the command as (`--user`).
  DockerComposeCmd user(String value) => pair('--user', value);

  /// The working directory inside the container (`--workdir`).
  DockerComposeCmd workdir(String path) => pair('--workdir', path);

  /// Builds without the layer cache (`--no-cache`).
  DockerComposeCmd noCache() => token('--no-cache');

  /// Pulls the base images before building (`--pull`).
  DockerComposeCmd pullFirst() => token('--pull');

  /// Keeps following the logs (`--follow`).
  DockerComposeCmd follow() => token('--follow');

  /// Only the last so many log lines (`--tail`).
  DockerComposeCmd tail(String value) => pair('--tail', value);

  /// Prefixes the log lines with their timestamp (`--timestamps`).
  DockerComposeCmd timestamps() => token('--timestamps');

  /// Prints ids only (`--quiet`).
  DockerComposeCmd quiet() => token('--quiet');

  /// Everything, stopped containers included (`--all`).
  DockerComposeCmd all() => token('--all');

  /// Formats the output, `json` above all (`--format`).
  DockerComposeCmd format(String value) => pair('--format', value);

  /// Filters the listing (`--filter`).
  DockerComposeCmd filter(String value) => pair('--filter', value);

  /// How long to wait for a graceful stop (`--timeout`).
  DockerComposeCmd timeout(String seconds) => pair('--timeout', seconds);

  /// Ends the compose options, so the rest belongs to the container (`--`).
  DockerComposeCmd separator() => token('--');

  /// Adds a bare argument: a service name, a command, its arguments.
  DockerComposeCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
DockerComposeCmd get DockerCompose => DockerComposeCmd();
