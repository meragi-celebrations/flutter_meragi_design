import 'package:intl/intl.dart';

String toINR(num number) {
  return NumberFormat.currency(locale: 'en_IN', symbol: '₹').format(number);
}
