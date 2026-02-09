// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Release _$ReleaseFromJson(Map<String, dynamic> json) => _Release(
  tag: json['tag_name'] as String,
  name: json['name'] as String?,
  publishedAt: DateTime.parse(json['published_at'] as String),
  assets: (json['assets'] as List<dynamic>)
      .map((e) => ReleaseAsset.fromJson(e as Map<String, dynamic>))
      .toList(),
  body: json['body'] as String?,
);

Map<String, dynamic> _$ReleaseToJson(_Release instance) => <String, dynamic>{
  'tag_name': instance.tag,
  'name': instance.name,
  'published_at': instance.publishedAt.toIso8601String(),
  'assets': instance.assets,
  'body': instance.body,
};

_ReleaseAsset _$ReleaseAssetFromJson(Map<String, dynamic> json) =>
    _ReleaseAsset(
      name: json['name'] as String,
      downloadUrl: json['browser_download_url'] as String,
      size: (json['size'] as num).toInt(),
      contentType: json['content_type'] as String?,
    );

Map<String, dynamic> _$ReleaseAssetToJson(_ReleaseAsset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'browser_download_url': instance.downloadUrl,
      'size': instance.size,
      'content_type': instance.contentType,
    };
