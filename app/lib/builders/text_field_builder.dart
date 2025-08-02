import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';



TextField textFieldBuilder(TextEditingController controller) {
  
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