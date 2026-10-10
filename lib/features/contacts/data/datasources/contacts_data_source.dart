import '../models/contacts_response_dto.dart';

abstract interface class ContactsDataSource {
  Future<ContactsResponseDto> getContacts({
    required int page,
    required int limit,
    required String search,
  });
}

class ContactsApiException implements Exception {
  const ContactsApiException();
}
