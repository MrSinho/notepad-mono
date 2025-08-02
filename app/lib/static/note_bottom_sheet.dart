import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/backend/note_edit.dart';

import '../backend/app_data.dart';

import '../builders/app_bar_builder.dart';

import './easy_dialogs.dart';



void noteBottomSheet(BuildContext context, Map<String, dynamic> note) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      Column column = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.title_sharp),
            title: Text("Rename", style: GoogleFonts.robotoMono()),
            onTap: () { 
              Navigator.pop(context);
              selectNote(context, note);
              showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_outlined),
            title: Text("Edit", style: GoogleFonts.robotoMono()),
            onTap: () { 
              Navigator.pop(context);
              selectNote(context, note);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppData.instance.notePageViewInfo.widget),
              );

            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outlined),
            title: Text("Delete", style: GoogleFonts.robotoMono()),
            onTap: () { 
              Navigator.pop(context);
              selectNote(context, note);
              showDialog(context: context, builder: (context) => deleteNoteDialog(context));
            },
          ),
        ],
      );

      Padding pad = Padding(
        padding: const EdgeInsets.all(16),
        child: column
      );

      return pad;
    }
  );
}