import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';

import '../backend/supabase/queries.dart';

import '../types/scaffold_view.dart';
import '../types/app_bar_view.dart';

import '../builders/app_bar_builder.dart';
import '../builders/input_field_builder.dart';

import '../new_primitives/notes_view_info.dart';
import '../new_primitives/note_page_view.dart';

import 'note_edit.dart';


class AppData {
  static final AppData instance = AppData._internal();

  Map<String, dynamic> version = {};

  List<Map<String, dynamic>> notes = [];

  late ScaffoldViewInfo mainScaffoldViewInfo;
  late AppBarViewInfo mainAppBarViewInfo;
  late NotesViewInfo notesViewInfo;

  Map<String, dynamic> selectedNote = {};

  late NotePageViewInfo notePageViewInfo;
  late CodeController noteCodeController;


  //This will be called once and only once... 
  //before every widget is built (no BuildContext is available, so you cannot initialize complex responsive widgets)
  AppData._internal() {
    
    notesViewInfo = NotesViewInfo();
    
    noteCodeController = CodeController();//set language and theme

    noteCodeController.addListener(
      setNoteCursorData
    );
    
    selectedNote = { "title": "note" };
  }



  FutureBuilder enterDashboard() {

    FutureBuilder builder = FutureBuilder(

      future: pullVersion(),

      //Here a BuildContext is available, so you initialize some complex and responsive widgets
      builder: (context, futureSnapshot) {
          
        mainAppBarViewInfo = AppBarViewInfo(appBar: mainAppBarBuilder(context)); 

        //link ListTileViewInfo as body of ScaffoldViewInfo
        //if any of those widgets needs to change, update ONLY the state of ListTilesViewInfo, NEVER replace with a new widget, which carries also a new key and may be outside of the widget tree
        //took me a lot of time to realize my mistakes...
        mainScaffoldViewInfo = ScaffoldViewInfo(
          appBarViewInfo: mainAppBarViewInfo,
          body: notesViewInfo.widget,
        );

        notePageViewInfo = NotePageViewInfo(
          noteCodeField: noteCodeFieldBuilder(noteCodeController, context)
        );

        return mainScaffoldViewInfo.widget;
      }

    );

    return builder;
  }


  
}