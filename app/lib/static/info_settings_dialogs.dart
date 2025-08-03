import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template/backend/app_data.dart';
import 'package:template/backend/supabase/queries.dart';
import 'package:template/static/sign_out_dialog.dart';
import 'package:template/static/ui_utils.dart';
import 'package:template/themes.dart';



Dialog userInfoDialog(BuildContext context) {

  String provider = Supabase.instance.client.auth.currentUser?.appMetadata["provider"] ?? "none";
  String username = Supabase.instance.client.auth.currentUser?.userMetadata?["user_name"] ?? "empty";
  String email = Supabase.instance.client.auth.currentUser?.email ?? "empty";

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
          Text(username, style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(email, style: GoogleFonts.robotoMono(fontSize: 14)),
          const SizedBox(height: 4),
          Text("Auth provider: ${provider}", style: GoogleFonts.robotoMono(fontSize: 14), textAlign: TextAlign.left)
        ],
      )
    ],
  );

  List<Widget> userInfoContents = [
    userRow,
    const SizedBox(height: 20),//While waiting for future updates...
    wrapIconTextButton(
      const Icon(Icons.logout_outlined),
      Text("Log out", style: GoogleFonts.robotoMono()),
      () {
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context) => signOutDialog(context));
      }
    )
  ];

  //While waiting for future updates
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

  List<Widget> footer = [
    const SizedBox(height: 40),
    Text(
      "${AppData.instance.version["name"] ?? ""}, build version: ${AppData.instance.version["version"] ?? ""}",
      style: TextStyle(
        fontSize: 12,
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      )
    ),
    //TextButton(
    //  child: Text("About ${AppData.instance.version["author"] ?? ""}", style: TextStyle(fontSize: 14)),
    //  onPressed: (){}
    //),
    Text(
      AppData.instance.version["copyright_notice"] ?? "",
      style: TextStyle(
        fontSize: 12,
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      ),
    )
  ];

  return footer;
}

Dialog settingsDialog(BuildContext context) {

  List<Widget> settingsContents = [
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