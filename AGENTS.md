# AGENTS.md — TDD-iOS

Guidance for AI agents (and humans) working in this repository.

## Project

iOS test-driven development practice (Lynda course *iOS App Development:
Test-Driven Development*, 2018). The Xcode workspace holds the app shell;
the substance is the **String Calculator kata** in a Swift package, so the
logic builds and tests without a simulator.
Stack: Swift 5 (`swift-tools-version:5.2`), SwiftPM packages `Domain/` +
`App/`, Xcode workspace (`TDD.iOS.xcworkspace`), CocoaPods `Podfile`
(unused), XCTest.

## Commands

Verified 2026-11-13 against CI (`.github/workflows/ci.yml`) and README.

| Task | Command |
|---|---|
| Domain tests | `cd Domain && swift test` (17 tests) |
| App tests | `cd ../App && swift test` |
| Xcode tests | open `TDD.iOS.xcworkspace` → `Cmd-U` (needs simulator matching deployment target) |

Requires: **macOS + Swift toolchain** — CI runs `macos-latest`. No external
package deps.

## Architecture

```
TDD.iOS.xcworkspace     app target + test targets (Xcode project)
├── Domain/             SwiftPM package — the kata logic
│   ├── Package.swift           swift-tools 5.2
│   ├── Sources/Domain/         StringCalculator.swift, Domain.swift
│   └── Tests/DomainTests/      StringCalculatorTests.swift (one test/rule),
│                               XCTestManifests.swift, LinuxMain.swift
├── App/                SwiftPM package depending on Domain
│   ├── Sources/App/App.swift
│   └── Tests/AppTests/
├── TDD.iOS/            app sources: AppDelegate, ViewController, assets
├── TDD.iOSTests/       unit test target (template)
├── TDD.iOSUITests/     UI test target (template)
└── Podfile             CocoaPods stub — no pods declared
```

`App` depends on `Domain` (check `App/Package.swift` for the path dep).

## The kata rules (the spec)

Same rules as the Android sibling: empty/nil → 0; comma/newline
separators; `//<d>\n` custom delimiter; bracketed `//[***]\n` and multi
`//[*][%]\n`; malformed brackets → `invalidDelimiter`; negatives →
`negativesNotAllowed([negatives])`; >1000 ignored. Errors are
`StringCalculatorError` with displayable `description`.

## Conventions

- **Swift packages for logic, Xcode project for the shell** — keeps tests
  simulator-free. New logic goes in `Domain`/`App` packages, not the app
  target, when it should be testable.
- XCTest; one test per rule in rule order (the kata's history).
- `XCTestManifests.swift` + `LinuxMain.swift` exist for Linux test
  discovery — regenerate/keep consistent if adding tests (swift-tools 5.2
  era).
- Swift 5.2 tools — avoid newer language features that break the manifest.
- KISS: kata repo; no architecture layers, no DI, no pods.

## Landmines

- **Default branch is `master`, not `main`.**
- **macOS-only** — `swift test` needs a Mac (CI uses `macos-latest`); the
  Xcode workspace can't build on Linux/Windows.
- Deployment target vs installed simulator runtimes — `Cmd-U` fails if no
  matching runtime; packages avoid this entirely.
- `Podfile` is a stub with no pods — `pod install` isn't needed for the
  packages; don't add pods casually.
- `.build/` dirs are committed?? — check `git status`; build output should
  stay untracked (`Domain/.build`, `App/.build` exist locally).
- `Domain.swift`/`App.swift` may hold package example tests — check before
  assuming they're empty.

## Agent rules

- Branch from `master`; name branches `feat/*`, `fix/*`, `chore/*`, `docs/*`.
- Docs-only changes still go through a PR; never commit to `master` directly.
- Verify before claiming: `cd Domain && swift test` (and `App`) — report
  the real result; note macOS requirement.
- Keep changes minimal and consistent with surrounding code. No drive-by
  refactors.
- New calculator behaviour needs a test in `StringCalculatorTests` first.
- Update AGENTS.md / docs/ARCHITECTURE.md when structure or commands change.
