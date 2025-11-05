import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../backend/supabase/auth_access.dart';

import '../backend/utils/color_utils.dart';
import '../backend/navigation/router.dart';

import '../backend/app_data.dart';

import '../themes.dart';



Dialog signOutDialog(BuildContext context) {

  ShaderMask confirmMask = paletteGradientShaderMask(
    generateRandomColorPalette(2),
    Text(
      "Confirm",
      style: GoogleFonts.robotoMono(
        color: Colors.white,
        fontWeight: FontWeight.bold
      )
    )
  );

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Confirm Sign Out", textAlign: TextAlign.center, style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold)),
      const Gap(20),
      Text(
        "Are you sure you want to sign out and leave this session?",
        style: GoogleFonts.robotoMono()
      ),
      const Gap(40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: Text(
              "Cancel",
              style: GoogleFonts.robotoMono(
                color: getCurrentThemePalette().quaternaryForegroundColor
              )
            ),
            onPressed: () => context.pop(),
          ),
          const Gap(20.0),
          TextButton(
            child: confirmMask,
            onPressed: () {
              popAll(context);
              logout();
              clearUserRelatedAppData();
              goToRootPage();
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
