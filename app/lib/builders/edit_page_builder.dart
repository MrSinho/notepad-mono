import 'package:flutter/material.dart';

import '../backend/supabase/queries.dart';
import '../backend/app_data.dart';
import '../backend/utils.dart';

import '../backend/note_edit/custom_intents/cut_lines.dart';
import '../backend/note_edit/custom_intents/duplicate_lines.dart';
import '../backend/note_edit/custom_intents/indent_lines.dart';
import '../backend/note_edit/custom_intents/outdent_lines.dart';
import '../backend/note_edit/custom_intents/move_lines.dart';

import '../static/ui_utils.dart';

import 'app_bar_builder.dart';
import 'input_field_builder.dart';



Widget noteEditPageBuilder(BuildContext context) {

  appLog("Note edit page builder triggered", true);

  Padding textFieldPad = Padding(
    padding: const EdgeInsets.all(8.0),
    child: noteCodeEditorBuilder(context, AppData.instance.noteEditData.controller)
  );

  Wrap editBar = Wrap(
  direction: Axis.horizontal,
  children: [
    wrapIconTextButton(
      const Icon(Icons.save_rounded),
      const Text("Save"),
      () => saveNoteContent()
    ),
    wrapIconTextButton(
      const Icon(Icons.copy_rounded),
      const Text("Copy"),
      () => copySelectionToClipboard()
    ),
    wrapIconTextButton(
      const Icon(Icons.sticky_note_2_rounded), // better than copy_all
      const Text("Copy note"),
      () => copyNoteToClipboard()
    ),
    wrapIconTextButton(
      const Icon(Icons.wrap_text_rounded),
      const Text("Duplicate line/s"),
      () => duplicateLines()
    ),
    //wrapIconTextButton(
    //  const Icon(Icons.cut_rounded),
    //  const Text("Cut"),
    //  () {}// TODO
    //),
    wrapIconTextButton(
      const Icon(Icons.cut_rounded),
      const Text("Cut line/s"),
      () => cutLines()
    ),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_left_rounded),
    //  const Text("Move cursor to sol"),
    //  () => moveCursorToLineEdge(false)
    //),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_right_rounded),
    //  const Text("Move cursor to eol"),
    //  () => moveCursorToLineEdge(true)
    //),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_left_rounded),
    //  const Text("Select from cursor to sol"),
    //  () {}//TODO
    //),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_right_rounded),
    //  const Text("Select from cursor to eol"),
    //  () {}//TODO
    //),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_left_rounded),
    //  const Text("Delete from cursor to sol"),
    //  () {}//TODO
    //),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_right_rounded),
    //  const Text("Delete from cursor to eol"),
    //  () {}//TODO
    //),
    wrapIconTextButton(
      const Icon(Icons.keyboard_arrow_up_rounded),
      const Text("Move line/s up"),
      () => moveSelectionLine(true)
    ),
    wrapIconTextButton(
      const Icon(Icons.keyboard_arrow_down_rounded),
      const Text("Move lines/s down"),
      () => moveSelectionLine(false)
    ),
    wrapIconTextButton(
      const Icon(Icons.format_indent_increase_rounded),
      const Text("Indent"),
      () => indentLines()
    ),
    wrapIconTextButton(
      const Icon(Icons.format_indent_decrease_rounded),
      const Text("Outdent"),
      () => outdentLines()
    ),
  ],
);


  Column noteBody = Column(
    children: [
      Padding(
        padding: const EdgeInsetsGeometry.directional(start: 8.0, end: 8.0),
        child: AppData.instance.editStatusBar,
      ),
      editBar,
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

  return scaffold;
}