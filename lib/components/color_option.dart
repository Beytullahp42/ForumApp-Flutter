import 'package:flutter/material.dart';

class ColorOption {
  final Color color;
  final String name;

  ColorOption(this.color, this.name);

  static final List<ColorOption> availableColors = [
    ColorOption(Colors.white, "White"),
    ColorOption(Colors.redAccent, "Red"),
    ColorOption(Colors.greenAccent, "Green"),
    ColorOption(Colors.blueAccent, "Blue"),
    ColorOption(Colors.yellowAccent, "Yellow"),
    ColorOption(Colors.purpleAccent, "Purple"),
    ColorOption(Colors.orangeAccent, "Orange"),
    ColorOption(Colors.grey, "Grey"),
  ];

  static final Map<String, Color> colorMap = {
    for (var option in availableColors) option.name: option.color,
  };

  static Color getColorByName(String? name) {
    return colorMap[name] ?? Colors.white;
  }

}
