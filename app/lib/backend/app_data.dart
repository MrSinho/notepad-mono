import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:app_links/app_links.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'supabase/queries.dart';
import 'supabase/session.dart';

import '../new_primitives/login_page.dart';
import '../new_primitives/home_page.dart';
import '../new_primitives/note_edit_page.dart';
import '../new_primitives/edit_app_bar_content.dart';
import '../new_primitives/edit_status_bar.dart';
import '../new_primitives/edit_bottom_bar.dart';
import '../new_primitives/input_field.dart';

import 'note_edit/note_edit.dart';

import 'navigation/router.dart';

import 'utils/color_utils.dart';

import 'inputs.dart';



class AppData {
  static final AppData instance = AppData._internal();

  late PackageInfo packageInfo;

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

  final ValueNotifier<int> rootPageUpdates     = ValueNotifier(0);
  final ValueNotifier<int> noteEditBarsUpdates = ValueNotifier(0);
  final ValueNotifier<int> inputFieldUpdates   = ValueNotifier(0);

  late final GoRouter router;

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

    router = setupRouter();

    noteEditData.controller = setupEditController();

    noteEditData.focusNode = FocusNode();

    queriesData.selectedNote = {"title": "note"};

    sessionData.appLinks = AppLinks();
  }

  void setupWithContext(BuildContext context) {
  }
}
