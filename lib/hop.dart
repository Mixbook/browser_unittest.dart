library browser_unittest.hop;

import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:hop/hop.dart';
import 'package:browser_unittest/browser_unittest.dart';
import 'package:ansicolor/ansicolor.dart';

const _COMMAND_OPTION = "content_shell";

final colorizeAsError = new AnsiPen()..red();
final colorizeAsFailure = new AnsiPen()..red();
final colorizeAsSuccess = new AnsiPen()..green();

Task createBrowserTestTask([Parser parser]) {
  parser = parser != null ? parser : htmlConfigParser;
  return new Task(
      (context) => _run(context, parser),
      description: "Runs browser tests using content shell. Defaults to running 'test/test.html'",
      config: (ArgParser parser) {
        parser.addOption(_COMMAND_OPTION, help: "The command to execute Content Shell", defaultsTo: "Content Shell");
      }
  );
}

Future _run(TaskContext context, Parser parser) {
  var command = context.arguments[_COMMAND_OPTION];
  var file = context.arguments.rest.isNotEmpty ? context.arguments.rest.first : "test/test.html";
  return Process.run(command, ['--dump-render-tree', file])
      .then((result) {
        var run = parser(result.stdout);

        if (run.didComplete) {
          var passes = run.results.where((result) => result.isPass);
          var errors = run.results.where((result) => result.isError);
          var failures = run.results.where((result) => result.isFailure);

          errors.forEach((error) => _logFailure(error, context));
          failures.forEach((failure) => _logFailure(failure, context));

          var summary = "Test results: ${passes.length} passed, ${failures.length} failed, ${errors.length} errored";
          if (errors.isNotEmpty || failures.isNotEmpty) {
            context.fail(colorizeAsError(summary));
          } else {
            context.info(colorizeAsSuccess(summary));
          }
        } else {
          context.severe(run.errorOutput);
          context.fail(colorizeAsError("Tests did not complete"));
        }
      });
}

void _logFailure(TestResult testResult, TaskContext context) {
  assert(!testResult.isPass);

  context
      .getSubLogger(testResult.result)
      .severe("${testResult.description}\n${testResult.stackTrace}");
}
