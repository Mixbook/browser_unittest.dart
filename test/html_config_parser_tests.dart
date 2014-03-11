library browser_unittest.html_config_parser_tests;

import 'package:unittest/unittest.dart';
import 'package:browser_unittest/browser_unittest.dart';

void main() => group("htmlConfigParser", () {
  group("when completed", () {
    group("when passing", () {
      var output = '''
1\tPASS\tExpectation: add operator.
All 2 tests passed
''';

      test("has correct results", () {
        var result = htmlConfigParser(output).results.where((result) => result.isPass).first;
        expect(result.result, equals("PASS"));
        expect(result.description, equals("Expectation: add operator."));
        expect(result.stackTrace.frames, isEmpty);
      });
    });

    group("when failing", () {
      var output = '''
Content-Type: text/plain
FAIL
1\tFAIL\tExpectation: add operator. Expected: <4> Actual: <3>
package:unittest/src/expect.dart 75:29                                                                                                     expect
test.dart 9:36                                                                                                                             main.<fn>
dart:async                                                                                                                                 _asyncRunCallback
../../../../../../../../Volumes/data/b/build/slave/dartium-mac-full-stable/build/src/dart/tools/dom/src/native_DOMImplementation.dart 604  _handleMutation
Total 0 passed, 1 failed 0 errors
''';

      test("has correct results", () {
        var result = htmlConfigParser(output).results.where((result) => result.isFailure).first;
        expect(result.result, equals("FAIL"));
        expect(result.description, equals("Expectation: add operator. Expected: <4> Actual: <3>"));
        expect(result.stackTrace.frames.length, equals(4));
      });
    });

    group("when erroring", () {
      var output = '''
FAIL
1\tERROR\tExpectation: add operator. Test failed: Caught Some error
test.dart 9:30                                                                                                                             main.<fn>
dart:async                                                                                                                                 _asyncRunCallback
../../../../../../../../Volumes/data/b/build/slave/dartium-mac-full-stable/build/src/dart/tools/dom/src/native_DOMImplementation.dart 604  _handleMutation
Total 0 passed, 0 failed 1 errors
''';

      test("has correct results", () {
        var result = htmlConfigParser(output).results.where((result) => result.isError).first;
        expect(result.result, equals("ERROR"));
        expect(result.description, equals("Expectation: add operator. Test failed: Caught Some error"));
        expect(result.stackTrace.frames.length, equals(3));
      });
    });
  });

  group("when internal error", () {
    var output = '''
CONSOLE MESSAGE: line 213: Error: 

FIXME:0:
Internal error: 'edit_text_presenter_test.dart': error: line 184 pos 5: invalid arguments passed to super class constructor 'EditTextPresenter.': 3 passed, 4 expected
    super(canvasPresenter, originalText, canvasWithText, textEngine: textEngine);
    ^


CONSOLE MESSAGE: line 213: FAIL
Content-Type: text/plain
Error: 

FIXME:0:
Internal error: 'file:///Users/dan/Development/mixbook/workspace/taco/taco_client/test/edit_text_presenter_test.dart': error: line 184 pos 5: invalid arguments passed to super class constructor 'EditTextPresenter.': 3 passed, 4 expected
    super(canvasPresenter, originalText, canvasWithText, textEngine: textEngine);
    ^

FAIL
#EOF
''';

    test("error output is populated", () {
      var result = htmlConfigParser(output);
      expect(result.errorOutput, isNot(isEmpty));
    });
  });

  group("when uncaught error", () {
    var output = '''
CONSOLE MESSAGE: Uncaught Error: The null object does not have a method 'add'.

NoSuchMethodError : method not found: 'add'
Receiver: null
Arguments: [Instance of 'Action']
CONSOLE MESSAGE: Stack Trace: 
#0      Object.noSuchMethod (dart:core-patch/object_patch.dart:45)
#1      EditTextPresenter._apply (package:taco_client/src/presenters/edit_text_presenter.dart:106:23)
#2      EditTextPresenter.save.<anonymous closure> (package:taco_client/src/presenters/edit_text_presenter.dart:89:37)
#3      _Future._propagateToListeners.<anonymous closure> (dart:async/future_impl.dart:453)
#4      _rootRun (dart:async/zone.dart:683)
#5      _RootZone.run (dart:async/zone.dart:832)
#6      _Future._propagateToListeners (dart:async/future_impl.dart:445)
#7      _Future._complete (dart:async/future_impl.dart:303)
#8      _Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:354)
#9      _asyncRunCallback (dart:async/schedule_microtask.dart:18)
#10     _handleMutation (native_DOMImplementation.dart:604)


CONSOLE MESSAGE: line 213: Error: 

FIXME:0:
Exception: The null object does not have a method 'add'.

NoSuchMethodError : method not found: 'add'
Receiver: null
Arguments: [Instance of 'Action']


CONSOLE MESSAGE: line 213: FAIL
Content-Type: text/plain
Error: 

FIXME:0:
Exception: The null object does not have a method 'add'.

NoSuchMethodError : method not found: 'add'
Receiver: null
Arguments: [Instance of 'Action']

FAIL
#EOF
''';

    test("error output is populated", () {
      var result = htmlConfigParser(output);
      expect(result.errorOutput, isNot(isEmpty));
    });
  });
});