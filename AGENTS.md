# Repository Guidelines

## Project Structure & Module Organization
This repository is a Flutter mobile app (`verto_chat`). Core application code is in `lib/`.
- `lib/features/`: feature-first modules (`auth`, `chats`, `home`, `profile`, etc.) with presentation/domain/data layers where applicable.
- `lib/core/` and `lib/common/`: shared infrastructure, utilities, and cross-feature components.
- `lib/router/`: navigation and route configuration.
- `lib/i18n/` and `lib/gen/`: localization sources and generated code.
- `assets/`: icons/images and static resources.
- `test/`: automated tests (currently minimal; expand with new features).
- Platform folders: `android/` and `ios/`.

## Build, Test, and Development Commands
Run commands from repository root.
- `flutter pub get`: install dependencies.
- `flutter run`: start app on connected emulator/device.
- `flutter analyze lib/features/core lib/features/media lib/features/billing`: static analysis for key modules.
- `flutter test`: run unit/widget tests.
- `dart run build_runner build --delete-conflicting-outputs`: regenerate `*.g.dart`, `*.freezed.dart`, and other generated files.
- `dart run slang`: regenerate localization outputs from `lib/i18n/*.i18n.json`.
- `npx @openapitools/openapi-generator-cli generate ...`: regenerate API client (see `README.md` for full command).

## Coding Style & Naming Conventions
- Follow `analysis_options.yaml` (`flutter_lints`) with strict inference/casts/raw types.
- Prefer `const` constructors and relative imports.
- Use 2-space indentation and format with `dart format .` before commit.
- Naming: files in `snake_case.dart`, classes/types in `PascalCase`, members in `camelCase`.
- Keep generated files out of manual edits (`*.g.dart`, `*.freezed.dart`, `*.gen.dart`).

## Testing Guidelines
- Framework: `flutter_test`.
- Place tests under `test/` mirroring source paths when possible.
- Test filenames: `<unit>_test.dart` (example: `chat_repository_test.dart`).
- Add widget tests for UI behavior changes and unit tests for business logic.
- Run `flutter test` and targeted `flutter analyze` before opening a PR.

## Commit & Pull Request Guidelines
- Use Conventional Commit style seen in history: `feat: ...` (also apply `fix:`, `chore:`, `refactor:` as needed).
- Keep commits focused and atomic; include regenerated artifacts when source changes require them.
- PRs should include:
  - concise description of behavior changes,
  - linked issue/task,
  - screenshots/video for UI updates,
  - validation notes (commands run: analyze/test/build_runner/slang).
