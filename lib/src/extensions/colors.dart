import 'package:flutter/material.dart';

/// Darken a color by [percent] amount (100 = black)
// ........................................................
Color darkenColor(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

extension DarkenColor on Color {
  Color darken([int percent = 10]) => darkenColor(this, percent);
}

/// Lighten a color by [percent] amount (100 = white)
// ........................................................
Color lightenColor(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}

extension LightenColor on Color {
  Color lighten([int percent = 10]) => lightenColor(this, percent);
}
