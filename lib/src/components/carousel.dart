import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/raw_carousel.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CarouselItem {
  final Widget child;
  final Widget? previewChild;
  const CarouselItem({required this.child, this.previewChild});
}

class MDCarousel extends StatelessWidget {
  final List<CarouselItem> children;
  final MDCarouselController? controller;

  final bool showNavButtons;
  final bool showPagination;
  final bool itemSnapping;
  final void Function(int)? onTap;
  final bool preview;
  final ShapeBorder? shape;
  final Widget Function(Widget child)? buildChild;

  const MDCarousel({
    super.key,
    this.controller,
    this.onTap,
    this.shape,
    this.buildChild,
    this.showNavButtons = true,
    this.showPagination = true,
    this.itemSnapping = false,
    this.preview = false,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    MDCarouselController effectiveController = controller ?? MDCarouselController();
    return Stack(
      children: [
        RawCarouselView(
          controller: effectiveController.internalController,
          itemExtent: effectiveController.itemExtent,
          shrinkExtent: effectiveController.itemExtent,
          shape: shape,
          onTap: onTap ??
              (preview
                  ? (index) {
                      showDialog(
                        context: context,
                        builder: (context) => MDCarouselPreview(
                          parentController: effectiveController,
                          initialIndex: index,
                          children: children,
                        ),
                      );
                    }
                  : null),
          itemSnapping: itemSnapping,
          buildChild: buildChild,
          children: children.map((e) => e.child).toList(),
        ),
        if (showNavButtons)
          Positioned.fill(
            child: ValueListenableBuilder(
                valueListenable: effectiveController.currentIndex,
                builder: (context, currentIndex, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (currentIndex != 0)
                          ? MDButton(
                              onTap: () {
                                effectiveController.previousPage();
                              },
                              decoration: ButtonDecoration(
                                context: context,
                                variant: ButtonVariant.outline,
                                type: ButtonType.primary,
                              ),
                              icon: PhosphorIconsRegular.caretLeft,
                            )
                          : const SizedBox(),
                      (currentIndex != children.length - 1)
                          ? MDButton(
                              onTap: () {
                                effectiveController.nextPage();
                              },
                              decoration: ButtonDecoration(
                                context: context,
                                variant: ButtonVariant.outline,
                                type: ButtonType.primary,
                              ),
                              icon: PhosphorIconsRegular.caretRight,
                            )
                          : const SizedBox(),
                    ],
                  );
                }),
          ),
        if (showPagination)
          Align(
            alignment: Alignment.bottomCenter,
            child: SlidePagination(
              length: children.length,
              effectiveController: effectiveController,
            ),
          )
      ],
    );
  }
}

class MDCarouselPreview extends StatefulWidget {
  const MDCarouselPreview({
    super.key,
    this.initialIndex = 0,
    required this.children,
    required this.parentController,
  });

  final List<CarouselItem> children;
  final MDCarouselController parentController;
  final int initialIndex;

  @override
  State<MDCarouselPreview> createState() => _MDCarouselPreviewState();
}

class _MDCarouselPreviewState extends State<MDCarouselPreview> {
  int _currentIndex = 0;

  late MDCarouselController thumbnailController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    final isWebMobile =
        kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);

    thumbnailController = MDCarouselController(
      initialIndex: widget.initialIndex,
      itemExtent: isWebMobile ? 70 : 100,
    );

    if (!isWebMobile) {
      ServicesBinding.instance.keyboard.addHandler(_handleKeyboardEvent);
    } else {
      PaintingBinding.instance.imageCache.maximumSize = 50;
    }
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_handleKeyboardEvent);

    thumbnailController.dispose();

    final isWebMobile =
        kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    if (isWebMobile) {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    }

    super.dispose();
  }

  bool _handleKeyboardEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (_currentIndex > 0) {
          previewGoTo(_currentIndex - 1);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (_currentIndex < widget.children.length - 1) {
          previewGoTo(_currentIndex + 1);
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 9,
              child: widget.children[_currentIndex].previewChild ?? widget.children[_currentIndex].child,
            ),
            Expanded(
              flex: 1,
              child: MDCarousel(
                controller: thumbnailController,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                showPagination: false,
                buildChild: (child) {
                  int childIndex = widget.children.indexWhere((i) => i.child == child);
                  return Container(
                    decoration: BoxDecoration(
                      border: (_currentIndex == childIndex)
                          ? Border.all(
                              width: 5,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    child: child,
                  );
                },
                onTap: (index) {
                  previewGoTo(index);
                },
                children: widget.children,
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: MDButton(
            decoration: ButtonDecoration(
              context: context,
              variant: ButtonVariant.ghost,
              type: ButtonType.standard,
              size: ButtonSize.lg,
              iconSizeOverride: 30,
            ),
            icon: PhosphorIconsRegular.x,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  void previewGoTo(int index) {
    if (index >= 0 && index < widget.children.length) {
      setState(() {
        _currentIndex = index;
      });
      widget.parentController.goTo(index.toDouble());
    }
  }
}

class SlidePagination extends StatelessWidget {
  const SlidePagination({
    super.key,
    required this.length,
    required this.effectiveController,
  });

  final int length;
  final MDCarouselController effectiveController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black12.withOpacity(.5),
      ),
      child: ValueListenableBuilder(
          valueListenable: effectiveController.currentIndex,
          builder: (context, currentIndex, _) {
            return BodyText(
              text: "${currentIndex + 1}/$length",
              style: const TextStyle(color: Colors.white),
            );
          }),
    );
  }
}

class MDCarouselController {
  final int initialIndex;
  final double itemExtent;

  late RawCarouselController internalController;
  late ValueNotifier<int> currentIndex;

  MDCarouselController({this.itemExtent = 200, this.initialIndex = 0}) {
    currentIndex = ValueNotifier(initialIndex);

    internalController = RawCarouselController(initialItem: initialIndex);
    internalController.addListener(() {
      int index = (internalController.position as CarouselPosition)
          .getItemFromPixels(
            internalController.position.pixels,
            internalController.position.viewportDimension,
          )
          .round();
      currentIndex.value = index;
    });

    currentIndex.addListener(() {});
  }

  void dispose() {
    internalController.dispose();
    currentIndex.dispose();
  }

  goTo(double index) {
    currentIndex.value = index.toInt();
    internalController.animateTo(
      (internalController.position as CarouselPosition).getPixelsFromItem(index),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  nextPage() {
    goTo(currentIndex.value + 1);
  }

  previousPage() {
    goTo(currentIndex.value - 1);
  }
}
