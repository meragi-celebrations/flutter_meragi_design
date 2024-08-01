import 'package:flutter/foundation.dart';

enum MeragiPlatform {
  web,
  android,
  ios,
  macos,
  windows,
  linux,
}

bool isPlatform(List<MeragiPlatform> platforms) {
  // Check if any of the provided platforms are enabled
  for (var platform in platforms) {
    switch (platform) {
      case MeragiPlatform.web:
        if (kIsWeb) {
          return true;
        }
        break;
      case MeragiPlatform.android:
        if (defaultTargetPlatform == TargetPlatform.android) {
          return true;
        }
        break;
      case MeragiPlatform.ios:
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          return true;
        }
        break;
      case MeragiPlatform.macos:
        if (defaultTargetPlatform == TargetPlatform.macOS) {
          return true;
        }
        break;
      case MeragiPlatform.windows:
        if (defaultTargetPlatform == TargetPlatform.windows) {
          return true;
        }
        break;
      case MeragiPlatform.linux:
        if (defaultTargetPlatform == TargetPlatform.linux) {
          return true;
        }
        break;
    }
  }
  // If none of the platforms are enabled, return false
  return false;
}
