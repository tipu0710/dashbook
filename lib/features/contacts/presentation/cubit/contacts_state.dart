import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/contact.dart';

part 'contacts_state.freezed.dart';

enum ContactsStatus { initial, loading, success, failure }

@freezed
abstract class ContactsState with _$ContactsState {
  const factory ContactsState({
    @Default(ContactsStatus.initial) ContactsStatus status,
    @Default('') String query,
    @Default(<Contact>[]) List<Contact> contacts,
    @Default(0) int page,
    @Default(0) int total,
    @Default(false) bool hasMore,
    @Default(false) bool isLoadingMore,
    @Default(false) bool isRefreshing,
    String? error,
    String? paginationError,
  }) = _ContactsState;
}
