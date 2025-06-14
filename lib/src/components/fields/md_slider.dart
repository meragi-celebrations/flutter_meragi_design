import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:flutter_meragi_design/src/components/fields/input.dart';
import 'package:flutter_meragi_design/src/extensions/context.dart';
import 'package:flutter_meragi_design/src/theme/components/slider_theme.dart';
import 'package:flutter_meragi_design/src/theme/extensions/dimensions.dart';
import 'package:flutter_meragi_design/src/theme/extensions/md_slider_theme_extension.dart';
import 'package:flutter_meragi_design/src/theme/extensions/typography.dart';

class MDSlider extends StatefulWidget {
  final String? label;
  final String? hint;
  final bool required;
  final bool disabled;
  final double min;
  final double max;
  final double? value; // for single value
  final RangeValues? values; // for range mode
  final ValueChanged<double>? onChanged;
  final ValueChanged<RangeValues>? onRangeChanged;
  final bool isRange;
  final String? errorText;
  final String? helperText;
  final bool simplifyValues;
  final bool showMinMaxTextValues;
  final bool showValues;
  final MDSliderTheme? decoration;
  final EdgeInsets sliderMargin;

  const MDSlider({
    Key? key,
    final EdgeInsets? sliderMargin,
    final bool? showValues,
    this.label,
    this.hint,
    this.required = false,
    this.disabled = false,
    required this.min,
    required this.max,
    this.value,
    this.values,
    this.onChanged,
    this.onRangeChanged,
    this.isRange = false,
    this.errorText,
    this.helperText,
    this.simplifyValues = false,
    this.decoration,
    final bool? showMinMaxTextValues,
  })  : assert(
            (isRange && values != null && onRangeChanged != null) || (!isRange && value != null && onChanged != null),
            'Must provide appropriate value and callback based on isRange'),
        sliderMargin = sliderMargin ?? const EdgeInsets.only(bottom: 2),
        showMinMaxTextValues = showMinMaxTextValues ?? false,
        showValues = showValues ?? true,
        super(key: key);

  @override
  State<MDSlider> createState() => _MDSliderState();
}

class _MDSliderState extends State<MDSlider> {
  late double _currentValue;
  late RangeValues _currentRangeValues;
  final TextEditingController minController = TextEditingController();
  final TextEditingController maxController = TextEditingController();
  final TextEditingController singleController = TextEditingController();
  MDSliderTheme get decoration => context.theme.mdSliderTheme.merge(other: widget.decoration);

  @override
  void initState() {
    super.initState();
    // Round initial values if simplifyValues is true
    if (widget.simplifyValues) {
      _currentValue = (widget.value ?? widget.min).round().toDouble();
      _currentRangeValues = widget.values ?? RangeValues(widget.min.round().toDouble(), widget.max.round().toDouble());
    } else {
      _currentValue = widget.value ?? widget.min;
      _currentRangeValues = widget.values ?? RangeValues(widget.min, widget.max);
    }
    maxController.text = _currentRangeValues.end.toString();
    minController.text = _currentRangeValues.start.toString();
    singleController.text = _currentValue.toString();
  }

  @override
  void didUpdateWidget(MDSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue =
          widget.simplifyValues ? (widget.value ?? widget.min).round().toDouble() : (widget.value ?? widget.min);
    }
    if (widget.values != oldWidget.values) {
      if (widget.simplifyValues) {
        final values = widget.values ?? RangeValues(widget.min, widget.max);
        _currentRangeValues = RangeValues(values.start.round().toDouble(), values.end.round().toDouble());
      } else {
        _currentRangeValues = widget.values ?? RangeValues(widget.min, widget.max);
      }
    }
  }

  @override
  void dispose() {
    singleController.dispose();
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(widget.label!, style: decoration.labelTextStyle),
          ),
        Padding(
          padding: widget.sliderMargin,
          child: widget.isRange ? _buildRangeSlider(theme) : _buildSingleSlider(theme),
        ),
        widget.showMinMaxTextValues ? _buildTextField() : _buildMinMaxLabels(),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(widget.errorText!, style: decoration.errorTextStyle),
          ),
        if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(widget.helperText!, style: decoration.helperTextStyle),
          ),
      ],
    );
  }

  Widget _buildTextField() {
    return widget.isRange
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: MDInput(
                  controller: minController,
                  style: context.theme.fonts.paragraph.small,
                  placeholder: const Text("Min"),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    double? numericValue = double.tryParse(value);
                    double? currentMaxValue = double.tryParse(maxController.text);
                    if (numericValue == null) {
                      return;
                    }

                    if (numericValue <= widget.max && numericValue >= widget.min) {
                      if (currentMaxValue != null && numericValue <= currentMaxValue) {
                        setState(() {
                          _currentRangeValues = widget.simplifyValues
                              ? RangeValues(numericValue.round().toDouble(), currentMaxValue.round().toDouble())
                              : RangeValues(numericValue, currentMaxValue);
                        });
                        widget.onRangeChanged?.call(_currentRangeValues);
                      }
                    } else {
                      minController.text = widget.min.toString();
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.theme.dimensions.padding / 2),
                child: const Text("To"),
              ),
              Flexible(
                child: MDInput(
                  controller: maxController,
                  style: context.theme.fonts.paragraph.small,
                  placeholder: const Text("Max"),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    double? numericValue = double.tryParse(value);
                    double? currentMinValue = double.tryParse(minController.text);
                    if (numericValue == null) {
                      return;
                    }

                    if (numericValue <= widget.max && numericValue >= widget.min) {
                      if (currentMinValue != null && numericValue >= currentMinValue) {
                        setState(() {
                          _currentRangeValues = widget.simplifyValues
                              ? RangeValues(currentMinValue.round().toDouble(), numericValue.round().toDouble())
                              : RangeValues(currentMinValue, numericValue);
                        });
                        widget.onRangeChanged?.call(_currentRangeValues);
                      }
                    } else {
                      if (numericValue > widget.max) {
                        maxController.text = widget.max.toString();
                      } else if (numericValue < widget.min) {
                        maxController.text = widget.min.toString();
                      }
                    }
                  },
                ),
              ),
            ],
          )
        : MDInput(
            controller: singleController,
            style: context.theme.fonts.paragraph.small,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              double? numericValue = double.tryParse(value);
              if (numericValue != null && numericValue >= widget.min && numericValue <= widget.max) {
                setState(() {
                  _currentValue = widget.simplifyValues ? numericValue.round().toDouble() : numericValue;
                });
                widget.onChanged?.call(_currentValue);
              } else {
                minController.text = _currentValue.toString();
              }
            },
          );
  }

  Widget _buildSingleSlider(ThemeData theme) {
    return LayoutBuilder(builder: (context, constraints) {
      final sliderWidth = constraints.maxWidth - 32;
      const bubbleWidth = 32.0;
      final position = ((_currentValue - widget.min) / (widget.max - widget.min)) * sliderWidth;
      final clampedPosition = position.clamp(bubbleWidth / 2, sliderWidth - bubbleWidth / 2);

      return Stack(
        alignment: Alignment.center,
        children: [
          Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            activeColor: decoration.activeTrackColor,
            inactiveColor: decoration.inactiveTrackColor,
            secondaryActiveColor: decoration.secondaryActiveColor,
            thumbColor: decoration.thumbColor,
            divisions: widget.simplifyValues ? (widget.max - widget.min).round() : null,
            onChanged: widget.disabled
                ? null
                : (value) {
                    final updatedValue = widget.simplifyValues ? value.round().toDouble() : value;
                    setState(() => _currentValue = updatedValue);
                    singleController.text = updatedValue.toString();
                  },
            onChangeEnd: widget.disabled
                ? null
                : (value) {
                    final updatedValue = widget.simplifyValues ? value.round().toDouble() : value;
                    widget.onChanged?.call(updatedValue);
                  },
          ),
          if (!widget.disabled && widget.showValues)
            Positioned(
              left: clampedPosition - bubbleWidth / 2,
              top: 0,
              child: _buildValueBubble(
                  widget.simplifyValues ? _currentValue.round().toString() : _currentValue.toStringAsFixed(1)),
            ),
        ],
      );
    });
  }

  Widget _buildRangeSlider(ThemeData theme) {
    return LayoutBuilder(builder: (context, constraints) {
      final sliderWidth = constraints.maxWidth - 32;
      const bubbleWidth = 32.0;
      final startPosition = ((_currentRangeValues.start - widget.min) / (widget.max - widget.min)) * sliderWidth;
      final endPosition = ((_currentRangeValues.end - widget.min) / (widget.max - widget.min)) * sliderWidth;

      final clampedStartPosition = startPosition.clamp(bubbleWidth / 2, sliderWidth - bubbleWidth / 2);
      final clampedEndPosition = endPosition.clamp(bubbleWidth / 2, sliderWidth - bubbleWidth / 2);

      return Stack(
        alignment: Alignment.center,
        children: [
          RangeSlider(
            values: _currentRangeValues,
            min: widget.min,
            max: widget.max,
            divisions: widget.simplifyValues ? (widget.max - widget.min).round() : null,
            onChanged: widget.disabled
                ? null
                : (RangeValues values) {
                    final updatedValues = widget.simplifyValues
                        ? RangeValues(
                            values.start.round().toDouble(),
                            values.end.round().toDouble(),
                          )
                        : values;
                    setState(() => _currentRangeValues = updatedValues);
                    minController.text = updatedValues.start.toString();
                    maxController.text = updatedValues.end.toString();
                  },
            onChangeEnd: widget.disabled
                ? null
                : (values) {
                    final updatedValues = widget.simplifyValues
                        ? RangeValues(
                            values.start.round().toDouble(),
                            values.end.round().toDouble(),
                          )
                        : values;
                    widget.onRangeChanged?.call(updatedValues);
                  },
          ),
          if (!widget.disabled && widget.showValues) ...[
            Positioned(
              left: clampedStartPosition - bubbleWidth / 2,
              top: -8,
              child: _buildValueBubble(
                widget.simplifyValues
                    ? _currentRangeValues.start.round().toString()
                    : _currentRangeValues.start.toStringAsFixed(1),
              ),
            ),
            Positioned(
              left: clampedEndPosition - bubbleWidth / 2,
              top: -8,
              child: _buildValueBubble(
                widget.simplifyValues
                    ? _currentRangeValues.end.round().toString()
                    : _currentRangeValues.end.toStringAsFixed(1),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildValueBubble(String value) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(color: decoration.bubbleColor, borderRadius: decoration.bubbleRadius),
      child: Text(value, style: decoration.bubbleTextStyle),
    );
  }

  Widget _buildMinMaxLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.min.round().toString(), style: decoration.minMaxLabelTextStyle),
          Text(widget.max.round().toString(), style: decoration.minMaxLabelTextStyle),
        ],
      ),
    );
  }
}

class MDSingleSliderFormBuilder extends MDFormBuilderField<double> {
  final double min;
  final double max;
  final String? hint;
  final bool disabled;

  final bool simplifyValues;
  final MDSliderTheme? sliderDecoration;

  MDSingleSliderFormBuilder({
    super.key,
    required String name,
    super.validator,
    super.initialValue,
    this.hint,
    required this.min,
    required this.max,
    this.disabled = false,
    final bool? showMinMaxTextValues,
    final EdgeInsets? sliderMargin,
    final bool? showValues,
    final String? labelText,
    final String? helperText,
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onReset,
    super.focusNode,
    super.onError,
    this.simplifyValues = false,
    this.sliderDecoration,
  }) : super(
          name: name,
          builder: (FormFieldState<double> field) {
            final state = field as _MDSingleSliderFormBuilderState;

            return MDSlider(
              value: state.value ?? min,
              min: min,
              max: max,
              disabled: disabled,
              label: labelText,
              hint: hint,
              errorText: field.errorText,
              helperText: helperText,
              simplifyValues: simplifyValues,
              decoration: sliderDecoration,
              showMinMaxTextValues: showMinMaxTextValues,
              sliderMargin: sliderMargin,
              showValues: showValues,
              onChanged: (value) {
                field.didChange(value);
              },
            );
          },
        );

  @override
  MDFormBuilderFieldState<MDSingleSliderFormBuilder, double> createState() => _MDSingleSliderFormBuilderState();
}

class _MDSingleSliderFormBuilderState extends MDFormBuilderFieldState<MDSingleSliderFormBuilder, double> {
  @override
  void initState() {
    super.initState();
    setValue(widget.initialValue ?? widget.min);
  }
}

class MDRangeSliderFormBuilder extends MDFormBuilderField<RangeValues> {
  final double min;
  final double max;
  final String? hint;
  final bool disabled;

  final bool simplifyValues;

  final MDSliderTheme? sliderDecoration;

  MDRangeSliderFormBuilder({
    super.key,
    required String name,
    super.validator,
    super.initialValue,
    this.hint,
    required this.min,
    required this.max,
    this.disabled = false,
    final bool? showMinMaxTextValues,
    final EdgeInsets? sliderMargin,
    final bool? showValues,
    final String? labelText,
    final String? helperText,
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onReset,
    super.focusNode,
    super.onError,
    this.simplifyValues = false,
    this.sliderDecoration,
  }) : super(
          name: name,
          builder: (FormFieldState<RangeValues> field) {
            final state = field as _MDRangeSliderFormBuilderState;

            return MDSlider(
              values: state.value ?? RangeValues(min, max),
              min: min,
              max: max,
              isRange: true,
              disabled: disabled,
              label: labelText,
              hint: hint,
              errorText: field.errorText,
              helperText: helperText,
              simplifyValues: simplifyValues,
              decoration: sliderDecoration,
              showMinMaxTextValues: showMinMaxTextValues,
              sliderMargin: sliderMargin,
              showValues: showValues,
              onRangeChanged: (values) {
                field.didChange(values);
              },
            );
          },
        );

  @override
  MDFormBuilderFieldState<MDRangeSliderFormBuilder, RangeValues> createState() => _MDRangeSliderFormBuilderState();
}

class _MDRangeSliderFormBuilderState extends MDFormBuilderFieldState<MDRangeSliderFormBuilder, RangeValues> {
  @override
  void setValue(dynamic value, {bool populateForm = true}) {
    if (value == null) {
      super.setValue(RangeValues(widget.min, widget.max), populateForm: populateForm);
    } else if (value is RangeValues) {
      super.setValue(value, populateForm: populateForm);
    } else if (value is Set<String>) {
      final list = value.map(double.parse).toList();
      super.setValue(RangeValues(list[0], list[1]), populateForm: populateForm);
    } else {
      super.setValue(RangeValues(widget.min, widget.max), populateForm: populateForm);
    }
  }

  @override
  void initState() {
    super.initState();
    setValue(widget.initialValue ?? RangeValues(widget.min, widget.max));
  }
}
