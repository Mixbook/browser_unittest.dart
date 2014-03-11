part of browser_unittest;

class TestResult {
  final String result;
  bool get isFailure => result == "FAIL";
  bool get isError => result == "ERROR";
  bool get isPass => result == "PASS";

  final String description;
  final Trace stackTrace;

  TestResult(this.result, this.description, this.stackTrace);

  TestResult.failure(this.description, this.stackTrace) :
    result = "FAIL";

  TestResult.error(this.description, this.stackTrace) :
    result = "ERROR";

  TestResult.pass(this.description, this.stackTrace) :
    result = "PASS";

  String toString() => "[${result.toUpperCase()}]\t$description\n$stackTrace";
}
