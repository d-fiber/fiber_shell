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

/// `yq` (the Go rewrite by Mike Farah, not the older Python wrapper around
/// `jq`), a portable processor for YAML, JSON, XML, CSV, TSV, properties, INI,
/// TOML and Lua. Not preinstalled anywhere; a single static binary once it is.
/// Where [Jq] is this repository's JSON specialist, `yq` is the one wrapper
/// that reads and writes the same document in any of those formats, YAML being
/// what it assumes when nothing else says otherwise.
///
/// ```dart
/// final ShellResult version = await Yq.nullInput().evalExpression('.version').file('sample.json').output();
/// await Yq.inplace().evalExpression('.stuff = "foo"').file('myfile.yml').execute();
/// final ShellResult asYaml = await Yq.prettyPrint().outputFormat('yaml').file('sample.json').output();
/// ```
///
/// The expression is jq-flavoured but its own dialect, not jq's: it understands
/// YAML-specific ideas jq has no notion of, comments and anchors among them.
/// [inplace] rewrites the first file given rather than printing to stdout, so it
/// has no effect reading from a pipe. [nullInput] is what a document built from
/// scratch needs: with no file to read, `yq` otherwise waits on stdin.
class YqCmd extends CommandBuilder<YqCmd> {
  @override
  final String executable = 'yq';

  /// Applies the expression to each document in each file in sequence, the default (`eval`).
  YqCmd eval() => token('eval');

  /// Loads every document of every file first, then runs the expression once (`eval-all`).
  ///
  /// What a cross-document operation like a merge needs; [eval] never sees more than one document at a time.
  YqCmd evalAll() => token('eval-all');

  /// Generates the autocompletion script for a shell (`completion`).
  YqCmd completion(String shell) => pair('completion', shell);

  /// Prints the help for `yq`, or for the subcommand already chained (`help`).
  YqCmd helpCommand() => token('help');

  /// Forces colored output even when stdout is not a terminal (`-C`).
  YqCmd colors() => token('-C');

  /// Forces plain output with no color (`-M`).
  YqCmd noColors() => token('-M');

  /// Parses CSV/TSV scalar values as YAML/JSON types instead of leaving them as strings (`--csv-auto-parse`).
  YqCmd csvAutoParse(bool value) => joined('--csv-auto-parse', '$value');

  /// The field separator for CSV input and output (`--csv-separator`).
  YqCmd csvSeparator(String char) => pair('--csv-separator', char);

  /// Prints internal node debug information (`--debug-node-info`).
  YqCmd debugNodeInfo() => token('--debug-node-info');

  /// Sets a non-zero exit status when the expression matches nothing, or returns `null` or `false` (`-e`).
  ///
  /// What turns `yq` into a query you can branch a script on, the way [GrepCmd.quiet] does for `grep`.
  YqCmd exitStatus() => token('-e');

  /// Forces this string to be treated as the expression, when `yq` would otherwise mistake it for a filename (`--expression`).
  YqCmd expression(String value) => pair('--expression', value);

  /// Reads the expression from this file instead of the command line (`--from-file`).
  YqCmd fromFile(String path) => pair('--from-file', path);

  /// Handles YAML front matter: `extract` pulls it out, `process` runs the expression against it (`-f`).
  YqCmd frontMatter(String mode) => pair('-f', mode);

  /// Slurps leading header comments and document separators before evaluating (`--header-preprocess`).
  YqCmd headerPreprocess(bool value) => joined('--header-preprocess', '$value');

  /// Prints the usage summary (`-h`).
  YqCmd help() => token('-h');

  /// The indentation width of the output, in spaces (`-I`).
  YqCmd indent(int level) => pair('-I', '$level');

  /// Rewrites the first file given in place instead of printing to stdout (`-i`).
  ///
  /// Has no effect on stdin: there is no file to write back to.
  YqCmd inplace() => token('-i');

  /// The input format to parse, `auto` unless told otherwise (`-p`).
  YqCmd inputFormat(String format) => pair('-p', format);

  /// Emits Lua tables as top-level global variables instead of a single returned value (`--lua-globals`).
  YqCmd luaGlobals() => token('--lua-globals');

  /// The prefix written before Lua output, `return ` by default (`--lua-prefix`).
  YqCmd luaPrefix(String value) => pair('--lua-prefix', value);

  /// The suffix written after Lua output (`--lua-suffix`).
  YqCmd luaSuffix(String value) => pair('--lua-suffix', value);

  /// Writes Lua string keys unquoted, `{foo="bar"}` rather than `{["foo"]="bar"}` (`--lua-unquoted`).
  YqCmd luaUnquoted() => token('--lua-unquoted');

  /// Drops the `---` document separators from YAML output (`-N`).
  YqCmd noDoc() => token('-N');

  /// Separates results with a NUL byte instead of a newline (`-0`).
  YqCmd nulOutput() => token('-0');

  /// Evaluates the expression without reading any input (`-n`).
  ///
  /// What a document built from scratch needs; without it `yq` waits on stdin.
  YqCmd nullInput() => token('-n');

  /// The output format to write, `auto` unless told otherwise (`-o`).
  YqCmd outputFormat(String format) => pair('-o', format);

  /// Pretty-prints the output, shorthand for setting an empty YAML style (`-P`).
  YqCmd prettyPrint() => token('-P');

  /// Writes properties-format array indices as `[x]`, the form Spring Boot expects (`--properties-array-brackets`).
  YqCmd propertiesArrayBrackets() => token('--properties-array-brackets');

  /// The separator between key and value in properties output, `" = "` by default (`--properties-separator`).
  YqCmd propertiesSeparator(String value) => pair('--properties-separator', value);

  /// Disables `env` and `envsubst` operators in the expression (`--security-disable-env-ops`).
  YqCmd securityDisableEnvOps() => token('--security-disable-env-ops');

  /// Disables the `load`, `load_str` and similar file operators (`--security-disable-file-ops`).
  ///
  /// Worth setting whenever the expression itself is not fully trusted.
  YqCmd securityDisableFileOps() => token('--security-disable-file-ops');

  /// The separator used when flattening keys for `shell` output (`--shell-key-separator`).
  YqCmd shellKeySeparator(String value) => pair('--shell-key-separator', value);

  /// Splits the output across files named by this expression, `$index` available as the counter (`-s`).
  YqCmd splitExp(String expression) => pair('-s', expression);

  /// Reads the [splitExp] expression from a file instead of the command line (`--split-exp-file`).
  YqCmd splitExpFile(String path) => pair('--split-exp-file', path);

  /// Turns off `\(expression)` string interpolation (`--string-interpolation`).
  YqCmd stringInterpolation(bool value) => joined('--string-interpolation', '$value');

  /// Parses TSV scalar values as YAML/JSON types (`--tsv-auto-parse`).
  YqCmd tsvAutoParse(bool value) => joined('--tsv-auto-parse', '$value');

  /// Unwraps a single scalar result: no quotes, no colour, no comments (`-r`).
  ///
  /// On by default for YAML output; the flag to reach for when scripting a single value out.
  YqCmd unwrapScalar() => token('-r');

  /// Talks more about what it is doing (`-v`).
  YqCmd verbose() => token('-v');

  /// Prints the version and exits (`-V`).
  YqCmd versionFlag() => token('-V');

  /// The prefix for XML attribute keys in the YAML representation, `+@` by default (`--xml-attribute-prefix`).
  YqCmd xmlAttributePrefix(String value) => pair('--xml-attribute-prefix', value);

  /// The key name used for an element's text content (`--xml-content-name`).
  YqCmd xmlContentName(String value) => pair('--xml-content-name', value);

  /// The key name used for an XML directive like `<!DOCTYPE ...>` (`--xml-directive-name`).
  YqCmd xmlDirectiveName(String value) => pair('--xml-directive-name', value);

  /// Keeps XML namespaces attached after parsing attributes (`--xml-keep-namespace`).
  YqCmd xmlKeepNamespace(bool value) => joined('--xml-keep-namespace', '$value');

  /// The prefix for XML processing instructions like `<?xml version="1"?>` (`--xml-proc-inst-prefix`).
  YqCmd xmlProcInstPrefix(String value) => pair('--xml-proc-inst-prefix', value);

  /// Uses the raw XML tokenizer, which commonly disables namespace translation (`--xml-raw-token`).
  YqCmd xmlRawToken(bool value) => joined('--xml-raw-token', '$value');

  /// Skips over XML directives like `<!DOCTYPE ...>` while parsing (`--xml-skip-directives`).
  YqCmd xmlSkipDirectives() => token('--xml-skip-directives');

  /// Skips over XML processing instructions while parsing (`--xml-skip-proc-inst`).
  YqCmd xmlSkipProcInst() => token('--xml-skip-proc-inst');

  /// Parses XML strictly rather than leniently (`--xml-strict-mode`).
  YqCmd xmlStrictMode() => token('--xml-strict-mode');

  /// Treats the leading `- ` of a YAML sequence item as part of the indentation (`-c`).
  YqCmd yamlCompactSeqIndent() => token('-c');

  /// Rewrites merge anchors (`<<`) to match the current YAML spec (`--yaml-fix-merge-anchor-to-spec`).
  YqCmd yamlFixMergeAnchorToSpec() => token('--yaml-fix-merge-anchor-to-spec');

  /// The jq-flavoured expression to evaluate. Positional; `yq` tries to tell it apart from a filename on its own, [expression] forces the point.
  YqCmd evalExpression(String value) => token(value);

  /// A file to read, or to rewrite under [inplace]. Repeatable, and `-` reads stdin.
  YqCmd file(String path) => token(path);
}

/// `yq`, ready to take its first option.
// ignore: non_constant_identifier_names
YqCmd get Yq => YqCmd();
