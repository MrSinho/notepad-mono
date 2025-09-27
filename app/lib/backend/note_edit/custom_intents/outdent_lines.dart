import 'package:flutter/material.dart';

import '../../note_edit/note_edit.dart';
import '../../app_data.dart';



class OutdentLinesIntent extends Intent {
  const OutdentLinesIntent();
}

class OutdentLinesAction extends Action<OutdentLinesIntent> {
  OutdentLinesAction();

  @override
  Object? invoke(OutdentLinesIntent intent) {
    outdentLines();
    return null;
  }
  
}

void outdentLines() {
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int startLine = text.lastIndexOf('\n', selection.start - 1) + 1;
  int endLine = text.indexOf('\n', selection.end);
  int end = endLine == -1 ? text.length : endLine;

  String selected = text.substring(startLine, end);
  String outdented = selected
      .split('\n')
      .map((line) => line.startsWith("  ") ? line.substring(2) : line)
      .join('\n');

  String newText = text.replaceRange(startLine, end, outdented);

  controller.value = controller.value.copyWith(
    text: newText,
    selection: TextSelection(
      baseOffset: startLine,
      extentOffset: startLine + outdented.length,
    ),
  );

  setNoteEditStatus(NoteEditStatus.outdentLines);
}