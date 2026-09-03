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

/// `kubectl`, the Kubernetes cluster client. A separate install everywhere, and
/// entirely dependent on `~/.kube/config` (or [kubeconfig]) for which cluster
/// it talks to, so `commandExists` first and never assume it means the cluster
/// you think it does.
///
/// ```dart
/// final ShellResult pods = await Kubectl.get().arg('pods').namespace('prod').output('json').output();
/// await Kubectl.apply().filename('deploy.yaml').namespace('prod').execute();
/// await Kubectl.rollout().arg('status').arg('deployment/api').namespace('prod').timeoutFlag('60s').execute();
/// ```
///
/// Like the git and docker wrappers, this is a vocabulary rather than a
/// grammar: every subcommand is a method, and the flags shared across
/// subcommands are one method each. Nothing here checks that `--replicas`
/// belongs to [scale] rather than [get]; kubectl will say so.
///
/// Three habits matter for automation. **[dryRun] with `client`** renders what
/// would be sent without touching the cluster, the safe way to inspect a
/// generated manifest. **[output] with `json` or `name`** is what a script
/// parses; the default table output is for a human's terminal and shifts
/// between versions. And **[context] and [namespace] are easy to leave off by
/// accident**, and kubectl then silently falls back to whatever the current
/// kubeconfig context and namespace are, which is rarely what an automated run
/// wants against a cluster with more than one environment in it.
class KubectlCmd extends CommandBuilder<KubectlCmd> {
  @override
  final String executable = 'kubectl';

  /// Creates a resource from a file or from stdin (`create`).
  KubectlCmd create() => token('create');

  /// Exposes a controller, deployment or pod as a new service (`expose`).
  KubectlCmd expose() => token('expose');

  /// Runs an image on the cluster as a new pod (`run`).
  KubectlCmd run() => token('run');

  /// Sets a specific feature on an object, image or resources among them (`set`).
  KubectlCmd set() => token('set');

  /// Prints documentation for a resource and its fields (`explain`).
  KubectlCmd explain() => token('explain');

  /// Displays one or many resources (`get`).
  KubectlCmd get() => token('get');

  /// Opens a resource in `$KUBE_EDITOR` and applies the saved changes (`edit`). Interactive.
  KubectlCmd edit() => token('edit');

  /// Deletes resources by file, name, or label selector (`delete`).
  KubectlCmd delete() => token('delete');

  /// Manages the rollout of a deployment, daemonset or statefulset (`rollout`).
  ///
  /// Takes `status`, `undo`, `restart`, `pause`, `resume` or `history` as the next positional argument, via [arg].
  KubectlCmd rollout() => token('rollout');

  /// Sets a new replica count for a deployment, replica set or stateful set (`scale`).
  KubectlCmd scale() => token('scale');

  /// Auto-scales a deployment, replica set or stateful set (`autoscale`).
  KubectlCmd autoscale() => token('autoscale');

  /// Modifies certificate signing request resources (`certificate`).
  KubectlCmd certificate() => token('certificate');

  /// Displays the addresses of the control plane and services (`cluster-info`).
  KubectlCmd clusterInfo() => token('cluster-info');

  /// Displays CPU and memory usage for nodes or pods (`top`).
  ///
  /// Needs the Metrics Server running in the cluster. Takes `node` or `pod` as the next positional argument, via [arg].
  KubectlCmd top() => token('top');

  /// Marks a node as unschedulable (`cordon`).
  KubectlCmd cordon() => token('cordon');

  /// Marks a node as schedulable again, undoing [cordon] (`uncordon`).
  KubectlCmd uncordon() => token('uncordon');

  /// Cordons a node and evicts its pods, in preparation for maintenance (`drain`).
  KubectlCmd drain() => token('drain');

  /// Updates the taints on one or more nodes (`taint`).
  KubectlCmd taint() => token('taint');

  /// Shows detailed information about a resource, events included (`describe`).
  KubectlCmd describe() => token('describe');

  /// Prints the logs of a container in a pod (`logs`).
  KubectlCmd logs() => token('logs');

  /// Attaches the local terminal to a running container's main process (`attach`).
  KubectlCmd attach() => token('attach');

  /// Runs a command inside a container (`exec`).
  ///
  /// End the kubectl options with [separator] before the command itself if it has flags of its own.
  KubectlCmd exec() => token('exec');

  /// Forwards local ports to a pod (`port-forward`).
  KubectlCmd portForward() => token('port-forward');

  /// Runs a local proxy to the Kubernetes API server (`proxy`).
  KubectlCmd proxy() => token('proxy');

  /// Copies files and directories to or from a container (`cp`).
  ///
  /// Requires `tar` inside the target container; without it, the copy fails outright.
  KubectlCmd cp() => token('cp');

  /// Inspects authorization: `can-i` and `whoami` (`auth`).
  KubectlCmd auth() => token('auth');

  /// Creates an ephemeral debugging session against a pod or node (`debug`).
  KubectlCmd debug() => token('debug');

  /// Lists the events for a resource, or for the whole namespace (`events`).
  KubectlCmd events() => token('events');

  /// Diffs the live object against what applying a manifest would produce (`diff`).
  KubectlCmd diff() => token('diff');

  /// Applies a configuration to a resource by file name or stdin (`apply`).
  ///
  /// Creates the resource if it does not exist yet. Always create a resource with `apply` or `create --save-config` if you intend to keep managing it with `apply`.
  KubectlCmd apply() => token('apply');

  /// Updates specific fields of a resource (`patch`).
  KubectlCmd patch() => token('patch');

  /// Replaces a resource entirely, by file name or stdin (`replace`).
  KubectlCmd replace() => token('replace');

  /// Waits for a condition on one or more resources (`wait`).
  KubectlCmd wait() => token('wait');

  /// Builds a kustomization target from a directory or URL (`kustomize`).
  KubectlCmd kustomize() => token('kustomize');

  /// Updates the labels on a resource (`label`).
  KubectlCmd label() => token('label');

  /// Updates the annotations on a resource (`annotate`).
  KubectlCmd annotate() => token('annotate');

  /// Outputs a shell completion script (`completion`).
  KubectlCmd completion() => token('completion');

  /// Commands still in alpha (`alpha`).
  KubectlCmd alpha() => token('alpha');

  /// Prints the API resources the server supports (`api-resources`).
  KubectlCmd apiResources() => token('api-resources');

  /// Prints the API versions the server supports, `group/version` form (`api-versions`).
  KubectlCmd apiVersions() => token('api-versions');

  /// Modifies kubeconfig files (`config`).
  ///
  /// Takes `current-context`, `use-context`, `view`, `get-contexts`, `set-context` and similar as the next positional argument, via [arg].
  KubectlCmd config() => token('config');

  /// Manages `kubectl` plugins (`plugin`).
  KubectlCmd plugin() => token('plugin');

  /// Prints the client and server version (`version`).
  KubectlCmd version() => token('version');

  /// Restricts the command to this namespace (`-n`). Falls back to the current context's namespace if left out.
  KubectlCmd namespace(String value) => pair('-n', value);

  /// Runs across every namespace, ignoring [namespace] (`-A`).
  KubectlCmd allNamespaces() => token('-A');

  /// The output format: `json`, `yaml`, `name`, `wide`, `jsonpath=...` and more (`-o`).
  ///
  /// Named around [CommandBuilder.output], the base class's own result-capturing execution method.
  /// `json` or `name` is what a script parses; the default table output is for a terminal and shifts between versions.
  KubectlCmd outputFormat(String format) => pair('-o', format);

  /// Filters by label, `key1=value1,key2!=value2` and the like (`-l`).
  KubectlCmd selector(String query) => pair('-l', query);

  /// Filters by field, `key1=value1,key2!=value2`; only `=`, `==` and `!=` are supported (`--field-selector`).
  KubectlCmd fieldSelector(String query) => pair('--field-selector', query);

  /// A file, directory or URL identifying the resource (`-f`). Repeatable.
  KubectlCmd filename(String path) => pair('-f', path);

  /// Processes the kustomization directory instead of [filename] (`-k`).
  KubectlCmd kustomizeFlag(String path) => pair('-k', path);

  /// Processes the [filename] directory recursively (`-R`).
  KubectlCmd recursive() => token('-R');

  /// Watches for changes after the initial listing (`-w`).
  KubectlCmd watch() => token('-w');

  /// Suppresses the table headers (`--no-headers`).
  KubectlCmd noHeaders() => token('--no-headers');

  /// Adds the resource type to each printed name (`--show-kind`).
  KubectlCmd showKind() => token('--show-kind');

  /// Shows every label as the last column (`--show-labels`).
  KubectlCmd showLabels() => token('--show-labels');

  /// Sorts the list by this JSONPath field, `{.metadata.name}` and the like (`--sort-by`).
  KubectlCmd sortBy(String jsonPath) => pair('--sort-by', jsonPath);

  /// Suppresses the not-found error for a resource that does not exist (`--ignore-not-found`).
  KubectlCmd ignoreNotFound() => token('--ignore-not-found');

  /// How many objects `get` returns per request against the API server (`--chunk-size`). `0` disables chunking.
  KubectlCmd chunkSize(int size) => pair('--chunk-size', '$size');

  /// The subresource to act on, `status` or `scale` among them (`--subresource`).
  KubectlCmd subresource(String value) => pair('--subresource', value);

  /// A Go template, or a path to one, for `-o go-template`/`go-template-file` (`--template`).
  KubectlCmd template(String value) => pair('--template', value);

  /// Simulates the request without persisting it: `none`, `client` or `server` (`--dry-run`).
  ///
  /// `client` renders the object without contacting the API server at all; `server` submits it for validation without saving.
  KubectlCmd dryRun(String mode) => pair('--dry-run', mode);

  /// Selects every resource of the given types in the namespace (`--all`).
  KubectlCmd all() => token('--all');

  /// Skips the graceful deletion period and removes the resource immediately (`--force`).
  ///
  /// For a pod, does not wait for confirmation that its processes actually stopped; can leave duplicates running if the node has not detected the deletion yet.
  KubectlCmd force() => token('--force');

  /// Sets `--grace-period` to `1` for a near-immediate delete (`--now`).
  KubectlCmd now() => token('--now');

  /// The graceful termination period, in seconds; `0` with [force] is immediate (`--grace-period`).
  KubectlCmd gracePeriod(int seconds) => pair('--grace-period', '$seconds');

  /// The deletion cascade strategy: `background`, `orphan` or `foreground` (`--cascade`).
  KubectlCmd cascade(String strategy) => pair('--cascade', strategy);

  /// How long to wait for the operation to finish, `0` for no limit (`--timeout`).
  KubectlCmd timeoutFlag(String duration) => pair('--timeout', duration);

  /// Waits for resources to be deleted before returning (`--wait`).
  KubectlCmd waitFlag() => token('--wait');

  /// Applies using server-side apply instead of the client-side three-way merge (`--server-side`).
  KubectlCmd serverSide() => token('--server-side');

  /// Under [serverSide], forces the change through a field-ownership conflict (`--force-conflicts`).
  KubectlCmd forceConflicts() => token('--force-conflicts');

  /// The name recorded as owning fields under [serverSide] (`--field-manager`).
  KubectlCmd fieldManager(String name) => pair('--field-manager', name);

  /// Deletes objects not present in the applied set, matching the given selector (`--prune`). Still alpha.
  KubectlCmd prune() => token('--prune');

  /// Under [prune], only deletes objects among these allow-listed group/kinds (`--prune-allowlist`).
  KubectlCmd pruneAllowlist(String value) => pair('--prune-allowlist', value);

  /// Formats the diff output, passed through to the diff program (`--diff-options`).
  KubectlCmd diffOptions(String value) => pair('--diff-options', value);

  /// The container to act on; without it, the pod's first or default-annotated container is used (`-c`).
  ///
  /// Shared by [logs], [exec], [cp], [attach] and [describe].
  KubectlCmd container(String name) => pair('-c', name);

  /// Streams the log output continuously instead of a one-time snapshot (`-f`).
  KubectlCmd follow() => token('-f');

  /// Shows the logs of the previously terminated instance of the container (`-p`).
  KubectlCmd previous() => token('-p');

  /// Only logs newer than this duration, `5s`, `2m`, `3h` style (`--since`).
  KubectlCmd since(String duration) => pair('--since', duration);

  /// Only logs newer than this RFC3339 timestamp (`--since-time`).
  KubectlCmd sinceTime(String timestamp) => pair('--since-time', timestamp);

  /// Only the last this many lines of log output; `-1` for everything (`--tail`).
  KubectlCmd tail(int lines) => pair('--tail', '$lines');

  /// Caps the log output at this many bytes (`--limit-bytes`).
  KubectlCmd limitBytes(int bytes) => pair('--limit-bytes', '$bytes');

  /// Prefixes each log line with its source pod and container name (`--prefix`).
  KubectlCmd prefix() => token('--prefix');

  /// Fetches logs from every container in the pod (`--all-containers`).
  KubectlCmd allContainers() => token('--all-containers');

  /// Fetches logs from every pod of the matched resource (`--all-pods`).
  KubectlCmd allPods() => token('--all-pods');

  /// Under [follow], keeps streaming even after a container error (`--ignore-errors`).
  KubectlCmd ignoreErrors() => token('--ignore-errors');

  /// Caps how many pods' logs are requested at once under [selector] (`--max-log-requests`).
  KubectlCmd maxLogRequests(int count) => pair('--max-log-requests', '$count');

  /// How long to wait for a pod to start running before giving up on its logs (`--pod-running-timeout`).
  KubectlCmd podRunningTimeout(String duration) => pair('--pod-running-timeout', duration);

  /// Keeps stdin open to the container (`-i`).
  KubectlCmd stdin() => token('-i');

  /// Allocates a TTY (`-t`).
  ///
  /// Leave it off for anything scripted: a TTY line-buffers and colourises, and the captured output stops being clean.
  KubectlCmd tty() => token('-t');

  /// Ends the kubectl options, so the rest belongs to the command run inside the container (`--`).
  KubectlCmd separator() => token('--');

  /// The desired replica count for [scale] (`--replicas`).
  KubectlCmd replicas(int count) => pair('--replicas', '$count');

  /// Requires the resource's current replica count to match before scaling (`--current-replicas`).
  KubectlCmd currentReplicas(int count) => pair('--current-replicas', '$count');

  /// Requires the resource's resource version to match before scaling (`--resource-version`).
  KubectlCmd resourceVersion(String version) => pair('--resource-version', version);

  /// The condition `wait` waits for, `condition=Ready` or `delete` among them (`--for`).
  KubectlCmd forCondition(String condition) => pair('--for', condition);

  /// The local address `port-forward` and `proxy` bind to, `localhost` by default (`--address`).
  KubectlCmd address(String value) => pair('--address', value);

  /// The kubeconfig file to use, instead of `$KUBECONFIG` or `~/.kube/config` (`--kubeconfig`).
  KubectlCmd kubeconfig(String path) => pair('--kubeconfig', path);

  /// The kubeconfig context to use (`--context`).
  KubectlCmd context(String name) => pair('--context', name);

  /// The kubeconfig cluster to use (`--cluster`).
  KubectlCmd cluster(String name) => pair('--cluster', name);

  /// The kubeconfig user to authenticate as (`--user`).
  KubectlCmd user(String name) => pair('--user', name);

  /// The bearer token to authenticate with, bypassing kubeconfig (`--token`).
  ///
  /// Named around [CommandBuilder.token], the base class's own bare-argument helper. Lands in argv, where `ps` can read it.
  KubectlCmd bearerToken(String value) => pair('--token', value);

  /// The API server URL, bypassing kubeconfig (`--server`).
  KubectlCmd server(String url) => pair('--server', url);

  /// The CA bundle to verify the API server against (`--certificate-authority`).
  KubectlCmd certificateAuthority(String path) => pair('--certificate-authority', path);

  /// The client certificate for authentication (`--client-certificate`).
  KubectlCmd clientCertificate(String path) => pair('--client-certificate', path);

  /// The client key for authentication (`--client-key`).
  KubectlCmd clientKey(String path) => pair('--client-key', path);

  /// Skips TLS verification of the API server (`--insecure-skip-tls-verify`).
  KubectlCmd insecureSkipTlsVerify() => token('--insecure-skip-tls-verify');

  /// Impersonates this user for the request (`--as`).
  KubectlCmd asUser(String name) => pair('--as', name);

  /// Impersonates this group for the request (`--as-group`). Repeatable.
  KubectlCmd asGroup(String name) => pair('--as-group', name);

  /// Caps how long the whole request may take before kubectl gives up (`--request-timeout`).
  KubectlCmd requestTimeout(String duration) => pair('--request-timeout', duration);

  /// The client-side log verbosity, `0` through `9` (`-v`).
  KubectlCmd logVerbosity(int level) => pair('-v', '$level');

  /// Adds a bare positional argument: a resource type, a name, an image, a subcommand's own argument.
  KubectlCmd arg(String value) => token(value);
}

/// `kubectl`, ready to take its first subcommand.
// ignore: non_constant_identifier_names
KubectlCmd get Kubectl => KubectlCmd();
