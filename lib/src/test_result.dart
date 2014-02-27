part of browser_unittest;

class TestResult {
  final String result;
  bool get isFailure => result == "FAIL";
  bool get isError => result == "ERROR";
  bool get isPass => result == "PASS";

  final String description;
  final Trace stackTrace;

  TestResult(this.result, this.description, this.stackTrace);

  String toString() => "[${result.toUpperCase()}]\t$description\n$stackTrace";
}
