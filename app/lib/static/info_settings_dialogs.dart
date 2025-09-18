import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nnotes/backend/color_palette.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/app_data.dart';
import '../backend/navigator.dart';

import 'sign_out_dialog.dart';
import 'ui_utils.dart';

import '../themes.dart';



Dialog userInfoDialog(BuildContext context) {

  String provider = Supabase.instance.client.auth.currentUser?.appMetadata["provider"] ?? "provider";
  String username = Supabase.instance.client.auth.currentUser?.userMetadata?["user_name"] ?? "user";
  String email = Supabase.instance.client.auth.currentUser?.email ?? "email";

  Row userRow = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsetsGeometry.all(16.0),
        child: userImageInkWell((){}) 
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          paletteGradientShaderMask(
            generateRandomColorPalette(2),
            Text(
              username,
              style: GoogleFonts.robotoMono(
                fontSize: 24, 
                fontWeight: FontWeight.bold
              )
            )
          ),
          const SizedBox(height: 4),
          Text(email, style: GoogleFonts.robotoMono(fontSize: 14)),
          const SizedBox(height: 4),
          Text("Auth provider: $provider", style: GoogleFonts.robotoMono(fontSize: 14), textAlign: TextAlign.left)
        ],
      )
    ],
  );

  // Different encryption key icon if encryption is enabled or disabled

  List<Widget> userInfoContents = [
    userRow,
    //const SizedBox(height: 20),
    //wrapIconTextButton(
    //  const Icon(Icons.key_rounded),
    //  Text("Setup encryption key", style: GoogleFonts.robotoMono()),
    //  () {}
    //),
    const SizedBox(height: 20),
    wrapIconTextButton(
      const Icon(Icons.logout_outlined),
      Text("Log out", style: GoogleFonts.robotoMono()),
      () {
        NavigatorInfo.getState()?.pop(context);
        showDialog(context: context, builder: (BuildContext context) => signOutDialog(context));
      }
    )
  ];

  userInfoContents.addAll(footerWidgets(context));

  Column column = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: userInfoContents
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: column,
    )
  );

  return dialog;
}

List<Widget> footerWidgets(BuildContext context) {

  String appName    = AppData.instance.queriesData.version["name"] ?? "NNotes";
  String version    = AppData.instance.queriesData.version["version"] ?? "0.1.0";
  String versionTag = AppData.instance.queriesData.version["tag"] ?? "vanilla";

  List<Widget> footer = [
    const SizedBox(height: 40),
    Text(
      "$appName, build version: $version, tag: $versionTag",
      style: TextStyle(
        fontSize: 12,
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      )
    ),
    Text(
      AppData.instance.queriesData.version["copyright_notice"] ?? "",
      style: TextStyle(
        fontSize: 12,
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      ),
    )
  ];

  return footer;
}

Dialog settingsDialog(BuildContext context) {

  List<Widget> settingsContents = [//Waiting for future updates...
    //THEME SETTINGS
    //DELETED NOTES SETTINGS
  ];

  settingsContents.addAll(footerWidgets(context));

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: settingsContents
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialogContent,
    )
  );

  return dialog;
}