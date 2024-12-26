import 'dart:async';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

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

  /// Does not work on web;
  final bool gaplessPlayback;
  final FilterQuality filterQuality;
  final bool isAntiAlias;
  final Map<String, String>? headers;
  final int? cacheWidth;
  final int? cacheHeight;
  final Widget Function(BuildContext context, Widget child, ImageChunkEvent? loadingProgress, bool? isLoading)?
      loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final String? semanticLabel;
  final bool excludeFromSemantics;

  /// In web, the [frames] is null when loading and 1 when it has loaded.
  /// For other platforms it works as intended
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
    return MDGestureDetector(
      isDisabled: !preview,
      onTap: () {
        showImageViewer(
          context,
          Image.network(urlForPreview).image,
          useSafeArea: true,
          swipeDismissible: false,
          doubleTapZoomable: true,
          backgroundColor: Colors.black54.withOpacity(.7),
        );
      },
      child: kIsWeb
          ? MDImage(
              imageProvider: NetworkImage(formatterUrl),
              scale: scale,
              width: width,
              height: height,
              color: color,
              opacity: opacity,
              colorBlendMode: colorBlendMode,
              fit: fit,
              repeat: repeat,
              centerSlice: centerSlice,
              matchTextDirection: matchTextDirection,
              filterQuality: filterQuality,
              isAntiAlias: isAntiAlias,
              loadingBuilder: loadingBuilder ??
                  (context, child, loadingProgress, isLoading) {
                    return isLoading!
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 200, minWidth: 200),
                            child: const Center(
                                child: MDLoadingIndicator(strokeWidth: 3.5, radius: 40, color: Color(0xFFFF5F68))),
                          )
                        : child;
                  },
              errorBuilder: errorBuilder,
              frameBuilder: frameBuilder,
            )
          : Image.network(
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
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingBuilder != null) {
                  loadingBuilder!.call(context, child, loadingProgress, null);
                }
                if (loadingProgress == null) {
                  return child;
                }
                return ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 200, minWidth: 200),
                  child: Center(
                      child: MDLoadingIndicator(
                          strokeWidth: 3.5,
                          radius: 40,
                          color: const Color(0xFFFF5F68),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null)),
                );
              },
              errorBuilder: errorBuilder,
              semanticLabel: semanticLabel,
              excludeFromSemantics: excludeFromSemantics,
              frameBuilder: frameBuilder,
            ),
    );
  }
}

class MDZoomableImage extends StatelessWidget {
  final Widget image;

  const MDZoomableImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return EasyImageView.imageWidget(
      image,
      doubleTapZoomable: true,
    );
  }
}

class MDImage extends StatefulWidget {
  const MDImage({
    super.key,
    required this.imageProvider,
    this.scale,
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
    this.filterQuality = FilterQuality.medium,
    this.isAntiAlias = false,
    this.loadingBuilder,
    this.errorBuilder,
    this.frameBuilder,
  });

  final ImageProvider imageProvider;
  final double? width;
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final Rect? centerSlice;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final FilterQuality filterQuality;
  final bool isAntiAlias;

  /// ```isLoading``` is used only for flutter web, for other platforms it will always be null. You can use the ```loadingProgress``` instead.
  ///
  ///  ```loadingProgress``` will always be null for flutter web canvas.
  /// You can use the ```isLoading``` instead in flutter web
  final Widget Function(BuildContext context, Widget child, ImageChunkEvent? loadingProgress, bool? isLoading)?
      loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;
  final double? scale;
  final ImageFrameBuilder? frameBuilder;

  @override
  State<MDImage> createState() => _MDImageState();
}

class _MDImageState extends State<MDImage> {
  ImageStream? _imageStream;
  final completer = Completer<(ImageInfo, bool)>();

  void _updateOnImage(ImageInfo info, bool synchronousCall) {
    if (!completer.isCompleted) {
      completer.complete((info, synchronousCall));
    }
  }

  void _errorImage(Object exception, StackTrace? stackTrace) {
    completer.completeError(exception, stackTrace);
  }

  Future<(ImageInfo, bool)> getImage() async {
    final oldStream = _imageStream;
    var newStream = widget.imageProvider.resolve(createLocalImageConfiguration(context));
    if (oldStream?.key != newStream.key) {
      final listener = ImageStreamListener(_updateOnImage, onError: _errorImage);
      oldStream?.removeListener(listener);
      newStream.addListener(listener);
      _imageStream = newStream;
    }
    return completer.future;
  }

  @override
  void dispose() {
    _imageStream?.removeListener(ImageStreamListener(_updateOnImage, onError: _errorImage));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(ImageInfo, bool)>(
        future: getImage(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return widget.errorBuilder?.call(context, snapshot.error!, snapshot.stackTrace) ?? const SizedBox.shrink();
          }
          Widget result = RawImage(
            image: snapshot.data?.$1.image,
            scale: snapshot.data?.$1.scale ?? 1,
            width: widget.width,
            height: widget.height,
            color: widget.color,
            opacity: widget.opacity,
            colorBlendMode: widget.colorBlendMode,
            fit: widget.fit,
            alignment: widget.alignment,
            repeat: widget.repeat,
            centerSlice: widget.centerSlice,
            matchTextDirection: widget.matchTextDirection,
            filterQuality: widget.filterQuality,
            isAntiAlias: widget.isAntiAlias,
          );
          if (widget.loadingBuilder != null) {
            result = widget.loadingBuilder!(
                context, result, null, snapshot.connectionState == ConnectionState.waiting && !completer.isCompleted);
          }
          if (widget.frameBuilder != null) {
            result = widget.frameBuilder!(
                context,
                result,
                snapshot.connectionState == ConnectionState.waiting && !completer.isCompleted ? null : 1,
                snapshot.hasData ? snapshot.data!.$2 : false);
          }
          return result;
        });
  }
}
