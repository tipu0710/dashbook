import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/widgets/contacts_placeholder.dart';

void main() {
  Future<void> pumpPlaceholder(WidgetTester tester, {Widget? action}) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ContactsPlaceholder(
              icon: Icons.cloud_off_outlined,
              title: 'Couldn’t load contacts',
              message: 'Please try again.',
              action: action,
            ),
          ),
        ),
      );

  testWidgets('shows icon, title and message', (tester) async {
    await pumpPlaceholder(tester);
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    expect(find.text('Couldn’t load contacts'), findsOneWidget);
    expect(find.text('Please try again.'), findsOneWidget);
    expect(find.byType(ButtonStyleButton), findsNothing);
  });

  testWidgets('renders a tappable action when provided', (tester) async {
    var taps = 0;
    await pumpPlaceholder(
      tester,
      action: FilledButton(onPressed: () => taps++, child: const Text('Go')),
    );
    await tester.tap(find.text('Go'));
    expect(taps, 1);
  });
}
