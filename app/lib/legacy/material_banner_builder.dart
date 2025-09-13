import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/app_data.dart';


MaterialBanner errorMaterialBannerBuilder(String errorMessage) {

  MaterialBanner banner = MaterialBanner(

    leading: const Icon(
      Icons.warning_amber_sharp,
      color: Colors.black,
    ),

    content: Text(
      errorMessage,
      style: GoogleFonts.robotoMono(
        color: Colors.black
      ),
    ),

    backgroundColor: Colors.amber,
    shadowColor: Colors.transparent,

    actions: [
      IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () {
          //AppData.instance.notePageViewInfo.key.currentState!.graphicsDismissWarningMessage();
        },
      )  
    ]

  );

  return banner;
}