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
  });

  final Widget? title;
  final Widget? description;
  final Widget? child;
  final Widget? footer;
  final double? height;
  final double? width;

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
          child: SizedBox(
            width: width ?? 350,
            height: height,
            child: MDPanel(
              title: title,
              description: description,
              footer: footer,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
