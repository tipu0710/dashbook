import 'package:injectable/injectable.dart';

import '../../domain/entities/contacts_page.dart';
import '../../domain/repositories/contacts_repository.dart';
import '../datasources/contacts_data_source.dart';

@LazySingleton(as: ContactsRepository)
class ContactsRepositoryImpl implements ContactsRepository {
  const ContactsRepositoryImpl(this._source);
  final ContactsDataSource _source;

  @override
  Future<ContactsPage> getContacts({
    required int page,
    required int limit,
    String search = '',
  }) async {
    try {
      return (await _source.getContacts(
        page: page,
        limit: limit,
        search: search,
      )).toDomain();
    } on ContactsApiException {
      throw const ContactsFailure(
        'We couldn’t load your contacts. Please try again.',
      );
    } on Exception {
      throw const ContactsFailure(
        'Something went wrong while loading contacts. Please try again.',
      );
    }
  }
}
