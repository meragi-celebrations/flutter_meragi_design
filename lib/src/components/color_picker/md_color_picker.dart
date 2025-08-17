import 'package:flutter/material.dart' hide HSVColor;
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

import 'utils/color_utils.dart';
import 'widgets/color_input_fields.dart';
import 'widgets/color_preview.dart';
import 'widgets/color_spectrum_box.dart';
import 'widgets/hue_slider.dart';
import 'widgets/opacity_slider.dart';
import 'widgets/palette_view.dart';
import 'widgets/value_slider.dart';

class MDColorPicker extends StatefulWidget {
  const MDColorPicker({
    super.key,
    this.initialColor,
    required this.onColorChanged,
    this.paletteColors = const [],
    this.onDone,
    this.doneButtonChild,
    this.showOpacitySlider = true,
    this.showValueSlider = true,
  });

  final Color? initialColor;
  final bool showOpacitySlider;
  final bool showValueSlider;
  final ValueChanged<Color> onColorChanged;
  final List<Color> paletteColors;
  final ValueChanged<Color>? onDone;
  final Widget? doneButtonChild;

  @override
  State<MDColorPicker> createState() => _MDColorPickerState();
}

class _MDColorPickerState extends State<MDColorPicker> {
  late HSVColor _hsvColor;
  late double _opacity;

  @override
  void initState() {
    super.initState();
    _hsvColor = HSVColor.fromColor(widget.initialColor ?? Colors.red);
    _opacity = (widget.initialColor ?? Colors.red).opacity;
  }

  @override
  Widget build(BuildContext context) {
    return MDPanel(
      footer: widget.onDone != null
          ? MDTap(
              onPressed: () {
                widget.onDone!(_hsvColor.toColor());
              },
              child: widget.doneButtonChild ?? const Text('Done'),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorSpectrumBox(
            hsvColor: _hsvColor,
            onColorChanged: (hsvColor) {
              setState(() {
                _hsvColor = hsvColor;
              });
              widget.onColorChanged(
                _hsvColor.toColor().withOpacity(_opacity),
              );
            },
          ),
          const SizedBox(height: 16),
          HueSlider(
            hue: _hsvColor.h,
            onHueChanged: (hue) {
              setState(() {
                _hsvColor = HSVColor(hue, _hsvColor.s, _hsvColor.v);
              });
              widget.onColorChanged(
                _hsvColor.toColor().withOpacity(_opacity),
              );
            },
          ),
          if (widget.showValueSlider) ...[
            const SizedBox(height: 16),
            ValueSlider(
              hsvColor: _hsvColor,
              onValueChanged: (value) {
                setState(() {
                  _hsvColor = HSVColor(_hsvColor.h, _hsvColor.s, value);
                });
                widget.onColorChanged(
                  _hsvColor.toColor().withOpacity(_opacity),
                );
              },
            ),
          ],
          if (widget.showOpacitySlider) ...[
            const SizedBox(height: 16),
            OpacitySlider(
              hsvColor: _hsvColor,
              opacity: _opacity,
              onOpacityChanged: (opacity) {
                setState(() {
                  _opacity = opacity;
                });
                widget.onColorChanged(
                  _hsvColor.toColor().withOpacity(_opacity),
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              ColorPreview(color: _hsvColor.toColor().withOpacity(_opacity)),
              const SizedBox(width: 16),
              Expanded(
                child: ColorInputFields(
                  color: _hsvColor.toColor().withOpacity(_opacity),
                  onColorChanged: (color) {
                    setState(() {
                      _hsvColor = HSVColor.fromColor(color);
                      _opacity = color.opacity;
                    });
                    widget.onColorChanged(color);
                  },
                ),
              ),
            ],
          ),
          const MDDivider(),
          if (widget.paletteColors.isNotEmpty)
            PaletteView(
              colors: widget.paletteColors,
              onColorSelected: (color) {
                setState(() {
                  _hsvColor = HSVColor.fromColor(color);
                  _opacity = color.opacity;
                });
                widget.onColorChanged(color);
              },
            ),
        ],
      ),
    );
  }
}
