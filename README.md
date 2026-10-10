# Dashbook

A searchable contacts list with pagination, pull-to-refresh, and loading, empty and error states, backed by a mock API.

## How to run

Built with **Flutter 3.47.7 (stable)** and **Dart 3.13.5**.

```sh
flutter pub get
flutter run
```

Generated files are committed. If you change a Freezed model or an Injectable registration, run `dart run build_runner build`.

### Testing error states

The mock API succeeds by default. To test errors:

```sh
flutter run --dart-define=MOCK_FAIL_PAGE=1          # first page fails once, then Retry works
flutter run --dart-define=MOCK_FAIL_PAGE=2          # next page fails once (scroll down), then Retry works
flutter run --dart-define=MOCK_FAILURE_PERCENT=30   # any request fails 30% of the time
```

Matching launch configurations are in `.vscode/launch.json`. Search `Nobody here` to see the empty state.

### Tests

```sh
flutter test
```

The tests cover the repository (search and pagination), the Cubit (debounce, out-of-order responses, duplicate requests, retries, refresh) and the main screen states.

## State management: Cubit

I chose Cubit (`flutter_bloc`). The hard part of this app is not sharing data between screens. It is coordinating async work on one screen: debounce, pagination, refresh, retry, and ignoring stale responses. That is a state machine, and Cubit is the most direct way to write one:

- **One owner for all transitions.** Each user action is one method (`onSearchQueryChanged`, `loadNextPage`, `refreshContacts`, `retryNextPage`). Every way the state can change is in `ContactsCubit`, so the race rules (request IDs, duplicate guards) sit in one place and can't be bypassed.
- **The state fits a single object.** The screen shows contacts *and* "loading more" *and* a pagination error at the same time. Riverpod's `AsyncValue` models one loading/data/error result, so for this screen I would end up writing a custom state class inside a `Notifier`, which is essentially a Cubit anyway.
- **Easy to test.** The Cubit is a plain Dart class. Tests create it with a fake repository and control time with `fake_async`, with no widget tree or provider container.
- **Explicit over implicit.** Riverpod's strengths (auto-dispose, derived providers, caching per argument) are useful when many widgets share data. Here they would add hidden behaviour without solving a problem this screen has.

### Trade-offs I accepted

- **More setup for dependency injection.** Riverpod has DI built in. With Cubit I use GetIt + Injectable, which adds code generation, and a missing registration fails at runtime instead of at compile time.
- **No built-in caching.** A Riverpod `family` provider could cache results per search query for free. With Cubit, caching would have to be written by hand (it is in the "next steps" list).
- **Manual async control.** Cubit does not cancel or debounce for you. I wrote the debounce timer and the request-ID check myself. A `Bloc` with event transformers could do this declaratively, but for one screen the plain Cubit is simpler to read.
- **More boilerplate** for state classes than a small Riverpod provider would need.

I would pick Riverpod in an app where many screens share and derive the same async data. For one screen with tightly coordinated async state, Cubit is the better fit.

## Architecture

```text
lib/
  core/                 dependency injection (GetIt + Injectable), theme
  features/contacts/
    domain/             Contact entity, repository interface, GetContacts use case
    data/               DTOs, mock data source, repository implementation
    presentation/       ContactsCubit, state, screen and widgets
```

**UI → Cubit → Use case → Repository → Data source**

- The Cubit calls the use case, and the use case calls the `ContactsRepository` interface. Neither knows about the mock.
- `MockContactsDataSource` loads the 30 provided contacts and adds a 500–1000 ms delay. To connect a real REST API, add another `ContactsDataSource` implementation and register it instead. The UI does not change.

## Key behaviour

- **Search** is case-insensitive, matches names and phone numbers, and is debounced by 400 ms. A new query clears the old results and resets pagination.
- **Race conditions:** every request has an ID. A response that arrives after a newer query or refresh is ignored, so it cannot overwrite newer results.
- **Pagination** loads 20 contacts per page when you scroll near the bottom. It ignores duplicate requests and stops when there are no more pages.
- **Pagination errors** keep the loaded contacts on screen and show a retry button.
- **Pull-to-refresh** reloads page 1 for the current query and replaces the list.
- **Disposal:** closing the screen cancels the debounce, and late responses are ignored.

## With another 2–3 hours

- Replace the mock with a real HTTP client that supports request cancellation.
- Add local caching to show previous results while a refresh is loading.
- Add integration tests on a real device.
- Save the selected theme between app launches.
