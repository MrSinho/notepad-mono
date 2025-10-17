import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/supabase/queries.dart';
import '../backend/app_data.dart';
import '../backend/utils.dart';

import '../backend/note_edit/custom_intents/copy_lines.dart';
import '../backend/note_edit/custom_intents/cut_lines.dart';
import '../backend/note_edit/custom_intents/paste.dart';
import '../backend/note_edit/custom_intents/duplicate_lines.dart';
import '../backend/note_edit/custom_intents/indent_lines.dart';
import '../backend/note_edit/custom_intents/outdent_lines.dart';
import '../backend/note_edit/custom_intents/move_lines.dart';
import '../backend/note_edit/custom_intents/move_cursor_to_line_edge.dart';
import '../backend/note_edit/custom_intents/canc.dart';

import '../static/ui_utils.dart';

import 'app_bar_builder.dart';
import 'input_field_builder.dart';



LayoutBuilder iconTextButtonLayoutBuilder(Widget icon, Widget text, VoidCallback onPressed, double minWidth) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < minWidth) {
        return IconButton(
          icon: icon,
          tooltip: (text is Text) ? text.data : null,
          onPressed: onPressed
        );
      }
      return wrapIconTextButton(icon, text, onPressed);
    }
  );
}

Widget noteEditPageBuilder(BuildContext context) {

  appLog("Note edit page builder triggered", true);

  Padding textFieldPad = Padding(
    padding: const EdgeInsets.all(8.0),
    child: noteCodeEditorBuilder(context, AppData.instance.noteEditData.controller)
  );

  double minWidth = 750;

  if (Platform.isAndroid || Platform.isIOS) {
    minWidth = 912;
  }

  List<Widget> editBarTopContent = [
    iconTextButtonLayoutBuilder(const Icon(Icons.save_rounded), Text("Save"), () => saveNoteContent(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.copy_rounded), Text("Copy"), () => copySelectionToClipboard(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.sticky_note_2_rounded), Text("Copy note"), () => copyNoteToClipboard(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.wrap_text_rounded), Text("Copy line/s"), () => copyLines(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.wrap_text_rounded), Text("Duplicate lines/s"), () => duplicateLines(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.cut_rounded), Text("Cut line/s"), () => cutLines(), minWidth),
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
    
  ];

  List<Widget> editBarBottomContent = [
    iconTextButtonLayoutBuilder(const Icon(Icons.paste_rounded), Text("Paste"), () => pasteContent(), minWidth),
    iconTextButtonLayoutBuilder(const Icon(Icons.format_indent_increase_rounded), Text("Indent"), () => indentLines(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.format_indent_decrease_rounded), Text("Outdent"), () => outdentLines(), minWidth), 
  ];

  if (Platform.isAndroid || Platform.isIOS) {// Makes sense only on mobile devices
    editBarTopContent.addAll([
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_up_rounded), Text("Move line/s up"), () => moveSelectionLine(true), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_down_rounded), Text("Move line/s down"), () => moveSelectionLine(false), minWidth), 
      ]
    );
    editBarBottomContent.addAll([
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_left_rounded), Text("Cursor to sol"), () => moveCursorToLineEdge(false), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_right_rounded), Text("Cursor to eol"), () => moveCursorToLineEdge(true), minWidth),
        iconTextButtonLayoutBuilder(Text("CANC", style: GoogleFonts.robotoMono(fontSize: 12)), Text("Cancel"), () => canc(), minWidth),
      ]
    );
  }
  else {
    editBarBottomContent.addAll([
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_up_rounded), Text("Move line/s up"), () => moveSelectionLine(true), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_down_rounded), Text("Move line/s down"), () => moveSelectionLine(false), minWidth), 
        iconTextButtonLayoutBuilder(Text("CANC", style: GoogleFonts.robotoMono(fontSize: 12)), Text("Cancel"), () => canc(), minWidth),
      ]
    );
  }

  Wrap editBar = Wrap(
    direction: Axis.horizontal,
    alignment: WrapAlignment.center,
    children: [
      Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: editBarTopContent
      ),
      Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: editBarBottomContent
      ),
      
    ] 
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
    body: SafeArea(child: noteBody),
  );

  return scaffold;
}