import 'package:flutter/material.dart';

class ColorOption {
  final Color color;
  final String name;

  ColorOption(this.color, this.name);

  static final List<ColorOption> availableColors = [
    ColorOption(Colors.white, "White"),
    ColorOption(Color(0xffff9696), "Red"),
    ColorOption(Colors.greenAccent, "Green"),
    ColorOption(Colors.lightBlueAccent, "Blue"),
    ColorOption(Color(0xFFFFFFA0), "Yellow"),
    ColorOption(Color(0xffe380ff), "Purple"),
    ColorOption(Colors.orangeAccent, "Orange"),
    ColorOption(Colors.white38, "Grey"),
  ];

  static final Map<String, Color> colorMap = {
    for (var option in availableColors) option.name: option.color,
  };

  static Color getColorByName(String? name) {
    return colorMap[name] ?? Colors.white;
  }

}
