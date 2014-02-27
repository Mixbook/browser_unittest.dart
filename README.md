# Headless Browser Unit Tests
This package provides tools for running and parsing headless browser unit tests with Content Shell.

## Usage

### Install Content Shell
The downloader for Content Shell is packaged with the Dart Editor. As of version 1.1, the downloader is located in `$DART_EDITOR/chromium/download_contentshell.sh`. Run the downloader, unpack the zip archive, and add the Content Shell executable to your path.

If everything is setup correctly, you should be able to dump the render tree of a website in your terminal:

```
$ Content\ Shell --dump-render-tree google.com
```

### Setup Your Test Files
In your Dart test file, make sure you're using the HTML configuration.

```
library test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';

void main() {
  useHtmlConfiguration();
  
  test("add", () => expect(1 + 1, equals(2)));
}
```

In your test HTML file, you must also include `test_controller.js` from the unit test package. This file is used by the testing framework to notify the browser when the tests have completed.

```
<!DOCTYPE html>

<html>
  <head>
    <title>test</title>
  </head>

  <body>
    <h1>Running tests...</h1>
    <script type="application/dart" src="test.dart"></script>
    <script type="text/javascript" src="packages/unittest/test_controller.js"></script>
  </body>
</html>
```

### Setup With Hop
This package includes a set of tasks to run headless unit tests with [Hop](https://github.com/dart-lang/hop). Inside your Dart Hop runner file, import the `browser_unittest/hop.dart` library, and add a test task with `createBrowserTestTask()`.

```
library hop_runner;

import 'package:hop/hop.dart';
import 'package:browser_unittest/hop.dart';

void main(List<String> args) {
  addTask("test", createBrowserTestTask());
  runHop(args);
}
```

Run the tests with Hop from your project's root directory. By default, this will look for a test file inside your project's directory at `test/test.html`.

```
$ dart tool/hop_runner.dart test
```

Use `help` to get a list of configuration options.

```
$ dart tool/hop_runner.dart help test
```