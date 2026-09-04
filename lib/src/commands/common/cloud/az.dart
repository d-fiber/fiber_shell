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

/// The Azure CLI: one `az` binary fronting several hundred command groups,
/// completing the `cloud/` family alongside [AwsCmd] and [GcloudCmd].
///
/// **This wrapper is a vocabulary, not a grammar**, for the same reason as its
/// two siblings: Azure's own reference lists several hundred command groups,
/// many of them extensions installed on demand, so this wrapper covers every
/// global parameter exhaustively and leaves [group]/[arg] as the general path
/// for whichever group and subcommand a given script needs.
///
/// ```dart
/// final ShellResult vms = await Az.vm().arg('list').outputFormat('json').output();
///
/// await Az.group().arg('create').arg('--name').arg('rg1').arg('--location').arg('eastus').execute();
/// ```
///
/// This wrapper only builds argv — it never touches what `az login` stores.
/// [subscription] is the flag form of picking a target without relying on
/// whichever subscription `az account set` last made active, which matters
/// once a script runs somewhere that default was never configured. Azure CLI
/// commands print human-readable tables by default; [outputFormat]`('json')`
/// is what makes the result worth parsing, and [onlyShowErrors] keeps warnings
/// (a deprecated parameter, a slow extension load) out of a script's stderr
/// checks.
class AzCmd extends CommandBuilder<AzCmd> {
  @override
  final String executable = 'az';

  // Frequently used command groups, as convenience methods.

  /// Manages Linux or Windows virtual machines (`vm`).
  AzCmd vm() => token('vm');

  /// Manages Virtual Machine Scale Sets (`vmss`).
  AzCmd vmss() => token('vmss');

  /// Manages resource groups and template deployments (`group`).
  AzCmd group() => token('group');

  /// Manages subscription information and the active account (`account`).
  AzCmd account() => token('account');

  /// Manages Azure Cloud Storage resources (`storage`).
  AzCmd storage() => token('storage');

  /// Manages Azure Kubernetes Service clusters (`aks`).
  AzCmd aks() => token('aks');

  /// Manages web apps (`webapp`).
  AzCmd webapp() => token('webapp');

  /// Manages function apps (`functionapp`).
  AzCmd functionapp() => token('functionapp');

  /// Manages Azure SQL databases and data warehouses (`sql`).
  AzCmd sql() => token('sql');

  /// Manages Azure Network resources: VNets, NSGs, load balancers (`network`).
  AzCmd network() => token('network');

  /// Manages Microsoft Entra ID (Azure AD) entities through the Microsoft Graph API (`ad`).
  AzCmd ad() => token('ad');

  /// Manages KeyVault keys, secrets and certificates (`keyvault`).
  AzCmd keyvault() => token('keyvault');

  /// Manages the Azure Monitor service: metrics, alerts, log queries (`monitor`).
  AzCmd monitor() => token('monitor');

  /// Manages Azure resources generically, across resource types (`resource`).
  AzCmd resource() => token('resource');

  /// Manages Azure role-based access control: role assignments and definitions (`role`).
  AzCmd role() => token('role');

  /// Manages Azure Resource Manager template deployments at subscription scope (`deployment`).
  AzCmd deployment() => token('deployment');

  /// Manages resources defined by the Azure Policy service (`policy`).
  AzCmd policy() => token('policy');

  /// Manages resource providers and their registration state (`provider`).
  AzCmd provider() => token('provider');

  /// Manages Azure Managed Disks (`disk`).
  AzCmd disk() => token('disk');

  /// Manages Managed Identity resources (`identity`).
  AzCmd identity() => token('identity');

  /// Manages Azure Cosmos DB database accounts (`cosmosdb`).
  AzCmd cosmosdb() => token('cosmosdb');

  /// Manages Azure Database for PostgreSQL (`postgres`).
  AzCmd postgres() => token('postgres');

  /// Manages Azure Container Registries (`acr`).
  AzCmd acr() => token('acr');

  /// Manages Azure Container Apps (`containerapp`).
  AzCmd containerapp() => token('containerapp');

  /// Manages Azure Backups (`backup`).
  AzCmd backup() => token('backup');

  /// Authenticates the CLI against Azure (`login`).
  AzCmd login() => token('login');

  /// Logs the CLI out, clearing cached credentials (`logout`).
  AzCmd logout() => token('logout');

  /// Reads or sets `az` CLI configuration defaults (`config`).
  AzCmd config() => token('config');

  /// Any other command group, by its CLI name — the general path this wrapper does not name a method for.
  ///
  /// Named to avoid colliding with [group], the `az group` (resource groups) convenience method.
  AzCmd commandGroup(String name) => token(name);

  // Global parameters, apply under any command group.

  /// Sets the output format: `json`, `jsonc`, `yaml`, `yamlc`, `table`, `tsv` or `none` (`--output`, `-o`).
  ///
  /// Named to avoid colliding with [CommandBuilder.output].
  AzCmd outputFormat(String value) => pair('--output', value);

  /// A JMESPath query to filter the response before printing it (`--query`).
  AzCmd queryFilter(String expression) => pair('--query', expression);

  /// Increases logging verbosity to show all debug logs (`--debug`).
  AzCmd debug() => token('--debug');

  /// Increases logging verbosity to show all information logs (`--verbose`).
  AzCmd verboseFlag() => token('--verbose');

  /// Shows only errors, suppressing warnings — keeps a script's stderr checks clean (`--only-show-errors`).
  AzCmd onlyShowErrors() => token('--only-show-errors');

  /// Prints the help for the command it follows (`--help`, `-h`).
  AzCmd help() => token('--help');

  /// The subscription (name or ID) to target, overriding the active `account` (`--subscription`).
  AzCmd subscription(String value) => pair('--subscription', value);

  // Positional / escape hatch.

  /// A bare positional argument or subcommand-specific parameter this wrapper has no named method for,
  /// e.g. `Az.vm().arg('create').arg('--name').arg('vm1').arg('--image').arg('Ubuntu2404')`.
  AzCmd arg(String value) => token(value);
}

/// `az`, ready to take its first command group.
// ignore: non_constant_identifier_names
AzCmd get Az => AzCmd();
