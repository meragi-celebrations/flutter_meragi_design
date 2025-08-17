import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class SliderWithInput extends StatefulWidget {
  const SliderWithInput({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final int? divisions;

  @override
  State<SliderWithInput> createState() => _SliderWithInputState();
}

class _SliderWithInputState extends State<SliderWithInput> {
  late final TextEditingController _controller;
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _controller = TextEditingController(text: _value.toStringAsFixed(1));
  }

  @override
  void didUpdateWidget(covariant SliderWithInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _value = widget.value;
      _controller.text = _value.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SectionTitle(widget.label),
            const Spacer(),
            SizedBox(
              width: 60,
              child: MDInput(
                controller: _controller,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                onSubmitted: (v) {
                  final d = double.tryParse(v);
                  if (d != null) {
                    final clamped = d.clamp(widget.min, widget.max);
                    setState(() {
                      _value = clamped;
                      _controller.text = clamped.toStringAsFixed(1);
                    });
                    widget.onChanged(clamped);
                  }
                },
              ),
            ),
          ],
        ),
        Slider(
          value: _value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: _value.toStringAsFixed(1),
          onChanged: (v) {
            setState(() {
              _value = v;
              _controller.text = v.toStringAsFixed(1);
            });
            widget.onChanged(v);
          },
        ),
      ],
    );
  }
}
