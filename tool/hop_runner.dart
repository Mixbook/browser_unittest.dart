library browser_unittest.hop_runner;

import 'package:hop/hop.dart';
import 'package:browser_unittest/hop.dart';

void main(List<String> args) {
  addTask("test", createBrowserTestTask());
  runHop(args);
}