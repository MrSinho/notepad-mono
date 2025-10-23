import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../backend/supabase/queries.dart';

import '../backend/app_data.dart';
import '../backend/router.dart';

import 'note_dialogs.dart';



void showNoteBottomSheet(BuildContext context) {

  String favoriteText = "Add to favorites";

  if (AppData.instance.queriesData.selectedNote["is_favorite"]) {
    favoriteText = "Remove from favorites";
  }

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      Column column = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.title_sharp),
            title: Text("Rename ${AppData.instance.queriesData.selectedNote["title"]}", style: GoogleFonts.robotoMono()),
            onTap: () { 
              context.pop();
              showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_outlined),
            title: Text("Edit", style: GoogleFonts.robotoMono()),
            onTap: () { 
              context.pop();
              goToNoteEditPage();
              //notifyHomePageUpdate(); ??
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rounded),
            title: Text(favoriteText, style: GoogleFonts.robotoMono()),
            onTap: () {
              context.pop();
              flipFavoriteNote();
            }
          ),
          ListTile(
            leading: const Icon(Icons.delete_outlined),
            title: Text("Delete", style: GoogleFonts.robotoMono()),
            onTap: () { 
              context.pop();
              showDialog(context: context, builder: (context) => deleteNoteDialog(context));
            },
          ),
        ],
      );

      Padding pad = Padding(
        padding: const EdgeInsets.all(16),
        child: column
      );

      return SafeArea(child: pad);
    }
  );
}