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

/// `packer`, HashiCorp's machine-image builder, alongside [TerraformCmd],
/// [TofuCmd] and [AnsiblePlaybookCmd] in this catalogue's `infrastructure/`
/// family. Packer builds the image; the others provision what runs on it.
///
/// ```dart
/// await Packer.init().arg('.').execute();
///
/// final ShellResult built = await Packer
///     .build()
///     .varFile('prod.pkrvars.hcl')
///     .colorOff()
///     .machineReadable()
///     .arg('.')
///     .output();
/// ```
///
/// [init] downloads the plugins an HCL2 template's `required_plugins` block
/// names, and needs to run once before [build] or [validate] will work on a
/// fresh checkout — a step easy to forget outside an interactive terminal.
/// [machineReadable] turns on the line-oriented, comma-delimited format meant
/// for scripts; without it, `packer`'s human-facing output is not something to
/// parse reliably. Packer 1's legacy JSON templates and its HCL2 templates take
/// mostly the same subcommands, but only HCL2 has [init] and `required_plugins`.
class PackerCmd extends CommandBuilder<PackerCmd> {
  @override
  final String executable = 'packer';

  // Subcommands.

  /// Downloads the plugins a template's `required_plugins` block asks for (`init`). HCL2 templates only.
  PackerCmd init() => token('init');

  /// Builds an image from a template (`build`).
  PackerCmd build() => token('build');

  /// Checks a template's syntax and configuration without building anything (`validate`).
  PackerCmd validate() => token('validate');

  /// Formats a template's HCL2 source (`fmt`).
  PackerCmd fmt() => token('fmt');

  /// Opens an interactive console for evaluating template expressions (`console`).
  PackerCmd console() => token('console');

  /// Prints a template's variables, builds and provisioners without building anything (`inspect`).
  PackerCmd inspect() => token('inspect');

  /// Rewrites a template to work around backward-incompatible changes to a builder/provisioner (`fix`).
  PackerCmd fix() => token('fix');

  /// Manages plugin installation (`plugins`).
  PackerCmd plugins() => token('plugins');

  /// Converts a legacy JSON template to HCL2 (`hcl2_upgrade`).
  PackerCmd hcl2Upgrade() => token('hcl2_upgrade');

  /// Verifies a build's SLSA attestation (`verify-attestation`).
  PackerCmd verifyAttestation() => token('verify-attestation');

  /// Prints the Packer version (`version`).
  PackerCmd version() => token('version');

  // `plugins` subcommands.

  /// Installs a plugin, optionally at a specific version (`plugins install`).
  PackerCmd install(String sourceAddress, [String? version]) {
    token('install');
    token(sourceAddress);
    if (version != null) token(version);
    return self;
  }

  /// Removes an installed plugin (`plugins remove`).
  PackerCmd remove(String sourceAddress) {
    token('remove');
    return token(sourceAddress);
  }

  /// Lists installed plugins (`plugins installed`).
  PackerCmd installed() => token('installed');

  /// Requires a plugin to be able to build a `.hcl` release SDK plugin (`plugins required`).
  PackerCmd required() => token('required');

  // Shared/build flags.

  /// Sets a template variable (`-var`). Repeatable.
  PackerCmd varFlag(String key, String value) => pair('-var', '$key=$value');

  /// Sets template variables from an HCL2/JSON `.pkrvars` file (`-var-file`). Repeatable.
  PackerCmd varFile(String path) => pair('-var-file', path);

  /// Turns colored output on or off; also `PACKER_NO_COLOR` (`-color`).
  PackerCmd color(bool value) => joined('-color', '$value');

  /// Disables colored output — shorthand equivalent of `-color=false` (`-color=false`).
  PackerCmd colorOff() => joined('-color', 'false');

  /// Pauses after each provisioner runs, dropping into an interactive debugger (`-debug`).
  PackerCmd debug() => token('-debug');

  /// Builds only the named build blocks/sources; the inverse of [except] (`-only`).
  PackerCmd only(String commaSeparatedNames) => joined('-only', commaSeparatedNames);

  /// Skips the named build blocks/sources; the inverse of [only] (`-except`).
  PackerCmd except(String commaSeparatedNames) => joined('-except', commaSeparatedNames);

  /// Forces a build to continue even if artifacts from a previous run already exist (`-force`).
  PackerCmd force() => token('-force');

  /// Emits fully machine-readable, line-oriented, comma-delimited output (`-machine-readable`).
  PackerCmd machineReadable() => token('-machine-readable');

  /// Sets what happens after a provisioner errors: `cleanup`, `abort` or `ask` (`-on-error`).
  PackerCmd onError(String action) => joined('-on-error', action);

  /// The number of builds to run in parallel; `0` means unlimited (`-parallel-builds`).
  PackerCmd parallelBuilds(int n) => joined('-parallel-builds', '$n');

  /// Adds a timestamp prefix to build output (`-timestamp-ui`).
  PackerCmd timestampUi() => token('-timestamp-ui');

  /// Checks configuration syntax only, without validating value types — used with [validate] (`-syntax-only`).
  PackerCmd syntaxOnly() => token('-syntax-only');

  /// Skips warnings about undeclared variables during [validate] (`-no-warn-undeclared-var`).
  PackerCmd noWarnUndeclaredVar() => token('-no-warn-undeclared-var');

  /// Enables strict evaluation mode for [fmt]/[validate]; fails on things Packer would otherwise tolerate (`-strict`).
  PackerCmd strict() => token('-strict');

  /// Applies formatting recursively to subdirectories, used with [fmt] (`-recursive`).
  PackerCmd recursive() => token('-recursive');

  /// Checks whether files are formatted, without writing changes; exits non-zero if not, used with [fmt] (`-check`).
  PackerCmd check() => token('-check');

  /// Prints the diff between the current and formatted content, used with [fmt] (`-diff`).
  PackerCmd diff() => token('-diff');

  /// Enables verbose logging to stderr; also `PACKER_LOG=1` (`-log`).
  PackerCmd log() => token('-log');

  // Positional / escape hatch.

  /// A bare positional argument: a template path/directory, a plugin source address, or a flag this wrapper
  /// has no named method for.
  PackerCmd arg(String value) => token(value);
}

/// `packer`, ready to take its first subcommand.
// ignore: non_constant_identifier_names
PackerCmd get Packer => PackerCmd();
