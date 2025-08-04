import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../types/text_view.dart';

import '../new_primitives/login_page.dart';



LoginInfo loginBuilder() {

  TextViewInfo titleViewInfo = TextViewInfo(
    text: Text(" NNotes!", style: GoogleFonts.robotoMono(fontSize: 36, fontWeight: FontWeight.bold))
  );

  TextViewInfo subtitleViewInfo = TextViewInfo(
    text: Text("Write simple monospace notes", style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold))
  );

  LoginInfo login = LoginInfo(
    authProviders: LoginAuthProviders.google | LoginAuthProviders.github,
    title:    titleViewInfo.widget.text,
    subtitle: subtitleViewInfo.widget.text
  );

  return login;
}