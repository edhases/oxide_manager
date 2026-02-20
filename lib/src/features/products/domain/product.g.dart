// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  iconUrl: json['iconUrl'] as String,
  channels: (json['channels'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  repoOwner: json['repoOwner'] as String,
  repoName: json['repoName'] as String,
  executableName: json['executableName'] as String?,
  packageFamilyName: json['packageFamilyName'] as String?,
  androidPackageName: json['androidPackageName'] as String?,
  installedTag: json['installedTag'] as String? ?? null,
  latestTag: json['latestTag'] as String? ?? null,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'iconUrl': instance.iconUrl,
  'channels': instance.channels,
  'repoOwner': instance.repoOwner,
  'repoName': instance.repoName,
  'executableName': instance.executableName,
  'packageFamilyName': instance.packageFamilyName,
  'androidPackageName': instance.androidPackageName,
  'installedTag': instance.installedTag,
  'latestTag': instance.latestTag,
};
