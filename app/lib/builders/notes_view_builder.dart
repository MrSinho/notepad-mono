import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import 'package:notepad_mono/static/note_dialogs.dart';

import '../backend/note_edit/note_edit.dart';

import '../backend/navigation/router.dart';

import '../backend/utils/utils.dart';
import '../backend/utils/ui_utils.dart';

import '../backend/app_data.dart';

import '../static/note_bottom_sheet.dart';



Widget notesViewBuilder(BuildContext context) {
  List<Widget> notesUI = [];

  for (Map<String, dynamic> note in AppData.instance.queriesData.notes) {

    notesUI.add(
      ListTile(
        leading: favoriteButton(note),
        title: Text(note["title"] ?? "", style: GoogleFonts.robotoMono(fontSize: 14)),
        trailing: Wrap(
          direction: Axis.horizontal,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Text(formatDateTime(note["last_edit"] ?? ""), style: GoogleFonts.robotoMono(fontSize: 9)),
            ),
            Gap(12),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 2.5),
              child: IconButton(
                icon: Icon(Icons.close, size: 14),
                onPressed: () {
                  selectNote(note, true);
                  showDialog(context: context, builder: (BuildContext context) => deleteNoteDialog(context)); 
                }
              ),
            )
          ],
        ),
        onTap: () {
          selectNote(note, true);
          goToNoteEditPage();
        },
        onLongPress: () {
          selectNote(note, true);
          showNoteBottomSheet(context);
        }
      ),
    );
  }

  notesUI.add(Gap(196));

  SingleChildScrollView scroll = SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: notesUI
      )
    ),
  );

  return scroll;
}