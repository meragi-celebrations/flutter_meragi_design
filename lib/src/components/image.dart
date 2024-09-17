import 'package:flutter/material.dart';

class MDNetworkImage extends StatelessWidget {
  // Constructor takes all the parameters of Image.network
  const MDNetworkImage({
    super.key,
    required this.src,
    this.scale = 1.0,
    this.format = "webp",
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.headers,
    this.cacheWidth,
    this.cacheHeight,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.frameBuilder,
  });

  final String src;
  final String? format;
  final double scale;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final FilterQuality filterQuality;
  final bool isAntiAlias;
  final Map<String, String>? headers;
  final int? cacheWidth;
  final int? cacheHeight;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final ImageFrameBuilder? frameBuilder;

  @override
  Widget build(BuildContext context) {
    String formatterUrl = "$src?format=$format";
    if (width != null) {
      formatterUrl = "$formatterUrl&width=$width";
    }
    if (height != null) {
      formatterUrl = "$formatterUrl&height=$height";
    }
    return Image.network(
      formatterUrl,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      headers: headers,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      frameBuilder: frameBuilder,
    );
  }
}
