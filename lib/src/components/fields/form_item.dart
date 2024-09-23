import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:flutter_meragi_design/src/components/fields/form_builder_field.dart';

class GridLayoutValues {
  final int labelFlex;
  final int fieldFlex;

  const GridLayoutValues(this.labelFlex, this.fieldFlex);
}

class FormItemStyle {
  const FormItemStyle({
    this.decoration,
  });

  final BoxDecoration? decoration;

  FormItemStyle copyWith({BoxDecoration? decoration}) {
    return FormItemStyle(
      decoration: decoration ?? this.decoration,
    );
  }

  FormItemStyle merge(FormItemStyle? other) {
    return FormItemStyle(
      decoration: other?.decoration ?? decoration,
    );
  }
}

class MDFormItem extends StatefulWidget {
  final MDFormBuilderField child;
  final Widget? label;
  final Axis? labelPosition;
  final Widget? error;
  final bool isGrid;
  final GridLayoutValues? gridValues;
  final double? contentSpace;
  final FormItemStyle? style;

  const MDFormItem({
    Key? key,
    required this.child,
    this.label,
    this.labelPosition = Axis.vertical,
    this.error,
    this.isGrid = false,
    this.gridValues,
    this.contentSpace,
    this.style,
  }) : super(key: key);

  @override
  State<MDFormItem> createState() => _MDFormItemState();
}

class _MDFormItemState extends State<MDFormItem> {
  Widget? workingError;

  @override
  void initState() {
    super.initState();
    workingError = widget.error;
  }

  @override
  Widget build(BuildContext context) {
    widget.child.onError = (isValid, error) {
      if (isValid) {
        setState(() {
          workingError = null;
        });
      } else {
        setState(() {
          workingError = BodyText(text: error ?? "", type: TextType.error);
        });
      }
    };

    FormItemStyle finalStyle = FormItemStyle().merge(widget.style);

    Widget space = SizedBox(
        height: widget.contentSpace ?? 3.0, width: widget.contentSpace ?? 3.0);
    return Container(
      decoration: finalStyle.decoration,
      child: widget.isGrid
          ? GridLayout(
              label: widget.label,
              space: space,
              error: workingError,
              gridValues: widget.gridValues ?? const GridLayoutValues(1, 9),
              child: widget.child,
            )
          : widget.labelPosition == Axis.horizontal
              ? RowLayout(
                  label: widget.label,
                  space: space,
                  error: workingError,
                  child: widget.child)
              : ColumnLayout(
                  label: widget.label,
                  space: space,
                  error: workingError,
                  child: widget.child),
    );
  }
}

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.label,
    required this.space,
    required this.child,
    required this.error,
    required this.gridValues,
  });

  final Widget? label;
  final Widget space;
  final Widget child;
  final Widget? error;
  final GridLayoutValues gridValues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (label != null)
              Flexible(
                flex: gridValues.labelFlex,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [label!, space],
                ),
              ),
            Expanded(
              flex: gridValues.fieldFlex,
              child: child,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height:
                  (MeragiTheme.of(context).token.bodyTextStyle.fontSize ?? 1) *
                      1.4,
            ),
            AnimatedOpacity(
              opacity: error != null ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: error,
            )
            // if (error != null) error!,
          ],
        )
      ],
    );
  }
}

class RowLayout extends StatelessWidget {
  const RowLayout({
    super.key,
    required this.label,
    required this.space,
    required this.child,
    required this.error,
  });

  final Widget? label;
  final Widget space;
  final Widget child;
  final Widget? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            if (label != null) ...[label!, space],
            Expanded(child: child)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height:
                  (MeragiTheme.of(context).token.bodyTextStyle.fontSize ?? 1) *
                      1.4,
            ),
            if (error != null) error!
          ],
        )
      ],
    );
  }
}

class ColumnLayout extends StatelessWidget {
  const ColumnLayout({
    super.key,
    required this.label,
    required this.space,
    required this.child,
    required this.error,
  });

  final Widget? label;
  final Widget space;
  final Widget child;
  final Widget? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[label!, space],
        child,
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            height:
                (MeragiTheme.of(context).token.bodyTextStyle.fontSize ?? 1) *
                    1.4,
          ),
          if (error != null) error!
        ]),
      ],
    );
  }
}
