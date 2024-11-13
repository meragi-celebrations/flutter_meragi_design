import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class MDModal extends StatelessWidget {
  final ModalHeader header;
  final Widget body;
  final ModalFooter footer;
  final double widthFactor;
  final bool showCloseButton;

  const MDModal._({
    Key? key,
    required this.header,
    required this.body,
    required this.footer,
    this.showCloseButton = true,
    this.widthFactor = 0.5,
  }) : super(key: key);

  // Default constructor (medium size)
  factory MDModal({
    Key? key,
    required ModalHeader header,
    required Widget bodyContent,
    required ModalFooter footer,
    bool showCloseButton = true,
    double widthFactor = 0.5,
  }) {
    return MDModal._(
      key: key,
      header: header,
      footer: footer,
      body: bodyContent,
      showCloseButton: showCloseButton,
      widthFactor: widthFactor, // Default to medium size: 50% of screen width
    );
  }

  // Factory constructor for small modal
  factory MDModal.sm({
    Key? key,
    required ModalHeader header,
    required Widget bodyContent,
    required ModalFooter footer,
    bool showCloseButton = true,
  }) {
    return MDModal._(
      key: key,
      header: header,
      footer: footer,
      body: bodyContent,
      showCloseButton: showCloseButton,
      widthFactor: 0.4, // Small size: 40% of screen width
    );
  }

  // Factory constructor for large modal
  factory MDModal.lg({
    Key? key,
    required ModalHeader header,
    required Widget bodyContent,
    required ModalFooter footer,
    bool showCloseButton = true,
  }) {
    return MDModal._(
      key: key,
      header: header,
      footer: footer,
      body: bodyContent,
      showCloseButton: showCloseButton,
      widthFactor: 0.8, // Large size: 80% of screen width
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double modalWidth = screenWidth * widthFactor;

    return Dialog(
      backgroundColor: MeragiTheme.of(context).token.defaultCardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0), // Added outer padding for better spacing
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: modalWidth, // Limit the width based on widthFactor
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const SizedBox(height: 22.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: body,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              footer,
            ],
          ),
        ),
      ),
    );
  }
}

class ModalHeader extends StatelessWidget {
  final String title;
  final String? description;
  final IconData? icon;
  final VoidCallback? onClose;

  const ModalHeader({
    Key? key,
    required this.title,
    this.description,
    this.icon,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.all(8.0).copyWith(left: 100.0, top: 14.0),
              decoration: BoxDecoration(
                  color: MeragiTheme.of(context).token.primaryCardBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  )),
              child: Text(
                title,
                style: MeragiTheme.of(context).token.h3TextStyle.copyWith(
                      color: MeragiTheme.of(context).token.primaryTextColor,
                    ),
              ),
            ),
            if (description != null && description!.isNotEmpty) // Validate description
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(left: 100.0, top: 16.0),
                  child: Text(
                    description!,
                    style: MeragiTheme.of(context).token.h5TextStyle.copyWith(
                          color: MeragiTheme.of(context).token.defaultTextColor,
                        ),
                  ),
                ),
              ),
          ],
        ),
        // Circular Icon Positioned Over the Header
        Positioned(
          left: 16, // Adjust the position of the icon
          top: 15, // Lift the icon above the header
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3.0,
              ),
              color: MeragiTheme.of(context).token.primaryCardBackgroundColor.withOpacity(0.6),
            ),
            child: Icon(
              icon ?? PhosphorIconsRegular.info, // Default icon
              size: 28,
              color: MeragiTheme.of(context).token.primaryButtonColor,
            ),
          ),
        ),
        if (onClose != null)
          Positioned(
            right: 16,
            top: 6,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose,
              color: MeragiTheme.of(context).token.errorTextColor,
            ),
          ),
      ],
    );
  }
}

class ModalFooter extends StatelessWidget {
  final VoidCallback onDone;
  final VoidCallback? onCancel;
  final String doneButtonText;
  final String? cancelButtonText;

  const ModalFooter({
    Key? key,
    required this.onDone,
    this.onCancel,
    this.doneButtonText = 'Done',
    this.cancelButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (cancelButtonText != null)
            MDButton(
              onTap: onCancel ?? () => Navigator.of(context).pop(),
              decoration: ButtonDecoration(
                context: context,
                variant: ButtonVariant.ghost,
                type: ButtonType.secondary,
              ),
              child: Text(cancelButtonText!),
            ),
          const SizedBox(width: 8.0),
          MDButton(
            onTap: onDone,
            decoration: ButtonDecoration(
              context: context,
              variant: ButtonVariant.filled,
              type: ButtonType.primary,
            ),
            child: Text(doneButtonText),
          ),
        ],
      ),
    );
  }
}