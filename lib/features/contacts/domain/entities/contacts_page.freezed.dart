// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contacts_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactsPage {

 List<Contact> get contacts; int get page; int get total; bool get hasMore;
/// Create a copy of ContactsPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactsPageCopyWith<ContactsPage> get copyWith => _$ContactsPageCopyWithImpl<ContactsPage>(this as ContactsPage, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ContactsPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactsPage&&const DeepCollectionEquality().equals(other.contacts, _this.contacts)&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore));
}


@override
int get hashCode {
  final _this = this as ContactsPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.contacts),_this.page,_this.total,_this.hasMore);
}

@override
String toString() {
  final _this = this as ContactsPage;
  return 'ContactsPage(contacts: ${_this.contacts}, page: ${_this.page}, total: ${_this.total}, hasMore: ${_this.hasMore})';
}


}

/// @nodoc
abstract mixin class $ContactsPageCopyWith<$Res>  {
  factory $ContactsPageCopyWith(ContactsPage value, $Res Function(ContactsPage) _then) = _$ContactsPageCopyWithImpl;
@useResult
$Res call({
 List<Contact> contacts, int page, int total, bool hasMore
});




}
/// @nodoc
class _$ContactsPageCopyWithImpl<$Res>
    implements $ContactsPageCopyWith<$Res> {
  _$ContactsPageCopyWithImpl(this._self, this._then);

  final ContactsPage _self;
  final $Res Function(ContactsPage) _then;

/// Create a copy of ContactsPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contacts = null,Object? page = null,Object? total = null,Object? hasMore = null,}) {
  return _then(ContactsPage(
contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<Contact>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactsPage].
extension ContactsPagePatterns on ContactsPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactsPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactsPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactsPage value)  $default,){
final _that = this;
switch (_that) {
case _ContactsPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactsPage value)?  $default,){
final _that = this;
switch (_that) {
case _ContactsPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Contact> contacts,  int page,  int total,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactsPage() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Contact> contacts,  int page,  int total,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _ContactsPage():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Contact> contacts,  int page,  int total,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _ContactsPage() when $default != null:
return $default(_that.contacts,_that.page,_that.total,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc


class _ContactsPage implements ContactsPage {
  const _ContactsPage({required  List<Contact> contacts, required this.page, required this.total, required this.hasMore}): _contacts = contacts;
  

 final  List<Contact> _contacts;
@override List<Contact> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}

@override final  int page;
@override final  int total;
@override final  bool hasMore;

/// Create a copy of ContactsPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactsPageCopyWith<_ContactsPage> get copyWith => __$ContactsPageCopyWithImpl<_ContactsPage>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactsPage&&const DeepCollectionEquality().equals(other.contacts, _contacts)&&(identical(other.page, page) || other.page == page)&&(identical(other.total, total) || other.total == total)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_contacts),page,total,hasMore);
}

@override
String toString() {
    return 'ContactsPage(contacts: $contacts, page: $page, total: $total, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$ContactsPageCopyWith<$Res> implements $ContactsPageCopyWith<$Res> {
  factory _$ContactsPageCopyWith(_ContactsPage value, $Res Function(_ContactsPage) _then) = __$ContactsPageCopyWithImpl;
@override @useResult
$Res call({
 List<Contact> contacts, int page, int total, bool hasMore
});




}
/// @nodoc
class __$ContactsPageCopyWithImpl<$Res>
    implements _$ContactsPageCopyWith<$Res> {
  __$ContactsPageCopyWithImpl(this._self, this._then);

  final _ContactsPage _self;
  final $Res Function(_ContactsPage) _then;

/// Create a copy of ContactsPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contacts = null,Object? page = null,Object? total = null,Object? hasMore = null,}) {
  return _then(_ContactsPage(
contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<Contact>,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
