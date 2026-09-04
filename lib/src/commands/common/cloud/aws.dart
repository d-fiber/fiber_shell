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

/// The AWS CLI: one `aws` binary fronting every AWS service, opening the new
/// `cloud/` family alongside [GcloudCmd] and [AzCmd].
///
/// **This wrapper is a vocabulary, not a grammar.** AWS ships well over three
/// hundred services and thousands of operations — enumerating all of them as
/// methods is not practical, and would not stay current with AWS's own release
/// pace. Instead this wrapper covers every global option exhaustively (they
/// apply the same way regardless of service), names the services reached for
/// most often as convenience methods, and leaves [service]/[operation]/[arg]
/// as the general path for everything else, the same escape hatch [GhCmd]'s
/// `api()` and [CertutilCmd]'s deep CA-admin verbs use for their own long
/// tails.
///
/// ```dart
/// final ShellResult buckets = await Aws.s3().arg('ls').outputFormat('json').output();
///
/// await Aws.service('ec2').operation('describe-instances').region('us-east-1').queryFilter(
///   'Reservations[].Instances[].InstanceId',
/// ).execute();
/// ```
///
/// This wrapper only builds argv — it never reads, sets or stores credentials.
/// Auth comes from whatever the AWS CLI itself resolves: `~/.aws/credentials`,
/// `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`, an SSO session, or an
/// instance/task role: pass overrides through [CommandBuilder.execute]'s `env`
/// rather than a flag repeated on every call. [outputFormat] is named to avoid
/// colliding with [CommandBuilder.output], the runner that captures a result;
/// the real flag is bare `--output`.
class AwsCmd extends CommandBuilder<AwsCmd> {
  @override
  final String executable = 'aws';

  // Frequently used services, as convenience methods.

  /// Works with S3 (`s3`, the high-level, object-store-aware subcommands).
  AwsCmd s3() => token('s3');

  /// Works with S3 through its low-level API, one call per S3 operation (`s3api`).
  AwsCmd s3api() => token('s3api');

  /// Works with EC2: instances, AMIs, security groups, VPCs (`ec2`).
  AwsCmd ec2() => token('ec2');

  /// Works with IAM: users, roles, policies (`iam`).
  AwsCmd iam() => token('iam');

  /// Works with AWS STS: temporary credentials, identity (`sts`).
  AwsCmd sts() => token('sts');

  /// Works with Lambda functions (`lambda`).
  AwsCmd lambda() => token('lambda');

  /// Works with DynamoDB tables and items (`dynamodb`).
  AwsCmd dynamodb() => token('dynamodb');

  /// Works with CloudFormation stacks (`cloudformation`).
  AwsCmd cloudformation() => token('cloudformation');

  /// Works with ECS clusters, services and tasks (`ecs`).
  AwsCmd ecs() => token('ecs');

  /// Works with ECR container image repositories (`ecr`).
  AwsCmd ecr() => token('ecr');

  /// Works with RDS database instances (`rds`).
  AwsCmd rds() => token('rds');

  /// Works with SQS queues (`sqs`).
  AwsCmd sqs() => token('sqs');

  /// Works with SNS topics (`sns`).
  AwsCmd sns() => token('sns');

  /// Works with CloudWatch Logs (`logs`).
  AwsCmd logs() => token('logs');

  /// Works with Systems Manager: parameters, sessions, patching (`ssm`).
  AwsCmd ssm() => token('ssm');

  /// Works with CloudFront distributions (`cloudfront`).
  AwsCmd cloudfront() => token('cloudfront');

  /// Works with Route 53 hosted zones and records (`route53`).
  AwsCmd route53() => token('route53');

  /// Works with Secrets Manager secrets (`secretsmanager`).
  AwsCmd secretsmanager() => token('secretsmanager');

  /// Works with EKS Kubernetes clusters (`eks`).
  AwsCmd eks() => token('eks');

  /// Manages `aws` CLI configuration interactively: region, output format, credentials (`configure`).
  AwsCmd configure() => token('configure');

  /// Any other service, by its CLI name — the general path this wrapper does not name a method for.
  AwsCmd service(String name) => token(name);

  /// The operation to call on the preceding [service]/convenience method, in its CLI form (e.g. `describe-instances`).
  AwsCmd operation(String name) => token(name);

  // Global options, apply to every command.

  /// Turns on debug logging (`--debug`).
  AwsCmd debug() => token('--debug');

  /// Overrides the service's default URL with this one (`--endpoint-url`).
  AwsCmd endpointUrl(String url) => pair('--endpoint-url', url);

  /// Skips SSL certificate verification (`--no-verify-ssl`).
  AwsCmd noVerifySsl() => token('--no-verify-ssl');

  /// Disables automatic result pagination; only the first page is fetched (`--no-paginate`).
  AwsCmd noPaginate() => token('--no-paginate');

  /// The output format: `json`, `text`, `table`, `yaml` or `yaml-stream` (`--output`).
  ///
  /// Named to avoid colliding with [CommandBuilder.output].
  AwsCmd outputFormat(String value) => pair('--output', value);

  /// A JMESPath query to filter the response before printing it (`--query`).
  AwsCmd queryFilter(String expression) => pair('--query', expression);

  /// The named profile from the credentials file to use (`--profile`).
  AwsCmd profile(String name) => pair('--profile', name);

  /// The AWS region to target, overriding config/env settings (`--region`).
  AwsCmd region(String value) => pair('--region', value);

  /// Prints the AWS CLI version and exits (`--version`).
  AwsCmd version() => token('--version');

  /// Turns colour output on, off, or leaves it automatic: `on`, `off` or `auto` (`--color`).
  AwsCmd color(String value) => pair('--color', value);

  /// Sends the request unsigned; no credentials are loaded (`--no-sign-request`).
  AwsCmd noSignRequest() => token('--no-sign-request');

  /// A CA certificate bundle to verify SSL certificates against, overriding config/env settings (`--ca-bundle`).
  AwsCmd caBundle(String path) => pair('--ca-bundle', path);

  /// The maximum socket read time in seconds; `0` blocks with no timeout. Default 60 (`--cli-read-timeout`).
  AwsCmd cliReadTimeout(int seconds) => pair('--cli-read-timeout', '$seconds');

  /// The maximum socket connect time in seconds; `0` blocks with no timeout. Default 60 (`--cli-connect-timeout`).
  AwsCmd cliConnectTimeout(int seconds) => pair('--cli-connect-timeout', '$seconds');

  /// The formatting style for binary blobs: `base64` or `raw-in-base64-out` (`--cli-binary-format`).
  AwsCmd cliBinaryFormat(String value) => pair('--cli-binary-format', value);

  /// Disables the CLI pager, so output is not piped through `less` (`--no-cli-pager`).
  AwsCmd noCliPager() => token('--no-cli-pager');

  /// Prompts interactively for missing CLI parameters — not for automation (`--cli-auto-prompt`).
  AwsCmd cliAutoPrompt() => token('--cli-auto-prompt');

  /// Disables the interactive parameter prompt, the automation-safe default (`--no-cli-auto-prompt`).
  AwsCmd noCliAutoPrompt() => token('--no-cli-auto-prompt');

  // Positional / escape hatch.

  /// A bare positional argument or operation-specific flag this wrapper has no named method for,
  /// e.g. `Aws.ec2().operation('describe-instances').arg('--instance-ids').arg('i-0123456789abcdef0')`.
  AwsCmd arg(String value) => token(value);
}

/// `aws`, ready to take its first service.
// ignore: non_constant_identifier_names
AwsCmd get Aws => AwsCmd();
