import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../backend/inputs.dart';
import '../backend/color_palette.dart';

import '../themes.dart';



Widget tableTitle(BuildContext context, String title) {

  Padding titlePad = Padding(
    padding: const EdgeInsets.only(left: 16),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white
      )
    )
  );

  Align align = Align(
    alignment: Alignment.centerLeft,
    child: titlePad
  );

  ShaderMask mask = paletteGradientShaderMask(
    generateRandomColorPalette(2, isThemeBright(context)),
    align
  );

  return mask;
}

TableRow shortcutRow(BuildContext context, String shortcut, String description) {
  
  TableRow row = TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 16), 
        child: Text(
          shortcut,
          style: GoogleFonts.robotoMono(
            fontWeight: FontWeight.bold,
            color: getCurrentThemePalette(context).quaternaryForegroundColor
          )
        ),
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

void showShortCutsMap(BuildContext context) {
  
  Table navigationTable = Table(
    columnWidths: const {
      0: FlexColumnWidth(),
      1: FlexColumnWidth(),
    },
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
    columnWidths: const {
      0: FlexColumnWidth(),
      1: FlexColumnWidth(),
    },
    children: [
      shortcutRow(context, "CTRL + Z", "Undo"),
      shortcutRow(context, "CTRL + SHIFT + Z", "Redo"),
      shortcutRow(context, "CTRL + C", "Copy selection"),
      shortcutRow(context, "CTRL + SHIFT + ALT + C", "Copy note"),
      shortcutRow(context, "CTRL + ALT + C", "Copy line/s"),
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
      shortcutRow(context, "CTRL + O", "Outdent line/s"),
      shortcutRow(context, "CTRL + ADD", "Zoom in"),
      shortcutRow(context, "CTRL + HYPHEN", "Zoom out"),
    ]
  );

  Column content = Column(
    children: [
      tableTitle(context, "Navigation shortcuts"),
      const Gap(12),
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: navigationTable
      ),
      const Gap(12),
      tableTitle(context, "Edit shortcuts"),
      const Gap(12),
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: editTable
      ),
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

  const double minWidth  = 760;
  const double minHeight = 730;
  if (MediaQuery.of(context).size.width < minWidth || MediaQuery.of(context).size.height < minHeight) {
    
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      builder: (context) => SafeArea(child: listener) 
    );
  }
  else {
    showDialog(
      context: context, 
      builder: (context) => Dialog(child: listener)
    );
  }

}