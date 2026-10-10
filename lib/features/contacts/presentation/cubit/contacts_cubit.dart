import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/contacts_repository.dart';
import '../../domain/usecases/get_contacts_usecase.dart';
import 'contacts_state.dart';

@injectable
class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit(this._getContacts) : super(const ContactsState());
  final GetContactsUseCase _getContacts;
  static const pageSize = 20;
  static const debounceDuration = Duration(milliseconds: 400);
  Timer? _debounce;
  int _requestId = 0;
  int? _inFlightFirstPageId;
  Future<void>? _inFlightFirstPage;

  Future<void> loadContacts() => _loadFirstPage();

  void onSearchQueryChanged(String value) {
    final query = value.trim();
    if (isClosed || query == state.query) return;
    _debounce?.cancel();
    ++_requestId;
    emit(ContactsState(query: query, status: ContactsStatus.loading));
    _debounce = Timer(debounceDuration, _loadFirstPage);
  }

  Future<void> refreshContacts() => _loadFirstPage(refresh: true);
  Future<void> retryInitialLoad() => _loadFirstPage();

  Future<void> _loadFirstPage({bool refresh = false}) {
    if (isClosed) return Future.value();
    if (_inFlightFirstPageId == _requestId) return _inFlightFirstPage!;
    _debounce?.cancel();
    final requestId = ++_requestId;
    _inFlightFirstPageId = requestId;
    return _inFlightFirstPage = _performFirstPageFetch(
      requestId,
      refresh: refresh,
    );
  }

  Future<void> _performFirstPageFetch(
    int requestId, {
    required bool refresh,
  }) async {
    final query = state.query;
    final keepContacts = refresh && state.contacts.isNotEmpty;
    emit(
      keepContacts
          ? state.copyWith(
              isRefreshing: true,
              isLoadingMore: false,
              error: null,
              paginationError: null,
            )
          : ContactsState(query: query, status: ContactsStatus.loading),
    );
    try {
      final result = await _getContacts(
        page: 1,
        limit: pageSize,
        search: query,
      );
      if (!_isLatestRequest(requestId)) return;
      emit(
        ContactsState(
          status: ContactsStatus.success,
          query: query,
          contacts: result.contacts,
          page: result.page,
          total: result.total,
          hasMore: result.hasMore,
        ),
      );
    } catch (error) {
      if (!_isLatestRequest(requestId)) return;
      emit(
        state.copyWith(
          status: keepContacts
              ? ContactsStatus.success
              : ContactsStatus.failure,
          isRefreshing: false,
          error: _errorMessageFor(error),
        ),
      );
    } finally {
      if (_inFlightFirstPageId == requestId) _inFlightFirstPageId = null;
    }
  }

  Future<void> loadNextPage() => _loadNextPage();
  Future<void> retryNextPage() => _loadNextPage(retry: true);

  Future<void> _loadNextPage({bool retry = false}) async {
    if (isClosed ||
        state.status != ContactsStatus.success ||
        !state.hasMore ||
        state.isLoadingMore ||
        state.isRefreshing ||
        (state.paginationError != null && !retry)) {
      return;
    }
    final requestId = _requestId;
    final nextPage = state.page + 1;
    emit(state.copyWith(isLoadingMore: true, paginationError: null));
    try {
      final result = await _getContacts(
        page: nextPage,
        limit: pageSize,
        search: state.query,
      );
      if (!_isLatestRequest(requestId)) return;
      final byId = {for (final contact in state.contacts) contact.id: contact};
      for (final contact in result.contacts) {
        byId[contact.id] = contact;
      }
      emit(
        state.copyWith(
          contacts: byId.values.toList(),
          page: result.page,
          total: result.total,
          hasMore: result.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      if (!_isLatestRequest(requestId)) return;
      emit(
        state.copyWith(
          isLoadingMore: false,
          paginationError: _errorMessageFor(error),
        ),
      );
    }
  }

  bool _isLatestRequest(int requestId) => !isClosed && requestId == _requestId;
  String _errorMessageFor(Object error) => error is ContactsFailure
      ? error.message
      : 'Unable to load contacts. Please try again.';

  @override
  Future<void> close() {
    _debounce?.cancel();
    ++_requestId;
    return super.close();
  }
}
