import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Displays an alert dialog with a custom content.
///
/// The alert dialog is created using the [showDialog] function and is not
/// dismissible by tapping outside of the dialog.
///
/// The [context] parameter is the build context in which the dialog is shown.
///
/// The [builder] parameter is a callback that builds the content of the dialog.
///
/// Returns a [Future] that resolves to the value returned by the dialog's
/// [Navigator.pop] function, or null if the dialog is dismissed without
/// returning a value.
Future<T?> showMDAlertDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showDialog<T>(
    context: context,
    builder: builder,
    barrierDismissible: false,
  );
}

/// A header widget for the alert dialog that displays a title, optional icon, and description.
class AlertHeader extends StatelessWidget {
  const AlertHeader({
    super.key,
    required this.title,
    this.description,
    this.icon,
  });

  final String title;
  final String? description;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final dims = context.theme.dimensions;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(dims.padding).copyWith(left: icon != null ? 80.0 : dims.padding),
              decoration: BoxDecoration(
                color: context.theme.colors.background.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(dims.radius),
                  topRight: Radius.circular(dims.radius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.theme.fonts.heading.medium),
                  if (description != null && description!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: dims.padding / 4),
                      child: Text(
                        description!,
                        style: context.theme.fonts.paragraph.medium.copyWith(
                          color: context.theme.colors.content.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (icon != null)
          Positioned(
            left: dims.padding,
            top: dims.padding,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                color: context.theme.colors.background.primary.withOpacity(0.6),
              ),
              child: Icon(
                icon,
                size: 24,
                color: context.theme.colors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

/// A basic alert dialog with a header, content, and automatically configured buttons.
///
/// The dialog will automatically show buttons based on the provided callbacks:
/// - If [onOk] is provided, an OK button will be shown
/// - If [onCancel] is provided, a Cancel button will be shown
/// - If [onBack] is provided, a Back button will be shown
///
/// The buttons will use default text unless overridden by [okText], [cancelText], or [backText].
class MDAlertDialog extends StatelessWidget {
  const MDAlertDialog({
    super.key,
    this.header,
    required this.content,
    this.onOk,
    this.onCancel,
    this.onBack,
    this.okText,
    this.cancelText,
    this.backText,
    this.okButtonType = ButtonType.primary,
    this.width = 350,
    this.decoration,
    this.backgroundColor,
    this.surfaceTintColor,
    this.insetPadding,
    this.borderRadius,
    this.scrollableContent = true,
  });

  final Widget? header;
  final Widget content;

  // Button callbacks - if provided, corresponding button will be shown
  final VoidCallback? onOk;
  final VoidCallback? onCancel;
  final VoidCallback? onBack;

  // Optional button text overrides
  final String? okText;
  final String? cancelText;
  final String? backText;

  // Button styling
  final ButtonType okButtonType;

  // Layout and styling
  final double width;
  final CardDecoration? decoration;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final EdgeInsets? insetPadding;
  final double? borderRadius;
  final bool scrollableContent;

  @override
  Widget build(BuildContext context) {
    final dims = context.theme.dimensions;
    final effectiveBorderRadius = borderRadius ?? dims.radius;

    final cardDecoration = CardDecoration(
      context: context,
      type: CardType.defaultType,
      borderRadiusOverride: effectiveBorderRadius,
    ).merge(decoration);

    // Calculate max height based on screen size
    final double maxDialogHeight = MediaQuery.of(context).size.height * 0.95;

    return Shortcuts(
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.escape): VoidCallbackIntent(
          () => handleOnCancel(context),
        ),
        const SingleActivator(LogicalKeyboardKey.enter): VoidCallbackIntent(
          () {
            handleOnOk();
          },
        ),
      },
      child: Focus(
        autofocus: true,
        child: Dialog(
          backgroundColor: backgroundColor,
          surfaceTintColor: surfaceTintColor,
          insetPadding: insetPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: maxDialogHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (header != null) header!,
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(dims.padding),
                    child: scrollableContent ? SingleChildScrollView(child: content) : content,
                  ),
                ),
                if (onOk != null || onCancel != null || onBack != null) _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final dims = context.theme.dimensions;

    return Padding(
      padding: EdgeInsets.all(dims.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onBack != null)
            MDButton(
              decoration: ButtonDecoration(
                context: context,
                type: ButtonType.standard,
              ),
              onTap: onBack,
              child: Text(backText ?? "Back"),
            ),
          if (onBack != null) SizedBox(width: dims.padding / 2),
          if (onCancel != null)
            MDTap.destructive(
              onPressed: onCancel ?? () => Navigator.pop(context),
              child: Text(cancelText ?? "Cancel"),
            ),
          if (onCancel != null) SizedBox(width: dims.padding / 2),
          if (onOk != null)
            MDTap(
              onPressed: handleOnOk,
              child: Text(okText ?? "OK"),
            ),
        ],
      ),
    );
  }

  void handleOnOk() {
    onOk?.call();
  }

  void handleOnCancel(BuildContext context) {
    onCancel ?? Navigator.pop(context);
  }
}
