import 'package:sprintf/sprintf.dart';

extension Interpolate on String {
  String format(List<dynamic> args) => sprintf(this, args);
}
