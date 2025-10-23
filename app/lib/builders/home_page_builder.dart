import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/app_data.dart';
import '../backend/note_edit/note_edit.dart';
import '../backend/utils.dart';
import '../backend/inputs.dart';
import '../backend/router.dart';

import '../static/note_bottom_sheet.dart';
import '../static/ui_utils.dart';

import 'app_bar_builder.dart';



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
      )
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar: mainAppBarBuilder(context),
    body: SafeArea(child: view) // Important for mobile devices
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: scaffold,
    onKeyEvent: (KeyEvent event) => homeInputListener(context, event),
  );

  // Da qui in poi sto sperimentando

  RoundedRectangleBorder border = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(48.0), // Increase this value for more roundness
  );

  List<Widget> cards = [
    Card(
      color: Colors.blue,
      shape: border,
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Notepad Mono v1.1.1 release notes")
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(onPressed: (){}, icon: Icon(Icons.close))
                  ),
                )
              ],
            )
          ],
        ),
      )
    ),
    Card(
      color: Colors.red,
      shape: border,
      child: const Text('2'),
    ),
    Card(
      color: Colors.purple,
      shape: border,
      child: const Text('3'),
    )
  ];

  CardSwiper swiper = CardSwiper(
      cardsCount: 3,
      allowedSwipeDirection: AllowedSwipeDirection.only(up: false, down: false, left: true, right: true),
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
        return cards[index];
    }
  );

  FractionallySizedBox box = FractionallySizedBox(
    widthFactor: 0.5,
    heightFactor: 0.5,
    child: swiper
  );

  return listener;
}