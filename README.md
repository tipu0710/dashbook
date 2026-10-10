# Rocket Contacts

A Flutter implementation of the supplied Contacts Search assignment. Includes all 30 supplied contacts, debounced name/phone search, pagination, refresh, recoverable errors, and monochrome light/dark themes.

## Run

Built with **Flutter 3.47.7 stable / Dart 3.13.5**. Use this SDK or a compatible newer stable release (Freezed 4 requires Dart 3.13).

```sh
flutter pub get
flutter run
```

Select an Android or iOS device/emulator. No backend, account, network access, or contacts permission is required. Generated Dart files and the dependency lockfile are included.

After changing Freezed models or Injectable registrations:

```sh
dart run build_runner build
```

## State management and architecture

### Why Cubit over Riverpod?

**Cubit**, from the Bloc ecosystem, was chosen because this app's main complexity is coordinating closely related state transitions on one screen:

- Search clears the previous results and resets pagination.
- Pagination appends results while preserving loaded contacts on failure.
- Refresh replaces results and invalidates pending pagination.
- Older requests must not overwrite results for a newer search query.

Cubit expresses these actions through explicit methods and keeps their coordination in one independently testable controller. The UI renders immutable state, while tests exercise the controller through an injected repository. `flutter_bloc` connects the UI to Cubit; GetIt and generated Injectable registrations compose dependencies at the application boundary.

**Riverpod would also be a sound choice.** Its built-in dependency injection and asynchronous providers could reduce wiring, and a Notifier could hold the same coordinated state and actions. Cubit was preferred here for the direct method-based interface and explicit state transitions; this behavior does not require a graph of dependent providers.

The tradeoff is additional setup through GetIt, Injectable, and generated registrations. Cubit also does **not** automatically prevent request races: the generation counter and request guards in `ContactsCubit` provide that protection. The choice reflects how this implementation organizes the app's behavior, rather than an inherent advantage in correctness, performance, or suitability for senior-level work.

### Feature-first clean architecture

```text
lib/
  app/
    di/                 GetIt + Injectable composition
    theme/              Parent palette, ThemeData factory, appearance Cubit
  features/contacts/
    domain/             Freezed entities, repository contract, GetContacts use case
    data/               Freezed JSON DTOs, mock API, repository implementation
    presentation/       Cubit, immutable state, screen and reusable widgets
```

The dependency flow is **UI → Cubit → use case → repository contract**. The data layer implements that contract and maps API DTOs into domain entities. Data and domain models use Freezed and JSON serialization as requested. Replace the `ContactsDataSource` registration with a REST implementation to connect a backend without changing the UI or Cubit. The domain has no dependency on Flutter widgets or the mock source.

## Behavior and edge cases

- Mock requests take a randomly chosen 500, 700 or 1000 ms, so overlapping requests can finish out of order. Search is case-insensitive, trims whitespace, and also matches formatted phone numbers. Filtering happens before pagination; pages contain up to 20 contacts.
- Search debounces for 400 ms and immediately clears old results. A generation counter invalidates old work as soon as the query changes, including during the debounce window.
- First-page requests are coalesced while active. Next-page requests are guarded, deduplicated by contact ID, and stop when `hasMore` is false. A viewport that is taller than a page automatically requests more.
- Pagination errors retain existing contacts and require an explicit retry of the failed page.
- Refresh reloads page one for the current query and invalidates pending pagination. Existing contacts remain visible during refresh and on refresh failure. A successful refresh replaces the list.
- Empty and error views support pull-to-refresh. A refresh button also works with a mouse or keyboard.
- Disposal cancels debounce and prevents pending responses from emitting state. This is logical cancellation; the simulated network delay itself continues.
- The appearance menu offers system, light, and dark modes. System is the default; a manual choice lasts for the app session.

## Reproduce errors

Normal runs do not fail. Use a `--dart-define` (or the matching VS Code launch configuration in `.vscode/launch.json`) to exercise error states.

```sh
# Initial error, followed by successful retry
flutter run --dart-define=MOCK_FAIL_PAGE=1

# Scroll down to see a pagination error, then retry
flutter run --dart-define=MOCK_FAIL_PAGE=2

# Any request fails with the given probability (0–100), e.g. 30%
flutter run --dart-define=MOCK_FAILURE_PERCENT=30
```

`MOCK_FAIL_PAGE` fails **once per app launch**, then retries succeed.

Hot restart or restart the app to reset the failure. For an empty state, search for `Nobody here`; search `alex` for five matching contacts.

## Theming

`ContactsApp` receives an `AppPalette` with parent light and dark `ColorScheme`s. `AppTheme.fromScheme` builds component themes; widgets obtain colors using `Theme.of(context)`. To introduce a different brand, pass a different palette from `main.dart`. Feature widgets have no hardcoded colors.

## Verify

```sh
flutter analyze
flutter test
flutter build ios --simulator
```

Tests cover repository filtering/pagination/serialization, debounce, out-of-order responses, duplicate requests, retries, refresh races, disposal, UI states, scrolling, pull-to-refresh, theme inheritance, and large text.

## With another 2–3 hours

Add a cancellable HTTP adapter with typed transport failures, persist the theme preference, and add device-level integration tests plus light/dark screenshot baselines. For a real service, also define its ordering and pagination consistency guarantees. Offline caching should follow explicit freshness requirements rather than silently presenting stale results.
