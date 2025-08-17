import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class ColorPickerStory extends StatefulWidget {
  const ColorPickerStory({super.key});

  @override
  State<ColorPickerStory> createState() => _ColorPickerStoryState();
}

class _ColorPickerStoryState extends State<ColorPickerStory> {
  final List<Color> _palette = [];
  Color _selectedColor = Colors.red;
  Color _selectedColor2 = Colors.blue;
  bool _showOpacitySlider = true;
  bool _showValueSlider = true;

  @override
  Widget build(BuildContext context) {
    return MDScaffold(
      appBar: const MDAppBar(
        title: Text('Color Picker'),
        asPageHeader: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _showOpacitySlider,
                      onChanged: (value) {
                        setState(() {
                          _showOpacitySlider = value!;
                        });
                      },
                    ),
                    const Text('Show Opacity Slider'),
                    const SizedBox(width: 24),
                    Checkbox(
                      value: _showValueSlider,
                      onChanged: (value) {
                        setState(() {
                          _showValueSlider = value!;
                        });
                      },
                    ),
                    const Text('Show Value Slider'),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 450,
                  child: MDColorPicker(
                    initialColor: _selectedColor,
                    paletteColors: _palette,
                    showOpacitySlider: _showOpacitySlider,
                    showValueSlider: _showValueSlider,
                    onColorChanged: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    onDone: (color) {
                      setState(() {
                        if (!_palette.contains(color)) {
                          _palette.add(color);
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 450,
                  child: MDColorPicker(
                    initialColor: _selectedColor2,
                    paletteColors: _palette,
                    doneButtonChild: const Text('Select this color'),
                    onColorChanged: (color) {
                      setState(() {
                        _selectedColor2 = color;
                      });
                    },
                    onDone: (color) {
                      setState(() {
                        if (!_palette.contains(color)) {
                          _palette.add(color);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
