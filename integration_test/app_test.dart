import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rocket_phone_contact/core/app.dart';
import 'package:rocket_phone_contact/core/di/injection.dart';
import 'package:rocket_phone_contact/core/theme/app_theme.dart';
import 'package:rocket_phone_contact/core/theme/theme_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/data/datasources/contacts_data_source.dart';
import 'package:rocket_phone_contact/features/contacts/data/datasources/mock_contacts_data_source.dart';
import 'package:rocket_phone_contact/features/contacts/data/models/contacts_response_dto.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/cubit/contacts_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/pages/contacts_page.dart';
import 'package:rocket_phone_contact/main.dart' as app;

class RecordingDataSource implements ContactsDataSource {
  RecordingDataSource({int failOnceOnPage = 0})
    : _delegate = MockContactsDataSource(
        loadJson: () => rootBundle.loadString('assets/data/contacts.json'),
        latency: const Duration(milliseconds: 300),
        failOnceOnPage: failOnceOnPage,
      );
  final MockContactsDataSource _delegate;
  final requests = <({int page, String search})>[];

  @override
  Future<ContactsResponseDto> getContacts({
    required int page,
    required int limit,
    required String search,
  }) {
    requests.add((page: page, search: search));
    return _delegate.getContacts(page: page, limit: limit, search: search);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() => getIt.reset());

  final list = find.byType(CustomScrollView);
  final listScrollable = find
      .descendant(of: list, matching: find.byType(Scrollable))
      .first;

  /// Mirrors `main()` but swaps in [source] before anything resolves it.
  Future<void> launchWith(
    WidgetTester tester,
    ContactsDataSource source,
  ) async {
    configureDependencies();
    getIt
      ..unregister<ContactsDataSource>()
      ..registerLazySingleton<ContactsDataSource>(() => source);
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => getIt<ThemeCubit>(),
        child: ContactsApp(
          createContactsCubit: () => getIt<ContactsCubit>(),
          palette: AppPalette.monochrome(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  ContactsCubit cubitOf(WidgetTester tester) =>
      tester.element(find.byType(ContactsScreen)).read<ContactsCubit>();

  Future<void> scrollToEnd(WidgetTester tester) async {
    await tester.fling(list, const Offset(0, -3000), 3000);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Andrew Johnson'),
      300,
      scrollable: listScrollable,
    );
    await tester.pumpAndSettle();
  }

  Future<void> search(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    // Settles once the debounce fires and the loading spinner goes away.
    await tester.pumpAndSettle();
  }

  testWidgets('full journey: browse, paginate, search, clear, change theme', (
    tester,
  ) async {
    app.main();
    await tester.pump();
    expect(find.text('Finding your people…'), findsOneWidget);
    await tester.pumpAndSettle();

    // First page from the bundled dataset.
    expect(find.text('Your people.'), findsOneWidget);
    expect(find.text('Alexander Smith'), findsOneWidget);
    expect(cubitOf(tester).state.contacts, hasLength(20));
    expect(cubitOf(tester).state.hasMore, isTrue);

    // Infinite scroll loads the remaining 10 without duplicates.
    await scrollToEnd(tester);
    expect(find.text('You’re all caught up'), findsOneWidget);
    final all = cubitOf(tester).state.contacts;
    expect(all, hasLength(30));
    expect(all.map((c) => c.id).toSet(), hasLength(30));

    // Name search, case-insensitive.
    await tester.drag(list, const Offset(0, 3000));
    await tester.pumpAndSettle();
    await search(tester, 'ALEX');
    expect(cubitOf(tester).state.contacts.map((c) => c.name), [
      'Alexander Smith',
      'Alexander Ivanov',
      'Alex Johnson',
      'Alexander Wilson',
      'Alex Brown',
    ]);
    expect(find.text('Anna Petrova'), findsNothing);

    // Phone search ignores formatting characters.
    await search(tester, '930 123');
    expect(find.text('Andrew Johnson'), findsOneWidget);
    expect(cubitOf(tester).state.contacts, hasLength(1));

    // No results, then recover via the empty-state action.
    await search(tester, 'zzzz');
    expect(find.text('No contacts found'), findsOneWidget);
    expect(find.text('Try a different name or phone number.'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Alexander Smith'), findsOneWidget);
    expect(cubitOf(tester).state.query, isEmpty);
    expect(cubitOf(tester).state.contacts, hasLength(20));

    // Search again and clear via the field's clear icon.
    await search(tester, 'Emma');
    expect(cubitOf(tester).state.contacts, hasLength(2));
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(cubitOf(tester).state.contacts, hasLength(20));

    // Appearance switch flows through the whole tree.
    await tester.tap(find.byTooltip('Change appearance'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<ThemeMode>, 'Dark'),
    );
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Alexander Smith'))).brightness,
      Brightness.dark,
    );
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
  });

  testWidgets('initial load failure recovers with "Try again"', (tester) async {
    final source = RecordingDataSource(failOnceOnPage: 1);
    await launchWith(tester, source);

    expect(find.text('Couldn’t load contacts'), findsOneWidget);
    expect(
      find.text('We couldn’t load your contacts. Please try again.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text('Alexander Smith'), findsOneWidget);
    expect(source.requests, hasLength(2));
  });

  testWidgets('next-page failure keeps loaded contacts and retries', (
    tester,
  ) async {
    final source = RecordingDataSource(failOnceOnPage: 2);
    await launchWith(tester, source);

    await tester.fling(list, const Offset(0, -3000), 3000);
    await tester.pumpAndSettle();
    final retry = find.text('Retry loading more');
    await tester.scrollUntilVisible(retry, 300, scrollable: listScrollable);
    expect(cubitOf(tester).state.contacts, hasLength(20));
    expect(find.text('Charlotte Young'), findsOneWidget);

    await tester.tap(retry);
    await tester.pumpAndSettle();
    await scrollToEnd(tester);
    expect(find.text('You’re all caught up'), findsOneWidget);
    expect(cubitOf(tester).state.contacts, hasLength(30));
    expect(source.requests.map((r) => r.page), [1, 2, 2]);
  });

  testWidgets('pull-to-refresh refetches the first page', (tester) async {
    final source = RecordingDataSource();
    await launchWith(tester, source);
    expect(source.requests, hasLength(1));

    await tester.fling(list, const Offset(0, 500), 1500);
    await tester.pumpAndSettle();
    expect(source.requests, hasLength(2));
    expect(source.requests.last.page, 1);
    expect(find.text('Alexander Smith'), findsOneWidget);
  });
}
