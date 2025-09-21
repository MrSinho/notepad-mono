import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nnotes/backend/inputs.dart';
import 'package:nnotes/backend/note_edit.dart';
import 'package:nnotes/backend/supabase/queries.dart';
import 'package:nnotes/static/info_settings_dialogs.dart';
import 'package:nnotes/static/note_dialogs.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';

import 'app_bar_builder.dart';
import 'input_field_builder.dart';



Widget noteEditPageBuilder(BuildContext context) {

  appLog("Note edit page builder triggered", true);

  Padding textFieldPad = Padding(
    padding: const EdgeInsets.all(8.0),
    child: noteCodeFieldBuilder(AppData.instance.noteEditData.controller, context)
  );

  Column noteBody = Column(
    children: [
      Padding(
        padding: const EdgeInsetsGeometry.directional(start: 8.0, end: 8.0),
        child: AppData.instance.editStatusBar,
      ),
      Expanded(child: textFieldPad),
      Padding(
        padding: const EdgeInsetsGeometry.directional(start: 8.0, end: 8.0),
        child: AppData.instance.editBottomBar,
      ),
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar: editAppBarBuilder(context),
    body: noteBody,
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    onKeyEvent: (KeyEvent event) => editInputListener(context, event),
    child: scaffold
  );

  return listener;
}