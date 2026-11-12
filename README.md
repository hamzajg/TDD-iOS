# TDD-iOS

Test-driven development practice for iOS, from the Lynda course *iOS App
Development: Test-Driven Development (2018)*.

The repository is the course's Xcode workspace plus two Swift packages that
hold the testable code, so the logic can be built and tested without an
emulator:

| Path | What it is |
|---|---|
| `TDD.iOS.xcworkspace` | the Xcode workspace (app target, tests, UI tests) |
| `Domain/` | Swift package with the domain logic |
| `App/` | Swift package that depends on `Domain` |

## The kata

`Domain` contains the **String Calculator kata**, written test-first:

[`StringCalculator`](Domain/Sources/Domain/StringCalculator.swift) sums the
numbers in a string:

| Rule | Example |
|---|---|
| An empty string (or `nil`) is 0 | `"" -> 0` |
| Numbers are separated by commas | `"1,2" -> 3` |
| A newline also separates numbers | `"1\n2,3" -> 6` |
| A custom delimiter can be declared | `"//;\n1;2" -> 3` |
| A delimiter of any length can be declared in brackets | `"//[***]\n1***2***3" -> 6` |
| Several delimiters can be declared together | `"//[*][%]\n1*2%3" -> 6` |
| A malformed bracketed delimiter is rejected | `"//[***\n1"` throws `invalidDelimiter` |
| Negative numbers are rejected, and every negative is reported | `"-1,2,-3"` throws `negativesNotAllowed([-1, -3])` |
| Numbers greater than 1000 are ignored | `"2,1001" -> 2` |

The calculator throws `StringCalculatorError`, whose `description` is the
message a caller can show: `"negatives not allowed: -1, -3"`.

[`StringCalculatorTests`](Domain/Tests/DomainTests/StringCalculatorTests.swift)
has one test per rule, in the order the rules were added — the history of the
kata.

## Run the tests

The packages build with Swift 5 and have no external dependencies:

```bash
cd Domain && swift test
cd ../App && swift test
```

`Domain` runs 17 tests (16 for the kata plus the package's example test).
The Xcode workspace can also be opened in Xcode and tested with
`Cmd-U`, provided a simulator runtime matching the project's deployment
target is installed.

## Continuous integration

[`.github/workflows/ci.yml`](.github/workflows/ci.yml) runs `swift test` for
both packages on `macos-latest` for every push and pull request to `master`.

## License

GPL-3.0 — see [LICENSE](LICENSE).
