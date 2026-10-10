import '../entities/contacts_page.dart';

abstract interface class ContactsRepository {
  Future<ContactsPage> getContacts({
    required int page,
    required int limit,
    String search = '',
  });
}

/// A transport-independent failure exposed by the repository boundary.
class ContactsFailure implements Exception {
  const ContactsFailure(this.message);
  final String message;
}
