library browser_unittest.test;

import 'package:unittest/html_config.dart';
import 'html_config_parser_tests.dart' as htmlConfigParserTests;

void main() {
  useHtmlConfiguration();
  htmlConfigParserTests.main();
}