import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/utils/platform.dart';

showMDDateRangePicker({
  required BuildContext context,
  DateTimeRange? initialDateRange,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? fieldStartLabelText,
  String? fieldEndLabelText,
  TextInputType? keyboardType,
  Offset? anchorPoint,
}) {
  return showDateRangePicker(
    context: context,
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    locale: locale,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    textDirection: textDirection,
    builder: (context, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ScreenUtil(context).isSmMd ? 500.0 : 400.0,
            ),
            child: Theme(
              data: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                datePickerTheme: DatePickerThemeData(
                  backgroundColor: Colors.white,
                  headerBackgroundColor: Colors.deepPurple.shade300.withOpacity(.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dividerColor: Colors.deepPurple.shade300.withOpacity(.3),
                ),
              ),
              child: child!,
            ),
          ),
        ],
      );
    },
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldStartHintText: fieldStartHintText,
    fieldEndHintText: fieldEndHintText,
    fieldStartLabelText: fieldStartLabelText,
    fieldEndLabelText: fieldEndLabelText,
    keyboardType: keyboardType = TextInputType.datetime,
    anchorPoint: anchorPoint,
    initialEntryMode: DatePickerEntryMode.calendar,
  );
}