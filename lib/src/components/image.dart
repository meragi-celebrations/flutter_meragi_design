import 'package:easy_image_viewer/easy_image_viewer.dart';
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
    this.preview = true,
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

  /// Whether to show a zoomable preview of the image when clicked.
  ///
  /// When [preview] is `true`, clicking on the image will show a preview of
  /// the image in a dialog.
  ///
  /// Defaults to `true`.
  final bool preview;

  @override
  Widget build(BuildContext context) {
    String formatterUrl = "$src?format=$format";
    String urlForPreview = formatterUrl;
    if (width != null) {
      formatterUrl = "$formatterUrl&width=$width";
    }
    if (height != null) {
      formatterUrl = "$formatterUrl&height=$height";
    }
    return MouseRegion(
      cursor: preview ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () {
          if (preview) {
            showImageViewer(
              context,
              Image.network(urlForPreview).image,
              useSafeArea: true,
              swipeDismissible: false,
              doubleTapZoomable: true,
              backgroundColor: Colors.black54.withOpacity(.7),
            );
          }
        },
        child: Image.network(
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
        ),
      ),
    );
  }
}
