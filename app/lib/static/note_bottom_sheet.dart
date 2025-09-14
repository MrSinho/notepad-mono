import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/supabase/queries.dart';

import '../backend/app_data.dart';
import '../backend/navigator.dart';
import '../backend/notify_ui.dart';

import 'supabase_dialogs.dart';



void showNoteBottomSheet(BuildContext context) {

  String favoriteText = "Add to favorites";

  if (AppData.instance.queriesData.selectedNote["is_favorite"]) {
    favoriteText = "Remove from favorites";
  }

  showModalBottomSheet(
    context: context,
    builder: (context) {
      Column column = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.title_sharp),
            title: Text("Rename ${AppData.instance.queriesData.selectedNote["title"]}", style: GoogleFonts.robotoMono()),
            onTap: () { 
              NavigatorInfo.getState()?.pop(context);
              showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_outlined),
            title: Text("Edit", style: GoogleFonts.robotoMono()),
            onTap: () { 
              NavigatorInfo.getState()?.pop(context);
              
              Future.microtask(() {

                NavigatorInfo.getState()?.push(
                  MaterialPageRoute(builder: (context) => AppData.instance.noteEditPage)
                );

                notifyHomePageUpdate();
                
              });

            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rounded),
            title: Text(favoriteText, style: GoogleFonts.robotoMono()),
            onTap: () async {
              NavigatorInfo.getState()?.pop(context);
              flipFavoriteNote();
            }
          ),
          ListTile(
            leading: const Icon(Icons.delete_outlined),
            title: Text("Delete", style: GoogleFonts.robotoMono()),
            onTap: () { 
              NavigatorInfo.getState()?.pop(context);
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