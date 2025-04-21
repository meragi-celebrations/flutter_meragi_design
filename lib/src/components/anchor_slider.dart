import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDAnchorSliderController {
  _MDAnchorSliderState? _state;

  void _attach(_MDAnchorSliderState state) {
    _state = state;
  }

  void showOverlay() {
    _state?._showOverlay();
  }

  void hideOverlay() {
    _state?._removeOverlay();
  }

  bool get isOverlayVisible => _state?._overlayEntry != null;
}

/// A widget that displays an anchor and an overlay slider. The overlay slider
/// can be shown or hidden programmatically using the [MDAnchorSliderController].
///
/// The overlay is displayed relative to the anchor widget and can be customized
/// using the provided builder function.
///
/// This widget is useful for creating custom dropdowns, tooltips, or other
/// anchored overlay components.
///
/// ## Parameters:
/// - [controller]: An optional [MDAnchorSliderController] to control the overlay.
/// - [anchor]: The widget that acts as the anchor for the overlay.
/// - [builder]: A function that builds the overlay content. It provides the
///   current [BuildContext] and the width of the overlay as parameters.
/// - [overlayWidth]: The maximum width of the overlay. Defaults to 500.
/// - [verticalOffset]: The vertical offset of the overlay relative to the anchor.
///   Defaults to 0.
/// - [horizontalOffset]: The horizontal offset of the overlay relative to the anchor.
///   Defaults to 0.
/// - [closeOnOutsideTap]: Whether the overlay should close when tapping outside of it.
///   Defaults to false.
///
/// ## Example:
/// ```dart
/// MDAnchorSlider(
///   anchor: Icon(Icons.menu),
///   builder: (context, width) {
///     return Container(
///       width: width,
///       color: Colors.white,
///       child: Text('Overlay Content'),
///     );
///   },
///   closeOnOutsideTap: true,
/// );
/// ```
///
/// ## Notes:
/// - The overlay is animated using an [AnimationController].
/// - The overlay is removed when the widget is disposed or when the controller
///   is used to hide it.
///
/// See also:
/// - [MDAnchorSliderController] for programmatically controlling the overlay.
class MDAnchorSlider extends StatefulWidget {
  final MDAnchorSliderController? controller;
  final Widget anchor;
  final Widget Function(BuildContext context, double width) builder;
  final double overlayWidth;
  final double verticalOffset;
  final double horizontalOffset;
  final bool closeOnOutsideTap;
  final Duration animationDuration;

  const MDAnchorSlider({
    super.key,
    required this.anchor,
    required this.builder,
    this.controller,
    this.overlayWidth = 500,
    this.verticalOffset = 0,
    this.horizontalOffset = 0,
    this.closeOnOutsideTap = false,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<MDAnchorSlider> createState() => _MDAnchorSliderState();
}

class _MDAnchorSliderState extends State<MDAnchorSlider>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _controller;
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
  }

  @override
  void didUpdateWidget(covariant MDAnchorSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final RenderBox renderBox =
        _childKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double startLeft = offset.dx + widget.horizontalOffset;
    final double top = offset.dy + widget.verticalOffset;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: MDGestureDetector(
                onTap: () {
                  _removeOverlay();
                },
                isDisabled: !widget.closeOnOutsideTap,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ),
            // Anchor rendered above the background
            Positioned(
              left: startLeft,
              top: top - widget.verticalOffset,
              child: SizedBox(
                width: renderBox.size.width,
                height: renderBox.size.height,
                child: IgnorePointer(
                  ignoring: false,
                  child: widget.anchor,
                ),
              ),
            ),
            // Overlay rendered above the background and anchor
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double width = _controller.value * widget.overlayWidth;
                return Positioned(
                  left: startLeft - width,
                  top: top,
                  child: Material(
                    color: Colors.transparent,
                    child: widget.builder(context, width),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
    _controller.forward(from: 0);
  }

  void _removeOverlay() {
    if (_overlayEntry == null) return;
    // Future.delayed(widget.animationDuration ~/ 2, () {
    //   _controller.reverse().then((_) {
    //     _overlayEntry?.remove();
    //     _overlayEntry = null;
    //   });
    // });
    _controller.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    // _overlayEntry?.remove();
    // _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _childKey,
      child: widget.anchor,
    );
  }
}
