import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// A material design calendar.
/// https://flutter-shadcn-ui.mariuti.com/components/calendar/
///
/// This calendar component allows for single, multiple, and range selections.
class MDCalendar extends StatelessWidget {
  const MDCalendar({
    Key? key,
    this.selected,
    this.onChanged,
    this.showOutsideDays,
    this.initialMonth,
    this.formatMonthYear,
    this.formatMonth,
    this.formatYear,
    this.formatWeekday,
    this.showWeekNumbers,
    this.weekStartsOn,
    this.fixedWeeks,
    this.hideWeekdayNames,
    this.numberOfMonths = 1,
    this.fromMonth,
    this.toMonth,
    this.onMonthChanged,
    this.reverseMonths = false,
    this.selectableDayPredicate,
    this.captionLayout,
    this.hideNavigation,
    this.yearSelectorMinWidth,
    this.monthSelectorMinWidth,
    this.yearSelectorPadding,
    this.monthSelectorPadding,
    this.navigationButtonSize,
    this.navigationButtonIconSize,
    this.backNavigationButtonSrc,
    this.forwardNavigationButtonSrc,
    this.navigationButtonPadding,
    this.navigationButtonDisabledOpacity,
    this.decoration,
    this.spacingBetweenMonths,
    this.runSpacingBetweenMonths,
    this.monthConstraints,
    this.headerHeight,
    this.headerPadding,
    this.captionLayoutGap,
    this.headerTextStyle,
    this.weekdaysPadding,
    this.weekdaysTextStyle,
    this.weekdaysTextAlign,
    this.weekNumbersHeaderText,
    this.weekNumbersHeaderTextStyle,
    this.weekNumbersTextStyle,
    this.weekNumbersTextAlign,
    this.dayButtonSize,
    this.dayButtonOutsideMonthOpacity,
    this.dayButtonPadding,
    this.dayButtonDecoration,
    this.selectedDayButtonTextStyle,
    this.insideRangeDayButtonTextStyle,
    this.dayButtonTextStyle,
    this.dayButtonVariant,
    this.selectedDayButtonVariant,
    this.insideRangeDayButtonVariant,
    this.todayButtonVariant,
    this.gridMainAxisSpacing,
    this.gridCrossAxisSpacing,
    this.dayButtonOutsideMonthTextStyle,
    this.dayButtonOutsideMonthVariant,
    this.selectedDayButtonOusideMonthVariant,
    this.allowDeselection,
  })  : variant = ShadCalendarVariant.single,
        multipleSelected = null,
        onMultipleChanged = null,
        min = null,
        max = null,
        onRangeChanged = null,
        selectedRange = null,
        super(key: key);

  const MDCalendar.multiple({
    Key? key,
    List<DateTime>? selected,
    ValueChanged<List<DateTime>>? onChanged,
    this.showOutsideDays,
    this.initialMonth,
    this.formatMonthYear,
    this.formatMonth,
    this.formatYear,
    this.formatWeekday,
    this.showWeekNumbers,
    this.weekStartsOn,
    this.fixedWeeks,
    this.hideWeekdayNames,
    this.numberOfMonths = 1,
    this.fromMonth,
    this.toMonth,
    this.onMonthChanged,
    this.reverseMonths = false,
    this.min,
    this.max,
    this.selectableDayPredicate,
    this.captionLayout,
    this.hideNavigation,
    this.yearSelectorMinWidth,
    this.monthSelectorMinWidth,
    this.yearSelectorPadding,
    this.monthSelectorPadding,
    this.navigationButtonSize,
    this.navigationButtonIconSize,
    this.backNavigationButtonSrc,
    this.forwardNavigationButtonSrc,
    this.navigationButtonPadding,
    this.navigationButtonDisabledOpacity,
    this.decoration,
    this.spacingBetweenMonths,
    this.runSpacingBetweenMonths,
    this.monthConstraints,
    this.headerHeight,
    this.headerPadding,
    this.captionLayoutGap,
    this.headerTextStyle,
    this.weekdaysPadding,
    this.weekdaysTextStyle,
    this.weekdaysTextAlign,
    this.weekNumbersHeaderText,
    this.weekNumbersHeaderTextStyle,
    this.weekNumbersTextStyle,
    this.weekNumbersTextAlign,
    this.dayButtonSize,
    this.dayButtonOutsideMonthOpacity,
    this.dayButtonPadding,
    this.dayButtonDecoration,
    this.selectedDayButtonTextStyle,
    this.insideRangeDayButtonTextStyle,
    this.dayButtonTextStyle,
    this.dayButtonVariant,
    this.selectedDayButtonVariant,
    this.insideRangeDayButtonVariant,
    this.todayButtonVariant,
    this.gridMainAxisSpacing,
    this.gridCrossAxisSpacing,
    this.dayButtonOutsideMonthTextStyle,
    this.dayButtonOutsideMonthVariant,
    this.selectedDayButtonOusideMonthVariant,
  })  : variant = ShadCalendarVariant.multiple,
        multipleSelected = selected,
        selected = null,
        onMultipleChanged = onChanged,
        onChanged = null,
        onRangeChanged = null,
        selectedRange = null,
        allowDeselection = null,
        super(key: key);

  const MDCalendar.range({
    Key? key,
    ShadDateTimeRange? selected,
    ValueChanged<ShadDateTimeRange?>? onChanged,
    this.showOutsideDays,
    this.initialMonth,
    this.formatMonthYear,
    this.formatMonth,
    this.formatYear,
    this.formatWeekday,
    this.showWeekNumbers = false,
    this.weekStartsOn,
    this.fixedWeeks,
    this.hideWeekdayNames,
    this.numberOfMonths = 1,
    this.fromMonth,
    this.toMonth,
    this.onMonthChanged,
    this.reverseMonths = false,
    this.min,
    this.max,
    this.selectableDayPredicate,
    this.captionLayout,
    this.hideNavigation,
    this.yearSelectorMinWidth,
    this.monthSelectorMinWidth,
    this.yearSelectorPadding,
    this.monthSelectorPadding,
    this.navigationButtonSize,
    this.navigationButtonIconSize,
    this.backNavigationButtonSrc,
    this.forwardNavigationButtonSrc,
    this.navigationButtonPadding,
    this.navigationButtonDisabledOpacity,
    this.decoration,
    this.spacingBetweenMonths,
    this.runSpacingBetweenMonths,
    this.monthConstraints,
    this.headerHeight,
    this.headerPadding,
    this.captionLayoutGap,
    this.headerTextStyle,
    this.weekdaysPadding,
    this.weekdaysTextStyle,
    this.weekdaysTextAlign,
    this.weekNumbersHeaderText,
    this.weekNumbersHeaderTextStyle,
    this.weekNumbersTextStyle,
    this.weekNumbersTextAlign,
    this.dayButtonSize,
    this.dayButtonOutsideMonthOpacity,
    this.dayButtonPadding,
    this.dayButtonDecoration,
    this.selectedDayButtonTextStyle,
    this.insideRangeDayButtonTextStyle,
    this.dayButtonTextStyle,
    this.dayButtonVariant,
    this.selectedDayButtonVariant,
    this.insideRangeDayButtonVariant,
    this.todayButtonVariant,
    this.gridMainAxisSpacing,
    this.gridCrossAxisSpacing,
    this.dayButtonOutsideMonthTextStyle,
    this.dayButtonOutsideMonthVariant,
    this.selectedDayButtonOusideMonthVariant,
  })  : variant = ShadCalendarVariant.range,
        multipleSelected = null,
        selected = null,
        onMultipleChanged = null,
        onChanged = null,
        selectedRange = selected,
        onRangeChanged = onChanged,
        allowDeselection = null,
        super(key: key);

  const MDCalendar.raw({
    Key? key,
    required this.variant,
    this.selected,
    this.multipleSelected,
    this.onChanged,
    this.onMultipleChanged,
    this.showOutsideDays,
    this.initialMonth,
    this.formatMonthYear,
    this.formatMonth,
    this.formatYear,
    this.formatWeekday,
    this.showWeekNumbers,
    this.weekStartsOn,
    this.fixedWeeks,
    this.hideWeekdayNames,
    this.numberOfMonths = 1,
    this.fromMonth,
    this.toMonth,
    this.onMonthChanged,
    this.reverseMonths = false,
    this.min,
    this.max,
    this.selectableDayPredicate,
    this.onRangeChanged,
    this.selectedRange,
    this.captionLayout,
    this.hideNavigation,
    this.yearSelectorMinWidth,
    this.monthSelectorMinWidth,
    this.yearSelectorPadding,
    this.monthSelectorPadding,
    this.navigationButtonSize,
    this.navigationButtonIconSize,
    this.backNavigationButtonSrc,
    this.forwardNavigationButtonSrc,
    this.navigationButtonPadding,
    this.navigationButtonDisabledOpacity,
    this.decoration,
    this.spacingBetweenMonths,
    this.runSpacingBetweenMonths,
    this.monthConstraints,
    this.headerHeight,
    this.headerPadding,
    this.captionLayoutGap,
    this.headerTextStyle,
    this.weekdaysPadding,
    this.weekdaysTextStyle,
    this.weekdaysTextAlign,
    this.weekNumbersHeaderText,
    this.weekNumbersHeaderTextStyle,
    this.weekNumbersTextStyle,
    this.weekNumbersTextAlign,
    this.dayButtonSize,
    this.dayButtonOutsideMonthOpacity,
    this.dayButtonPadding,
    this.dayButtonDecoration,
    this.selectedDayButtonTextStyle,
    this.insideRangeDayButtonTextStyle,
    this.dayButtonTextStyle,
    this.dayButtonVariant,
    this.selectedDayButtonVariant,
    this.insideRangeDayButtonVariant,
    this.todayButtonVariant,
    this.gridMainAxisSpacing,
    this.gridCrossAxisSpacing,
    this.dayButtonOutsideMonthTextStyle,
    this.dayButtonOutsideMonthVariant,
    this.selectedDayButtonOusideMonthVariant,
    this.allowDeselection,
  }) : super(key: key);

  final ShadCalendarVariant variant;
  final DateTime? selected;
  final List<DateTime>? multipleSelected;
  final ValueChanged<DateTime?>? onChanged;
  final ValueChanged<List<DateTime>>? onMultipleChanged;
  final bool? showOutsideDays;
  final DateTime? initialMonth;
  final String Function(DateTime date)? formatMonthYear;
  final String Function(DateTime date)? formatMonth;
  final String Function(DateTime date)? formatYear;
  final String Function(DateTime date)? formatWeekday;
  final bool? showWeekNumbers;
  final int? weekStartsOn;
  final bool? fixedWeeks;
  final bool? hideWeekdayNames;
  final int numberOfMonths;
  final DateTime? fromMonth;
  final DateTime? toMonth;
  final ValueChanged<DateTime>? onMonthChanged;
  final bool reverseMonths;
  final int? min;
  final int? max;
  final SelectableDayPredicate? selectableDayPredicate;
  final ShadDateTimeRange? selectedRange;
  final ValueChanged<ShadDateTimeRange?>? onRangeChanged;
  final ShadCalendarCaptionLayout? captionLayout;
  final bool? hideNavigation;
  final double? yearSelectorMinWidth;
  final double? monthSelectorMinWidth;
  final EdgeInsets? yearSelectorPadding;
  final EdgeInsets? monthSelectorPadding;
  final double? navigationButtonSize;
  final double? navigationButtonIconSize;
  final ShadImageSrc? backNavigationButtonSrc;
  final ShadImageSrc? forwardNavigationButtonSrc;
  final EdgeInsets? navigationButtonPadding;
  final double? navigationButtonDisabledOpacity;
  final ShadDecoration? decoration;
  final double? spacingBetweenMonths;
  final double? runSpacingBetweenMonths;
  final BoxConstraints? monthConstraints;
  final double? headerHeight;
  final EdgeInsets? headerPadding;
  final double? captionLayoutGap;
  final TextStyle? headerTextStyle;
  final EdgeInsets? weekdaysPadding;
  final TextStyle? weekdaysTextStyle;
  final TextAlign? weekdaysTextAlign;
  final String? weekNumbersHeaderText;
  final TextStyle? weekNumbersHeaderTextStyle;
  final TextStyle? weekNumbersTextStyle;
  final TextAlign? weekNumbersTextAlign;
  final double? dayButtonSize;
  final double? dayButtonOutsideMonthOpacity;
  final EdgeInsets? dayButtonPadding;
  final ShadDecoration? dayButtonDecoration;
  final TextStyle? selectedDayButtonTextStyle;
  final TextStyle? insideRangeDayButtonTextStyle;
  final TextStyle? dayButtonTextStyle;
  final ShadButtonVariant? dayButtonVariant;
  final ShadButtonVariant? selectedDayButtonVariant;
  final ShadButtonVariant? insideRangeDayButtonVariant;
  final ShadButtonVariant? todayButtonVariant;
  final double? gridMainAxisSpacing;
  final double? gridCrossAxisSpacing;
  final TextStyle? dayButtonOutsideMonthTextStyle;
  final ShadButtonVariant? dayButtonOutsideMonthVariant;
  final ShadButtonVariant? selectedDayButtonOusideMonthVariant;
  final bool? allowDeselection;

  @override
  Widget build(BuildContext context) {
    return ShadCalendar.raw(
      variant: variant,
      selected: selected,
      multipleSelected: multipleSelected,
      onChanged: onChanged,
      onMultipleChanged: onMultipleChanged,
      showOutsideDays: showOutsideDays,
      initialMonth: initialMonth,
      formatMonthYear: formatMonthYear,
      formatMonth: formatMonth,
      formatYear: formatYear,
      formatWeekday: formatWeekday,
      showWeekNumbers: showWeekNumbers,
      weekStartsOn: weekStartsOn,
      fixedWeeks: fixedWeeks,
      hideWeekdayNames: hideWeekdayNames,
      numberOfMonths: numberOfMonths,
      fromMonth: fromMonth,
      toMonth: toMonth,
      onMonthChanged: onMonthChanged,
      reverseMonths: reverseMonths,
      min: min,
      max: max,
      selectableDayPredicate: selectableDayPredicate,
      onRangeChanged: onRangeChanged,
      selectedRange: selectedRange,
      captionLayout: captionLayout,
      hideNavigation: hideNavigation,
      yearSelectorMinWidth: yearSelectorMinWidth,
      monthSelectorMinWidth: monthSelectorMinWidth,
      yearSelectorPadding: yearSelectorPadding,
      monthSelectorPadding: monthSelectorPadding,
      navigationButtonSize: navigationButtonSize,
      navigationButtonIconSize: navigationButtonIconSize,
      backNavigationButtonSrc: backNavigationButtonSrc,
      forwardNavigationButtonSrc: forwardNavigationButtonSrc,
      navigationButtonPadding: navigationButtonPadding,
      navigationButtonDisabledOpacity: navigationButtonDisabledOpacity,
      decoration: decoration,
      spacingBetweenMonths: spacingBetweenMonths,
      runSpacingBetweenMonths: runSpacingBetweenMonths,
      monthConstraints: monthConstraints,
      headerHeight: headerHeight,
      headerPadding: headerPadding,
      captionLayoutGap: captionLayoutGap,
      headerTextStyle: headerTextStyle,
      weekdaysPadding: weekdaysPadding,
      weekdaysTextStyle: weekdaysTextStyle,
      weekdaysTextAlign: weekdaysTextAlign,
      weekNumbersHeaderText: weekNumbersHeaderText,
      weekNumbersHeaderTextStyle: weekNumbersHeaderTextStyle,
      weekNumbersTextStyle: weekNumbersTextStyle,
      weekNumbersTextAlign: weekNumbersTextAlign,
      dayButtonSize: dayButtonSize,
      dayButtonOutsideMonthOpacity: dayButtonOutsideMonthOpacity,
      dayButtonPadding: dayButtonPadding,
      dayButtonDecoration: dayButtonDecoration,
      selectedDayButtonTextStyle: selectedDayButtonTextStyle,
      insideRangeDayButtonTextStyle: insideRangeDayButtonTextStyle,
      dayButtonTextStyle: dayButtonTextStyle,
      dayButtonVariant: dayButtonVariant,
      selectedDayButtonVariant: selectedDayButtonVariant,
      insideRangeDayButtonVariant: insideRangeDayButtonVariant,
      todayButtonVariant: todayButtonVariant,
      gridMainAxisSpacing: gridMainAxisSpacing,
      gridCrossAxisSpacing: gridCrossAxisSpacing,
      dayButtonOutsideMonthTextStyle: dayButtonOutsideMonthTextStyle,
      dayButtonOutsideMonthVariant: dayButtonOutsideMonthVariant,
      selectedDayButtonOusideMonthVariant: selectedDayButtonOusideMonthVariant,
      allowDeselection: allowDeselection,
    );
  }
}
