import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';

import '../backend/supabase/queries.dart';

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

  NoteEditStatusValue noteEditStatus = NoteEditStatus.uninitialized;
  Color noteEditColor = Colors.brown;
  String noteEditMessage = "";
  Map<String, dynamic> selectedNote = {};

  int savedContentLength = 0;
  int savedContentLines = 0;
  int selectionLength = 0;
  int selectionLines = 0;
  int bufferLength = 0;
  int bufferLines = 0;
  int unsavedBytes = 0;
  int cursorRow = 0;
  int cursorColumn = 0;

  String errorMessage = "";

  late NotePageViewInfo notePageViewInfo;
  late CodeController noteCodeController;

  //This will be called once and only once, before every widget is built...
  //No BuildContext is available, you cannot initialize complex responsive widgets
  AppData._internal() {
    
    noteCodeController = CodeController();//set language and theme

    noteCodeController.addListener(setNoteCursorData);

    selectedNote = {"title": "note"};
  }

  FutureBuilder enterDashboard() {
    FutureBuilder builder = FutureBuilder(

      future: pullVersion(),
      
      builder: (context, futureSnapshot) {//Here a BuildContext is available, so you initialize some complex and responsive widgets
          
        notesPageViewInfo = NotesPageViewInfo();

          notePageViewInfo = NotePageViewInfo(
              noteCodeField: noteCodeFieldBuilder(noteCodeController, context));

        return notesPageViewInfo.widget;
      }

    );

    return builder;
  }
}
