import 'package:flutter/material.dart';

// HSV (Hue, Saturation, Value) Color
class HSVColor {
  final double h, s, v;

  HSVColor(this.h, this.s, this.v);

  Color toColor() {
    return HSVColor.fromAHSV(1.0, h, s, v);
  }

  static HSVColor fromColor(Color color) {
    return HSVColor(
      HSVColor.getHue(color),
      HSVColor.getSaturation(color),
      HSVColor.getValue(color),
    );
  }

  // The following methods are adaptations of the Android SDK's Color class methods.
  static double getHue(Color color) {
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    final int V = r > g ? (r > b ? r : b) : (g > b ? g : b);
    final int temp = r < g ? (r < b ? r : b) : (g < b ? g : b);

    double H;

    if (V == temp) {
      H = 0;
    } else {
      final double vtemp = (V - temp).toDouble();
      final double cr = (V - r) / vtemp;
      final double cg = (V - g) / vtemp;
      final double cb = (V - b) / vtemp;

      if (V == r) {
        H = cb - cg;
      } else if (V == g) {
        H = 2 + cr - cb;
      } else {
        H = 4 + cg - cr;
      }

      H = H * 60;
      if (H < 0) {
        H = H + 360;
      }
    }
    return H;
  }

  static double getSaturation(Color color) {
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    final int V = r > g ? (r > b ? r : b) : (g > b ? g : b);
    final int temp = r < g ? (r < b ? r : b) : (g < b ? g : b);

    double S;

    if (V == temp) {
      S = 0;
    } else {
      S = (V - temp) / V.toDouble();
    }

    return S;
  }

  static double getValue(Color color) {
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    final int V = r > g ? (r > b ? r : b) : (g > b ? g : b);
    return V / 255.0;
  }

  static Color fromAHSV(
      double alpha, double hue, double saturation, double value) {
    final double H = hue;
    final double S = saturation;
    final double V = value;

    double R, G, B;

    if (S == 0) {
      R = G = B = V;
    } else {
      double h = (H / 60);
      int i = h.floor();
      double f = h - i;
      double p = V * (1 - S);
      double q = V * (1 - S * f);
      double t = V * (1 - S * (1 - f));

      switch (i) {
        case 0:
          R = V;
          G = t;
          B = p;
          break;
        case 1:
          R = q;
          G = V;
          B = p;
          break;
        case 2:
          R = p;
          G = V;
          B = t;
          break;
        case 3:
          R = p;
          G = q;
          B = V;
          break;
        case 4:
          R = t;
          G = p;
          B = V;
          break;
        default:
          R = V;
          G = p;
          B = q;
      }
    }

    return Color.fromARGB(
      (alpha * 255).round(),
      (R * 255).round(),
      (G * 255).round(),
      (B * 255).round(),
    );
  }
}
