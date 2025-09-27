import 'package:flutter/material.dart';


import '../../note_edit/note_edit.dart';
import '../../app_data.dart';



class DuplicateLinesIntent extends Intent {
  const DuplicateLinesIntent();
}

class DuplicateLinesAction extends Action<DuplicateLinesIntent> {
  DuplicateLinesAction();

  @override
  Object? invoke(DuplicateLinesIntent intent) {
    duplicateLines();
    return null;
  }

}

void duplicateLines() {
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int start = selection.start;
  int end   = selection.end;

  int startLine    = text.lastIndexOf('\n', start - 1) + 1;
  int endLineIndex = text.indexOf('\n', end);
  int endLine      = endLineIndex == -1 ? text.length : endLineIndex;

  String selectedText = text.substring(startLine, endLine);

  String newText = text.replaceRange(endLine, endLine, '\n$selectedText');

  controller.value = controller.value.copyWith(
    text: newText,
    selection: TextSelection(
      baseOffset: endLine + 1,
      extentOffset: endLine + 1 + selectedText.length,
    )
  );

  setNoteEditStatus(NoteEditStatus.duplicatedLines);

}