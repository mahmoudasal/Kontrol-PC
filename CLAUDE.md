# Kontrol: PC Control Kit

<!--
Golden Test: "Would removing this rule cause Claude to make mistakes?"
If not — cut it. Don't restate defaults Claude already knows.
-->

Open-source phone-to-PC remote (Unified Remote-style). CV project. Publish on Google Play. License: Apache 2.0.

## Project Overview

UI spec: see design-handoff/DESIGN_HANDOFF.md and design-handoff/design/project/.

### Monorepo layout

Dart pub workspace + melos 8 (config under `melos:` in root `pubspec.yaml`).

- `apps/mobile` — Flutter Android/iOS client (the remote)
- `apps/desktop` — Flutter Windows server (tray app; injects input via Dart FFI → user32 `SendInput`)
- `packages/kontrol_protocol` — shared pure-Dart message models (JSON)
- `packages/kontrol_ui` — shared theme/design tokens

### System design

- Transport: WebSocket over LAN (UDP later for mouse movement if latency is bad)
- Discovery: mDNS
- Pairing: QR + 6-digit PIN
- Keep platform code behind interfaces (Windows first, macOS/Linux later)

### MVP scope

Discovery, pairing, touchpad, keyboard, media, power. Windows server only.

### Roadmap

Phase 0 scaffold (done) → Phase 1 spike (move cursor from phone) → Phase 2 MVP → Phase 3 tests/security → Phase 4 release.

## Commands

melos is a workspace dev dependency, not global: run via `dart run melos <cmd>`.

| Command                      | Purpose                             |
| ---------------------------- | ----------------------------------- |
| `dart run melos bootstrap`   | Resolve workspace                   |
| `dart run melos run analyze` | `flutter analyze` in every package  |
| `dart run melos run test`    | Flutter tests, then pure-Dart tests |
| `dart run melos run format`  | `dart format .`                     |

- Melos scripts must not call `melos` directly (not on PATH); compose with `steps:`.

## Conventions

- App ID: `com.asal.kontrol` (Android applicationId + iOS bundle ID)
- Toolchain: Flutter 3.47.2 / Dart 3.13.2. Pubspecs use `sdk: ^3.13.2`; Flutter packages add `flutter: ">=3.47.2"`
- Every sub-package uses `resolution: workspace`; single root `pubspec.lock`
- Apps depend on shared packages via path deps

## Workflow (Mandatory)

1. Before creating any new feature → invoke the `/flutter-feature` skill first for scaffolding and architecture reference
2. Before marking any task done → run the `/flutter-code-review` skill
3. After task approved → use the `@git-expert` agent for branch, commit, and PR output

## Agents — Proactively Suggest (YOU MUST FOLLOW)

You MUST proactively suggest the appropriate agent when the situation matches. Do not wait for the user to ask.

- `@debugger` — When a bug, crash, error, or unexpected behavior is encountered
- `@code-reviewer` — After `/flutter-code-review` passes, ALWAYS suggest running `@code-reviewer` for a deeper independent review before proceeding to PR
- `@test-writer` — When code is changed or added without corresponding tests, or when test coverage is missing
- `@git-expert` — When it's time to create a branch, commit, or PR. Also for merge conflicts, rebases, or any complex git situation

---

## General Engineering Rules

### Architecture & Separation of Concerns (YOU MUST FOLLOW)

- Follow the project's architecture layer boundaries strictly: presentation → domain → data
- Never bypass layers or mix responsibilities
- UI/presentation layer has ZERO business logic — only rendering, interaction, and state observation
- Business logic lives in the domain layer
- Data access (APIs, databases, storage) lives in the data layer
- Do not introduce new abstractions or patterns without justification

### Shared Code (IMPORTANT)

- Any reusable logic, utility, constant, extension, or helper used in 2+ places goes in `core/`
- Check `core/` before creating new shared code — never duplicate across features

### Error Handling

- Errors flow cleanly across layers — never skip layers
- Handle null, empty, loading, and error states explicitly — no silent failures
- Catch errors at the boundary (data layer), not deep inside business logic

### Change Discipline

- Make the smallest change that solves the problem
- Fix root causes, not symptoms
- Don't refactor unrelated code unless explicitly requested
- Never break existing functionality, APIs, flows, or UX unless explicitly instructed
- Read relevant code before modifying it — state assumptions when unclear

### Dependencies

- Don't add new packages without justification
- Any new package must be: latest stable, well-maintained, production-grade

### Security

- Never hardcode secrets, tokens, or credentials
- Never log sensitive information
- Validate all external and API input
- Proactively flag security risks when spotted

### Testing

- Write tests for domain and data layer logic
- Bug fixes must include a reproducing test
- Tests must be deterministic — no flaky or timing-dependent tests
- One behavior per test case

---

## Flutter / Dart Rules

<!--
Follow official Dart style guide, Effective Dart, and flutter_lints defaults.
Rules below only cover things that OVERRIDE defaults or encode project decisions.
-->

### State Management

- Cubit (flutter_bloc) with sealed states; DI via get_it

### No Code Generation

- **No Freezed. No build_runner.** Use Dart 3+ native features instead:
  - `sealed class` for state unions with exhaustive pattern matching
  - `switch` expressions and records for lightweight data

### Domain Layer Purity

- Domain layer must have ZERO Flutter imports
- No `package:flutter/...` in any file under `domain/`

### Feature Folder Structure

```
features/{feature_name}/
├── data/
├── domain/
└── presentation/
```

### Error Handling Contract

- Data layer: catch exceptions and map to typed `Failure` classes
- Domain layer: return `ApiResult<T>` from use cases and repositories
- Presentation layer: map failures to user-friendly messages and UI states

### Dependency Injection

- Use **`get_it`** as the service locator
- Register dependencies in a single `core/di/` setup file
- Cubits, use cases, and repositories are resolved via `get_it`, not instantiated manually

### Build Method Discipline (IMPORTANT)

- Prefer `const` constructors wherever possible
- NEVER create `TextEditingController`, `AnimationController`, `FocusNode`, or other expensive objects inside `build()`
- Avoid heavy work inside `build()` methods
- Dispose controllers and focus nodes in `StatefulWidget.dispose()`
- Prefer small, composed widgets to minimize rebuild scope
- Use `BlocBuilder`/`BlocSelector` on the smallest widget that needs the state — never at the top of the tree
