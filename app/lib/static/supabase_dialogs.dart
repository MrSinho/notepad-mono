import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template/backend/app_data.dart';
import 'package:template/backend/supabase/queries.dart';
import 'package:template/static/sign_out_dialog.dart';
import 'package:template/static/ui_utils.dart';
import 'package:template/themes.dart';



Dialog newNoteDialog(BuildContext context) {

  TextEditingController controller = TextEditingController(text: "New note");

  TextField field = TextField(
    controller: controller,
    style: GoogleFonts.robotoMono(),
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0)),
    ),
  );

  TextButton confirmButton = TextButton(
    child: Text(
      "Done", 
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).primaryVividColor
      )
    ), 
    onPressed: () async {
      Navigator.pop(context);
      await createNewNote(controller.text);
    }
  );

  TextButton noButton = TextButton(
    child: Text(
      "Cancel",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).primaryVividColor
      )
    ), 
    onPressed: () {
      Navigator.pop(context);
    }
  );

  Column dialogContent = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text("Create note", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold),),
      const SizedBox(height: 20),
      IntrinsicWidth(child: field),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          noButton,
          const SizedBox(width: 12),
          confirmButton
        ]
      ),
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

  TextEditingController renameController = TextEditingController(text: AppData.instance.selectedNote["title"] ?? "");

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
    child: Text(
      "Done",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).primaryVividColor
      )
    ), 
    onPressed: () async {
      Navigator.pop(context);
      await renameNote(renameController.text);
    }
  );

  TextButton noButton = TextButton(
    child: Text(
      "Cancel",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).primaryVividColor
      )
    ), 
    onPressed: () {
      Navigator.pop(context);
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          noButton,
          const SizedBox(width: 12),
          saveButton
        ]
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

Dialog deleteNoteDialog(BuildContext context) {

  TextButton yesButton = TextButton(
    child: Text(
      "Yes, delete",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).primaryVividColor
      )
    ), 
    onPressed: () async {
      Navigator.pop(context);
      await deleteSelectedNote();
    }
  );

  TextButton noButton = TextButton(
    child: Text(
      "Cancel",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).primaryVividColor
      )
    ), 
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