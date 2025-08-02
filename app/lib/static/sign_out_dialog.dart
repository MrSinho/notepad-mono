import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/supabase/logout.dart';



Dialog signOutDialog(BuildContext context) {

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Confirm Sign Out", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      Text(
        "Are you sure you want to Sign Out?",
        style: GoogleFonts.robotoMono()
      ),
      const SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 20.0),
          TextButton(
            child: const Text("Confirm"),
            onPressed: () async {
              Navigator.pop(context);
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
