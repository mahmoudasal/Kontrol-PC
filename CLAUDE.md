# Kontrol: PC Control Kit

Open-source phone-to-PC remote (Unified Remote-style). CV project. Publish on Google Play. License: Apache 2.0.

## Architecture
- Monorepo: Dart pub workspace + melos 8 (config under `melos:` in root pubspec.yaml)
- apps/mobile — Flutter Android/iOS client (the remote)
- apps/desktop — Flutter Windows server (tray app; injects input via Dart FFI → user32 SendInput)
- packages/kontrol_protocol — shared pure-Dart message models (JSON)
- packages/kontrol_ui — shared theme/design tokens
- Transport: WebSocket over LAN (UDP later for mouse movement if latency is bad)
- Discovery: mDNS. Pairing: QR + 6-digit PIN.

## Conventions
- App ID: com.asal.kontrol (Android applicationId + iOS bundle ID)
- Toolchain: Flutter 3.47.2 / Dart 3.13.2. Pubspecs use `sdk: ^3.13.2`; Flutter packages add `flutter: ">=3.47.2"`
- Every sub-package uses `resolution: workspace`; single root pubspec.lock
- Apps depend on shared packages via path deps

## Commands
melos is a workspace dev dependency, not global: run via `dart run melos <cmd>`.
- `dart run melos bootstrap` — resolve workspace
- `dart run melos run analyze` — `flutter analyze` in every package
- `dart run melos run test` — Flutter tests, then pure-Dart tests
- `dart run melos run format` — `dart format .`
Scripts must not call `melos` directly (not on PATH); compose with `steps:`.
- State management: Riverpod (TBD)
- Keep platform code behind interfaces (Windows first, macOS/Linux later)

## MVP scope
Discovery, pairing, touchpad, keyboard, media, power. Windows server only.

## Roadmap
Phase 0 scaffold (done) → Phase 1 spike (move cursor from phone) → Phase 2 MVP → Phase 3 tests/security → Phase 4 release.