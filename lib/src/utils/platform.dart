import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

enum MeragiPlatform {
  web,
  android,
  ios,
  macos,
  windows,
  linux,
}

int getResponsiveColumnCount(double maxWidth, num min, num max, {num breakpoint = 1200}) {
  if (breakpoint <= 0 || min <= 0 || max < min) {
    throw "kya kar rha h be!";
  }
  return lerpDouble(min, max, (maxWidth / breakpoint).clamp(0, 1))!.toInt();
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

bool isDesktop = isPlatform([MeragiPlatform.linux, MeragiPlatform.windows, MeragiPlatform.macos]);

bool isMobile = isPlatform([MeragiPlatform.android, MeragiPlatform.ios]);

bool isDesktopWeb = kIsWeb && isDesktop;

bool isMobileWeb = kIsWeb && isMobile;

class ScreenUtil {
  BuildContext context;
  final BoxConstraints? constraints;
  ScreenUtil(this.context, {this.constraints});

  bool get isSm => maxWidth < 500; // phone
  bool get isMd => (maxWidth < 800 && maxWidth >= 500); // tablet
  bool get isLg => (maxWidth < 1200 && maxWidth >= 800); // desktop
  bool get isXl => maxWidth >= 1200; // everything

  bool get isSmMd => isSm || isMd;

  double get maxWidth => (constraints?.maxWidth ?? MediaQuery.of(context).size.width);
}
