import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

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

/// A basic alert dialog with a title, content, and one or two buttons.
///
/// The title is an optional parameter, and the content is a required parameter.
///
/// The buttons are created using the [MDButton] widget and the [ButtonDecoration]
/// class. The first button is the cancel button and is created using the
/// [ButtonType.standard] type. The second button is the OK button and is created
/// using the [ButtonType.primary] type. If the [isDestructive] parameter is true,
/// the OK button is created using the [ButtonType.danger] type.
///
/// The [onOk] and [onCancel] parameters are callbacks that are called when the
/// respective button is tapped. If the [onCancel] parameter is null, the
/// [Navigator.pop] function is called instead.
///
/// If the [onBack] parameter is not null, a third button is created with the
/// [ButtonType.standard] type and the [backText] parameter as its text. When this
/// button is tapped, the [onBack] callback is called.
///
/// The [width] parameter is the width of the dialog, and the [height] parameter
/// is the height of the dialog. If the [height] parameter is null, the dialog's
/// height is automatically set to fit its content.
///
/// The [type] parameter is the type of the card used to display the content of
/// the dialog. If the [type] parameter is null, the [CardType.defaultType] type
/// is used.
class MDAlertDialog extends StatelessWidget {
  const MDAlertDialog({
    super.key,
    required this.content,
    this.onOk,
    this.title,
    this.okText,
    this.cancelText,
    this.onCancel,
    this.backText,
    this.onBack,
    this.isDestructive = false,
    this.width = 350,
    this.height,
    this.type,
  });

  final String? title;
  final Widget content;
  final String? okText;
  final VoidCallback? onOk;
  final String? cancelText;
  final VoidCallback? onCancel;
  final String? backText;
  final VoidCallback? onBack;
  final bool isDestructive;
  final double width;
  final double? height;
  final CardType? type;

  @override
  Widget build(BuildContext context) {
    final cardDecoration = CardDecoration(
      context: context,
      type: type ?? CardType.defaultType,
    );

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
        child: Center(
          child: SizedBox(
            width: width,
            height: height,
            child: MDCard(
              alignment: CrossAxisAlignment.start,
              decoration: cardDecoration,
              header: Row(
                children: [H4(text: title ?? "Alert")],
              ),
              body: content,
              footer: Row(
                mainAxisAlignment: (onBack == null) ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                children: [
                  MDButton(
                    decoration: ButtonDecoration(
                      context: context,
                      type: ButtonType.standard,
                    ),
                    onTap: () => handleOnCancel(context),
                    child: Text(cancelText ?? "Cancel"),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      (onBack != null)
                          ? Row(
                              children: [
                                MDButton(
                                  decoration: ButtonDecoration(
                                    context: context,
                                    type: ButtonType.standard,
                                  ),
                                  onTap: onBack ?? () {},
                                  child: Text(backText ?? "Back"),
                                ),
                                const SizedBox(width: 5),
                              ],
                            )
                          : const SizedBox.shrink(),
                      MDButton(
                        decoration: ButtonDecoration(
                          context: context,
                          type: isDestructive ? ButtonType.danger : ButtonType.primary,
                        ),
                        onTap: handleOnOk,
                        child: Text(okText ?? (onBack != null ? "Next" : "OK")),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
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
