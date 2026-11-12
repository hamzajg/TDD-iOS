# App

The application layer for the TDD-iOS practice repository.

This package depends on [`../Domain`](../Domain) and is where UI-facing code
would live. Right now it contains only the placeholder `App` type used to
verify that the package graph builds and that a package can depend on a
sibling package by path.

## Usage

```swift
import App

let app = App()
print(app.text)   // Hello, World!
```

## Test

```bash
swift test
```

The test imports both `App` and `Domain`, so it also checks the local package
dependency.
