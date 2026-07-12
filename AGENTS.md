# AGENTS.md

## Project Snapshot
- Flutter app with Firebase-backed auth and chat onboarding UI.
- App entrypoint is `lib/main.dart`: initializes DI (`configureDependencies()`), then Firebase (`DefaultFirebaseOptions.currentPlatform`), then starts `MaterialApp.router`.
- Routing is centralized in `lib/core/routes/routes.dart` using `go_router` route constants from `lib/core/routes/app_routes_names.dart`.

## Architecture You Should Follow
- Keep shared infrastructure in `lib/core/*` (routes, DI, theme, constants, validators, reusable widgets, error/result types).
- Keep feature code under `lib/features/<feature>/{data,domain,presentation}` where available.
- Auth example split: data in `features/auth/data/*`, domain in `features/auth/domain/*`, presentation in `features/auth/presentation/*`.
- Typical auth flow: page -> `AuthCubit` -> use case -> `AuthRepo` -> remote datasource -> Firebase Auth/Firestore.
- Repo returns `Result<T>` (`Success` / `FailureResult`) from `lib/core/error/result.dart`; keep this pattern for new async domain operations.

## Dependency Injection Pattern
- DI bootstrap lives in `lib/core/di/injection_container.dart`.
- Registrations are generated into `lib/core/di/injection_container.config.dart`; do not hand-edit generated file.
- Firebase instances are provided by `lib/core/services/firebase_module.dart` (`@module`, `@lazySingleton`).
- After adding injectable classes/constructors, run: `dart run build_runner build --delete-conflicting-outputs`.

## UI/State/Routing Conventions
- State management is `flutter_bloc` (Cubit). Example: `AuthCubit` emits loading/success/error states for each auth action.
- Use centralized design tokens/styles from `lib/core/theme/*` and `lib/core/constants/*` instead of inline styling.
- Use `ScreenUtilInit` sizing assumptions from `main.dart` (`designSize: Size(430, 932)`) when adding responsive UI.
- Route by constants in `AppRouteNames`; define route constant and router entry together to avoid drift.

## Firebase and External Integrations
- Firebase startup config is generated in `lib/firebase_options.dart`.
- Android Firebase wiring exists in `android/app/google-services.json` and Gradle plugin setup.
- Auth datasource uses `FirebaseAuth`, `GoogleSignIn` (`GoogleAuthProvider.credential`), and Firestore writes to `users` in `saveUser()`.

## Developer Workflows
- Install deps: `flutter pub get`
- Run app: `flutter run`
- Static analysis: `flutter analyze`
- Tests: `flutter test`
- Regenerate splash assets after editing `flutter_native_splash.yaml`: `dart run flutter_native_splash:create`.

## Known Codebase Caveats (Check Before Extending)
- `getUser` is unimplemented in both `lib/features/auth/data/datasource/auth_remote_data_source_impl.dart` and `lib/features/auth/data/repositories/auth_repo_impl.dart`.
- `AppRouteNames.completeProfile` exists but has no matching `GoRoute` in `lib/core/routes/routes.dart`.
- DI generated config currently expects `GoogleSignIn` and `SignInWithGoogleUseCase`; if DI fails, verify injectable annotations/constructors and regenerate.
