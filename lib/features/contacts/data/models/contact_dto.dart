import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/contact.dart';

part 'contact_dto.freezed.dart';
part 'contact_dto.g.dart';

@freezed
abstract class ContactDto with _$ContactDto {
  const ContactDto._();
  const factory ContactDto({
    @Default('') String id,
    @Default('') String name,
    @Default('') String phone,
  }) = _ContactDto;
  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);
  Contact toDomain() => Contact(id: id, name: name, phone: phone);
}
