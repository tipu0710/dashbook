import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rocket_phone_contact/features/contacts/domain/entities/contact.dart';
import 'package:rocket_phone_contact/features/contacts/presentation/widgets/contact_tile.dart';

void main() {
  Future<void> pumpTile(WidgetTester tester, Contact contact) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ContactTile(contact: contact)),
        ),
      );

  testWidgets('shows name, phone and two-letter initials', (tester) async {
    await pumpTile(
      tester,
      const Contact(id: '1', name: 'Alexander Smith', phone: '+421901234567'),
    );
    expect(find.text('Alexander Smith'), findsOneWidget);
    expect(find.text('+421901234567'), findsOneWidget);
    expect(find.text('AS'), findsOneWidget);
  });

  testWidgets('initials ignore extra whitespace and extra name parts', (
    tester,
  ) async {
    await pumpTile(
      tester,
      const Contact(id: '1', name: '  Mary   Ann  Walker ', phone: '+1'),
    );
    expect(find.text('MA'), findsOneWidget);
  });

  testWidgets('single-word name yields a single initial', (tester) async {
    await pumpTile(tester, const Contact(id: '1', name: 'Cher', phone: '+1'));
    expect(find.text('C'), findsOneWidget);
  });

  testWidgets('empty name renders without throwing', (tester) async {
    await pumpTile(tester, const Contact(id: '1', name: '', phone: '+1'));
    expect(tester.takeException(), isNull);
    expect(find.text('+1'), findsOneWidget);
  });

  testWidgets('exposes one merged semantics label', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpTile(
      tester,
      const Contact(id: '1', name: 'Anna Petrova', phone: '+421903456789'),
    );
    expect(
      find.bySemanticsLabel('Anna Petrova, +421903456789'),
      findsOneWidget,
    );
    // Child texts are excluded so screen readers don't announce them twice.
    expect(find.bySemanticsLabel('AP'), findsNothing);
    semantics.dispose();
  });

  testWidgets('avatar grows with text scale up to 1.5x without overflow', (
    tester,
  ) async {
    Future<Size> avatarSizeAt(double scale) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: const Scaffold(
              body: ContactTile(
                contact: Contact(id: '1', name: 'Anna Petrova', phone: '+1'),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      return tester.getSize(
        find.ancestor(of: find.text('AP'), matching: find.byType(Container)),
      );
    }

    expect(await avatarSizeAt(1), const Size(48, 48));
    expect(await avatarSizeAt(1.25), const Size(60, 60));
    expect(await avatarSizeAt(3), const Size(72, 72));
  });
}
