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

/// `helm`, the Kubernetes package manager. A separate install from [Kubectl],
/// and just as dependent on `~/.kube/config` for which cluster it acts on, so
/// `commandExists` first and check [kubeContext] before anything that mutates
/// a release.
///
/// ```dart
/// await Helm.upgrade().install().createNamespace().atomicWait().namespace('prod')
///     .valuesFile('prod.yaml').arg('api').arg('./charts/api').execute();
///
/// final ShellResult rendered = await Helm.template().arg('api').arg('./charts/api').output();
/// ```
///
/// Like the docker and kubectl wrappers, this is a vocabulary rather than a
/// grammar: every subcommand is a method, and the flags shared across
/// subcommands, [valuesFile] and [setValue] chief among them, are one method
/// each. Nothing here checks that `--atomic` belongs to [upgrade] rather than
/// [template]; helm will say so.
///
/// Three habits worth knowing. **`upgrade --install`**, [install2] here, is
/// the idempotent form almost every pipeline actually wants: a plain [install]
/// fails outright on a release that already exists. **[atomicWait] rolls the
/// whole release back on a failed install or upgrade**, which is what turns a
/// bad rollout into a no-op instead of a half-applied cluster. And **[dryRun]
/// with `server` still talks to the cluster** to validate the rendered
/// manifests; only `client` renders fully offline.
class HelmCmd extends CommandBuilder<HelmCmd> {
  @override
  final String executable = 'helm';

  /// Outputs a shell completion script (`completion`).
  HelmCmd completion(String shell) => pair('completion', shell);

  /// Scaffolds a new chart with the given name (`create`).
  HelmCmd create() => token('create');

  /// Manages a chart's dependencies (`dependency`).
  ///
  /// Takes `build`, `list` or `update` as the next positional argument, via [arg].
  HelmCmd dependency() => token('dependency');

  /// Prints the Helm client's environment information (`env`).
  HelmCmd env() => token('env');

  /// Downloads extended information about a named release (`get`).
  ///
  /// Takes `all`, `hooks`, `manifest`, `notes`, `values` or `metadata` as the next positional argument, via [arg].
  HelmCmd get() => token('get');

  /// Prints the help for helm, or for the subcommand already chained (`help`).
  HelmCmd help() => token('help');

  /// Fetches the release history (`history`).
  HelmCmd history() => token('history');

  /// Installs a chart, failing outright if the release name already exists (`install`).
  ///
  /// [install2] (`upgrade --install`) is the idempotent form most pipelines actually want.
  HelmCmd install() => token('install');

  /// Examines a chart for possible issues (`lint`).
  HelmCmd lint() => token('lint');

  /// Lists releases (`list`, aliased `ls`).
  HelmCmd list() => token('list');

  /// Packages a chart directory into a versioned archive (`package`).
  HelmCmd package() => token('package');

  /// Installs, lists or uninstalls Helm plugins (`plugin`).
  HelmCmd plugin() => token('plugin');

  /// Downloads a chart from a repository, optionally unpacking it (`pull`).
  HelmCmd pull() => token('pull');

  /// Pushes a chart to a remote registry (`push`).
  HelmCmd push() => token('push');

  /// Logs in to, or out of, an OCI registry (`registry`).
  ///
  /// Takes `login` or `logout` as the next positional argument, via [arg].
  HelmCmd registry() => token('registry');

  /// Adds, lists, removes, updates or indexes chart repositories (`repo`).
  ///
  /// Takes `add`, `list`, `remove`, `update` or `index` as the next positional argument, via [arg].
  HelmCmd repo() => token('repo');

  /// Rolls a release back to a previous revision (`rollback`).
  HelmCmd rollback() => token('rollback');

  /// Searches for a keyword in charts, in a repository or the Hub (`search`).
  ///
  /// Takes `repo` or `hub` as the next positional argument, via [arg].
  HelmCmd search() => token('search');

  /// Shows information about a chart: `all`, `chart`, `readme`, `values` or `crds` (`show`).
  HelmCmd show() => token('show');

  /// Displays the status of a named release (`status`).
  HelmCmd status() => token('status');

  /// Renders chart templates locally, without touching the cluster (`template`).
  ///
  /// Everything that would normally be looked up in-cluster is faked, so a chart depending on cluster state renders incompletely.
  HelmCmd template() => token('template');

  /// Runs the tests declared for a release (`test`).
  HelmCmd test() => token('test');

  /// Uninstalls a release (`uninstall`, aliased `del`, `delete`, `un`).
  HelmCmd uninstall() => token('uninstall');

  /// Upgrades a release to a new chart version (`upgrade`).
  ///
  /// Chain [install2] (`--install`) to fall back to installing when the release does not exist yet.
  HelmCmd upgrade() => token('upgrade');

  /// Verifies a chart's provenance and integrity (`verify`).
  HelmCmd verify() => token('verify');

  /// Prints the Helm client version (`version`).
  HelmCmd version() => token('version');

  /// Under [upgrade], installs the release first if it does not already exist (`-i`, `--install`).
  ///
  /// What makes `upgrade` idempotent; a plain [install] fails outright on an existing release.
  HelmCmd install2() => token('--install');

  /// Sets a value on the command line, `key1=val1,key2=val2` (`--set`). Repeatable.
  HelmCmd setValue(String assignment) => pair('--set', assignment);

  /// The same as [setValue], forcing every value to a string (`--set-string`).
  HelmCmd setString(String assignment) => pair('--set-string', assignment);

  /// Sets a value from the contents of a file, `key=path` (`--set-file`).
  HelmCmd setFile(String assignment) => pair('--set-file', assignment);

  /// Sets a JSON-typed value, `key=jsonval` or a whole JSON object as one string (`--set-json`).
  HelmCmd setJson(String assignment) => pair('--set-json', assignment);

  /// Sets a value taken completely literally, with no type coercion at all (`--set-literal`).
  HelmCmd setLiteral(String assignment) => pair('--set-literal', assignment);

  /// A values file or URL to merge in, on top of the chart's defaults (`-f`, `--values`). Repeatable; the last one wins on conflicts.
  HelmCmd valuesFile(String path) => pair('--values', path);

  /// The namespace to operate in (`-n`, `--namespace`).
  HelmCmd namespace(String value) => pair('--namespace', value);

  /// Creates the release namespace first if it does not already exist (`--create-namespace`).
  HelmCmd createNamespace() => token('--create-namespace');

  /// Simulates the operation without persisting changes: `none`, `client` or `server` (`--dry-run`).
  ///
  /// `client` renders fully offline; `server` still talks to the cluster, to validate against its OpenAPI schema.
  HelmCmd dryRun(String mode) => pair('--dry-run', mode);

  /// Hides Kubernetes Secrets when combined with [dryRun] (`--hide-secret`).
  HelmCmd hideSecret() => token('--hide-secret');

  /// Waits for the resources to become ready before returning, up to [timeout] (`--wait`).
  ///
  /// The strategy defaults to `hookOnly`; pass `watcher` or `legacy` explicitly where that matters.
  HelmCmd waitFlag() => token('--wait');

  /// Under [waitFlag], also waits for every Job to complete (`--wait-for-jobs`).
  HelmCmd waitForJobs() => token('--wait-for-jobs');

  /// How long to wait for any individual Kubernetes operation, `5m0s` by default (`--timeout`).
  HelmCmd timeoutFlag(String duration) => pair('--timeout', duration);

  /// Rolls the release back automatically if install or upgrade fails (`--atomic`).
  ///
  /// Implies [waitFlag]. The setting that turns a bad rollout into a no-op instead of a half-applied cluster.
  HelmCmd atomicWait() => token('--atomic');

  /// Skips running the chart's hooks (`--no-hooks`).
  HelmCmd noHooks() => token('--no-hooks');

  /// Skips OpenAPI schema validation of the rendered templates (`--disable-openapi-validation`).
  HelmCmd disableOpenapiValidation() => token('--disable-openapi-validation');

  /// Skips installing any CustomResourceDefinitions the chart carries (`--skip-crds`).
  HelmCmd skipCrds() => token('--skip-crds');

  /// Disables JSON schema validation of the supplied values (`--skip-schema-validation`).
  HelmCmd skipSchemaValidation() => token('--skip-schema-validation');

  /// Generates the release name instead of taking one positionally (`-g`, `--generate-name`).
  HelmCmd generateName() => token('--generate-name');

  /// The Go template used to generate the release name, used with [generateName] (`--name-template`).
  HelmCmd nameTemplate(String value) => pair('--name-template', value);

  /// Suppresses printing the chart's notes after install (`--hide-notes`).
  HelmCmd hideNotes() => token('--hide-notes');

  /// Skips the check for Helm's ownership annotations on pre-existing resources (`--take-ownership`).
  HelmCmd takeOwnership() => token('--take-ownership');

  /// Applies updates on the server rather than the client (`--server-side`).
  HelmCmd serverSide() => token('--server-side');

  /// Under [serverSide], forces the change through a field-ownership conflict (`--force-conflicts`).
  HelmCmd forceConflicts() => token('--force-conflicts');

  /// Forces resource updates through delete-and-recreate rather than a patch (`--force-replace`).
  HelmCmd forceReplace() => token('--force-replace');

  /// Reuses a release name that is only soft-deleted in the release history (`--replace`).
  ///
  /// Unsafe in production: the reused name can collide with history another process still expects.
  HelmCmd replace() => token('--replace');

  /// Renders subchart notes alongside the parent chart's (`--render-subchart-notes`).
  HelmCmd renderSubchartNotes() => token('--render-subchart-notes');

  /// Enables DNS lookups while rendering templates (`--enable-dns`).
  HelmCmd enableDns() => token('--enable-dns');

  /// Downloads missing chart dependencies before installing (`--dependency-update`).
  HelmCmd dependencyUpdate() => token('--dependency-update');

  /// A custom description recorded against the release (`--description`).
  HelmCmd description(String value) => pair('--description', value);

  /// Runs an external post-renderer plugin over the rendered manifests (`--post-renderer`).
  HelmCmd postRenderer(String plugin) => pair('--post-renderer', plugin);

  /// An argument passed to [postRenderer] (`--post-renderer-args`). Repeatable.
  HelmCmd postRendererArgs(String value) => pair('--post-renderer-args', value);

  /// Rolls the release back automatically on failure, distinct from [atomicWait] (`--rollback-on-failure`).
  HelmCmd rollbackOnFailure() => token('--rollback-on-failure');

  /// Labels to attach to the release metadata, comma-separated (`-l`, `--labels`).
  HelmCmd labels(String value) => pair('--labels', value);

  /// Verifies the chart's provenance before using it, requiring a `.prov` file (`--verify`).
  HelmCmd verifyFlag() => token('--verify');

  /// The keyring to verify against, under [verifyFlag] (`--keyring`).
  HelmCmd keyring(String path) => pair('--keyring', path);

  /// Includes development versions when resolving the latest chart (`--devel`). Ignored once [chartVersion] is set.
  HelmCmd devel() => token('--devel');

  /// Pins the chart to this version or version range (`--version`).
  HelmCmd chartVersion(String constraint) => pair('--version', constraint);

  /// The repository URL to resolve the chart against, instead of a configured repo (`--repo`).
  HelmCmd repoUrl(String url) => pair('--repo', url);

  /// Fetches the chart over plain HTTP (`--plain-http`). Insecure.
  HelmCmd plainHttp() => token('--plain-http');

  /// Skips TLS certificate verification of the chart download (`--insecure-skip-tls-verify`).
  HelmCmd insecureSkipTlsVerify() => token('--insecure-skip-tls-verify');

  /// The CA bundle to verify an HTTPS chart repository against (`--ca-file`).
  HelmCmd caFile(String path) => pair('--ca-file', path);

  /// The client certificate for an HTTPS chart repository (`--cert-file`).
  HelmCmd certFile(String path) => pair('--cert-file', path);

  /// The client key for an HTTPS chart repository (`--key-file`).
  HelmCmd keyFile(String path) => pair('--key-file', path);

  /// The chart repository username (`--username`).
  HelmCmd username(String value) => pair('--username', value);

  /// The chart repository password (`--password`).
  ///
  /// Lands in argv, where `ps` can read it; [passwordStdin] avoids that for `repo add`.
  HelmCmd password(String value) => pair('--password', value);

  /// Reads the chart repository password from stdin instead of argv (`--password-stdin`).
  HelmCmd passwordStdin() => token('--password-stdin');

  /// Passes repository credentials to every domain a redirect leads to (`--pass-credentials`).
  HelmCmd passCredentials() => token('--pass-credentials');

  /// Replaces the repository if it is already configured, for `repo add` (`--force-update`).
  HelmCmd forceUpdate() => token('--force-update');

  /// The output format for a listing: `table`, `json` or `yaml` (`-o`, `--output`).
  ///
  /// Named around [CommandBuilder.output], the base class's own result-capturing execution method.
  HelmCmd outputFormat(String format) => pair('--output', format);

  /// Limits the maximum number of revisions kept per release (`--history-max`). `0` for no limit.
  HelmCmd historyMax(int count) => pair('--history-max', '$count');

  /// Shows the status of a specific past revision instead of the latest (`--revision`).
  HelmCmd revision(int number) => pair('--revision', '$number');

  /// Caps how many revisions [history] lists (`--max`).
  HelmCmd maxRevisions(int count) => pair('--max', '$count');

  /// Lists releases across every namespace (`-A`, `--all-namespaces`).
  HelmCmd allNamespaces() => token('--all-namespaces');

  /// Sorts the release list by date instead of alphabetically (`-d`, `--date`).
  HelmCmd sortByDate() => token('--date');

  /// A Perl-compatible regular expression filtering the release list (`--filter`).
  HelmCmd filter(String pattern) => pair('--filter', pattern);

  /// Only shows releases in the `deployed` state (`--deployed`).
  HelmCmd deployed() => token('--deployed');

  /// Only shows releases in the `failed` state (`--failed`).
  HelmCmd failed() => token('--failed');

  /// Allows uninstall to keep a release's history instead of erasing it (`--keep-history`).
  HelmCmd keepHistory() => token('--keep-history');

  /// Treats a missing release as a successful uninstall (`--ignore-not-found`).
  HelmCmd ignoreNotFoundFlag() => token('--ignore-not-found');

  /// The cascade strategy for uninstall's dependent resources (`--cascade`).
  HelmCmd cascade(String strategy) => pair('--cascade', strategy);

  /// Allows Helm to delete resources newly created by a failed rollback (`--cleanup-on-fail`).
  HelmCmd cleanupOnFail() => token('--cleanup-on-fail');

  /// Reuses the values from the previous release, merging any new [setValue]/[valuesFile] on top (`--reuse-values`).
  HelmCmd reuseValues() => token('--reuse-values');

  /// Only searches for repositories already added locally, for `search repo` (`-r`, `--regexp`).
  HelmCmd regexp() => token('--regexp');

  /// Lists every version of every matched chart, one per line (`-l`, `--versions`).
  HelmCmd versionsFlag() => token('--versions');

  /// Fails the command outright when a search finds nothing (`--fail-on-no-result`).
  HelmCmd failOnNoResult() => token('--fail-on-no-result');

  /// The directory to write a packaged or pulled chart into (`-d`, `--destination`).
  HelmCmd destination(String path) => pair('--destination', path);

  /// Signs a package with a PGP private key, for `helm package` (`--sign`).
  HelmCmd sign() => token('--sign');

  /// The signing key's name, under [sign] (`--key`).
  HelmCmd signingKey(String name) => pair('--key', name);

  /// A file holding the signing key's passphrase, `-` for stdin (`--passphrase-file`).
  HelmCmd passphraseFile(String path) => pair('--passphrase-file', path);

  /// Sets the `appVersion` on a packaged chart (`--app-version`).
  HelmCmd appVersion(String value) => pair('--app-version', value);

  /// Fetches the provenance file without verifying it, for `helm pull` (`--prov`).
  HelmCmd prov() => token('--prov');

  /// Untars the pulled chart after downloading it (`--untar`).
  HelmCmd untar() => token('--untar');

  /// The directory a [untar]red chart is expanded into (`--untardir`).
  HelmCmd untardir(String path) => pair('--untardir', path);

  /// Fails `lint` on warnings, not only on errors (`--strict`).
  HelmCmd strict() => token('--strict');

  /// Prints only warnings and errors from `lint` (`--quiet`).
  HelmCmd quiet() => token('--quiet');

  /// Also lints the chart's dependent subcharts (`--with-subcharts`).
  HelmCmd withSubcharts() => token('--with-subcharts');

  /// The Kubernetes version assumed for capability and deprecation checks (`--kube-version`).
  HelmCmd kubeVersion(String version) => pair('--kube-version', version);

  /// The API versions available to `Capabilities.APIVersions` while templating (`-a`, `--api-versions`). Repeatable.
  HelmCmd apiVersions(String value) => pair('--api-versions', value);

  /// The kubeconfig file to use (`--kubeconfig`).
  HelmCmd kubeconfig(String path) => pair('--kubeconfig', path);

  /// The kubeconfig context to use (`--kube-context`).
  HelmCmd kubeContext(String name) => pair('--kube-context', name);

  /// The Kubernetes API server address, bypassing kubeconfig (`--kube-apiserver`).
  HelmCmd kubeApiserver(String url) => pair('--kube-apiserver', url);

  /// The bearer token to authenticate to the API server with (`--kube-token`).
  ///
  /// Lands in argv, where `ps` can read it.
  HelmCmd kubeToken(String value) => pair('--kube-token', value);

  /// The user to impersonate for the Kubernetes request (`--kube-as-user`).
  HelmCmd kubeAsUser(String name) => pair('--kube-as-user', name);

  /// A group to impersonate for the Kubernetes request (`--kube-as-group`). Repeatable.
  HelmCmd kubeAsGroup(String name) => pair('--kube-as-group', name);

  /// The CA bundle to verify the Kubernetes API server against (`--kube-ca-file`).
  HelmCmd kubeCaFile(String path) => pair('--kube-ca-file', path);

  /// Skips TLS verification of the Kubernetes API server (`--kube-insecure-skip-tls-verify`).
  HelmCmd kubeInsecureSkipTlsVerify() => token('--kube-insecure-skip-tls-verify');

  /// Turns on verbose client output (`--debug`).
  HelmCmd debug() => token('--debug');

  /// Adds a bare positional argument: a release name, a chart reference, a path, whatever the subcommand ahead of it expects next.
  HelmCmd arg(String value) => token(value);
}

/// `helm`, ready to take its first subcommand.
// ignore: non_constant_identifier_names
HelmCmd get Helm => HelmCmd();
