import 'package:injectable/injectable.dart';

import '../entities/contacts_page.dart';
import '../repositories/contacts_repository.dart';

@injectable
class GetContactsUseCase {
  const GetContactsUseCase(this._repository);
  final ContactsRepository _repository;

  Future<ContactsPage> call({
    required int page,
    required int limit,
    String search = '',
  }) {
    if (page < 1 || limit < 1) {
      throw ArgumentError('Page and limit must be positive.');
    }
    return _repository.getContacts(
      page: page,
      limit: limit,
      search: search.trim(),
    );
  }
}
