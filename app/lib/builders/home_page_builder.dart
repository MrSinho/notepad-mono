import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/app_data.dart';
import '../backend/note_edit.dart';
import '../backend/utils.dart';
import '../backend/navigator.dart';

import '../static/note_bottom_sheet.dart';
import '../static/ui_utils.dart';

import 'app_bar_builder.dart';



Widget notesPageViewBuilder(BuildContext context) {
  List<ListTile> notesUI = [];

  for (Map<String, dynamic> note in AppData.instance.queriesData.notes) {

    notesUI.add(
      ListTile(
        leading: favoriteButton(note, context),
        title: Text(note["title"] ?? "", style: GoogleFonts.robotoMono()),
        trailing: Text("Last edit ${formatDateTime(note["last_edit"] ?? "")}", style: GoogleFonts.robotoMono()),
        onTap: () {
          selectNote(note, true);
          NavigatorInfo.getState()?.push(
            MaterialPageRoute(builder: (context) => AppData.instance.noteEditPage)
          );

        },
        onLongPress: () {
          selectNote(note, true);
          showNoteBottomSheet(context);
        }
      ),
    );
  }

  Column view = Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: notesUI
            )
          ),
        )
      )
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar: mainAppBarBuilder(context),
    body: view
  );
    
  return scaffold;
}