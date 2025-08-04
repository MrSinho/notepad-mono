import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/app_data.dart';
import '../backend/navigator.dart';
import '../backend/check.dart';
import '../backend/utils.dart';
import '../backend/note_edit.dart';

import '../static/note_bottom_sheet.dart';



class NotesView extends StatefulWidget {
  const NotesView({
      super.key
    }
  );

  @override
  State<NotesView> createState() => NotesViewState();
}

class NotesViewInfo {
  
  late GlobalKey<NotesViewState> key;
  late NotesView                 widget;

  NotesViewInfo() {
    
    key    = GlobalKey<NotesViewState>();
    widget = NotesView(key: key);

  }

}

class NotesViewState extends State<NotesView> {

  @override
  void initState() {
    super.initState();
  }
  
  void graphicsUpdate() {
    setState(() {});
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

            ////if you push too early the notePageViewInfo widget might not be built yet, so better add to a post frame callback to avoid null exceptions
            //WidgetsBinding.instance.addPostFrameCallback((_) {
            //  print("PUSHING NOTE PAGE VIEW TO NAVIGATOR!!!");
            //  Navigator.push(
            //    context,
            //    MaterialPageRoute(builder: (context) => AppData.instance.notePageViewInfo.widget)
            //  );
            //
            //  //Cannot update immediately the noteAppBarViewInfo app bar because the key current state will always be null before pushing to the navigator
            //  AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdateNotePageView();//It will check alone the selected note and make the correct app bar
            //
            //});

            //if you push too early the notePageViewInfo widget might not be built yet, so better add to a post frame callback to avoid null exceptions
            Future.microtask(() {//A post frame callback didn't work, a future microtask did

              NavigatorInfo.key.currentState!.push(
                MaterialPageRoute(builder: (context) => AppData.instance.notePageViewInfo.widget)
              );

              //Cannot update immediately the noteAppBarViewInfo app bar because the key current state will always be null before pushing to the navigator
              AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdateNotePageView();//It will check alone the selected note and make the correct app bar
            });

            selectNote(context, note);

          },
          onLongPress: () {
            selectNote(context, note);
            showNoteBottomSheet(context);

            //WidgetsBinding.instance.addPostFrameCallback((_) {//Displaying a bottom sheet "as is" does not garantee a valid build context is available...
            //  noteBottomSheet(context, note);
            //});

            //Displaying a bottom sheet "as is" does not garantee a valid build context is available...
            //Future.microtask(() {//A post frame callback didn't work, a future microtask did
            //  AppData.instance.notePageViewInfo.key.currentState?.showNoteBottomSheet();
            //});
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
    
    return view;

  }
}