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
    this.radius = 15.0,
    this.padding = 20.0,
    this.stroke = 1.0,
    this.inputHeight = 48.0,
  });

  @override
  final double radius;
  @override
  final double padding;
  @override
  final double stroke;
  @override
  final double inputHeight;
}
