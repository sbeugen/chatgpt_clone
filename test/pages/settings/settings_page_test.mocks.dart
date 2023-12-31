// Mocks generated by Mockito 5.4.2 from annotations
// in chatgpt_clone/test/pages/settings/settings_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i3;

import 'package:chatgpt_clone/providers/settings/settings_model.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [SettingsModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsModel extends _i1.Mock implements _i2.SettingsModel {
  @override
  set openAIApiKey(String? _openAIApiKey) => super.noSuchMethod(
        Invocation.setter(
          #openAIApiKey,
          _openAIApiKey,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get initialized => (super.noSuchMethod(
        Invocation.getter(#initialized),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  set initialized(bool? _initialized) => super.noSuchMethod(
        Invocation.setter(
          #initialized,
          _initialized,
        ),
        returnValueForMissingStub: null,
      );
  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
  @override
  void updateOpenAIApiKey(String? openAIApiKey) => super.noSuchMethod(
        Invocation.method(
          #updateOpenAIApiKey,
          [openAIApiKey],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void maybeDispatchObjectCreation() => super.noSuchMethod(
        Invocation.method(
          #maybeDispatchObjectCreation,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void addListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void removeListener(_i3.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
