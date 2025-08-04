import 'package:NNotes/backend/supabase/listen.dart';
import 'package:NNotes/builders/app_bar_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/app_data.dart';
import '../backend/navigator.dart';
import '../backend/utils.dart';
import '../backend/note_edit.dart';

import '../types/app_bar_view.dart';

import '../static/note_bottom_sheet.dart';



class NotesPageView extends StatefulWidget {
  const NotesPageView({
      super.key
    }
  );

  @override
  State<NotesPageView> createState() => NotesPageViewState();
}

class NotesPageViewInfo {
  
  late GlobalKey<NotesPageViewState> key;
  late NotesPageView                 widget;

  NotesPageViewInfo() {
    key    = GlobalKey<NotesPageViewState>();
    widget = NotesPageView(key: key);
  }

}

class NotesPageViewState extends State<NotesPageView> {

  AppBarViewInfo appBarViewInfo = AppBarViewInfo(appBar: AppBar());

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    listenToNotes(context);
    listenToVersions(context);
  }
  
  void graphicsUpdate() {
    setState(() {});
  }

  void graphicsSetWarningMessage(String errorMsg) {
    setState(() {
      errorMessage = errorMsg; 
    });
  }

  void graphicsDismissWarningMessage() {
    setState(() {
      errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {

    List<ListTile> notesUI = [];

    for (Map<String, dynamic> note in AppData.instance.notes) {

      notesUI.add(
        ListTile(
          title: Text(note["title"] ?? "", style: GoogleFonts.robotoMono()),
          trailing: Text("Last edit ${formatDateTime(note["last_edit"] ?? "")}", style: GoogleFonts.robotoMono()),
          onTap: () {

            //if you push too early the notePageViewInfo widget might not be built yet, so better add to a post frame callback to avoid null exceptions
            Future.microtask(() {//A post frame callback didn't work, a future microtask did

              NavigatorInfo.key.currentState!.push(
                MaterialPageRoute(builder: (context) => AppData.instance.notePageViewInfo.widget)
              );

              //Cannot update immediately the noteAppBarViewInfo app bar because the key current state will always be null before pushing to the navigator
              AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdateNotePageView();//It will check alone the selected note and make the correct app bar
            });

            selectNote(note);
          },
          onLongPress: () {
            selectNote(note);
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
      appBar: mainAppBarBuilder(context, errorMessage),
      body: view
    );
    
    return scaffold;

  }
}