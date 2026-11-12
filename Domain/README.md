# Domain

The domain layer for the TDD-iOS practice repository.

It holds plain Swift logic with no UIKit or SwiftUI dependency, so it can be
tested with `swift test` on any machine — no simulator required.

## Contents

- `StringCalculator` — the String Calculator kata: an empty or `nil` input is
  0, numbers are separated by commas or newlines, a custom delimiter can be
  declared with `//<delimiter>\n`, negatives are rejected and all of them are
  reported, and numbers above 1000 are ignored.
- `StringCalculatorError` — `invalidDelimiter` and
  `negativesNotAllowed([Int])`, both with a human-readable `description`.
- `Domain` — the package's original placeholder type.

## Usage

```swift
import Domain

let calculator = StringCalculator()
let total = try calculator.add("1,2,3")        // 6
let custom = try calculator.add("//;\n1;2")    // 3

do {
    _ = try calculator.add("-1,2,-3")
} catch let error as StringCalculatorError {
    print(error)   // negatives not allowed: -1, -3
}
```

## Test

```bash
swift test
```

12 tests: 11 for the kata, one for the placeholder type.
