import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template/backend/app_data.dart';
import 'package:template/backend/supabase/queries.dart';
import 'package:template/static/sign_out_dialog.dart';
import 'package:template/static/utils.dart';


Widget userImageInkWell(GestureTapCallback callback) {
  return ClipOval(
    child: Material(
      color: Colors.transparent, // Needed to make Ink splash work
      child: Ink.image(
        image: NetworkImage(
          Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? ""
        ),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        child: InkWell(
          onTap: callback,
          splashColor: const Color.from(alpha: 0.1, red: 0.0, green: 0.0, blue: 0.0),
          highlightColor: Colors.transparent,
        ),
      ),
    ),
  );
}


Dialog easySettingsDialog(BuildContext context) {

  String provider = Supabase.instance.client.auth.currentUser?.appMetadata["provider"] ?? "empty";
  String username = Supabase.instance.client.auth.currentUser?.userMetadata?["user_name"] ?? "empty";
  String email = Supabase.instance.client.auth.currentUser?.email ?? "empty";

  provider[0].toUpperCase();

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
          Text(provider, style: GoogleFonts.robotoMono(fontSize: 14), textAlign: TextAlign.left)
        ],
      )
    ],
  );

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      userRow,
      const SizedBox(height: 40),
      wrapIconTextButton(
        const Icon(Icons.logout_outlined),
        Text("Log out", style: GoogleFonts.robotoMono()),
        () {
          Navigator.pop(context);
          showDialog(context: context, builder: (BuildContext context) => signOutDialog(context));
        } 
      ),
      const SizedBox(height: 40),
      const Text("Build version: v1.0.0", style: TextStyle(fontSize: 14)),
      TextButton(child: const Text("Support this project on Github", style: TextStyle(fontSize: 14)), onPressed: (){}),

      //const SizedBox(height: 40),
      //Row(
      //  mainAxisAlignment: MainAxisAlignment.center,
      //  mainAxisSize: MainAxisSize.min,
      //  children: [
      //    TextButton(
      //      child: const Text("Cancel"),
      //      onPressed: () => Navigator.pop(context),
      //    ),
      //    TextButton(
      //      child: const Text("Confirm"),
      //      onPressed: () async {
      //        //await logout();
      //        Navigator.pop(context);
      //      } 
      //    )
      //  ],
      //)
      
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

Dialog renameNoteDialog(BuildContext context) {

  TextEditingController renameController = TextEditingController(text: AppData.instance.selectedNote["title"]);

  TextField renameField = TextField(
    controller: renameController,
    style: GoogleFonts.robotoMono(),
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0)),
    ),
  );

  TextButton saveButton = TextButton(
    child: Text("Done", style: GoogleFonts.robotoMono()), 
    onPressed: () async {
      Navigator.pop(context);
      await renameNote(renameController.text);
    }
  );

  Column dialogContent = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text("Rename note", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold),),
      const SizedBox(height: 20),
      IntrinsicWidth(child: renameField),
      const SizedBox(height: 20),
      saveButton,
      //IconButton(icon: const Icon(Icons.done_sharp), onPressed: (){}),
      //const SizedBox(height: 40),
      //const Text("Build version: v1.0.0", style: TextStyle(fontSize: 10)),
      //TextButton(child: const Text("Support this project on Github", style: TextStyle(fontSize: 10)), onPressed: (){}),
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

Dialog deleteNoteDialog(BuildContext context) {

  TextButton yesButton = TextButton(
    child: Text("Yes, delete", style: GoogleFonts.robotoMono()), 
    onPressed: () {
      Navigator.pop(context);
    }
  );

  TextButton noButton = TextButton(
    child: Text("Cancel", style: GoogleFonts.robotoMono()), 
    onPressed: () {
      Navigator.pop(context);
    }
  );

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Confirm delete", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold),),
      const SizedBox(height: 20),
      Text("Are you sure you want to delete this note?", style: GoogleFonts.robotoMono(fontSize: 12),),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          noButton,
          const SizedBox(width: 12),
          yesButton
        ]
      )
      //IconButton(icon: const Icon(Icons.done_sharp), onPressed: (){}),
      //const SizedBox(height: 40),
      //const Text("Build version: v1.0.0", style: TextStyle(fontSize: 10)),
      //TextButton(child: const Text("Support this project on Github", style: TextStyle(fontSize: 10)), onPressed: (){}),
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