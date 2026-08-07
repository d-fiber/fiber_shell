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
