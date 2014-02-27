part of browser_unittest;

/// Parses the Content Shell output from a unit test that's configured
/// with `useHtmlConfiguration()`.
Parser htmlConfigParser = (String output) {
  /// A regexp matcher for an HTML configuration.
  ///
  /// Capturing groups:
  /// 1. Result
  /// 2. Description
  /// 3. Stack trace
  var matcher = new RegExp(r"^\d+\t(.+)\t(.+?)$([\s\S]+?)(?=^\d+\t|^Total|^All)", multiLine: true);

  return matcher.allMatches(output).map((match) {
    return new TestResult(match[1], match[2], new Trace.parse(match[3]));
  });
};
