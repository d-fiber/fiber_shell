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

/// `schtasks`, the Task Scheduler client, the counterpart of `cron` and of
/// systemd timers. Windows only.
///
/// ```dart
/// await Schtasks.create()
///     .taskName('koko-backup')
///     .taskRun(r'C:\koko\backup.cmd')
///     .schedule('DAILY')
///     .startTime('03:00')
///     .runAs('SYSTEM')
///     .runLevel('HIGHEST')
///     .force()
///     .execute();
/// ```
///
/// [force] makes [create] idempotent: without it the command fails when the task
/// already exists.
///
/// **[runAs] `SYSTEM` takes no password**, and is the right answer for a task
/// that has to run whether or not anyone is logged in. Any other account needs
/// [runPassword], which puts a password in the process arguments, or
/// [noPassword], which lets the task run without stored credentials at the cost
/// of reaching nothing on the network.
///
/// Two more traps. The dates [startDate] and [endDate] follow the **machine's
/// locale**, so the same string means different days on two machines. And
/// `schtasks` prompts for a password more or less whenever an account is named,
/// even locally.
class SchtasksCmd extends CommandBuilder<SchtasksCmd> {
  @override
  final String executable = 'schtasks';

  /// Schedules a new task (`/create`).
  SchtasksCmd create() => token('/create');

  /// Removes one (`/delete`).
  SchtasksCmd delete() => token('/delete');

  /// Lists the scheduled tasks (`/query`).
  SchtasksCmd query() => token('/query');

  /// Changes an existing task (`/change`).
  SchtasksCmd change() => token('/change');

  /// Runs a task now, ignoring its schedule (`/run`).
  SchtasksCmd run() => token('/run');

  /// Stops a task that is running (`/end`).
  SchtasksCmd end() => token('/end');

  /// Prints the SID of a task (`/showsid`).
  SchtasksCmd showSid() => token('/showsid');

  /// The task name, with a folder path if you want one (`/tn`).
  SchtasksCmd taskName(String value) => pair('/tn', value);

  /// The program the task runs (`/tr`). Give it a full path.
  SchtasksCmd taskRun(String value) => pair('/tr', value);

  /// The schedule type: `MINUTE`, `HOURLY`, `DAILY`, `WEEKLY`, `MONTHLY`,
  /// `ONCE`, `ONSTART`, `ONLOGON`, `ONIDLE`, `ONEVENT` (`/sc`).
  SchtasksCmd schedule(String value) => pair('/sc', value);

  /// How often within that type, or `LASTDAY`, `FIRST`, `SECOND`… (`/mo`).
  SchtasksCmd modifier(String value) => pair('/mo', value);

  /// The day or days, `MON,FRI` or a date of the month (`/d`).
  SchtasksCmd day(String value) => pair('/d', value);

  /// The month or months, `JAN,JUL` or `*` (`/m`).
  SchtasksCmd month(String value) => pair('/m', value);

  /// How many idle minutes trigger an `ONIDLE` task (`/i`).
  SchtasksCmd idleTime(String value) => pair('/i', value);

  /// The start time, 24-hour `HH:mm` (`/st`).
  SchtasksCmd startTime(String value) => pair('/st', value);

  /// How often to repeat within the window, in minutes (`/ri`).
  SchtasksCmd repeatInterval(String value) => pair('/ri', value);

  /// When the repeating window ends, `HH:mm` (`/et`).
  SchtasksCmd endTime(String value) => pair('/et', value);

  /// How long that window lasts, `HHHH:mm` (`/du`).
  SchtasksCmd duration(String value) => pair('/du', value);

  /// Kills the program when the window closes (`/k`).
  SchtasksCmd killAtEnd() => token('/k');

  /// The first day the schedule applies, in the machine's date format (`/sd`).
  SchtasksCmd startDate(String value) => pair('/sd', value);

  /// The last day it applies (`/ed`).
  SchtasksCmd endDate(String value) => pair('/ed', value);

  /// The account the task runs as, or `SYSTEM` (`/ru`).
  SchtasksCmd runAs(String value) => pair('/ru', value);

  /// Its password (`/rp`). Not valid, and not needed, for `SYSTEM`.
  SchtasksCmd runPassword(String value) => pair('/rp', value);

  /// The privilege level: `LIMITED` or `HIGHEST` (`/rl`).
  SchtasksCmd runLevel(String value) => pair('/rl', value);

  /// Runs only while that account is logged in (`/it`).
  SchtasksCmd interactiveOnly() => token('/it');

  /// Stores no password; the task then reaches nothing on the network (`/np`).
  SchtasksCmd noPassword() => token('/np');

  /// Deletes the task once its schedule is done (`/z`).
  SchtasksCmd deleteWhenDone() => token('/z');

  /// How long to wait after the trigger, `mmmm:ss` (`/delay`).
  SchtasksCmd delay(String value) => pair('/delay', value);

  /// Overwrites an existing task instead of failing (`/f`).
  SchtasksCmd force() => token('/f');

  /// Creates the task from an XML definition (`/xml`).
  ///
  /// The way to express what the flags cannot, and the way to keep a task
  /// definition in version control.
  SchtasksCmd xml(String path) => pair('/xml', path);

  /// Creates a task the pre-Vista scheduler can see (`/v1`).
  SchtasksCmd legacyFormat() => token('/v1');

  /// The event channel that triggers an `ONEVENT` task (`/ec`).
  SchtasksCmd eventChannel(String value) => pair('/ec', value);

  /// Returns the exit code as an HRESULT (`/hresult`).
  SchtasksCmd hresult() => token('/hresult');

  /// The remote machine to schedule on (`/s`).
  SchtasksCmd server(String value) => pair('/s', value);

  /// The account to run the command as, for a remote machine (`/u`).
  SchtasksCmd user(String value) => pair('/u', value);

  /// Its password (`/p`).
  SchtasksCmd password(String value) => pair('/p', value);

  /// The output format: `TABLE`, `LIST` or `CSV` (`/fo`).
  SchtasksCmd format(String value) => pair('/fo', value);

  /// Drops the column headers (`/nh`).
  SchtasksCmd noHeader() => token('/nh');

  /// The verbose listing (`/v`).
  SchtasksCmd verbose() => token('/v');

  /// Prints a task as XML (`/xml` under [query]).
  SchtasksCmd queryXml() => token('/xml');

  /// Adds a bare argument.
  SchtasksCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
SchtasksCmd get Schtasks => SchtasksCmd();
