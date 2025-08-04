import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/navigator.dart';

import '../themes.dart';



Dialog signOutDialog(BuildContext context) {

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
                color: getCurrentThemePalette(context).primaryVividColor
              )
            ),
            onPressed: () => NavigatorInfo.key.currentState!.pop(context),
          ),
          const SizedBox(width: 20.0),
          TextButton(
            child: Text(
              "Confirm",
              style: GoogleFonts.robotoMono(
                color: getCurrentThemePalette(context).primaryVividColor
              )
            ),
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
