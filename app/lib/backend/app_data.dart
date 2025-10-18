import 'package:flutter/material.dart';
//import 'package:code_text_field/code_text_field.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:app_links/app_links.dart';

import 'supabase/listen.dart';
import 'supabase/auth_access.dart';
import 'supabase/queries.dart';

import '../new_primitives/login_page.dart';
import '../new_primitives/home_page.dart';
import '../new_primitives/note_edit_page.dart';
import '../new_primitives/edit_app_bar_content.dart';
import '../new_primitives/edit_status_bar.dart';
import '../new_primitives/edit_bottom_bar.dart';
import '../new_primitives/input_field.dart';

import 'note_edit/note_edit.dart';
import 'color_palette.dart';
import 'inputs.dart';



class AppData {
  static final AppData instance = AppData._internal();

  late SessionData        sessionData;
  late QueriesData        queriesData;
  late NoteEditData       noteEditData;
  late NoteEditStatusData noteEditStatusData;
  late InputData          inputData;

  late final LoginPage         loginPage;
  late final HomePage          homePage;
  late final NoteEditPage      noteEditPage;
  late final EditAppBarContent editAppBarContent;
  late final EditStatusBar     editStatusBar;
  late final EditBottomBar     editBottomBar;
  late final NoteInputField    noteInputField;

  late ColorPaletteData editColorPaletteData;

  final ValueNotifier<int> loginPageUpdates    = ValueNotifier(0);
  final ValueNotifier<int> homePageUpdates     = ValueNotifier(0);
  final ValueNotifier<int> noteEditBarsUpdates = ValueNotifier(0);
  final ValueNotifier<int> inputFieldUpdates   = ValueNotifier(0);

  AppData._internal() {//Called once and only once, no BuildContext available

    sessionData        = SessionData();
    queriesData        = QueriesData();
    noteEditStatusData = NoteEditStatusData();
    noteEditData       = NoteEditData();
    inputData          = InputData();

    loginPage         = const LoginPage();
    homePage          = const HomePage();
    noteEditPage      = const NoteEditPage();
    editAppBarContent = const EditAppBarContent();
    editStatusBar     = const EditStatusBar();
    editBottomBar     = const EditBottomBar();
    noteInputField    = const NoteInputField();

    noteEditData.controller = CodeController(
      language: markdown,// currently only markdown linting
      namedSectionParser: const BracketsStartEndNamedSectionParser(),
    );
    noteEditData.controller.popupController.enabled = true;

    noteEditData.controller.addListener(noteEditCallback);
    noteEditData.focusNode = FocusNode();

    queriesData.selectedNote = {"title": "note"};

    sessionData.appLinks = AppLinks();
  }

  void setupWithContext(BuildContext context) {
    listenToVersions(context);
    listenToNotes(context);
  }
}
