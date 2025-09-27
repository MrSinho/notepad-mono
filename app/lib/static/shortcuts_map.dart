import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../backend/inputs.dart';
import '../backend/color_palette.dart';

import '../themes.dart';



TableRow shortcutRow(BuildContext context, String shortcut, String description) {
  
  TableRow row = TableRow(
    children: [
      Text(
        shortcut,
        style: GoogleFonts.robotoMono(
          fontWeight: FontWeight.bold,
          color: getCurrentThemePalette(context).quaternaryForegroundColor
        )
      ),
      Text(
        description,
        style: TextStyle(
          color: getCurrentThemePalette(context).secondaryForegroundColor
        )
      )
    ]
  );

  return row;
}

void showShortCutsMapBottomSheet(BuildContext context) {
  
  Table navigationTable = Table(
    children: [
      shortcutRow(context, "CTRL + S", "Save note"),
      shortcutRow(context, "CTRL + N", "Shortcuts map"),
      shortcutRow(context, "CTRL + M", "Settings / user info"),
      shortcutRow(context, "CTRL + R", "Rename note"), 
      shortcutRow(context, "CTRL + T", "Favorite/unfavorite note"), 
      shortcutRow(context, "CTRL + Q", "Go to home page"), 
    ]
  );

  Table editTable = Table(
    children: [
      shortcutRow(context, "CTRL + Z", "Undo"),
      shortcutRow(context, "CTRL + SHIFT + Z", "Redo"),
      shortcutRow(context, "CTRL + C", "Copy selection"),
      shortcutRow(context, "CTRL + ALT + C", "Copy note"),
      shortcutRow(context, "CTRL + D", "Duplicate line/s"),
      shortcutRow(context, "CTRL + ALT + X", "Cut line/s"),
      shortcutRow(context, "ALT + ARROW UP", "Move cursor to top of the note"),
      shortcutRow(context, "ALT + ARROW DOWN", "Move cursor to bottom of the note"),
      shortcutRow(context, "ALT + ARROW LEFT", "Move cursor to start of the line"),
      shortcutRow(context, "ALT + ARROW RIGHT", "Move cursor to end of the line"),
      shortcutRow(context, "CTRL + ALT + ARROW UP", "Move line/s up"),
      shortcutRow(context, "CTRL + ALT + ARROW DOWN", "Move line/s down"),
      shortcutRow(context, "CTRL + ALT + ARROW LEFT", "Select from cursor to the start of the line"),
      shortcutRow(context, "CTRL + ALT + ARROW RIGHT", "Select from cursor to the end of the line"),
      shortcutRow(context, "CTRL + ALT + BACKSPACE", "Delete from cursor to the start of the line"),
      shortcutRow(context, "CTRL + ALT + K", "Delete from cursor to the start of the line"),
      shortcutRow(context, "CTRL + ALT + L", "Delete from cursor to the end of the line"),
      shortcutRow(context, "CTRL + I", "Indent line/s"),
      shortcutRow(context, "CTRL + O", "Outdent line/s")
    ]
  );

  Column content = Column(
    children: [
      paletteGradientShaderMask(
        generateRandomColorPalette(2, isThemeBright(context)),
        const Text(
          "Navigation shortcuts",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white
          )
        )
      ),
      const Gap(12),
      navigationTable,
      const Gap(12),
      paletteGradientShaderMask(
        generateRandomColorPalette(2, isThemeBright(context)),
        const Text(
          "Edit shortcuts",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white
          )
        )
      ),
      const Gap(12),
      editTable,
      const Gap(12),
    ],
  );

  SingleChildScrollView scroll = SingleChildScrollView(
    child: content,
  );

  Padding pad = Padding(
    padding: const EdgeInsets.all(16),
    child: scroll,
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    onKeyEvent: (KeyEvent event) => shortcutsMapInputListener(context, event),
    child: pad
  );

  showModalBottomSheet(
    context: context,
    builder: (context) => listener 
  );

}