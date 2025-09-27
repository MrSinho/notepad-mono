import 'package:flutter/material.dart';

import '../../note_edit/note_edit.dart';
import '../../app_data.dart';



class IndentLinesIntent extends Intent {
  const IndentLinesIntent();
}

class IndentLinesAction extends Action<IndentLinesIntent> {
  IndentLinesAction();

  @override
  Object? invoke(IndentLinesIntent intent) {
    indentLines();
    return null;
  }

}

void indentLines() {
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int start = selection.start;
  int end   = selection.end;

  int startLine     = text.lastIndexOf('\n', start - 1) + 1;
  int endLine       = text.indexOf('\n', end);
  int actualEndLine = endLine == -1 ? text.length : endLine;

  List<String> lines    = text.substring(startLine, actualEndLine).split('\n');
  String       indented = lines.map((line) => "\t$line").join('\n');

  String newText = text.replaceRange(startLine, actualEndLine, indented);

  controller.value = controller.value.copyWith(
    text: newText,
    selection: TextSelection(
      baseOffset: start + 1, // keep cursor shifted by indent
      extentOffset: end + 1 * lines.length,
    ),
  );

  setNoteEditStatus(NoteEditStatus.indentLines);

}