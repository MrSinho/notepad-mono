import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';

import '../backend/supabase/queries.dart';

import '../types/scaffold_view.dart';
import '../types/app_bar_view.dart';

import '../builders/app_bar_builder.dart';
import '../builders/input_field_builder.dart';

import '../new_primitives/notes_page_view_info.dart';
import '../new_primitives/note_page_view.dart';

import 'note_edit.dart';


class AppData {
  static final AppData instance = AppData._internal();

  Map<String, dynamic> version = {};

  List<Map<String, dynamic>> notes = [];

  late NotesPageViewInfo notesPageViewInfo;
  //late AppBarViewInfo mainAppBarViewInfo;
  //late NotesViewInfo notesViewInfo;

  Map<String, dynamic> selectedNote = {};

  late NotePageViewInfo notePageViewInfo;
  late CodeController noteCodeController;


  //This will be called once and only once, before every widget is built...
  //No BuildContext is available, you cannot initialize complex responsive widgets
  AppData._internal() {
    
    noteCodeController = CodeController();//set language and theme

    noteCodeController.addListener(
      setNoteCursorData
    );
    
    selectedNote = { "title": "note" };
  }



  FutureBuilder enterDashboard() {

    FutureBuilder builder = FutureBuilder(

      future: pullVersion(),
      
      builder: (context, futureSnapshot) {//Here a BuildContext is available, so you initialize some complex and responsive widgets
          
        notesPageViewInfo = NotesPageViewInfo();

        notePageViewInfo = NotePageViewInfo(
          noteCodeField: noteCodeFieldBuilder(noteCodeController, context)
        );

        return notesPageViewInfo.widget;
      }

    );

    return builder;
  }


  
}