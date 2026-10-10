// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactDto _$ContactDtoFromJson(Map<String, dynamic> json) => _ContactDto(
  id: json['id'] as String? ?? "",
  name: json['name'] as String? ?? "",
  phone: json['phone'] as String? ?? "",
);

Map<String, dynamic> _$ContactDtoToJson(_ContactDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };
