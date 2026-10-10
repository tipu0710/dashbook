import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/core/app.dart';
import 'package:rocket_phone_contact/core/theme/app_theme.dart';
import 'package:rocket_phone_contact/core/theme/theme_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/domain/entities/contact.dart';
import 'package:rocket_phone_contact/features/contacts/domain/usecases/get_contacts_usecase.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/cubit/contacts_cubit.dart';

import 'support/controlled_repository.dart';

void main() {
  late ControlledRepository repository;
  late ThemeCubit theme;

  Future<void> launch(WidgetTester tester, {AppPalette? palette}) async {
    repository = ControlledRepository();
    theme = ThemeCubit();
    await tester.pumpWidget(
      BlocProvider.value(
        value: theme,
        child: ContactsApp(
          createContactsCubit: () =>
              ContactsCubit(GetContactsUseCase(repository)),
          palette: palette ?? AppPalette.monochrome(),
        ),
      ),
    );
    addTearDown(theme.close);
  }

  testWidgets('shows loading, initial error, retry and contacts', (
    tester,
  ) async {
    await launch(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.requests.last.fail();
    await tester.pumpAndSettle();
    expect(find.text('Couldn’t load contacts'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    expect(find.text('Person 1'), findsOneWidget);
  });

  testWidgets('search shows empty state and clear restores all contacts', (
    tester,
  ) async {
    await launch(tester);
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nobody');
    await tester.pump();
    expect(find.text('Person 1'), findsNothing);
    await tester.pump(const Duration(milliseconds: 400));
    repository.requests.last.succeed(contacts: []);
    await tester.pumpAndSettle();
    expect(find.text('No contacts found'), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Clear search'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(repository.requests.last.search, isEmpty);
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    expect(find.text('Person 1'), findsOneWidget);
  });

  testWidgets('scroll paginates, retains contacts on error, and retries', (
    tester,
  ) async {
    await launch(tester);
    repository.requests.last.succeed(
      contacts: List.generate(
        20,
        (i) => Contact(id: '$i', name: 'Contact $i', phone: '+123'),
      ),
      hasMore: true,
      total: 30,
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -2000));
    await tester.pump();
    expect(repository.requests.last.page, 2);
    repository.requests.last.fail();
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Retry loading more'), findsOneWidget);
    expect(find.text('Contact 19'), findsOneWidget);
    await tester.tap(find.text('Retry loading more'));
    await tester.pump();
    expect(repository.requests, hasLength(3));
    repository.requests.last.succeed(
      contacts: [const Contact(id: '20', name: 'Last person', phone: '+123')],
      total: 21,
    );
    await tester.pumpAndSettle();
    expect(find.text('Last person'), findsOneWidget);
  });

  testWidgets('pull-to-refresh works with an empty list', (tester) async {
    await launch(tester);
    repository.requests.last.succeed(contacts: []);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 350));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(repository.requests, hasLength(2));
    expect(repository.requests.last.page, 1);
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    expect(find.text('Person 1'), findsOneWidget);
  });

  testWidgets('appearance menu changes the inherited theme', (tester) async {
    await launch(tester);
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Change appearance'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<ThemeMode>, 'Dark'),
    );
    await tester.pumpAndSettle();
    expect(theme.state, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(TextField))).brightness,
      Brightness.dark,
    );
    await tester.tap(find.byTooltip('Change appearance'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<ThemeMode>, 'Light'),
    );
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(TextField))).brightness,
      Brightness.light,
    );
  });

  testWidgets('custom parent color scheme flows into descendant widgets', (
    tester,
  ) async {
    final light = ColorScheme.fromSeed(seedColor: Colors.blue);
    await launch(
      tester,
      palette: AppPalette(
        light: light,
        dark: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
    );
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(TextField))).colorScheme.primary,
      light.primary,
    );
  });

  testWidgets('small display and large text remain usable', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await launch(tester);
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
    await tester.pumpAndSettle();
    expect(find.text('Person 1'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('landscape with an open keyboard scrolls without overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(640, 320);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 150);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await launch(tester);
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'Alex');
    await tester.pump(const Duration(milliseconds: 400));
    repository.requests.last.succeed();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
