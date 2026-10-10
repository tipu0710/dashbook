import 'dart:async';

import 'package:rocket_phone_contact/features/contacts/domain/entities/contact.dart';
import 'package:rocket_phone_contact/features/contacts/domain/entities/contacts_page.dart';
import 'package:rocket_phone_contact/features/contacts/domain/repositories/contacts_repository.dart';

class PendingRequest {
  PendingRequest(this.page, this.search);
  final int page;
  final String search;
  final completer = Completer<ContactsPage>();

  void succeed({List<Contact>? contacts, bool hasMore = false, int? total}) {
    final items =
        contacts ??
        [Contact(id: '$page', name: 'Person $page', phone: '+421901234567')];
    completer.complete(
      ContactsPage(
        contacts: items,
        page: page,
        total: total ?? items.length,
        hasMore: hasMore,
      ),
    );
  }

  void fail() =>
      completer.completeError(const ContactsFailure('Please try again.'));
}

class ControlledRepository implements ContactsRepository {
  final requests = <PendingRequest>[];
  @override
  Future<ContactsPage> getContacts({
    required int page,
    required int limit,
    String search = '',
  }) {
    final request = PendingRequest(page, search);
    requests.add(request);
    return request.completer.future;
  }
}
