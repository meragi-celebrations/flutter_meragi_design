import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class ColorInputFields extends StatefulWidget {
  const ColorInputFields({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  State<ColorInputFields> createState() => _ColorInputFieldsState();
}

class _ColorInputFieldsState extends State<ColorInputFields> {
  late final TextEditingController hexController;
  late final TextEditingController rController;
  late final TextEditingController gController;
  late final TextEditingController bController;

  @override
  void initState() {
    super.initState();
    hexController = TextEditingController();
    rController = TextEditingController();
    gController = TextEditingController();
    bController = TextEditingController();
    _updateControllers(widget.color);
  }

  @override
  void didUpdateWidget(ColorInputFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _updateControllers(widget.color);
    }
  }

  void _updateControllers(Color color) {
    hexController.text = '#${color.value.toRadixString(16).substring(2)}';
    rController.text = color.red.toString();
    gController.text = color.green.toString();
    bController.text = color.blue.toString();
  }

  @override
  void dispose() {
    hexController.dispose();
    rController.dispose();
    gController.dispose();
    bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MDInput(
                controller: hexController,
                placeholder: const Text('HEX'),
                onSubmitted: (value) {
                  try {
                    final newColor = Color(
                        int.parse(value.replaceAll('#', ''), radix: 16) +
                            0xFF000000);
                    widget.onColorChanged(newColor);
                  } catch (e) {
                    _updateControllers(widget.color);
                  }
                },
              ),
            ),
            MDTap.ghost(
              iconData: Icons.copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: hexController.text));
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: MDInput(
                controller: rController,
                placeholder: const Text('R'),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  try {
                    final newColor = widget.color.withRed(int.parse(value));
                    widget.onColorChanged(newColor);
                  } catch (e) {
                    _updateControllers(widget.color);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MDInput(
                controller: gController,
                placeholder: const Text('G'),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  try {
                    final newColor = widget.color.withGreen(int.parse(value));
                    widget.onColorChanged(newColor);
                  } catch (e) {
                    _updateControllers(widget.color);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: MDInput(
                controller: bController,
                placeholder: const Text('B'),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  try {
                    final newColor = widget.color.withBlue(int.parse(value));
                    widget.onColorChanged(newColor);
                  } catch (e) {
                    _updateControllers(widget.color);
                  }
                },
              ),
            ),
            MDTap.ghost(
              iconData: Icons.copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(
                    text:
                        'rgb(${rController.text}, ${gController.text}, ${bController.text})'));
              },
            ),
          ],
        ),
      ],
    );
  }
}
