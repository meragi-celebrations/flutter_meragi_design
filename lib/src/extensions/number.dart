import 'package:flutter_meragi_design/src/utils/currency.dart';

extension ToINR on num {
  String inr({showDecimal = false}) => toINR(this, showDecimal: showDecimal);
}
