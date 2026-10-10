import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/core/theme/theme_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/domain/entities/contact.dart';
import 'package:rocket_phone_contact/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/pages/contacts_page.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/widgets/contact_tile.dart';

import '../../support/controlled_repository.dart';

void main() {
  late ControlledRepository repository;

  Future<void> pumpScreen(WidgetTester tester) async {
    repository = ControlledRepository();
    final theme = ThemeCubit();
    addTearDown(theme.close);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: theme),
          BlocProvider(
            create: (_) =>
                ContactsCubit(GetContactsUseCase(repository))..loadContacts(),
          ),
        ],
        child: const MaterialApp(home: ContactsScreen()),
      ),
    );
  }

  List<Contact> people(int count) => [
    for (var i = 0; i < count; i++)
      Contact(id: '$i', name: 'Contact $i', phone: '+42190000$i'),
  ];

  testWidgets('loading indicator is announced to assistive tech', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpScreen(tester);
    expect(find.bySemanticsLabel('Loading contacts'), findsOneWidget);
    expect(find.text('Finding your people…'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('renders one tile per contact and an end-of-list marker', (
    tester,
  ) async {
    await pumpScreen(tester);
    repository.requests.single.succeed(contacts: people(3));
    await tester.pumpAndSettle();
    expect(find.byType(ContactTile), findsNWidgets(3));
    expect(find.text('You’re all caught up'), findsOneWidget);
    expect(repository.requests, hasLength(1));
  });

  testWidgets('rapid typing is debounced into a single request', (
    tester,
  ) async {
    await pumpScreen(tester);
    repository.requests.single.succeed();
    await tester.pumpAndSettle();
    for (final query in ['a', 'an', 'ann', 'anna']) {
      await tester.enterText(find.byType(TextField), query);
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(repository.requests, hasLength(1));
    await tester.pump(ContactsCubit.debounceDuration);
    expect(repository.requests, hasLength(2));
    expect(repository.requests.last.search, 'anna');
    expect(repository.requests.last.page, 1);
  });

  testWidgets('failed refresh keeps contacts and offers an inline retry', (
    tester,
  ) async {
    await pumpScreen(tester);
    repository.requests.single.succeed(contacts: people(2));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 350));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(repository.requests, hasLength(2));
    repository.requests.last.fail();
    await tester.pumpAndSettle();

    expect(find.text('Contact 0'), findsOneWidget);
    expect(find.text('Please try again.'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Retry'));
    await tester.pump();
    expect(repository.requests, hasLength(3));
    repository.requests.last.succeed(contacts: people(4));
    await tester.pumpAndSettle();
    expect(find.text('Please try again.'), findsNothing);
    expect(find.byType(ContactTile), findsNWidgets(4));
  });

  testWidgets('pagination keeps going until the last page', (tester) async {
    await pumpScreen(tester);
    repository.requests.single.succeed(
      contacts: people(20),
      hasMore: true,
      total: 25,
    );
    await tester.pumpAndSettle();
    expect(find.text('You’re all caught up'), findsNothing);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
    await tester.pump();
    expect(repository.requests.last.page, 2);
    repository.requests.last.succeed(
      contacts: [
        for (var i = 20; i < 25; i++)
          Contact(id: '$i', name: 'Contact $i', phone: '+1'),
      ],
      total: 25,
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(find.text('Contact 24'), findsOneWidget);
    expect(find.text('You’re all caught up'), findsOneWidget);
    expect(repository.requests, hasLength(2));
  });
}
