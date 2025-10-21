import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notepad_mono/backend/note_edit/note_edit.dart';

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
    child: AppData.instance.noteInputField,
  );

  double minWidth = 860;

  if (Platform.isAndroid || Platform.isIOS) {
    minWidth = 1034;
  }

  List<Widget> editBarTopContent = [
    iconTextButtonLayoutBuilder(const Icon(Icons.save_rounded), Text("Save"), () => saveNoteContent(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.copy_rounded), Text("Copy"), () => copySelectionToClipboard(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.sticky_note_2_rounded), Text("Copy note"), () => copyNoteToClipboard(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.wrap_text_rounded), Text("Copy line/s"), () => copyLines(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.wrap_text_rounded), Text("Duplicate lines/s"), () => duplicateLines(), minWidth), 
    iconTextButtonLayoutBuilder(const Icon(Icons.cut_rounded), Text("Cut line/s"), () => cutLines(), minWidth),
    iconTextButtonLayoutBuilder(const Icon(Icons.paste_rounded), Text("Paste"), () => pasteContent(), minWidth),

    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_right_rounded),
    //  const Text("Select from cursor to eol"),
    //  () {}
    //),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_left_rounded),
    //  const Text("Delete from cursor to sol"),
    //  () {}
    //),
    //wrapIconTextButton(
    //  const Icon(Icons.keyboard_arrow_right_rounded),
    //  const Text("Delete from cursor to eol"),
    //  () {}
    //),
    
  ];

  List<Widget> editBarBottomContent = [
  ];

  if (Platform.isAndroid || Platform.isIOS) {// Makes sense only on mobile devices
    editBarTopContent.addAll([
        iconTextButtonLayoutBuilder(Text("CANC", style: GoogleFonts.robotoMono(fontSize: 12)), Text("Cancel"), () => canc(), minWidth),
      ]
    );
    editBarBottomContent.addAll([
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_up_rounded), Text("Move line/s up"), () => moveSelectionLine(true), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_down_rounded), Text("Move line/s down"), () => moveSelectionLine(false), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.format_indent_increase_rounded), Text("Indent"), () => indentLines(), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.format_indent_decrease_rounded), Text("Outdent"), () => outdentLines(), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_left_rounded), Text("Cursor to sol"), () => moveCursorToLineEdge(false), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_right_rounded), Text("Cursor to eol"), () => moveCursorToLineEdge(true), minWidth),
        iconTextButtonLayoutBuilder(const Icon(Icons.zoom_out), Text("Zoom out"), () => addToEditFontSize(-1.0), minWidth),
        iconTextButtonLayoutBuilder(const Icon(Icons.zoom_in), Text("Zoom in"), () => addToEditFontSize(1.0), minWidth),
      ]
    );
  }
  else {
    editBarBottomContent.addAll([
        iconTextButtonLayoutBuilder(const Icon(Icons.format_indent_increase_rounded), Text("Indent"), () => indentLines(), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.format_indent_decrease_rounded), Text("Outdent"), () => outdentLines(), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_up_rounded), Text("Move line/s up"), () => moveSelectionLine(true), minWidth), 
        iconTextButtonLayoutBuilder(const Icon(Icons.keyboard_arrow_down_rounded), Text("Move line/s down"), () => moveSelectionLine(false), minWidth), 
        iconTextButtonLayoutBuilder(Text("CANC", style: GoogleFonts.robotoMono(fontSize: 12)), Text("Cancel"), () => canc(), minWidth),
        iconTextButtonLayoutBuilder(const Icon(Icons.zoom_out), Text("Zoom out"), () => addToEditFontSize(-1.0), minWidth),
        iconTextButtonLayoutBuilder(const Icon(Icons.zoom_in), Text("Zoom in"), () => addToEditFontSize(1.0), minWidth),
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