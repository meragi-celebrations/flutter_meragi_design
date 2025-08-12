import 'package:flutter/material.dart';

String buildId() => DateTime.now().microsecondsSinceEpoch.toString();

String colorToHex(Color c) =>
    '#${c.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

Color? hexToColor(String s) {
  try {
    var hex = s.replaceAll('#', '').trim();
    if (hex.length == 6) hex = 'FF$hex';
    final v = int.parse(hex, radix: 16);
    return Color(v);
  } catch (_) {
    return null;
  }
}

Map<String, dynamic>? serializeProvider(ImageProvider provider) {
  if (provider is NetworkImage) return {'type': 'network', 'url': provider.url};
  if (provider is AssetImage) {
    return {
      'type': 'asset',
      'name': provider.assetName,
      if (provider.package != null) 'package': provider.package
    };
  }
  return null;
}

ImageProvider? deserializeProvider(dynamic src) {
  if (src is! Map) return null;
  final type = src['type'];
  switch (type) {
    case 'network':
      final url = src['url'] as String?;
      if (url == null || url.isEmpty) return null;
      return NetworkImage(url);
    case 'asset':
      final name = src['name'] as String?;
      if (name == null || name.isEmpty) return null;
      final pkg = src['package'] as String?;
      return AssetImage(name, package: pkg);
    default:
      return null;
  }
}
