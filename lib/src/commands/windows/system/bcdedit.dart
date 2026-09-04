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

/// `bcdedit`, the command-line editor for the Boot Configuration Data (BCD)
/// store — Windows Vista and later's replacement for `boot.ini`. Windows
/// only, and modifying the store needs an elevated prompt.
///
/// ```dart
/// final ShellResult entries = await Bcdedit.enumerate().verbose().asRoot().output();
///
/// await Bcdedit.timeout('5').asRoot().execute();
/// ```
///
/// **This edits how the machine boots.** A wrong `{identifier}` on [set],
/// [delete] or [defaultEntry] can leave a system unable to start; there is no
/// dry run, and the BCD store has no built-in undo beyond whatever you
/// captured yourself with [export] first. Back the store up with [export]
/// before scripting changes against it, and restore with [import] if
/// something goes wrong.
///
/// `bcdedit` is deliberately limited to the standard, well-known data types.
/// Nonstandard element values, and anything more elaborate than "change one
/// setting", go through the BCD WMI API instead — outside what a CLI wrapper
/// can help with. [set] and [deleteValue] here cover the common
/// `bcdedit /set {id} <element> <value>` shape; pass `<element>` and
/// `<value>` as they'd appear on the real command line, in the order
/// `bcdedit /? types` and `bcdedit /? set` document.
///
/// Every command operates on the system store unless [store] names another
/// one. [enumerate] with no arguments — or no command at all — is shorthand
/// for `/enum active`.
class BcdeditCmd extends CommandBuilder<BcdeditCmd> {
  @override
  final String executable = 'bcdedit';

  // --- Store-level operations -------------------------------------------

  /// Creates a new, empty (non-system) BCD store (`/createstore`).
  BcdeditCmd createStore() => token('/createstore');

  /// Exports the system store to a backup file (`/export`).
  BcdeditCmd export() => token('/export');

  /// Restores the system store from a file made by [export], replacing its
  /// current contents (`/import`).
  BcdeditCmd import() => token('/import');

  /// Names the store most commands below operate on, instead of the system
  /// store (`/store`).
  BcdeditCmd store(String path) => pair('/store', path);

  // --- Entry operations ---------------------------------------------------

  /// Copies a boot entry within the same store (`/copy`).
  BcdeditCmd copy() => token('/copy');

  /// Creates a new entry in the store (`/create`). A well-known identifier
  /// cannot be combined with [application], [inherit] or [device]; anything
  /// else needs one of those three.
  BcdeditCmd create() => token('/create');

  /// Marks the entry being [create]d as a boot application, taking its path
  /// (`/application`).
  BcdeditCmd application(String path) => pair('/application', path);

  /// Marks the entry being [create]d as inheriting from a template
  /// identifier (`/inherit`).
  BcdeditCmd inherit(String identifier) => pair('/inherit', identifier);

  /// Marks the entry being [create]d as a device option (`/device`).
  BcdeditCmd device() => token('/device');

  /// Deletes an element from a specified entry (`/delete`).
  BcdeditCmd delete() => token('/delete');

  // --- Entry-option operations ---------------------------------------------

  /// Deletes one element from a boot entry (`/deletevalue`).
  BcdeditCmd deleteValue(String identifier, String element) => token('/deletevalue').arg(identifier).arg(element);

  /// Sets an entry option's value (`/set`). Pass the identifier, the element
  /// name and its new value in that order, exactly as `bcdedit /set` expects
  /// them on the real command line.
  BcdeditCmd set(String identifier, String element, String value) =>
      token('/set').arg(identifier).arg(element).arg(value);

  // --- Output control -------------------------------------------------------

  /// Lists entries in a store (`/enum`). Bare, this is the default action —
  /// `bcdedit` alone is `/enum active`.
  BcdeditCmd enumerate() => token('/enum');

  /// Verbose mode: prints identifiers in full instead of their friendly
  /// shorthand (`/v`).
  BcdeditCmd verbose() => token('/v');

  // --- Boot manager control -------------------------------------------------

  /// Sets a one-time display order for the next boot only (`/bootsequence`).
  BcdeditCmd bootSequence() => token('/bootsequence');

  /// Sets the entry the boot manager selects once the timeout expires
  /// (`/default`).
  BcdeditCmd defaultEntry() => token('/default');

  /// Sets the display order the boot manager shows to a user
  /// (`/displayorder`).
  BcdeditCmd displayOrder() => token('/displayorder');

  /// Sets how many seconds the boot manager waits before choosing
  /// [defaultEntry] (`/timeout`).
  BcdeditCmd timeout(String seconds) => pair('/timeout', seconds);

  /// Sets the display order for the boot manager's Tools menu
  /// (`/toolsdisplayorder`).
  BcdeditCmd toolsDisplayOrder() => token('/toolsdisplayorder');

  // --- Emergency Management Services (EMS) -----------------------------------

  /// Enables or disables EMS for one boot entry (`/bootems`).
  BcdeditCmd bootEms() => token('/bootems');

  /// Enables or disables EMS for one operating-system boot entry (`/ems`).
  BcdeditCmd ems() => token('/ems');

  /// Sets the global EMS settings for the computer, without enabling or
  /// disabling EMS on any entry (`/emssettings`).
  BcdeditCmd emsSettings() => token('/emssettings');

  // --- Debugging -----------------------------------------------------------

  /// Enables or disables the boot debugger for one entry (`/bootdebug`).
  /// Only has an effect on boot applications.
  BcdeditCmd bootDebug() => token('/bootdebug');

  /// Sets or displays the global debugger settings (`/dbgsettings`). Does not
  /// itself enable or disable the kernel debugger — see [debug].
  BcdeditCmd dbgSettings() => token('/dbgsettings');

  /// Enables or disables the kernel debugger for one boot entry (`/debug`).
  BcdeditCmd debug() => token('/debug');

  // --- Escape hatch ----------------------------------------------------------

  /// Adds a bare positional argument: a `{identifier}` (`{current}`,
  /// `{default}`, `{bootmgr}`, a GUID, …), an element name, an `on`/`off`
  /// value, or any other value the chosen command expects, in the order
  /// `bcdedit /? <command>` shows.
  BcdeditCmd arg(String value) => token(value);

  /// Prints help, or detailed help for one command with [arg] (`/?`).
  BcdeditCmd help() => token('/?');
}

/// `bcdedit`, ready to take its first option.
// ignore: non_constant_identifier_names
BcdeditCmd get Bcdedit => BcdeditCmd();
