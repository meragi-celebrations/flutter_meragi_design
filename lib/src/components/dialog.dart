import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class MDDialog extends StatelessWidget {
  const MDDialog({
    super.key,
    this.title,
    this.description,
    this.child,
    this.footer,
    this.height,
    this.width,
    this.showCloseButton = true,
    this.closeButton,
  });

  final Widget? title;
  final Widget? description;
  final Widget? child;
  final Widget? footer;
  final double? height;
  final double? width;
  final bool showCloseButton;
  final Widget? closeButton;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.escape): VoidCallbackIntent(
          () => Navigator.of(context).pop(),
        ),
      },
      child: Focus(
        autofocus: true,
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: width ?? 350,
                height: height,
                child: MDPanel(
                  title: title,
                  description: description,
                  footer: footer,
                  child: child,
                ),
              ),
              if (showCloseButton)
                Positioned(
                  top: 0,
                  right: 0,
                  child: closeButton ??
                      MDTap.ghost(
                        onPressed: () => Navigator.of(context).pop(),
                        iconData: PhosphorIconsRegular.x,
                        foregroundColor: context.theme.colors.primaryB,
                      ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
