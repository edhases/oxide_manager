// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'release.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Release {

@JsonKey(name: 'tag_name') String get tag; String? get name;@JsonKey(name: 'published_at') DateTime get publishedAt; List<ReleaseAsset> get assets; String? get body;
/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseCopyWith<Release> get copyWith => _$ReleaseCopyWithImpl<Release>(this as Release, _$identity);

  /// Serializes this Release to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Release&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.name, name) || other.name == name)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&const DeepCollectionEquality().equals(other.assets, assets)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,name,publishedAt,const DeepCollectionEquality().hash(assets),body);

@override
String toString() {
  return 'Release(tag: $tag, name: $name, publishedAt: $publishedAt, assets: $assets, body: $body)';
}


}

/// @nodoc
abstract mixin class $ReleaseCopyWith<$Res>  {
  factory $ReleaseCopyWith(Release value, $Res Function(Release) _then) = _$ReleaseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tag_name') String tag, String? name,@JsonKey(name: 'published_at') DateTime publishedAt, List<ReleaseAsset> assets, String? body
});




}
/// @nodoc
class _$ReleaseCopyWithImpl<$Res>
    implements $ReleaseCopyWith<$Res> {
  _$ReleaseCopyWithImpl(this._self, this._then);

  final Release _self;
  final $Res Function(Release) _then;

/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,Object? name = freezed,Object? publishedAt = null,Object? assets = null,Object? body = freezed,}) {
  return _then(_self.copyWith(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<ReleaseAsset>,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Release].
extension ReleasePatterns on Release {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Release value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Release() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Release value)  $default,){
final _that = this;
switch (_that) {
case _Release():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Release value)?  $default,){
final _that = this;
switch (_that) {
case _Release() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_name')  String tag,  String? name, @JsonKey(name: 'published_at')  DateTime publishedAt,  List<ReleaseAsset> assets,  String? body)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Release() when $default != null:
return $default(_that.tag,_that.name,_that.publishedAt,_that.assets,_that.body);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tag_name')  String tag,  String? name, @JsonKey(name: 'published_at')  DateTime publishedAt,  List<ReleaseAsset> assets,  String? body)  $default,) {final _that = this;
switch (_that) {
case _Release():
return $default(_that.tag,_that.name,_that.publishedAt,_that.assets,_that.body);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tag_name')  String tag,  String? name, @JsonKey(name: 'published_at')  DateTime publishedAt,  List<ReleaseAsset> assets,  String? body)?  $default,) {final _that = this;
switch (_that) {
case _Release() when $default != null:
return $default(_that.tag,_that.name,_that.publishedAt,_that.assets,_that.body);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Release implements Release {
  const _Release({@JsonKey(name: 'tag_name') required this.tag, this.name, @JsonKey(name: 'published_at') required this.publishedAt, required final  List<ReleaseAsset> assets, this.body}): _assets = assets;
  factory _Release.fromJson(Map<String, dynamic> json) => _$ReleaseFromJson(json);

@override@JsonKey(name: 'tag_name') final  String tag;
@override final  String? name;
@override@JsonKey(name: 'published_at') final  DateTime publishedAt;
 final  List<ReleaseAsset> _assets;
@override List<ReleaseAsset> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

@override final  String? body;

/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseCopyWith<_Release> get copyWith => __$ReleaseCopyWithImpl<_Release>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReleaseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Release&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.name, name) || other.name == name)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&const DeepCollectionEquality().equals(other._assets, _assets)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tag,name,publishedAt,const DeepCollectionEquality().hash(_assets),body);

@override
String toString() {
  return 'Release(tag: $tag, name: $name, publishedAt: $publishedAt, assets: $assets, body: $body)';
}


}

/// @nodoc
abstract mixin class _$ReleaseCopyWith<$Res> implements $ReleaseCopyWith<$Res> {
  factory _$ReleaseCopyWith(_Release value, $Res Function(_Release) _then) = __$ReleaseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tag_name') String tag, String? name,@JsonKey(name: 'published_at') DateTime publishedAt, List<ReleaseAsset> assets, String? body
});




}
/// @nodoc
class __$ReleaseCopyWithImpl<$Res>
    implements _$ReleaseCopyWith<$Res> {
  __$ReleaseCopyWithImpl(this._self, this._then);

  final _Release _self;
  final $Res Function(_Release) _then;

/// Create a copy of Release
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,Object? name = freezed,Object? publishedAt = null,Object? assets = null,Object? body = freezed,}) {
  return _then(_Release(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<ReleaseAsset>,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReleaseAsset {

 String get name;@JsonKey(name: 'browser_download_url') String get downloadUrl; int get size;@JsonKey(name: 'content_type') String? get contentType;
/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseAssetCopyWith<ReleaseAsset> get copyWith => _$ReleaseAssetCopyWithImpl<ReleaseAsset>(this as ReleaseAsset, _$identity);

  /// Serializes this ReleaseAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReleaseAsset&&(identical(other.name, name) || other.name == name)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.size, size) || other.size == size)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,downloadUrl,size,contentType);

@override
String toString() {
  return 'ReleaseAsset(name: $name, downloadUrl: $downloadUrl, size: $size, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class $ReleaseAssetCopyWith<$Res>  {
  factory $ReleaseAssetCopyWith(ReleaseAsset value, $Res Function(ReleaseAsset) _then) = _$ReleaseAssetCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'browser_download_url') String downloadUrl, int size,@JsonKey(name: 'content_type') String? contentType
});




}
/// @nodoc
class _$ReleaseAssetCopyWithImpl<$Res>
    implements $ReleaseAssetCopyWith<$Res> {
  _$ReleaseAssetCopyWithImpl(this._self, this._then);

  final ReleaseAsset _self;
  final $Res Function(ReleaseAsset) _then;

/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? downloadUrl = null,Object? size = null,Object? contentType = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReleaseAsset].
extension ReleaseAssetPatterns on ReleaseAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReleaseAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReleaseAsset value)  $default,){
final _that = this;
switch (_that) {
case _ReleaseAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReleaseAsset value)?  $default,){
final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'browser_download_url')  String downloadUrl,  int size, @JsonKey(name: 'content_type')  String? contentType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
return $default(_that.name,_that.downloadUrl,_that.size,_that.contentType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name, @JsonKey(name: 'browser_download_url')  String downloadUrl,  int size, @JsonKey(name: 'content_type')  String? contentType)  $default,) {final _that = this;
switch (_that) {
case _ReleaseAsset():
return $default(_that.name,_that.downloadUrl,_that.size,_that.contentType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name, @JsonKey(name: 'browser_download_url')  String downloadUrl,  int size, @JsonKey(name: 'content_type')  String? contentType)?  $default,) {final _that = this;
switch (_that) {
case _ReleaseAsset() when $default != null:
return $default(_that.name,_that.downloadUrl,_that.size,_that.contentType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReleaseAsset implements ReleaseAsset {
  const _ReleaseAsset({required this.name, @JsonKey(name: 'browser_download_url') required this.downloadUrl, required this.size, @JsonKey(name: 'content_type') this.contentType});
  factory _ReleaseAsset.fromJson(Map<String, dynamic> json) => _$ReleaseAssetFromJson(json);

@override final  String name;
@override@JsonKey(name: 'browser_download_url') final  String downloadUrl;
@override final  int size;
@override@JsonKey(name: 'content_type') final  String? contentType;

/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseAssetCopyWith<_ReleaseAsset> get copyWith => __$ReleaseAssetCopyWithImpl<_ReleaseAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReleaseAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReleaseAsset&&(identical(other.name, name) || other.name == name)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.size, size) || other.size == size)&&(identical(other.contentType, contentType) || other.contentType == contentType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,downloadUrl,size,contentType);

@override
String toString() {
  return 'ReleaseAsset(name: $name, downloadUrl: $downloadUrl, size: $size, contentType: $contentType)';
}


}

/// @nodoc
abstract mixin class _$ReleaseAssetCopyWith<$Res> implements $ReleaseAssetCopyWith<$Res> {
  factory _$ReleaseAssetCopyWith(_ReleaseAsset value, $Res Function(_ReleaseAsset) _then) = __$ReleaseAssetCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'browser_download_url') String downloadUrl, int size,@JsonKey(name: 'content_type') String? contentType
});




}
/// @nodoc
class __$ReleaseAssetCopyWithImpl<$Res>
    implements _$ReleaseAssetCopyWith<$Res> {
  __$ReleaseAssetCopyWithImpl(this._self, this._then);

  final _ReleaseAsset _self;
  final $Res Function(_ReleaseAsset) _then;

/// Create a copy of ReleaseAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? downloadUrl = null,Object? size = null,Object? contentType = freezed,}) {
  return _then(_ReleaseAsset(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
