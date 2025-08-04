import 'package:flutter/material.dart';



class SimplePalette {

  late Color primaryForegroundColor;
  late Color secondaryForegroundColor;
  late Color tertiaryForegroundColor;
  late Color quaternaryForegroundColor;

  late Color primaryBackgroundColor;
  late Color secondaryBackgroundColor;
  late Color tertiaryBackgroundColor;
  
  late Color primaryVividColor;
  late Color secondaryVividColor;
  late Color tertiaryVividColor;

  SimplePalette({
    required this.primaryForegroundColor,
    required this.secondaryForegroundColor,
    required this.tertiaryForegroundColor,
    required this.quaternaryForegroundColor,

    required this.primaryBackgroundColor,
    required this.secondaryBackgroundColor,
    required this.tertiaryBackgroundColor,

    required this.primaryVividColor,
    required this.secondaryVividColor,
    required this.tertiaryVividColor
  });

}

class ThemesPalettes {
  
  static SimplePalette bright = SimplePalette(
    primaryForegroundColor: Colors.black,
    secondaryForegroundColor: Colors.grey[900]!,
    tertiaryForegroundColor: Colors.grey[700]!,
    quaternaryForegroundColor: Colors.grey[400]!,

    primaryBackgroundColor: Colors.white,
    secondaryBackgroundColor: Colors.grey[200]!,
    tertiaryBackgroundColor: Colors.grey[300]!,

    primaryVividColor: Colors.blue,
    secondaryVividColor: Colors.blue[800]!,
    tertiaryVividColor: Colors.blue[900]!
  );

  static SimplePalette dark = SimplePalette(

    primaryForegroundColor: Colors.white,
    secondaryForegroundColor: Colors.grey[100]!,
    tertiaryForegroundColor: Colors.grey[300]!,
    quaternaryForegroundColor: Colors.grey[500]!,

    primaryBackgroundColor: Colors.black,
    secondaryBackgroundColor: Colors.grey[800]!,
    tertiaryBackgroundColor: Colors.grey[900]!,

    primaryVividColor: Colors.purpleAccent,
    secondaryVividColor: Colors.purpleAccent[400]!,
    tertiaryVividColor: Colors.purpleAccent[700]!

  );

  static SimplePalette brightHighContrast = SimplePalette(

    primaryForegroundColor: Colors.black,
    secondaryForegroundColor: Colors.grey[900]!,
    tertiaryForegroundColor: Colors.grey[700]!,
    quaternaryForegroundColor: Colors.grey[400]!,

    primaryBackgroundColor: Colors.black,
    secondaryBackgroundColor: Colors.grey[800]!,
    tertiaryBackgroundColor: Colors.grey[900]!,

    primaryVividColor: Colors.red,
    secondaryVividColor: Colors.red[800]!,
    tertiaryVividColor: Colors.red[900]!

  );

  static SimplePalette darkHighContrast = SimplePalette(

    primaryForegroundColor: Colors.white,
    secondaryForegroundColor: Colors.grey[100]!,
    tertiaryForegroundColor: Colors.grey[200]!,
    quaternaryForegroundColor: Colors.grey[500]!,

    primaryBackgroundColor: Colors.black,
    secondaryBackgroundColor: Colors.grey[800]!,
    tertiaryBackgroundColor: Colors.grey[900]!,

    primaryVividColor: Colors.yellow,
    secondaryVividColor: Colors.yellow[800]!,
    tertiaryVividColor: Colors.yellow[900]!

  );

}

class DefaultColorSchemes {

  static ColorScheme bright = const ColorScheme.light();
  static ColorScheme dark = const ColorScheme.dark();

  static ColorScheme brightHighContrast = const ColorScheme.highContrastLight();
  static ColorScheme darkHighContrast = const ColorScheme.highContrastDark();

}

SimplePalette getCurrentThemePalette(BuildContext context) {

  if (Theme.of(context).colorScheme == DefaultColorSchemes.bright) {
    return ThemesPalettes.bright;
  }
  else if (Theme.of(context).colorScheme == DefaultColorSchemes.dark) {
    return ThemesPalettes.dark;
  }
  else if (Theme.of(context).colorScheme == DefaultColorSchemes.brightHighContrast) {
    return ThemesPalettes.brightHighContrast;
  }
  else if (Theme.of(context).colorScheme == DefaultColorSchemes.darkHighContrast) {
    return ThemesPalettes.darkHighContrast;
  }
    
  return ThemesPalettes.dark;
}

ThemeData brightTheme() {

  ThemeData data = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light()
  );

  return data;
}

ThemeData darkTheme() {

  ThemeData data = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark()
  );

  return data;
}

ThemeData darkThemeHighContrast() {

  ThemeData data = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.highContrastDark()
  );

  return data;
}

ThemeData brightThemeHighContrast() {

  ThemeData data = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.highContrastLight()
  );

  return data;
}