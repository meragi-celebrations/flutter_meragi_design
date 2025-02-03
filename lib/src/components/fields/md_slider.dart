import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';

class MDSliderDecoration {
  final Color? bubbleColor;
  final Color? bubbleTextColor;
  final Color? labelTextColor;
  final Color? helperTextColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;
  final Color? minMaxLabelsColor;
  final BuildContext context;

  const MDSliderDecoration({
    required this.context,
    this.bubbleColor,
    this.bubbleTextColor,
    this.labelTextColor,
    this.helperTextColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.minMaxLabelsColor,
  });

  Color get _bubbleColor => bubbleColor ?? Colors.white;
  Color get _bubbleTextColor => bubbleTextColor ?? Theme.of(context).colorScheme.onPrimary;
  Color get _labelTextColor => labelTextColor ?? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
  Color get _helperTextColor => helperTextColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.black54;
  Color get _activeTrackColor => activeTrackColor ?? Theme.of(context).primaryColor;
  Color get _inactiveTrackColor => inactiveTrackColor ?? Theme.of(context).primaryColor.withOpacity(0.2);
  Color get _thumbColor => thumbColor ?? Theme.of(context).primaryColor;
  Color get _minMaxLabelsColor => minMaxLabelsColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.black54;
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
  final MDSliderDecoration? decoration;

  const MDSlider({
    Key? key,
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
  })  : assert(
            (isRange && values != null && onRangeChanged != null) || (!isRange && value != null && onChanged != null),
            'Must provide appropriate value and callback based on isRange'),
        super(key: key);

  @override
  State<MDSlider> createState() => _MDSliderState();
}

class _MDSliderState extends State<MDSlider> {
  late double _currentValue;
  late RangeValues _currentRangeValues;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value ?? widget.min;
    _currentRangeValues = widget.values ?? RangeValues(widget.min, widget.max);
  }

  @override
  void didUpdateWidget(MDSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value ?? widget.min;
    }
    if (widget.values != oldWidget.values) {
      _currentRangeValues = widget.values ?? RangeValues(widget.min, widget.max);
    }
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
              style: theme.textTheme.bodyMedium?.copyWith(
                color: widget.decoration?._labelTextColor,
              ),
            ),
          ),
        SizedBox(
          height: 48,
          child: widget.isRange ? _buildRangeSlider(theme) : _buildSingleSlider(theme),
        ),
        _buildMinMaxLabels(theme),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.helperText!,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildSingleSlider(ThemeData theme) {
    return LayoutBuilder(builder: (context, constraints) {
      final sliderWidth = constraints.maxWidth - 32; // Account for slider padding
      final bubbleWidth = 32.0; // Width of the bubble
      final position = ((_currentValue - widget.min) / (widget.max - widget.min)) * sliderWidth;

      // Clamp position to keep bubble visible
      final clampedPosition = position.clamp(
          bubbleWidth / 2, // Min position
          sliderWidth - bubbleWidth / 2 // Max position
          );

      return Stack(
        alignment: Alignment.center,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: widget.decoration?._activeTrackColor ?? theme.primaryColor,
              inactiveTrackColor: widget.decoration?._inactiveTrackColor ?? theme.primaryColor.withOpacity(0.2),
              thumbColor: widget.decoration?._thumbColor ?? theme.primaryColor,
              overlayColor: widget.decoration?._thumbColor.withOpacity(0.1),
              valueIndicatorColor: widget.decoration?._thumbColor,
            ),
            child: Slider(
              value: _currentValue,
              min: widget.min,
              max: widget.max,
              divisions: widget.simplifyValues ? (widget.max - widget.min).round() : null,
              onChanged: widget.disabled
                  ? null
                  : (value) {
                      setState(() => _currentValue = value);
                      widget.onChanged?.call(value);
                    },
            ),
          ),
          if (!widget.disabled)
            Positioned(
              left: clampedPosition - bubbleWidth / 2,
              top: 0,
              child: _buildValueBubble(
                  widget.simplifyValues ? _currentValue.round().toString() : _currentValue.toStringAsFixed(1), theme),
            ),
        ],
      );
    });
  }

  Widget _buildRangeSlider(ThemeData theme) {
    return LayoutBuilder(builder: (context, constraints) {
      final sliderWidth = constraints.maxWidth - 32; // Account for slider padding
      final bubbleWidth = 32.0; // Width of the bubble
      final startPosition = ((_currentRangeValues.start - widget.min) / (widget.max - widget.min)) * sliderWidth;
      final endPosition = ((_currentRangeValues.end - widget.min) / (widget.max - widget.min)) * sliderWidth;

      // Clamp positions to keep bubbles visible
      final clampedStartPosition = startPosition.clamp(
          bubbleWidth / 2, // Min position
          sliderWidth - bubbleWidth / 2 // Max position
          );
      final clampedEndPosition = endPosition.clamp(
          bubbleWidth / 2, // Min position
          sliderWidth - bubbleWidth / 2 // Max position
          );

      return Stack(
        alignment: Alignment.center,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: widget.decoration?._activeTrackColor ?? theme.primaryColor,
              inactiveTrackColor: widget.decoration?._inactiveTrackColor ?? theme.primaryColor.withOpacity(0.2),
              thumbColor: widget.decoration?._thumbColor ?? theme.primaryColor,
              overlayColor: widget.decoration?._thumbColor.withOpacity(0.1),
              rangeThumbShape: const RoundRangeSliderThumbShape(),
              rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            ),
            child: RangeSlider(
              values: _currentRangeValues,
              min: widget.min,
              max: widget.max,
              divisions: widget.simplifyValues ? (widget.max - widget.min).round() : null,
              onChanged: widget.disabled
                  ? null
                  : (RangeValues values) {
                      setState(() => _currentRangeValues = values);
                      widget.onRangeChanged?.call(values);
                    },
            ),
          ),
          if (!widget.disabled) ...[
            Positioned(
              left: clampedStartPosition - bubbleWidth / 2,
              top: 0,
              child: _buildValueBubble(
                  widget.simplifyValues
                      ? _currentRangeValues.start.round().toString()
                      : _currentRangeValues.start.toStringAsFixed(1),
                  theme),
            ),
            Positioned(
              left: clampedEndPosition - bubbleWidth / 2,
              top: 0,
              child: _buildValueBubble(
                  widget.simplifyValues
                      ? _currentRangeValues.end.round().toString()
                      : _currentRangeValues.end.toStringAsFixed(1),
                  theme),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildValueBubble(String value, ThemeData theme) {
    final decoration = widget.decoration;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: decoration?._bubbleColor ?? Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          color: decoration?._bubbleTextColor ?? theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildMinMaxLabels(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.min.round().toString(),
            style: theme.textTheme.bodySmall,
          ),
          Text(
            widget.max.round().toString(),
            style: theme.textTheme.bodySmall,
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
