import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/supabase/listen.dart';
import '../backend/supabase/queries.dart';

import '../backend/app_data.dart';
import '../backend/navigator.dart';
import '../backend/utils.dart';
import '../backend/note_edit.dart';

import '../builders/app_bar_builder.dart';

import '../types/app_bar_view.dart';

import '../static/note_bottom_sheet.dart';

import '../themes.dart';



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

  @override
  void initState() {
    super.initState();
    listenToNotes(context);
    listenToVersions(context);
  }
  
  void graphicsUpdate() {
    appLog("Updating graphics for NotesPageView");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    List<ListTile> notesUI = [];

    for (Map<String, dynamic> note in AppData.instance.notes) {

      Widget leadingIcon = const Icon(Icons.star_rounded, color: Colors.amber);

      if (note["is_favorite"] == false) {
        leadingIcon = Icon(Icons.star_outline_rounded, color: getCurrentThemePalette(context).quaternaryForegroundColor);
      }

      notesUI.add(
        ListTile(
          leading: IconButton(
            icon: leadingIcon,
            onPressed: () async {
              selectNote(note, false);
              await flipFavoriteNote();
            } 
          ),
          title: Text(note["title"] ?? "", style: GoogleFonts.robotoMono()),
          trailing: Text("Last edit ${formatDateTime(note["last_edit"] ?? "")}", style: GoogleFonts.robotoMono()),
          onTap: () {

            NavigatorInfo.key.currentState!.push(
              MaterialPageRoute(builder: (context) => AppData.instance.notePageViewInfo.widget)
            );

            selectNote(note, false);

          },
          onLongPress: () {
            selectNote(note, false);
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
}