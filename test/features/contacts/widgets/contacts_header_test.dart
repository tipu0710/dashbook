import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/core/theme/theme_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/domain/entities/contact.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/cubit/contacts_state.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/widgets/contacts_header.dart';

void main() {
  const contact = Contact(id: '1', name: 'Anna Petrova', phone: '+421');
  late List<String> searches;
  late int clears;
  late int refreshes;

  Future<void> pumpHeader(WidgetTester tester, ContactsState state) async {
    searches = [];
    clears = 0;
    refreshes = 0;
    final theme = ThemeCubit();
    final controller = TextEditingController();
    addTearDown(theme.close);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      BlocProvider.value(
        value: theme,
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ContactsHeader(
                state: state,
                searchController: controller,
                onSearchChanged: searches.add,
                onClearSearch: () => clears++,
                onRefresh: () async => refreshes++,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows branding, copy, search field and theme menu', (
    tester,
  ) async {
    await pumpHeader(tester, const ContactsState());
    expect(find.text('ROCKET / CONTACTS'), findsOneWidget);
    expect(find.text('Your people.'), findsOneWidget);
    expect(find.text('A little closer, with a quick search.'), findsOneWidget);
    expect(find.text('Search by name or phone'), findsOneWidget);
    expect(find.byTooltip('Change appearance'), findsOneWidget);
  });

  testWidgets('typing forwards every change to onSearchChanged', (
    tester,
  ) async {
    await pumpHeader(tester, const ContactsState());
    await tester.enterText(find.byType(TextField), 'An');
    await tester.enterText(find.byType(TextField), 'Ann');
    expect(searches, ['An', 'Ann']);
  });

  testWidgets('clear button is hidden for an empty query', (tester) async {
    await pumpHeader(tester, const ContactsState());
    expect(find.byTooltip('Clear search'), findsNothing);
  });

  testWidgets('clear button appears for a query and calls onClearSearch', (
    tester,
  ) async {
    await pumpHeader(tester, const ContactsState(query: 'Ann'));
    await tester.tap(find.byTooltip('Clear search'));
    expect(clears, 1);
  });

  testWidgets('refresh error banner shows over retained contacts', (
    tester,
  ) async {
    await pumpHeader(
      tester,
      const ContactsState(
        status: ContactsStatus.success,
        contacts: [contact],
        error: 'Refresh failed.',
      ),
    );
    expect(find.text('Refresh failed.'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Retry'));
    expect(refreshes, 1);
  });

  testWidgets('no banner when the error has no contacts to sit above', (
    tester,
  ) async {
    await pumpHeader(
      tester,
      const ContactsState(status: ContactsStatus.failure, error: 'Boom.'),
    );
    expect(find.text('Boom.'), findsNothing);
    expect(find.text('Retry'), findsNothing);
  });
}
