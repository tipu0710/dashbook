// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactsResponseDto {

 List<ContactDto> get contacts; int get page; int get total; bool get hasMore;
/// Create a copy of ContactsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactsResponseDtoCopyWith<ContactsResponseDto> get copyWith => _$ContactsResponseDtoCopyWithImpl<ContactsResponseDto>(this as ContactsResponseDto, _$identity);

  /// Serializes this ContactsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContactsResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsResponseDto&&const DeepCollectionEquality().equals(other.contacts, _this.contacts)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContactsResponseDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.contacts),_this.page,_this.total,_this.hasMore);
}

@override
String toString() {
  final _this = this as ContactsResponseDto;
  return 'ContactsResponseDto(contacts: ${_this.contacts}, page: ${_this.page}, total: ${_this.total}, hasMore: ${_this.hasMore})';
}


}

/// @nodoc
abstract mixin class $ContactsResponseDtoCopyWith<$Res>  {
  factory $ContactsResponseDtoCopyWith(ContactsResponseDto value, $Res Function(ContactsResponseDto) _then) = _$ContactsResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<ContactDto> contacts, int page, int total, bool hasMore
});




}
/// @nodoc
class _$ContactsResponseDtoCopyWithImpl<$Res>
    implements $ContactsResponseDtoCopyWith<$Res> {
  _$ContactsResponseDtoCopyWithImpl(this._self, this._then);

  final ContactsResponseDto _self;
  final $Res Function(ContactsResponseDto) _then;

/// Create a copy of ContactsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contacts = null,Object? page = null,Object? total = null,Object? hasMore = null,}) {
  return _then(ContactsResponseDto(
contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ContactDto>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactsResponseDto].
extension ContactsResponseDtoPatterns on ContactsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ContactsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ContactsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ContactDto> contacts,  int page,  int total,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactsResponseDto() when $default != null:
return $default(_that.contacts,_that.page,_that.total,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ContactDto> contacts,  int page,  int total,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _ContactsResponseDto():
return $default(_that.contacts,_that.page,_that.total,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ContactDto> contacts,  int page,  int total,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _ContactsResponseDto() when $default != null:
return $default(_that.contacts,_that.page,_that.total,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ContactsResponseDto extends ContactsResponseDto {
  const _ContactsResponseDto({ List<ContactDto> contacts = const [], this.page = 1, this.total = 1, this.hasMore = false}): _contacts = contacts,super._();
  factory _ContactsResponseDto.fromJson(Map<String, dynamic> json) => _$ContactsResponseDtoFromJson(json);

 final  List<ContactDto> _contacts;
@override@JsonKey() List<ContactDto> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

@override@JsonKey() final  int page;
@override@JsonKey() final  int total;
@override@JsonKey() final  bool hasMore;

/// Create a copy of ContactsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactsResponseDtoCopyWith<_ContactsResponseDto> get copyWith => __$ContactsResponseDtoCopyWithImpl<_ContactsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactsResponseDto&&const DeepCollectionEquality().equals(other.contacts, _contacts)&&(identical(other.page, page) || other.page == page)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_contacts),page,total,hasMore);
}

@override
String toString() {
    return 'ContactsResponseDto(contacts: $contacts, page: $page, total: $total, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ContactsResponseDtoCopyWith<$Res> implements $ContactsResponseDtoCopyWith<$Res> {
  factory _$ContactsResponseDtoCopyWith(_ContactsResponseDto value, $Res Function(_ContactsResponseDto) _then) = __$ContactsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<ContactDto> contacts, int page, int total, bool hasMore
});




}
/// @nodoc
class __$ContactsResponseDtoCopyWithImpl<$Res>
    implements _$ContactsResponseDtoCopyWith<$Res> {
  __$ContactsResponseDtoCopyWithImpl(this._self, this._then);

  final _ContactsResponseDto _self;
  final $Res Function(_ContactsResponseDto) _then;

/// Create a copy of ContactsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contacts = null,Object? page = null,Object? total = null,Object? hasMore = null,}) {
  return _then(_ContactsResponseDto(
contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ContactDto>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
