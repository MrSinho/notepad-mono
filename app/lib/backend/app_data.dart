import 'dart:io';

import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';

import 'supabase/auth_access.dart';

import '../new_primitives/home_page.dart';
import '../new_primitives/note_edit_page.dart';
import '../new_primitives/edit_app_bar_content.dart';
import '../new_primitives/edit_status_bar.dart';
import '../new_primitives/edit_bottom_bar.dart';

import 'note_edit.dart';



class NoteEditData {

  late CodeController controller;

  int savedContentLength = 0;
  int savedContentLines  = 0;
  int selectionLength    = 0;
  int selectionLines     = 0;
  int bufferLength       = 0;
  int bufferLines        = 0;
  int unsavedBytes       = 0;
  int cursorRow          = 0;
  int cursorColumn       = 0;
}

class QueriesData {
  Map<String, dynamic>       version      = {};
  List<Map<String, dynamic>> notes        = [];
  Map<String, dynamic>       selectedNote = {};
}

class AppData {
  static final AppData instance = AppData._internal();

  late HttpServer authServer;

  late final QueriesData        queriesData;
  late final NoteEditData       noteEditData;

  late final HomePage          homePage;
  late final NoteEditPage      noteEditPage;
  late final EditAppBarContent editAppBarContent;
  late final EditStatusBar     editStatusBar;
  late final EditBottomBar     editBottomBar;
  
  late NoteEditStatusData noteEditStatusData;

  final ValueNotifier<int> noteEditUpdates = ValueNotifier(0);
  final ValueNotifier<int> homePageUpdates = ValueNotifier(0);

  AppData._internal() {//Called once and only once, no BuildContext available
    
    queriesData        = QueriesData();
    noteEditStatusData = NoteEditStatus.uninitialized;
    noteEditData       = NoteEditData();

    homePage          = const HomePage();
    noteEditPage      = const NoteEditPage();
    editAppBarContent = const EditAppBarContent();
    editStatusBar     = const EditStatusBar();
    editBottomBar     = const EditBottomBar();

    noteEditData.controller = CodeController();
    noteEditData.controller.addListener(noteEditCallback);
    startAuthServer();

    queriesData.selectedNote = {"title": "note"};
  }
}