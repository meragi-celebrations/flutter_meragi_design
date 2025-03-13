abstract class AppDimension {
  const AppDimension({
    required this.radius,
    required this.padding,
    required this.stroke,
    required this.inputHeight,
  });

  final double radius;
  final double padding;
  final double stroke;
  final double inputHeight;
}

class MDDefaultDimension implements AppDimension {
  const MDDefaultDimension({
    this.radius = 10.0,
    this.padding = 15.0,
    this.stroke = 1.0,
    this.inputHeight = 42.0,
  });

  @override
  final double radius;
  @override
  final double padding;
  @override
  final double stroke;
  @override
  final double inputHeight;

  MDDefaultDimension copyWith({
    double? radius,
    double? padding,
    double? stroke,
    double? inputHeight,
  }) {
    return MDDefaultDimension(
      radius: radius ?? this.radius,
      padding: padding ?? this.padding,
      stroke: stroke ?? this.stroke,
      inputHeight: inputHeight ?? this.inputHeight,
    );
  }

  MDDefaultDimension merge(MDDefaultDimension other) {
    return MDDefaultDimension(
      radius: other.radius != 15.0 ? other.radius : radius,
      padding: other.padding != 20.0 ? other.padding : padding,
      stroke: other.stroke != 1.0 ? other.stroke : stroke,
      inputHeight: other.inputHeight != 48.0 ? other.inputHeight : inputHeight,
    );
  }
}
