// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get name; String get description; String get iconUrl; List<String> get channels; String get repoOwner; String get repoName; String? get executableName; String? get packageFamilyName; String? get androidPackageName; String? get installedTag;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&const DeepCollectionEquality().equals(other.channels, channels)&&(identical(other.repoOwner, repoOwner) || other.repoOwner == repoOwner)&&(identical(other.repoName, repoName) || other.repoName == repoName)&&(identical(other.executableName, executableName) || other.executableName == executableName)&&(identical(other.packageFamilyName, packageFamilyName) || other.packageFamilyName == packageFamilyName)&&(identical(other.androidPackageName, androidPackageName) || other.androidPackageName == androidPackageName)&&(identical(other.installedTag, installedTag) || other.installedTag == installedTag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconUrl,const DeepCollectionEquality().hash(channels),repoOwner,repoName,executableName,packageFamilyName,androidPackageName,installedTag);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, iconUrl: $iconUrl, channels: $channels, repoOwner: $repoOwner, repoName: $repoName, executableName: $executableName, packageFamilyName: $packageFamilyName, androidPackageName: $androidPackageName, installedTag: $installedTag)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String iconUrl, List<String> channels, String repoOwner, String repoName, String? executableName, String? packageFamilyName, String? androidPackageName, String? installedTag
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconUrl = null,Object? channels = null,Object? repoOwner = null,Object? repoName = null,Object? executableName = freezed,Object? packageFamilyName = freezed,Object? androidPackageName = freezed,Object? installedTag = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,repoOwner: null == repoOwner ? _self.repoOwner : repoOwner // ignore: cast_nullable_to_non_nullable
as String,repoName: null == repoName ? _self.repoName : repoName // ignore: cast_nullable_to_non_nullable
as String,executableName: freezed == executableName ? _self.executableName : executableName // ignore: cast_nullable_to_non_nullable
as String?,packageFamilyName: freezed == packageFamilyName ? _self.packageFamilyName : packageFamilyName // ignore: cast_nullable_to_non_nullable
as String?,androidPackageName: freezed == androidPackageName ? _self.androidPackageName : androidPackageName // ignore: cast_nullable_to_non_nullable
as String?,installedTag: freezed == installedTag ? _self.installedTag : installedTag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String iconUrl,  List<String> channels,  String repoOwner,  String repoName,  String? executableName,  String? packageFamilyName,  String? androidPackageName,  String? installedTag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconUrl,_that.channels,_that.repoOwner,_that.repoName,_that.executableName,_that.packageFamilyName,_that.androidPackageName,_that.installedTag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String iconUrl,  List<String> channels,  String repoOwner,  String repoName,  String? executableName,  String? packageFamilyName,  String? androidPackageName,  String? installedTag)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.description,_that.iconUrl,_that.channels,_that.repoOwner,_that.repoName,_that.executableName,_that.packageFamilyName,_that.androidPackageName,_that.installedTag);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String iconUrl,  List<String> channels,  String repoOwner,  String repoName,  String? executableName,  String? packageFamilyName,  String? androidPackageName,  String? installedTag)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconUrl,_that.channels,_that.repoOwner,_that.repoName,_that.executableName,_that.packageFamilyName,_that.androidPackageName,_that.installedTag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.name, required this.description, required this.iconUrl, required final  List<String> channels, required this.repoOwner, required this.repoName, this.executableName, this.packageFamilyName, this.androidPackageName, this.installedTag = null}): _channels = channels;
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String iconUrl;
 final  List<String> _channels;
@override List<String> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

@override final  String repoOwner;
@override final  String repoName;
@override final  String? executableName;
@override final  String? packageFamilyName;
@override final  String? androidPackageName;
@override@JsonKey() final  String? installedTag;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&const DeepCollectionEquality().equals(other._channels, _channels)&&(identical(other.repoOwner, repoOwner) || other.repoOwner == repoOwner)&&(identical(other.repoName, repoName) || other.repoName == repoName)&&(identical(other.executableName, executableName) || other.executableName == executableName)&&(identical(other.packageFamilyName, packageFamilyName) || other.packageFamilyName == packageFamilyName)&&(identical(other.androidPackageName, androidPackageName) || other.androidPackageName == androidPackageName)&&(identical(other.installedTag, installedTag) || other.installedTag == installedTag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconUrl,const DeepCollectionEquality().hash(_channels),repoOwner,repoName,executableName,packageFamilyName,androidPackageName,installedTag);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, iconUrl: $iconUrl, channels: $channels, repoOwner: $repoOwner, repoName: $repoName, executableName: $executableName, packageFamilyName: $packageFamilyName, androidPackageName: $androidPackageName, installedTag: $installedTag)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String iconUrl, List<String> channels, String repoOwner, String repoName, String? executableName, String? packageFamilyName, String? androidPackageName, String? installedTag
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconUrl = null,Object? channels = null,Object? repoOwner = null,Object? repoName = null,Object? executableName = freezed,Object? packageFamilyName = freezed,Object? androidPackageName = freezed,Object? installedTag = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,repoOwner: null == repoOwner ? _self.repoOwner : repoOwner // ignore: cast_nullable_to_non_nullable
as String,repoName: null == repoName ? _self.repoName : repoName // ignore: cast_nullable_to_non_nullable
as String,executableName: freezed == executableName ? _self.executableName : executableName // ignore: cast_nullable_to_non_nullable
as String?,packageFamilyName: freezed == packageFamilyName ? _self.packageFamilyName : packageFamilyName // ignore: cast_nullable_to_non_nullable
as String?,androidPackageName: freezed == androidPackageName ? _self.androidPackageName : androidPackageName // ignore: cast_nullable_to_non_nullable
as String?,installedTag: freezed == installedTag ? _self.installedTag : installedTag // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
