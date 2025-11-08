import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../backend/supabase/auth_access.dart';

import '../backend/app_data.dart';
import '../backend/navigation/router.dart';

import '../themes.dart';



Dialog deleteAccountDialog(BuildContext context) {

  String appName = AppData.instance.queriesData.currentVersion["name"] ?? "Notepad Mono";

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Confirm delete account", textAlign: TextAlign.center, style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
      const Gap(20),
      Text(
        "Are you sure you want to permanently delete your $appName account associated with the email address ${AppData.instance.sessionData.email}?",
        textAlign: TextAlign.center,
      ),
      const Gap(8),
      Text(
        "You can still create a new account using the same email address.",
        textAlign: TextAlign.center,
      ),
      const Gap(16),
      Text(
        "This action cannot be undone!",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      ),
      const Gap(8),
      Text(
        "Current email: ${AppData.instance.sessionData.email}",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
            child: Text(
              "Delete account",
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold,
                color: Colors.red
              )
            ),
            onPressed: () => showDialog(context: context, builder: (context) => confirmDeleteAccountDialog(context))
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


Dialog confirmDeleteAccountDialog(BuildContext context) {

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Last chance...", textAlign: TextAlign.center, style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
      const Gap(20),
      Text(
        "This is your last chance to back out. Are you sure you want to permanently delete your account? All your notes and data will be lost forever.",
        textAlign: TextAlign.center,
      ),
      const Gap(8),
      Text(
        "There's no going back after this. Did you back up all of your important data?",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
      ),
      const Gap(8),
      Text(
        "Current email: ${AppData.instance.sessionData.email}",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
            onPressed: () => context.pop()
          ),
          const Gap(20.0),
          TextButton(
            child: Text(
              "Do it!",
              style: GoogleFonts.robotoMono(
                fontWeight: FontWeight.bold,
                color: Colors.red
              )
            ),
            onPressed: () {
              popAll(context);
              deleteUser();
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
