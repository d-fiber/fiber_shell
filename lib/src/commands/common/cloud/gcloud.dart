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

/// The Google Cloud CLI: one `gcloud` binary fronting well over a hundred
/// command groups, next to [AwsCmd] and [AzCmd] in this catalogue's `cloud/`
/// family.
///
/// **This wrapper is a vocabulary, not a grammar.** Like [AwsCmd], `gcloud`'s
/// surface is too large to enumerate as methods and moves too fast to stay
/// current if it tried. This wrapper covers every global flag exhaustively —
/// they apply the same way under any command group — names the groups reached
/// for most often, and leaves [group]/[arg] as the general path for the rest.
///
/// ```dart
/// final ShellResult vms = await Gcloud.compute().arg('instances').arg('list').format('json').output();
///
/// await Gcloud.config().arg('set').arg('project').arg('my-project').quiet().execute();
/// ```
///
/// This wrapper only builds argv — it never touches `gcloud auth login`'s
/// stored credentials or application-default credentials itself. [project],
/// [account] and [configuration] are the flag forms of picking a target
/// without relying on whatever `gcloud config` last set as the active
/// default, which matters once a script runs somewhere those defaults were
/// never configured. [quiet] is what keeps a destructive command
/// (`instances delete`, `sql instances delete`) from blocking on a
/// confirmation prompt that has nothing to read from in CI.
class GcloudCmd extends CommandBuilder<GcloudCmd> {
  @override
  final String executable = 'gcloud';

  // Frequently used command groups, as convenience methods.

  /// Works with Compute Engine: instances, disks, networks, images (`compute`).
  GcloudCmd compute() => token('compute');

  /// Works with Cloud Storage buckets and objects (`storage`).
  GcloudCmd storage() => token('storage');

  /// Works with GKE Kubernetes clusters (`container`).
  GcloudCmd container() => token('container');

  /// Works with IAM: service accounts, roles, policy bindings (`iam`).
  GcloudCmd iam() => token('iam');

  /// Manages projects: create, list, set IAM policy (`projects`).
  GcloudCmd projects() => token('projects');

  /// Manages `gcloud`'s own authentication state (`auth`).
  GcloudCmd auth() => token('auth');

  /// Manages `gcloud`'s local configuration: active project, account, properties (`config`).
  GcloudCmd config() => token('config');

  /// Works with Cloud Functions (`functions`).
  GcloudCmd functions() => token('functions');

  /// Works with Cloud Run services and jobs (`run`).
  GcloudCmd run() => token('run');

  /// Works with Cloud SQL instances (`sql`).
  GcloudCmd sql() => token('sql');

  /// Works with App Engine applications and versions (`app`).
  GcloudCmd app() => token('app');

  /// Works with Cloud Build triggers and builds (`builds`).
  GcloudCmd builds() => token('builds');

  /// Works with Secret Manager secrets (`secrets`).
  GcloudCmd secrets() => token('secrets');

  /// Works with Pub/Sub topics and subscriptions (`pubsub`).
  GcloudCmd pubsub() => token('pubsub');

  /// Works with Cloud Logging (`logging`).
  GcloudCmd logging() => token('logging');

  /// Works with Cloud DNS managed zones and records (`dns`).
  GcloudCmd dns() => token('dns');

  /// Works with Cloud KMS keyrings and keys (`kms`).
  GcloudCmd kms() => token('kms');

  /// Enables, disables and lists API services for a project (`services`).
  GcloudCmd services() => token('services');

  /// Works with Cloud Deploy delivery pipelines (`deploy`).
  GcloudCmd deploy() => token('deploy');

  /// Manages billing accounts and their project links (`billing`).
  GcloudCmd billing() => token('billing');

  /// Any other command group, by its CLI name — the general path this wrapper does not name a method for.
  GcloudCmd group(String name) => token(name);

  // Global flags, apply under any command group.

  /// The Google Cloud project to target, overriding the active `config` project (`--project`).
  GcloudCmd project(String id) => joined('--project', id);

  /// The account to invoke the command as, overriding the active `config` account (`--account`).
  GcloudCmd account(String value) => joined('--account', value);

  /// The named configuration to use for this invocation, without switching the active one (`--configuration`).
  GcloudCmd configuration(String name) => joined('--configuration', name);

  /// Reads flags from a YAML/JSON file instead of, or alongside, the command line (`--flags-file`).
  GcloudCmd flagsFile(String path) => joined('--flags-file', path);

  /// Flattens a named list field so each element prints as its own record (`--flatten`).
  GcloudCmd flatten(String fieldPath) => joined('--flatten', fieldPath);

  /// The output format: `json`, `yaml`, `csv`, `table`, `value`, `config`, `text`, `none`, and more (`--format`).
  GcloudCmd format(String value) => joined('--format', value);

  /// Prints the detailed help for the command it follows (`--help`).
  GcloudCmd helpFlag() => token('--help');

  /// The billing project charged for quota on this call, when it differs from [project] (`--billing-project`).
  GcloudCmd billingProject(String id) => joined('--billing-project', id);

  /// Disables interactive confirmation prompts, answering their default — required for unattended scripts (`--quiet`, `-q`).
  GcloudCmd quiet() => token('--quiet');

  /// Sets the log/output verbosity: `debug`, `info`, `warning`, `error`, `critical` or `none` (`--verbosity`).
  GcloudCmd verbosity(String level) => joined('--verbosity', level);

  /// Prints the `gcloud` CLI version and exits (`--version`).
  GcloudCmd version() => token('--version');

  /// Reads the OAuth2 access token from a file instead of the stored credentials (`--access-token-file`).
  GcloudCmd accessTokenFile(String path) => joined('--access-token-file', path);

  /// Impersonates a service account for this call, without switching the active account (`--impersonate-service-account`).
  GcloudCmd impersonateServiceAccount(String email) => joined('--impersonate-service-account', email);

  /// Logs the raw HTTP requests and responses `gcloud` makes — verbose, useful for debugging auth/API issues (`--log-http`).
  GcloudCmd logHttp() => token('--log-http');

  /// A token attached to the request for Google-side trace lookup during a support case (`--trace-token`).
  GcloudCmd traceToken(String value) => joined('--trace-token', value);

  /// Turns non-essential console output (progress bars, status lines) on or off (`--user-output-enabled`).
  GcloudCmd userOutputEnabled(bool value) => joined('--user-output-enabled', '$value');

  // Positional / escape hatch.

  /// A bare positional argument or subcommand-specific flag this wrapper has no named method for,
  /// e.g. `Gcloud.compute().arg('instances').arg('describe').arg('my-vm').arg('--zone=us-central1-a')`.
  GcloudCmd arg(String value) => token(value);
}

/// `gcloud`, ready to take its first command group.
// ignore: non_constant_identifier_names
GcloudCmd get Gcloud => GcloudCmd();
