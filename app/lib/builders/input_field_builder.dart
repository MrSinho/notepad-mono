import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:template/themes.dart';



CodeField noteCodeFieldBuilder(CodeController controller, BuildContext context) {

  CodeField codeField = CodeField(
    controller: controller,
    expands: true,
    maxLines: null,
    minLines: null,
    lineNumbers: true,

    textStyle: GoogleFonts.robotoMono(
      color: getCurrentThemePalette(context).primaryForegroundColor,
    ),

    lineNumberStyle: LineNumberStyle(
      textStyle: GoogleFonts.robotoMono(
      color: getCurrentThemePalette(context).quaternaryForegroundColor,
      ),
    ),

    cursorColor: getCurrentThemePalette(context).primaryForegroundColor,

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Theme.of(context).highlightColor
    ),

    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
    ),

  );

  return codeField;
}

TextField noteTextFieldBuilder(TextEditingController controller) {
  
  TextField textField = TextField(
    style: GoogleFonts.robotoMono(),
    decoration: InputDecoration(
      hintText: "# Write your notes here...",
      hintStyle: GoogleFonts.robotoMono(),
      border: InputBorder.none,
    ),
    expands: true,
    maxLines: null,
    minLines: null,
    controller: controller,
  );

  return textField;
}
