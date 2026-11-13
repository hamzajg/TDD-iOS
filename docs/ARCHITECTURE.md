# Architecture — TDD-iOS

Current-state map. Descriptive, not aspirational; see `docs/adr/` for why.

## Shape

```
TDD-iOS/   (Xcode workspace + two SwiftPM packages)
├── TDD.iOS.xcworkspace   app + unit + UI test targets
├── Domain/               SwiftPM package (the testable core)
│   ├── Package.swift            swift-tools-version:5.2
│   ├── Sources/Domain/
│   │   ├── StringCalculator.swift   the kata
│   │   └── Domain.swift             package example
│   └── Tests/DomainTests/
│       ├── StringCalculatorTests.swift   one test per rule
│       ├── DomainTests.swift            package example test
│       ├── XCTestManifests.swift       Linux test manifest
│       └── LinuxMain.swift
├── App/                  SwiftPM package depending on Domain (path dep)
│   ├── Sources/App/App.swift
│   └── Tests/AppTests/               AppTests + manifests
├── TDD.iOS/              app target sources (AppDelegate, ViewController…)
├── TDD.iOSTests/         unit test target (template)
├── TDD.iOSUITests/       UI test target (template)
└── Podfile               stub — no pods
```

## Design

- **Logic in packages, shell in Xcode.** The kata lives in `Domain`
  (SwiftPM) so `swift test` runs without a simulator; the app target is
  just the course template.
- **`App` depends on `Domain`** — demonstrates package composition; app
  code that needs domain logic imports `Domain`.
- **Kata errors as enum.** `StringCalculatorError` (`invalidDelimiter`,
  `negativesNotAllowed`) with user-displayable `description` — errors are
  typed, not strings.

## Verification

CI: `swift test` per package on `macos-latest` (matrix: Domain, App).
Xcode path: `Cmd-U` in the workspace — needs a matching simulator runtime.
