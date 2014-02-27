library browser_unittest.html_config_parser_tests;

import 'package:unittest/unittest.dart';
import 'package:browser_unittest/browser_unittest.dart';

void main() => group("htmlConfigParser", () {
  group("when passing", () {
    var output = '''
1\tPASS\tExpectation: add operator.
All 2 tests passed
''';

    test("has correct results", () {
      var result = htmlConfigParser(output).where((result) => result.isPass).first;
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
      var result = htmlConfigParser(output).where((result) => result.isFailure).first;
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
      var result = htmlConfigParser(output).where((result) => result.isError).first;
      expect(result.result, equals("ERROR"));
      expect(result.description, equals("Expectation: add operator. Test failed: Caught Some error"));
      expect(result.stackTrace.frames.length, equals(3));
    });
  });
});