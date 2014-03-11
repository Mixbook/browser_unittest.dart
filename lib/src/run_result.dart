part of browser_unittest;

class RunResult {
  final Iterable<TestResult> results;
  final String errorOutput;

  bool get didComplete => errorOutput != null && errorOutput.isEmpty;

  RunResult.completed(this.results) :
    errorOutput = "";

  RunResult.errored(this.errorOutput) :
    results = [];
}
