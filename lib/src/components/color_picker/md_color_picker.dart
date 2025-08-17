import 'package:flutter/material.dart' hide HSVColor;
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

import 'utils/color_utils.dart';
import 'widgets/color_input_fields.dart';
import 'widgets/color_preview.dart';
import 'widgets/color_spectrum_box.dart';
import 'widgets/hue_slider.dart';
import 'widgets/palette_view.dart';

class MDColorPicker extends StatefulWidget {
  const MDColorPicker({
    super.key,
    this.initialColor,
    required this.onColorChanged,
    this.paletteColors = const [],
    this.onDone,
    this.doneButtonChild,
  });

  final Color? initialColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> paletteColors;
  final ValueChanged<Color>? onDone;
  final Widget? doneButtonChild;

  @override
  State<MDColorPicker> createState() => _MDColorPickerState();
}

class _MDColorPickerState extends State<MDColorPicker> {
  late HSVColor _hsvColor;

  @override
  void initState() {
    super.initState();
    _hsvColor = HSVColor.fromColor(widget.initialColor ?? Colors.red);
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
              widget.onColorChanged(_hsvColor.toColor());
            },
          ),
          const SizedBox(height: 16),
          HueSlider(
            hue: _hsvColor.h,
            onHueChanged: (hue) {
              setState(() {
                _hsvColor = HSVColor(hue, _hsvColor.s, _hsvColor.v);
              });
              widget.onColorChanged(_hsvColor.toColor());
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ColorPreview(color: _hsvColor.toColor()),
              const SizedBox(width: 16),
              Expanded(
                child: ColorInputFields(
                  color: _hsvColor.toColor(),
                  onColorChanged: (color) {
                    setState(() {
                      _hsvColor = HSVColor.fromColor(color);
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
                });
                widget.onColorChanged(color);
              },
            ),
        ],
      ),
    );
  }
}
