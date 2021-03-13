# AppLog

AppLog is a super simple logging package for Swift.

## Making the instance

First, make an instance of `AppLog` in your app. There can be multiple instances if necessary.

```swift
let log = AppLog()
```

You can also specify a custom file name if you would like to use multiple log files for different portions of the app:

```swift
let log = AppLog(filename: "error.txt")
```

Note that the `filename` should include a `.txt` extension.

## Reporting logs

Once you have your instance, simply use the `report` method to write a new log to the file:

```swift
log.report("My test log")
```

You can use any of the available overloads (including providing an error) to report logs:

```swift
log.report("My test log")
log.report(["My test log", "Second log"])
log.report("My test log", "Second log")

log.report(myError)
log.report([myError, myError2])
log.report(myError, myError2)
```

Using any of the `String` overloads, defaults to the `.normal` severity. `Error` overloads default to the `.error` severity.

> Note that when logs are made, they are also printed to the console (i.e. no need for an extra `print` statement as well). However, in debug builds, AppLog will not print to the console.

## Severity/formatting

You can optionally provide a severity level to apply to your log.

There are four available severity levels:

- `.normal` - indicates a standard log
- `.debug` - same format as `.normal` but is added only in debug builds
- `.error` - standard error reporting; gives more prominence to the error
- `.critical` - a major error that causes the app to crash or functionality to not work as intended

Here are examples of each severity's output:

```swift
log.report("My test log", severity: .normal)

// outputs...

<date>, <sender-file>, <sender-function>, <sender-line>
my test log
```
```swift
log.report("My test log", severity: .error)

// outputs...

ERROR:
my test log
DATE: <date>
SENDER: <sender-file>, <sender-function>, <sender-line>
```

```swift
log.report("My test log", severity: .critical)

// outputs...

--- CRITICAL ---

my test log

DATE: <date>
SENDER-FILE: <sender-file>
SENDER-FUNCTION: <sender-function>
SENDER-LINE: <sender-line>

IMMEDIATE ACTION REQUIRED

--- END CRITICAL ---
```

## Reading the file

To read the contents of the log file, simply use the `readFile()` method:

```swift
let contents = log.readFile()
if case .success(let str) = contents {
    // Use file contents
}
```

The file contents can then be used during a feedback/bug report or similar.

## Clearing the file

Occasionally, it is a good idea to clear the file to prevent it from becoming too large. This can be acheived through the `clearFile()` method:

```swift
log.clearFile()
```

## Credits/Legal

See `LICENSE.md` for more information.

This package was created by [benrobinson16](https://github.com/benrobinson16).

Copyright (c) 2021 Benjamin Robinson. All Rights Reserved.
