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

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:fiber_shell/src/result.dart' as _i2;
import 'package:fiber_shell/src/script.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint

class _FakeShellResult_0 extends _i1.SmartFake implements _i2.ShellResult {
  _FakeShellResult_0(Object parent, Invocation parentInvocation) : super(parent, parentInvocation);
}

class _FakeShellScript_1 extends _i1.SmartFake implements _i3.ShellScript {
  _FakeShellScript_1(Object parent, Invocation parentInvocation) : super(parent, parentInvocation);
}

class MockShellScript extends _i1.Mock implements _i3.ShellScript {
  @override
  String get line =>
      (super.noSuchMethod(
            Invocation.getter(#line),
            returnValue: _i4.dummyValue<String>(this, Invocation.getter(#line)),
            returnValueForMissingStub: _i4.dummyValue<String>(this, Invocation.getter(#line)),
          )
          as String);

  @override
  _i5.Future<void> execute({String? cwd, Map<String, String>? env}) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [], {#cwd: cwd, #env: env}),
            returnValue: _i5.Future<void>.value(),
            returnValueForMissingStub: _i5.Future<void>.value(),
          )
          as _i5.Future<void>);

  @override
  _i5.Future<_i2.ShellResult> output({String? cwd, Map<String, String>? env, String? input}) =>
      (super.noSuchMethod(
            Invocation.method(#output, [], {#cwd: cwd, #env: env, #input: input}),
            returnValue: _i5.Future<_i2.ShellResult>.value(
              _FakeShellResult_0(this, Invocation.method(#output, [], {#cwd: cwd, #env: env, #input: input})),
            ),
            returnValueForMissingStub: _i5.Future<_i2.ShellResult>.value(
              _FakeShellResult_0(this, Invocation.method(#output, [], {#cwd: cwd, #env: env, #input: input})),
            ),
          )
          as _i5.Future<_i2.ShellResult>);

  @override
  _i3.ShellScript and(_i3.ShellScript? next) =>
      (super.noSuchMethod(
            Invocation.method(#and, [next]),
            returnValue: _FakeShellScript_1(this, Invocation.method(#and, [next])),
            returnValueForMissingStub: _FakeShellScript_1(this, Invocation.method(#and, [next])),
          )
          as _i3.ShellScript);

  @override
  _i3.ShellScript or(_i3.ShellScript? next) =>
      (super.noSuchMethod(
            Invocation.method(#or, [next]),
            returnValue: _FakeShellScript_1(this, Invocation.method(#or, [next])),
            returnValueForMissingStub: _FakeShellScript_1(this, Invocation.method(#or, [next])),
          )
          as _i3.ShellScript);

  @override
  _i3.ShellScript then(_i3.ShellScript? next) =>
      (super.noSuchMethod(
            Invocation.method(#then, [next]),
            returnValue: _FakeShellScript_1(this, Invocation.method(#then, [next])),
            returnValueForMissingStub: _FakeShellScript_1(this, Invocation.method(#then, [next])),
          )
          as _i3.ShellScript);
}
