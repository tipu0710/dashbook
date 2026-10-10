// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contacts_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactsResponseDto _$ContactsResponseDtoFromJson(Map<String, dynamic> json) =>
    _ContactsResponseDto(
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => ContactDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      page: (json['page'] as num?)?.toInt() ?? 1,
      total: (json['total'] as num?)?.toInt() ?? 1,
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$ContactsResponseDtoToJson(
  _ContactsResponseDto instance,
) => <String, dynamic>{
  'contacts': instance.contacts.map((e) => e.toJson()).toList(),
  'page': instance.page,
  'total': instance.total,
  'hasMore': instance.hasMore,
};
