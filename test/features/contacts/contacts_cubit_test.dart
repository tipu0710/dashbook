import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/features/contacts/domain/entities/contact.dart';
import 'package:rocket_phone_contact/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/cubit/contacts_state.dart';

import '../../support/controlled_repository.dart';

void main() {
  late ControlledRepository repository;
  late ContactsCubit cubit;
  setUp(() {
    repository = ControlledRepository();
    cubit = ContactsCubit(GetContactsUseCase(repository));
  });
  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
  });

  test(
    'loads first page and prevents duplicate simultaneous initial requests',
    () async {
      final loading = cubit.loadContacts();
      cubit.loadContacts();
      expect(cubit.state.status, ContactsStatus.loading);
      expect(repository.requests, hasLength(1));
      repository.requests.single.succeed(hasMore: true, total: 30);
      await loading;
      expect(cubit.state.status, ContactsStatus.success);
      expect(cubit.state.total, 30);
      expect(cubit.state.hasMore, isTrue);
    },
  );

  test('debounces keystrokes and sends only the final query', () {
    fakeAsync((clock) {
      for (final query in ['a', 'al', 'ale', 'alex']) {
        cubit.onSearchQueryChanged(query);
        clock.elapse(const Duration(milliseconds: 100));
      }
      expect(repository.requests, isEmpty);
      clock.elapse(const Duration(milliseconds: 300));
      expect(repository.requests, hasLength(1));
      expect(repository.requests.single.search, 'alex');
      repository.requests.single.succeed();
      clock.flushMicrotasks();
      expect(cubit.state.status, ContactsStatus.success);
    });
  });

  test('ignores whitespace-only changes to the query', () {
    fakeAsync((clock) {
      cubit.loadContacts();
      repository.requests.single.succeed();
      clock.flushMicrotasks();
      final loaded = cubit.state;

      cubit.onSearchQueryChanged('   ');
      clock.elapse(ContactsCubit.debounceDuration);
      expect(cubit.state, loaded);
      expect(repository.requests, hasLength(1));

      cubit.onSearchQueryChanged('al');
      clock.elapse(ContactsCubit.debounceDuration);
      repository.requests.last.succeed();
      clock.flushMicrotasks();
      cubit.onSearchQueryChanged('al ');
      clock.elapse(ContactsCubit.debounceDuration);
      expect(repository.requests, hasLength(2));
      expect(cubit.state.status, ContactsStatus.success);
    });
  });

  test(
    'clears old contacts immediately and ignores a response during debounce',
    () {
      fakeAsync((clock) {
        cubit.loadContacts();
        repository.requests.last.succeed(hasMore: true);
        clock.flushMicrotasks();
        cubit.loadNextPage();
        cubit.onSearchQueryChanged('new');
        expect(cubit.state.contacts, isEmpty);
        expect(cubit.state.page, 0);
        repository.requests.last.succeed();
        clock.flushMicrotasks();
        expect(cubit.state.contacts, isEmpty);
        clock.elapse(ContactsCubit.debounceDuration);
        expect(repository.requests.last.page, 1);
        repository.requests.last.succeed();
        clock.flushMicrotasks();
        expect(cubit.state.query, 'new');
      });
    },
  );

  test('late older search cannot overwrite a newer response', () {
    fakeAsync((clock) {
      cubit.onSearchQueryChanged('al');
      clock.elapse(ContactsCubit.debounceDuration);
      cubit.onSearchQueryChanged('alex');
      clock.elapse(ContactsCubit.debounceDuration);
      repository.requests.last.succeed(
        contacts: [const Contact(id: 'new', name: 'Alex', phone: '123')],
      );
      clock.flushMicrotasks();
      repository.requests.first.succeed();
      clock.flushMicrotasks();
      expect(cubit.state.contacts.single.id, 'new');
      expect(cubit.state.query, 'alex');
    });
  });

  test('pagination appends, deduplicates IDs, and stops at the end', () async {
    final first = cubit.loadContacts();
    repository.requests.last.succeed(hasMore: true);
    await first;
    final next = cubit.loadNextPage();
    cubit.loadNextPage();
    expect(repository.requests, hasLength(2));
    repository.requests.last.succeed(
      contacts: [
        const Contact(id: '1', name: 'Updated name', phone: '123'),
        const Contact(id: '2', name: 'Second person', phone: '456'),
      ],
    );
    await next;
    expect(cubit.state.contacts, hasLength(2));
    expect(cubit.state.contacts.first.name, 'Updated name');
    await cubit.loadNextPage();
    expect(repository.requests, hasLength(2));
  });

  test('initial error can be retried', () async {
    final first = cubit.loadContacts();
    repository.requests.last.fail();
    await first;
    expect(cubit.state.status, ContactsStatus.failure);
    final retry = cubit.retryInitialLoad();
    repository.requests.last.succeed();
    await retry;
    expect(cubit.state.status, ContactsStatus.success);
    expect(cubit.state.error, isNull);
  });

  test(
    'pagination error retains contacts and retries the same page explicitly',
    () async {
      final first = cubit.loadContacts();
      repository.requests.last.succeed(hasMore: true);
      await first;
      final next = cubit.loadNextPage();
      repository.requests.last.fail();
      await next;
      expect(cubit.state.contacts, hasLength(1));
      expect(cubit.state.page, 1);
      expect(cubit.state.paginationError, isNotNull);
      await cubit.loadNextPage();
      expect(repository.requests, hasLength(2));
      final retry = cubit.retryNextPage();
      expect(repository.requests.last.page, 2);
      repository.requests.last.succeed();
      await retry;
      expect(cubit.state.contacts, hasLength(2));
      expect(cubit.state.paginationError, isNull);
    },
  );

  test(
    'refresh keeps the query, replaces contacts and ignores pending pagination',
    () {
      fakeAsync((clock) {
        cubit.onSearchQueryChanged('John');
        clock.elapse(ContactsCubit.debounceDuration);
        repository.requests.last.succeed(hasMore: true);
        clock.flushMicrotasks();
        cubit.loadNextPage();
        final stale = repository.requests.last;
        cubit.refreshContacts();
        expect(cubit.state.isRefreshing, isTrue);
        expect(cubit.state.contacts, hasLength(1));
        expect(repository.requests.last.page, 1);
        expect(repository.requests.last.search, 'John');
        repository.requests.last.succeed(contacts: []);
        clock.flushMicrotasks();
        stale.succeed();
        clock.flushMicrotasks();
        expect(cubit.state.contacts, isEmpty);
        expect(cubit.state.page, 1);
        expect(cubit.state.isRefreshing, isFalse);
      });
    },
  );

  test(
    'failed refresh retains the list and exposes a recoverable error',
    () async {
      final first = cubit.loadContacts();
      repository.requests.last.succeed(hasMore: true);
      await first;
      final refresh = cubit.refreshContacts();
      repository.requests.last.fail();
      await refresh;
      expect(cubit.state.contacts, hasLength(1));
      expect(cubit.state.status, ContactsStatus.success);
      expect(cubit.state.error, isNotNull);
      expect(cubit.state.isRefreshing, isFalse);
    },
  );

  test(
    'search during refresh invalidates the refresh and completes normally',
    () {
      fakeAsync((clock) {
        cubit.loadContacts();
        repository.requests.last.succeed();
        clock.flushMicrotasks();
        cubit.refreshContacts();
        final refresh = repository.requests.last;
        cubit.onSearchQueryChanged('Anna');
        clock.elapse(ContactsCubit.debounceDuration);
        repository.requests.last.succeed();
        clock.flushMicrotasks();
        refresh.fail();
        clock.flushMicrotasks();
        expect(cubit.state.query, 'Anna');
        expect(cubit.state.error, isNull);
      });
    },
  );

  test('closing cancels debounce and safely ignores an in-flight request', () {
    fakeAsync((clock) {
      cubit.loadContacts();
      cubit.onSearchQueryChanged('Alex');
      cubit.close();
      repository.requests.first.succeed();
      clock.elapse(const Duration(seconds: 1));
      clock.flushMicrotasks();
      expect(repository.requests, hasLength(1));
    });
  });
}
