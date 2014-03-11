part of browser_unittest;

/// Parses the Content Shell output from a unit test that's configured
/// with `useHtmlConfiguration()`.
Parser htmlConfigParser = (String output) {
  // A regexp matcher for an HTML configuration.
  //
  // Capturing groups:
  // 1. Result
  // 2. Description
  // 3. Stack trace
  var testMatcher = new RegExp(r"^\d+\t(.+)\t(.+?)$([\s\S]+?)(?=^\d+\t|^Total|^All)", multiLine: true);

  // A regexp match for errors internal errors that cause the test run
  // to not complete, such as syntax errors or unhandled exceptions.
  var internalErrorMatcher = new RegExp(r"Internal error|Uncaught Error");

  var testResults = testMatcher.allMatches(output).map((match) {
    return new TestResult(match[1], match[2], new Trace.parse(match[3]));
  });

  if (!internalErrorMatcher.hasMatch(output)) {
    return new RunResult.completed(testResults);
  } else {
    return new RunResult.errored(output);
  }
};
