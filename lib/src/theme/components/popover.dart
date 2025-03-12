import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

@immutable
class MDPopoverTheme {
  const MDPopoverTheme({
    this.merge = true,
    this.effects,
    this.shadows,
    this.padding,
    this.decoration,
    this.anchor,
    this.filter,
  });

  final bool merge;

  /// {@macro popover.effects}
  final List<Effect<dynamic>>? effects;

  /// {@macro popover.shadows}
  final List<BoxShadow>? shadows;

  /// {@macro popover.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro popover.decoration}
  final MDDecoration? decoration;

  /// {@macro popover.anchor}
  final MDAnchorBase? anchor;

  /// {@macro popover.filter}
  final ImageFilter? filter;

  static MDPopoverTheme lerp(
    MDPopoverTheme a,
    MDPopoverTheme b,
    double t,
  ) {
    if (identical(a, b)) return a;
    return MDPopoverTheme(
      merge: b.merge,
      effects: t < 0.5 ? a.effects : b.effects,
      shadows: t < 0.5 ? a.shadows : b.shadows,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      decoration: MDDecoration.lerp(a.decoration, b.decoration, t),
      anchor: t < 0.5 ? a.anchor : b.anchor,
      filter: t < 0.5 ? a.filter : b.filter,
    );
  }

  MDPopoverTheme copyWith({
    bool? merge,
    Duration? waitDuration,
    Duration? showDuration,
    List<Effect<dynamic>>? effects,
    List<BoxShadow>? shadows,
    EdgeInsetsGeometry? padding,
    MDDecoration? decoration,
    MDAnchorBase? anchor,
    ImageFilter? filter,
  }) {
    return MDPopoverTheme(
      merge: merge ?? this.merge,
      effects: effects ?? this.effects,
      shadows: shadows ?? this.shadows,
      padding: padding ?? this.padding,
      decoration: decoration ?? this.decoration,
      anchor: anchor ?? this.anchor,
      filter: filter ?? this.filter,
    );
  }

  MDPopoverTheme mergeWith(MDPopoverTheme? other) {
    if (other == null) return this;
    if (!other.merge) return other;
    return copyWith(
      effects: other.effects,
      shadows: other.shadows,
      padding: other.padding,
      decoration: decoration?.mergeWith(other.decoration) ?? other.decoration,
      anchor: other.anchor,
      filter: other.filter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MDPopoverTheme &&
        other.merge == merge &&
        listEquals(other.effects, effects) &&
        listEquals(other.shadows, shadows) &&
        other.padding == padding &&
        other.decoration == decoration &&
        other.anchor == anchor &&
        other.filter == filter;
  }

  @override
  int get hashCode {
    return merge.hashCode ^
        effects.hashCode ^
        shadows.hashCode ^
        padding.hashCode ^
        decoration.hashCode ^
        anchor.hashCode ^
        filter.hashCode;
  }
}
