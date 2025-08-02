import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



Text loginTitleBuilder() {
  
  //pull title from database
  Text text = Text(" NNotes!", style: GoogleFonts.robotoMono(fontSize: 36, fontWeight: FontWeight.bold));

  return text;
}


Text loginSubtitleBuilder() {
  
  Text text = Text("Write simple monospace notes", style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold));

  return text;
}