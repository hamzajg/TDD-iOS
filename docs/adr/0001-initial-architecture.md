# ADR 0001 — Initial architecture

Date: 2026-11-13 (baseline recorded retroactively)
Status: accepted (describes what is built)

## Context

An iOS TDD course repo. The constraint: exercise test-driven development
without needing the simulator for every loop.

## Decisions

1. **SwiftPM packages for logic, Xcode workspace for the app.** `Domain`
   and `App` are packages (`swift-tools-version:5.2`); the Xcode project
   holds only the app shell + template test targets. Rationale: `swift
   test` runs headless on macOS CI; simulator tests stay optional.
2. **String Calculator kata in `Domain`.** Same rule set as the Android
   sibling repo (delimiters, negatives, >1000) — cross-platform pairing.
   Rationale: the kata is the course's spine.
3. **Typed errors.** `StringCalculatorError` enum with `description`
   messages ("negatives not allowed: -1, -3"). Rationale: Swift-idiomatic —
   errors carry structure, UI can localise.
4. **XCTest, one test per rule in rule order.** `StringCalculatorTests`
   mirrors the kata's history. Rationale: readable TDD narrative.
5. **Linux manifests kept.** `XCTestManifests.swift`/`LinuxMain.swift`
   retained (swift-tools 5.2 era). Rationale: preserves the package's
   original Linux-testability intent.
6. **No CocoaPods.** `Podfile` is an empty stub; packages have zero
   external deps. Rationale: KISS — nothing to install.

## Consequences

- macOS-only development/CI — no Linux/Windows path for the packages
  either (XCTest on Linux wasn't the goal).
- The app target is essentially untouched template — features would start
  in `Domain`/`App` packages.
- swift-tools 5.2 constrains language features; bumping tools-version is
  a deliberate migration, not a tweak.
