import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/navigator.dart';
import '../backend/color_palette.dart';

import '../themes.dart';



Dialog signOutDialog(BuildContext context) {

  ShaderMask confirmMask = paletteGradientShaderMask(
    generateRandomColorPalette(2, isThemeBright(context)),
    Text(
      "Confirm",
      style: GoogleFonts.robotoMono(
        color: Colors.white
      )
    )
  );

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Confirm Sign Out", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      Text(
        "Are you sure you want to sign out and leave this session?",
        style: GoogleFonts.robotoMono()
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: Text(
              "Cancel",
              style: GoogleFonts.robotoMono(
                color: getCurrentThemePalette(context).quaternaryForegroundColor
              )
            ),
            onPressed: () => NavigatorInfo.getState()?.pop(context),
          ),
          const SizedBox(width: 20.0),
          TextButton(
            child: confirmMask,
            onPressed: () async {
              Navigator.of(context).popUntil((route) => route.isFirst);
              await Supabase.instance.client.auth.signOut();
            } 
          )
        ],
      )
      
    ]
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialogContent,
    )
  );

  return dialog;
}
