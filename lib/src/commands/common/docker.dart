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

/// `docker`, the container client. Available for macOS, Windows and Linux, but a
/// separate install everywhere, so `commandExists` first, and remember the client
/// can be present while the daemon it talks to is not running.
///
/// ```dart
/// final ShellResult running = await Docker.ps().quiet().filter('name=db').output();
/// ```
///
/// Like the git wrapper, this is a vocabulary rather than a grammar: every
/// subcommand is a method, and the flags shared across subcommands are one method
/// each. Nothing here checks that `--detach` belongs to the subcommand you picked;
/// docker will say so.
///
/// Global options such as [context] and [host] go before the subcommand, which is
/// why they read first in a chain.
class DockerCmd extends CommandBuilder<DockerCmd> {
  @override
  final String executable = 'docker';

  /// The client configuration directory (`--config`).
  DockerCmd clientConfig(String path) => pair('--config', path);

  /// The context to connect through, overriding `DOCKER_HOST` (`--context`).
  DockerCmd context(String name) => pair('--context', name);

  /// Turns debug logging on (`--debug`).
  DockerCmd debug() => token('--debug');

  /// The daemon socket to talk to (`--host`).
  DockerCmd host(String value) => pair('--host', value);

  /// How much the client says: `debug`, `info`, `warn`, `error` or `fatal` (`--log-level`).
  DockerCmd logLevel(String value) => pair('--log-level', value);

  /// Uses TLS, implied by [tlsVerify] (`--tls`).
  DockerCmd tls() => token('--tls');

  /// The CA whose certificates to trust (`--tlscacert`).
  DockerCmd tlsCacert(String path) => pair('--tlscacert', path);

  /// The client certificate (`--tlscert`).
  DockerCmd tlsCert(String path) => pair('--tlscert', path);

  /// The client key (`--tlskey`).
  DockerCmd tlsKey(String path) => pair('--tlskey', path);

  /// Uses TLS and verifies the daemon (`--tlsverify`).
  DockerCmd tlsVerify() => token('--tlsverify');

  /// Prints the client and daemon version (`--version`).
  DockerCmd versionFlag() => token('--version');

  /// Creates a container and runs it (`run`).
  DockerCmd run() => token('run');

  /// Runs a command inside a container that is already up (`exec`).
  DockerCmd exec() => token('exec');

  /// Lists containers (`ps`). Only the running ones unless [all].
  DockerCmd ps() => token('ps');

  /// Builds an image from a Dockerfile (`build`).
  DockerCmd build() => token('build');

  /// Downloads an image (`pull`).
  DockerCmd pull() => token('pull');

  /// Uploads an image (`push`).
  DockerCmd push() => token('push');

  /// Lists images (`images`).
  DockerCmd images() => token('images');

  /// Authenticates to a registry (`login`).
  DockerCmd login() => token('login');

  /// Logs out of a registry (`logout`).
  DockerCmd logout() => token('logout');

  /// Searches the public registry (`search`).
  DockerCmd search() => token('search');

  /// Prints the version information (`version`).
  DockerCmd version() => token('version');

  /// Prints system-wide information (`info`).
  DockerCmd info() => token('info');

  /// Manages builds (`builder`).
  DockerCmd builder() => token('builder');

  /// Manages checkpoints (`checkpoint`).
  DockerCmd checkpoint() => token('checkpoint');

  /// Manages containers (`container`).
  DockerCmd container() => token('container');

  /// Manages contexts (`context` as a subcommand, not the global flag).
  DockerCmd contextCommand() => token('context');

  /// Manages images (`image`).
  DockerCmd image() => token('image');

  /// Manages image manifests (`manifest`).
  DockerCmd manifest() => token('manifest');

  /// Manages networks (`network`).
  DockerCmd network() => token('network');

  /// Manages plugins (`plugin`).
  DockerCmd plugin() => token('plugin');

  /// Manages the daemon itself (`system`). `system prune` lives here.
  DockerCmd system() => token('system');

  /// Manages volumes (`volume`).
  DockerCmd volume() => token('volume');

  /// Manages Swarm configs (`config`).
  DockerCmd config() => token('config');

  /// Manages Swarm nodes (`node`).
  DockerCmd node() => token('node');

  /// Manages Swarm secrets (`secret`).
  DockerCmd secret() => token('secret');

  /// Manages Swarm services (`service`).
  DockerCmd service() => token('service');

  /// Manages Swarm stacks (`stack`).
  DockerCmd stack() => token('stack');

  /// Manages the Swarm (`swarm`).
  DockerCmd swarm() => token('swarm');

  /// Attaches the local streams to a running container (`attach`).
  DockerCmd attach() => token('attach');

  /// Makes an image out of a container's changes (`commit`).
  DockerCmd commit() => token('commit');

  /// Copies between a container and the local filesystem (`cp`).
  DockerCmd cp() => token('cp');

  /// Creates a container without starting it (`create`).
  DockerCmd create() => token('create');

  /// Shows what changed in a container filesystem (`diff`).
  DockerCmd diff() => token('diff');

  /// Streams the daemon events (`events`).
  DockerCmd events() => token('events');

  /// Writes a container filesystem out as a tar archive (`export`).
  DockerCmd exportFilesystem() => token('export');

  /// Shows the layers of an image (`history`).
  DockerCmd history() => token('history');

  /// Makes an image out of a tarball (`import`).
  DockerCmd importTarball() => token('import');

  /// Prints the low-level record of any docker object (`inspect`).
  DockerCmd inspect() => token('inspect');

  /// Kills containers (`kill`).
  DockerCmd kill() => token('kill');

  /// Loads an image from a tar archive (`load`).
  DockerCmd load() => token('load');

  /// Fetches the logs of a container (`logs`).
  DockerCmd logs() => token('logs');

  /// Pauses every process in a container (`pause`).
  DockerCmd pause() => token('pause');

  /// Lists the port mappings of a container (`port`).
  DockerCmd port() => token('port');

  /// Renames a container (`rename`).
  DockerCmd rename() => token('rename');

  /// Restarts containers (`restart`).
  DockerCmd restart() => token('restart');

  /// Removes containers (`rm`).
  DockerCmd rm() => token('rm');

  /// Removes images (`rmi`).
  DockerCmd rmi() => token('rmi');

  /// Saves images to a tar archive (`save`).
  DockerCmd save() => token('save');

  /// Starts stopped containers (`start`).
  DockerCmd start() => token('start');

  /// Streams the resource usage of containers (`stats`).
  DockerCmd stats() => token('stats');

  /// Stops running containers (`stop`).
  DockerCmd stop() => token('stop');

  /// Tags an image (`tag`).
  DockerCmd tag() => token('tag');

  /// Lists the processes inside a container (`top`).
  DockerCmd top() => token('top');

  /// Unpauses a container (`unpause`).
  DockerCmd unpause() => token('unpause');

  /// Updates the configuration of running containers (`update`).
  DockerCmd update() => token('update');

  /// Blocks until containers stop, then prints their exit codes (`wait`).
  DockerCmd waitFor() => token('wait');

  /// Removes the unused objects (`prune`). Pair it with a management subcommand.
  DockerCmd prune() => token('prune');

  /// Lists (`ls`), the spelling the management subcommands use.
  DockerCmd ls() => token('ls');

  /// Everything, not just what is running (`--all`).
  DockerCmd all() => token('--all');

  /// Detaches and prints the container id (`--detach`).
  DockerCmd detach() => token('--detach');

  /// Names the container (`--name`).
  DockerCmd name(String value) => pair('--name', value);

  /// Publishes a port, `host:container` (`--publish`).
  DockerCmd publish(String value) => pair('--publish', value);

  /// Publishes every exposed port to a random host port (`--publish-all`).
  DockerCmd publishAll() => token('--publish-all');

  /// Mounts a volume or a bind, `source:target` (`--volume`).
  DockerCmd volumeMount(String value) => pair('--volume', value);

  /// Mounts with the long syntax, `type=bind,src=...,dst=...` (`--mount`).
  DockerCmd mount(String value) => pair('--mount', value);

  /// Sets an environment variable, `NAME=value` (`--env`).
  DockerCmd env(String value) => pair('--env', value);

  /// Reads the environment from a file (`--env-file`).
  DockerCmd envFile(String path) => pair('--env-file', path);

  /// The working directory inside the container (`--workdir`).
  DockerCmd workdir(String path) => pair('--workdir', path);

  /// The user to run as, `uid:gid` or a name (`--user`).
  DockerCmd user(String value) => pair('--user', value);

  /// Removes the container once it exits (`--rm`).
  DockerCmd removeOnExit() => token('--rm');

  /// Keeps stdin open (`--interactive`).
  DockerCmd interactive() => token('--interactive');

  /// Allocates a pseudo-tty (`--tty`).
  ///
  /// Leave it off for anything scripted: a tty makes docker line-buffer and
  /// colourise, and the captured output stops being clean.
  DockerCmd tty() => token('--tty');

  /// The network to join (`--network`).
  DockerCmd joinNetwork(String value) => pair('--network', value);

  /// The restart policy (`--restart`).
  DockerCmd restartPolicy(String value) => pair('--restart', value);

  /// Overrides the image entrypoint (`--entrypoint`).
  DockerCmd entrypoint(String value) => pair('--entrypoint', value);

  /// Adds a label, `key=value` (`--label`).
  DockerCmd label(String value) => pair('--label', value);

  /// The platform to pull or build for, `linux/amd64` and the like (`--platform`).
  DockerCmd platform(String value) => pair('--platform', value);

  /// The pull policy: `always`, `missing` or `never` (`--pull`).
  DockerCmd pullPolicy(String value) => pair('--pull', value);

  /// Prints ids only (`--quiet`). What you parse.
  DockerCmd quiet() => token('--quiet');

  /// Forces the operation through (`--force`).
  DockerCmd force() => token('--force');

  /// Filters the listing, `name=db` or `status=running` (`--filter`).
  DockerCmd filter(String value) => pair('--filter', value);

  /// Formats the output with a Go template (`--format`).
  ///
  /// `--format=json` on the listings is the one to reach for; the table output is
  /// column-aligned for humans and painful to parse.
  DockerCmd format(String value) => pair('--format', value);

  /// Keeps following the log output (`--follow`).
  DockerCmd follow() => token('--follow');

  /// Only the last so many log lines (`--tail`).
  DockerCmd tail(String value) => pair('--tail', value);

  /// Only what happened since this timestamp or duration (`--since`).
  DockerCmd since(String value) => pair('--since', value);

  /// Prefixes each log line with its timestamp (`--timestamps`).
  DockerCmd timestamps() => token('--timestamps');

  /// Builds without the layer cache (`--no-cache`).
  DockerCmd noCache() => token('--no-cache');

  /// Sets a build argument, `NAME=value` (`--build-arg`).
  DockerCmd buildArg(String value) => pair('--build-arg', value);

  /// Tags the built image (`--tag`).
  DockerCmd tagAs(String value) => pair('--tag', value);

  /// The Dockerfile to build from (`--file`).
  DockerCmd file(String path) => pair('--file', path);

  /// The build stage to stop at (`--target`).
  DockerCmd target(String value) => pair('--target', value);

  /// How the build reports progress: `auto`, `plain`, `tty` or `quiet` (`--progress`).
  ///
  /// `plain` is the one for a log file; the default redraws itself and reads as
  /// noise once captured.
  DockerCmd progress(String value) => pair('--progress', value);

  /// Signals a container with something other than `SIGKILL` (`--signal`).
  DockerCmd signal(String value) => pair('--signal', value);

  /// How long to wait for a graceful stop (`--time`).
  DockerCmd time(String value) => pair('--time', value);

  /// Also removes the anonymous volumes (`--volumes`).
  DockerCmd volumes() => token('--volumes');

  /// Ends the docker options, so the rest belongs to the container (`--`).
  DockerCmd separator() => token('--');

  /// Adds a bare argument: an image, a container name, a command to run inside.
  DockerCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
DockerCmd get Docker => DockerCmd();
