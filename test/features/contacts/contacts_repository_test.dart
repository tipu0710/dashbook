import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/features/contacts/data/datasources/mock_contacts_data_source.dart';
import 'package:rocket_phone_contact/features/contacts/data/models/contacts_response_dto.dart';
import 'package:rocket_phone_contact/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:rocket_phone_contact/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:rocket_phone_contact/features/contacts/domain/usecases/get_contacts_usecase.dart';

void main() {
  MockContactsDataSource createSource({int failPage = 0}) =>
      MockContactsDataSource(
        loadJson: () => File('assets/data/contacts.json').readAsString(),
        latency: Duration.zero,
        failOnceOnPage: failPage,
      );

  ContactsRepositoryImpl create({int failPage = 0}) =>
      ContactsRepositoryImpl(createSource(failPage: failPage));

  test(
    'supplied 30 contacts paginate without overlap or missing entries',
    () async {
      final repository = create();
      final first = await repository.getContacts(page: 1, limit: 20);
      final second = await repository.getContacts(page: 2, limit: 20);
      final third = await repository.getContacts(page: 3, limit: 20);
      expect(first.contacts, hasLength(20));
      expect(second.contacts, hasLength(10));
      expect(first.hasMore, isTrue);
      expect(second.hasMore, isFalse);
      expect(first.total, 30);
      expect({
        ...first.contacts.map((c) => c.id),
        ...second.contacts.map((c) => c.id),
      }, hasLength(30));
      expect(third.contacts, isEmpty);
      expect(first.contacts.first.name, 'Alexander Smith');
      expect(second.contacts.last.phone, '+421930123456');
    },
  );

  test(
    'search is trimmed, case insensitive and applied before pagination',
    () async {
      final repository = create();
      final first = await repository.getContacts(
        page: 1,
        limit: 2,
        search: '  ALEX  ',
      );
      final second = await repository.getContacts(
        page: 2,
        limit: 2,
        search: 'alex',
      );
      expect(first.total, 5);
      expect(first.contacts, hasLength(2));
      expect(second.contacts, hasLength(2));
      expect(
        first.contacts.every((c) => c.name.toLowerCase().contains('alex')),
        isTrue,
      );
    },
  );

  test('formatted phone search and empty results work', () async {
    final repository = create();
    expect(
      (await repository.getContacts(
        page: 1,
        limit: 20,
        search: '+421 901 234 567',
      )).contacts.single.id,
      '1',
    );
    expect(
      (await repository.getContacts(
        page: 1,
        limit: 20,
        search: 'Nobody here',
      )).contacts,
      isEmpty,
    );
  });

  test('blank search returns everything; a bare "+" matches nothing', () async {
    final repository = create();
    expect(
      (await repository.getContacts(page: 1, limit: 20, search: '   ')).total,
      30,
    );
    expect(
      (await repository.getContacts(page: 1, limit: 20, search: '+')).contacts,
      isEmpty,
    );
    expect(
      (await repository.getContacts(
        page: 1,
        limit: 20,
        search: ' + ',
      )).contacts,
      isEmpty,
    );
  });

  test(
    'configured failure is translated and the same request succeeds on retry',
    () async {
      final repository = create(failPage: 2);
      await expectLater(
        repository.getContacts(page: 2, limit: 20),
        throwsA(isA<ContactsFailure>()),
      );
      expect(
        (await repository.getContacts(page: 2, limit: 20)).contacts,
        hasLength(10),
      );
    },
  );

  test(
    'JSON serialization round-trips nested DTOs and maps to domain',
    () async {
      final response = await createSource().getContacts(
        page: 1,
        limit: 2,
        search: '',
      );
      final decoded = ContactsResponseDto.fromJson(
        jsonDecode(jsonEncode(response.toJson())) as Map<String, dynamic>,
      );

      expect(decoded, response);
      expect(decoded.toDomain(), await create().getContacts(page: 1, limit: 2));
    },
  );

  test('default latency is randomly 500, 700 or 1000 ms', () {
    fakeAsync((async) {
      // Failing every request completes right after the delay, before the
      // dataset is parsed, so fake time alone drives the request.
      final source = MockContactsDataSource(
        loadJson: () async => '[]',
        failurePercent: 100,
        random: Random(1),
      );
      final delays = <int>{};
      for (var i = 0; i < 20; i++) {
        var done = false;
        source
            .getContacts(page: 1, limit: 20, search: '')
            .catchError((_) => const ContactsResponseDto())
            .whenComplete(() => done = true);
        var elapsed = 0;
        while (!done) {
          async.elapse(const Duration(milliseconds: 1));
          elapsed++;
        }
        expect(elapsed, isIn([500, 700, 1000]));
        delays.add(elapsed);
      }
      expect(delays.length, greaterThan(1));
    });
  });

  test('failurePercent fails every request at 100 and none at 0', () async {
    MockContactsDataSource withPercent(int percent) => MockContactsDataSource(
      loadJson: () => File('assets/data/contacts.json').readAsString(),
      latency: Duration.zero,
      failurePercent: percent,
    );
    final failing = ContactsRepositoryImpl(withPercent(100));
    for (var i = 0; i < 3; i++) {
      await expectLater(
        failing.getContacts(page: 1, limit: 20),
        throwsA(isA<ContactsFailure>()),
      );
    }
    final healthy = ContactsRepositoryImpl(withPercent(0));
    for (var i = 0; i < 3; i++) {
      expect((await healthy.getContacts(page: 1, limit: 20)).total, 30);
    }
  });

  test('use case rejects invalid pagination', () {
    expect(
      () => GetContactsUseCase(create())(page: 0, limit: 20),
      throwsArgumentError,
    );
    expect(
      () => GetContactsUseCase(create())(page: 1, limit: 0),
      throwsArgumentError,
    );
  });
}
