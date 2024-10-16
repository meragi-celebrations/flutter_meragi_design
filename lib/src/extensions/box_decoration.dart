import 'package:flutter/material.dart';

extension BoxDecorationMerge on BoxDecoration {
  /// Merges another [BoxDecoration] into this one.
  ///
  /// If [other] has a non-null value for any of its properties, that value
  /// will be used instead of the corresponding value from this object.
  /// If [other] has a null value for any of its properties, the corresponding
  /// value from this object will be used.
  BoxDecoration merge(BoxDecoration? other) {
    if (other == null) return this;

    return BoxDecoration(
      color: other.color ?? color,
      image: other.image ?? image,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      gradient: other.gradient ?? gradient,
      backgroundBlendMode: other.backgroundBlendMode ?? backgroundBlendMode,
      shape: other.shape,
    );
  }
}
