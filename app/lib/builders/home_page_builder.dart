import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/app_data.dart';
import '../backend/note_edit/note_edit.dart';
import '../backend/utils/utils.dart';
import '../backend/inputs.dart';
import '../backend/navigation/router.dart';

import '../static/note_bottom_sheet.dart';
import '../static/swipe_card.dart';
import '../static/ui_utils.dart';

import 'home_app_bar_builder.dart';



Widget homePageBuilder(BuildContext context) {
  List<ListTile> notesUI = [];

  for (Map<String, dynamic> note in AppData.instance.queriesData.notes) {

    notesUI.add(
      ListTile(
        leading: favoriteButton(note),
        title: Text(note["title"] ?? "", style: GoogleFonts.robotoMono(fontSize: 14)),
        trailing: Text(formatDateTime(note["last_edit"] ?? ""), style: GoogleFonts.robotoMono(fontSize: 9)),
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
      ),
      swipeCardsBuilder(),
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar: homeAppBarBuilder(context),
    body: SafeArea(child: view) // Important for mobile devices
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: scaffold,
    onKeyEvent: (KeyEvent event) => homeInputListener(context, event),
  );

  return listener;
}