import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MDRating extends StatefulWidget {
  const MDRating({
    Key? key,
    required this.value,
    this.onValueChanged,
    this.starSize = 20,
    this.starColor,
    this.iconType = IconType.filled,
    this.starCount = 5,
    this.starBuilder,
    this.showLabels = false,
    this.labels,
    this.labelBuilder,
    this.readOnly = false, // Add this parameter
  }) : super(key: key);

  final double value;
  final ValueChanged<double>? onValueChanged;
  final double starSize;
  final Color? starColor;
  final IconType iconType;
  final int starCount;
  final bool showLabels;
  final List<String>? labels;
  final bool readOnly;
  final Widget Function(
    BuildContext context, {
    required bool isSelected,
    required bool isHovered,
    required bool isAnimating,
  })? starBuilder;
  final Widget Function(BuildContext context, String label)?
      labelBuilder; // Add this

  @override
  State<MDRating> createState() => _MDRatingState();
}

class _MDRatingState extends State<MDRating> {
  double _currentRating = 0;
  int _animationIndex = -1;
  int _hoverIndex = -1;

  final List<String> _defaultLabels = [
    'Terrible',
    'Bad',
    'Okay',
    'Good',
    'Amazing',
  ];

  @override
  void initState() {
    super.initState();
    _currentRating = widget.value;
  }

  Future<void> _animateRating(int index) async {
    for (int i = 0; i <= index; i++) {
      setState(() {
        _animationIndex = i;
      });
      await Future.delayed(const Duration(milliseconds: 50));
    }
    setState(() {
      _animationIndex = -1;
    });
  }

  Widget _defaultStarBuilder(
    BuildContext context, {
    required bool isSelected,
    required bool isHovered,
    required bool isAnimating,
  }) {
    return Icon(
      widget.iconType == IconType.filled
          ? PhosphorIconsFill.star
          : PhosphorIconsRegular.star,
      color: isSelected
          ? widget.starColor ?? context.theme.colors.accent
          : Colors.grey,
      size: widget.starSize,
    );
  }

  Widget _defaultLabelBuilder(BuildContext context, String label) {
    return Text(
      label,
      style: context.theme.fonts.heading.xSmall.copyWith(
        color: widget.starColor ?? context.theme.colors.accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.starCount, (index) {
            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  _hoverIndex = index;
                });
              },
              onExit: (_) {
                setState(() {
                  _hoverIndex = -1;
                });
              },
              child: MDGestureDetector(
                onTap: () {
                  if (widget.readOnly) return; // Add this
                  _animateRating(index).then((_) {
                    setState(() {
                      _currentRating = index + 1;
                      widget.onValueChanged?.call(_currentRating);
                    });
                  });
                },
                child: AnimatedScale(
                  scale: widget.readOnly ? 1 : (_animationIndex >= 0 && index <= _animationIndex) ||
                          _hoverIndex == index
                      ? 1.2
                      : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: widget.starBuilder?.call(
                        context,
                        isSelected: _currentRating >= index + 1,
                        isHovered: _hoverIndex == index,
                        isAnimating:
                            _animationIndex >= 0 && index <= _animationIndex,
                      ) ??
                      _defaultStarBuilder(
                        context,
                        isSelected: _currentRating >= index + 1,
                        isHovered: _hoverIndex == index,
                        isAnimating:
                            _animationIndex >= 0 && index <= _animationIndex,
                      ),
                ),
              ),
            );
          }),
        ),
        if (widget.showLabels && _hoverIndex != -1) ...[
          const SizedBox(height: 4),
          widget.labelBuilder?.call(
                context,
                widget.labels?.elementAtOrNull(_hoverIndex) ??
                    _defaultLabels.elementAtOrNull(_hoverIndex) ??
                    '',
              ) ??
              _defaultLabelBuilder(
                context,
                widget.labels?.elementAtOrNull(_hoverIndex) ??
                    _defaultLabels.elementAtOrNull(_hoverIndex) ??
                    '',
              ),
        ],
      ],
    );
  }
}

enum IconType {
  filled,
  outline,
}
