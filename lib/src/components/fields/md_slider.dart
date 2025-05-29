import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';
import 'package:flutter_meragi_design/src/components/fields/input.dart';
import 'package:flutter_meragi_design/src/extensions/context.dart';
import 'package:flutter_meragi_design/src/theme/extensions/dimensions.dart';
import 'package:flutter_meragi_design/src/theme/style.dart';

class MDSliderDecoration extends Style {
  MDSliderDecoration({
    required super.context,
    Color? bubbleColorOverride,
    Color? bubbleTextColorOverride,
    Color? labelTextColorOverride,
    Color? helperTextColorOverride,
    Color? activeTrackColorOverride,
    Color? inactiveTrackColorOverride,
    Color? thumbColorOverride,
    Color? minMaxLabelsColorOverride,
  })  : _bubbleColorOverride = bubbleColorOverride,
        _bubbleTextColorOverride = bubbleTextColorOverride,
        _labelTextColorOverride = labelTextColorOverride,
        _helperTextColorOverride = helperTextColorOverride,
        _activeTrackColorOverride = activeTrackColorOverride,
        _inactiveTrackColorOverride = inactiveTrackColorOverride,
        _thumbColorOverride = thumbColorOverride,
        _minMaxLabelsColorOverride = minMaxLabelsColorOverride;

  final Color? _bubbleColorOverride;
  final Color? _bubbleTextColorOverride;
  final Color? _labelTextColorOverride;
  final Color? _helperTextColorOverride;
  final Color? _activeTrackColorOverride;
  final Color? _inactiveTrackColorOverride;
  final Color? _thumbColorOverride;
  final Color? _minMaxLabelsColorOverride;

  @override
  Map get styles => {};

  Color get bubbleColor => _bubbleColorOverride ?? token.defaultCardBackgroundColor;
  Color get bubbleTextColor => _bubbleTextColorOverride ?? token.primaryTextColor;
  Color get labelTextColor => _labelTextColorOverride ?? token.primaryTextColor;
  Color get helperTextColor => _helperTextColorOverride ?? token.secondaryTextColor;
  Color get activeTrackColor => _activeTrackColorOverride ?? token.primaryColor;
  Color get inactiveTrackColor => _inactiveTrackColorOverride ?? token.primaryColor.withOpacity(0.2);
  Color get thumbColor => _thumbColorOverride ?? token.primaryColor;
  Color get minMaxLabelsColor => _minMaxLabelsColorOverride ?? token.secondaryTextColor;
}

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
  final MDSliderDecoration? decoration;
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
            child: Text(
              widget.label!,
              style: widget.decoration?.token.bodyTextStyle.copyWith(
                color: widget.decoration?.labelTextColor,
              ),
            ),
          ),
        Padding(
          padding: widget.sliderMargin,
          child: widget.isRange ? _buildRangeSlider(theme) : _buildSingleSlider(theme),
        ),
        widget.showMinMaxTextValues ? _buildTextField() : _buildMinMaxLabels(),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: widget.decoration?.token.bodyTextStyle.copyWith(
                color: widget.decoration?.token.errorColor,
              ),
            ),
          ),
        if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.helperText!,
              style: widget.decoration?.token.bodyTextStyle.copyWith(
                color: widget.decoration?.helperTextColor,
              ),
            ),
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
                          _currentRangeValues = RangeValues(numericValue, currentMaxValue);
                        });
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
                          _currentRangeValues = RangeValues(currentMinValue, numericValue);
                        });
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
        : TextField(
            controller: singleController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: "Value",
              labelText: "Value",
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
            ),
            onChanged: (value) {
              double? numericValue = double.tryParse(value);
              if (numericValue != null && numericValue >= widget.min && numericValue <= widget.max) {
                setState(() {
                  _currentValue = numericValue;
                });
              } else {
                minController.text = _currentValue.toString();
              }
            },
          );
  }

  Widget _buildSingleSlider(ThemeData theme) {
    return LayoutBuilder(builder: (context, constraints) {
      final sliderWidth = constraints.maxWidth - 32;
      final bubbleWidth = 32.0;
      final position = ((_currentValue - widget.min) / (widget.max - widget.min)) * sliderWidth;
      final clampedPosition = position.clamp(bubbleWidth / 2, sliderWidth - bubbleWidth / 2);

      return Stack(
        alignment: Alignment.center,
        children: [
          Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            divisions: widget.simplifyValues ? (widget.max - widget.min).round() : null,
            onChanged: widget.disabled
                ? null
                : (value) {
                    final updatedValue = widget.simplifyValues ? value.round().toDouble() : value;
                    setState(() => _currentValue = updatedValue);
                    singleController.text = updatedValue.toString();
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
      decoration: BoxDecoration(
        color: widget.decoration?.bubbleColor,
        borderRadius: BorderRadius.circular(widget.decoration?.token.radius ?? 4),
      ),
      child: Text(
        value,
        style: widget.decoration?.token.bodyTextStyle.copyWith(
          color: widget.decoration?.bubbleTextColor,
        ),
      ),
    );
  }

  Widget _buildMinMaxLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.min.round().toString(),
            style: widget.decoration?.token.bodyTextStyle.copyWith(
              color: widget.decoration?.minMaxLabelsColor,
            ),
          ),
          Text(
            widget.max.round().toString(),
            style: widget.decoration?.token.bodyTextStyle.copyWith(
              color: widget.decoration?.minMaxLabelsColor,
            ),
          ),
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
  final InputDecoration? decoration;
  final Function(bool, String?)? onError;
  final bool simplifyValues;
  final MDSliderDecoration? sliderDecoration;

  MDSingleSliderFormBuilder({
    super.key,
    required String name,
    super.validator,
    super.initialValue,
    this.hint,
    required this.min,
    required this.max,
    this.disabled = false,
    this.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onReset,
    super.focusNode,
    this.onError,
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
              label: decoration?.labelText,
              hint: hint,
              errorText: field.errorText,
              helperText: decoration?.helperText,
              simplifyValues: simplifyValues,
              decoration: sliderDecoration,
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
  final InputDecoration? decoration;
  final Function(bool, String?)? onError;
  final bool simplifyValues;

  final MDSliderDecoration? sliderDecoration;

  MDRangeSliderFormBuilder({
    super.key,
    required String name,
    super.validator,
    super.initialValue,
    this.hint,
    required this.min,
    required this.max,
    this.disabled = false,
    this.decoration,
    final bool? showMinMaxTextValues,
    final EdgeInsets? sliderMargin,
    final bool? showValues,
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.onReset,
    super.focusNode,
    this.onError,
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
              label: decoration?.labelText,
              hint: hint,
              errorText: field.errorText,
              helperText: decoration?.helperText,
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
