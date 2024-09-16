import 'package:intl/intl.dart';

String toINR(num number, {showDecimal = false}) {
  return NumberFormat.currency(
          locale: 'en_IN', symbol: '₹', decimalDigits: showDecimal ? 2 : 0)
      .format(number);
}
