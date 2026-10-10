// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactDto {

 String get id; String get name; String get phone;
/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactDtoCopyWith<ContactDto> get copyWith => _$ContactDtoCopyWithImpl<ContactDto>(this as ContactDto, _$identity);

  /// Serializes this ContactDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContactDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContactDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone);
}

@override
String toString() {
  final _this = this as ContactDto;
  return 'ContactDto(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone})';
}


}

/// @nodoc
abstract mixin class $ContactDtoCopyWith<$Res>  {
  factory $ContactDtoCopyWith(ContactDto value, $Res Function(ContactDto) _then) = _$ContactDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone
});




}
/// @nodoc
class _$ContactDtoCopyWithImpl<$Res>
    implements $ContactDtoCopyWith<$Res> {
  _$ContactDtoCopyWithImpl(this._self, this._then);

  final ContactDto _self;
  final $Res Function(ContactDto) _then;

/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,}) {
  return _then(ContactDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactDto].
extension ContactDtoPatterns on ContactDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactDto value)  $default,){
final _that = this;
switch (_that) {
case _ContactDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactDto value)?  $default,){
final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
return $default(_that.id,_that.name,_that.phone);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone)  $default,) {final _that = this;
switch (_that) {
case _ContactDto():
return $default(_that.id,_that.name,_that.phone);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone)?  $default,) {final _that = this;
switch (_that) {
case _ContactDto() when $default != null:
return $default(_that.id,_that.name,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContactDto extends ContactDto {
  const _ContactDto({this.id = "", this.name = "", this.phone = ""}): super._();
  factory _ContactDto.fromJson(Map<String, dynamic> json) => _$ContactDtoFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  String phone;

/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactDtoCopyWith<_ContactDto> get copyWith => __$ContactDtoCopyWithImpl<_ContactDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone);
}

@override
String toString() {
    return 'ContactDto(id: $id, name: $name, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ContactDtoCopyWith<$Res> implements $ContactDtoCopyWith<$Res> {
  factory _$ContactDtoCopyWith(_ContactDto value, $Res Function(_ContactDto) _then) = __$ContactDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone
});




}
/// @nodoc
class __$ContactDtoCopyWithImpl<$Res>
    implements _$ContactDtoCopyWith<$Res> {
  __$ContactDtoCopyWithImpl(this._self, this._then);

  final _ContactDto _self;
  final $Res Function(_ContactDto) _then;

/// Create a copy of ContactDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,}) {
  return _then(_ContactDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
