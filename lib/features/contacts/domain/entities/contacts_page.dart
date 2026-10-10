import 'package:freezed_annotation/freezed_annotation.dart';

import 'contact.dart';

part 'contacts_page.freezed.dart';

@freezed
abstract class ContactsPage with _$ContactsPage {
  const factory ContactsPage({
    required List<Contact> contacts,
    required int page,
    required int total,
    required bool hasMore,
  }) = _ContactsPage;
}
