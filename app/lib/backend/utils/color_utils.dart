import 'dart:math';

import 'package:flutter/material.dart';
import 'package:color_palette_generator/color_palette_generator.dart';
import 'package:material_color_generator/material_color_generator.dart';

import '../../themes.dart';



class ColorPaletteData {

  late ColorPalette palette;

  int colorCount = 0;
  
  List<String> asStrings    = [];
  List<Color>  asColors     = [];
  List<String> asHtmlColors = [];

}

ColorPalette generateColorPalette(List<String> htmlColors, int outputColorCount) {

  ColorPalette basic = ColorPalette.from(htmlColors);
  ColorGeneratorFromBasicPalette generator = ColorGeneratorFromBasicPalette(basic);
  ColorPalette exp = generator.generatePaletteAsColorPalette(outputColorCount);

  return exp;

}

List<String> colorPaletteToStringList(ColorPalette palette) {

  List<String> list = palette.toString()
    .replaceAll('[', '')
    .replaceAll(']', '')
    .split(',')
    .map((s) => s.trim()) // clean whitespace
    .toList();

  return list;
}

ColorPaletteData generateRandomColorPalette(int outputColorCount) {
  
  Random random = Random();

  ColorPaletteData data = ColorPaletteData();
  data.colorCount = outputColorCount;

  int minimumBrightness = 100;
  int maximumBrightness = 255;

  if (isThemeBright()) {
    minimumBrightness = 150;
    maximumBrightness = 255;
  }

  for (int i = 0; i < outputColorCount; i++) {
    int r = minimumBrightness + random.nextInt(maximumBrightness - minimumBrightness);
    int g = minimumBrightness + random.nextInt(maximumBrightness - minimumBrightness);
    int b = minimumBrightness + random.nextInt(maximumBrightness - minimumBrightness);

    data.asColors.add(Color.fromARGB(255, r, g, b));
    data.asHtmlColors.add("rgba($r, $g, $b, 1.0)");
  }

  data.palette = generateColorPalette(
    data.asHtmlColors,
    outputColorCount 
  );

  data.asStrings = colorPaletteToStringList(data.palette);
  
  return data;
}

Paint paletteToPaintGradient(ColorPaletteData paletteData) {
  Paint paint = Paint();

  LinearGradient gradient = LinearGradient(
    colors: paletteData.asColors,
  );

  Shader shader = gradient.createShader(const Rect.fromLTWH(0, 0, 200, 70));

  paint.shader = shader;

  return paint;
}

ShaderMask paletteGradientShaderMask(ColorPaletteData paletteData, Widget child) {

  LinearGradient gradient = LinearGradient(
    colors: paletteData.asColors,
  );

  ShaderMask mask = ShaderMask(
    shaderCallback: (bounds) {
      Shader shader = gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      return shader;
    },
    child: child
  );

  return mask;
}

MaterialColor generateMaterialColorData(Color color) {

  MaterialColor materialColor = generateMaterialColor(color: color);

  return materialColor;
}
