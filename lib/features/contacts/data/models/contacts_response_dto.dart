import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/contacts_page.dart';
import 'contact_dto.dart';

part 'contacts_response_dto.freezed.dart';
part 'contacts_response_dto.g.dart';

@freezed
abstract class ContactsResponseDto with _$ContactsResponseDto {
  const ContactsResponseDto._();
  @JsonSerializable(explicitToJson: true)
  const factory ContactsResponseDto({
    @Default([]) List<ContactDto> contacts,
    @Default(1) int page,
    @Default(1) int total,
    @Default(false) bool hasMore,
  }) = _ContactsResponseDto;
  factory ContactsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ContactsResponseDtoFromJson(json);
  ContactsPage toDomain() => ContactsPage(
    contacts: contacts.map((item) => item.toDomain()).toList(),
    page: page,
    total: total,
    hasMore: hasMore,
  );
}
