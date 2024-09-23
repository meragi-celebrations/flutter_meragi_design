import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/raw_carousel.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MDCarousel extends StatelessWidget {
  final List<Widget> children;
  final MDCarouselController? controller;

  final bool showNavButtons;
  final bool showPagination;
  final bool itemSnapping;
  final void Function(int)? onTap;

  const MDCarousel({
    super.key,
    required this.children,
    this.controller,
    this.showNavButtons = true,
    this.showPagination = true,
    this.itemSnapping = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    MDCarouselController effectiveController =
        controller ?? MDCarouselController();
    return Stack(
      children: [
        RawCarouselView(
          controller: effectiveController.internalController,
          itemExtent: effectiveController.itemExtent,
          shrinkExtent: effectiveController.itemExtent,
          onTap: onTap,
          itemSnapping: itemSnapping,
          children: children,
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
          .getItemFromPixels(internalController.position.pixels,
              internalController.position.viewportDimension)
          .round();
      currentIndex.value = index;
    });

    currentIndex.addListener(() {});
  }

  goTo(double index) {
    internalController.animateTo(
        (internalController.position as CarouselPosition)
            .getPixelsFromItem(index),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn);
  }

  nextPage() {
    goTo(currentIndex.value + 1);
  }

  previousPage() {
    goTo(currentIndex.value - 1);
  }
}
