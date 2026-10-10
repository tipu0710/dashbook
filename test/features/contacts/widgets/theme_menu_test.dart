import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/core/theme/theme_cubit.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/widgets/theme_menu.dart';

void main() {
  late ThemeCubit cubit;

  Future<void> pumpMenu(WidgetTester tester, {Brightness? brightness}) async {
    cubit = ThemeCubit();
    addTearDown(cubit.close);
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          theme: ThemeData(brightness: brightness ?? Brightness.light),
          home: const Scaffold(body: Center(child: ThemeMenu())),
        ),
      ),
    );
  }

  CheckedPopupMenuItem<ThemeMode> item(WidgetTester tester, String label) =>
      tester.widget(
        find.widgetWithText(CheckedPopupMenuItem<ThemeMode>, label),
      );

  testWidgets('shows a light icon under a light theme', (tester) async {
    await pumpMenu(tester);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
  });

  testWidgets('shows a dark icon under a dark theme', (tester) async {
    await pumpMenu(tester, brightness: Brightness.dark);
    expect(find.byIcon(Icons.dark_mode_outlined), findsOneWidget);
  });

  testWidgets('lists all modes and checks the current one', (tester) async {
    await pumpMenu(tester);
    await tester.tap(find.byTooltip('Change appearance'));
    await tester.pumpAndSettle();
    expect(item(tester, 'Use device setting').checked, isTrue);
    expect(item(tester, 'Light').checked, isFalse);
    expect(item(tester, 'Dark').checked, isFalse);
  });

  testWidgets('selecting a mode updates the cubit and the checkmark', (
    tester,
  ) async {
    await pumpMenu(tester);
    await tester.tap(find.byTooltip('Change appearance'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(CheckedPopupMenuItem<ThemeMode>, 'Dark'),
    );
    await tester.pumpAndSettle();
    expect(cubit.state, ThemeMode.dark);

    await tester.tap(find.byTooltip('Change appearance'));
    await tester.pumpAndSettle();
    expect(item(tester, 'Dark').checked, isTrue);
    expect(item(tester, 'Use device setting').checked, isFalse);
  });
}
