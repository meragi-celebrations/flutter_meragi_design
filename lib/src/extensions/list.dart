import 'package:flutter/material.dart';

extension ListSpaceBetweenExtension on List<Widget> {
  List<Widget> withSpaceBetween({double? width, double? height}) => [
        for (int i = 0; i < length; i++) ...[
          if (i > 0) SizedBox(width: width, height: height),
          this[i],
        ],
      ];
  List<Widget> withDividerBetween(
          {Widget divider = const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Divider(
              color: Color(0xFFE9E9E9),
              height: 0.8,
              thickness: 0.8,
            ),
          )}) =>
      [
        for (int i = 0; i < length; i++) ...[
          if (i > 0) divider,
          this[i],
        ],
      ];
}
