import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_data.dart';
import '../../note_edit/note_edit.dart';



class CopyLinesIntent extends Intent {
  const CopyLinesIntent();
}

class CopyLinesAction extends Action<CopyLinesIntent> {
  CopyLinesAction();

  @override
  Object? invoke(CopyLinesIntent intent) {
    copyLines();
    return null;
  }
  
}

void copyLines() {
  
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

  String line = text.substring(startLine, endLine);
  line += '\n';
  
  Clipboard.setData(ClipboardData(text: line));

  setNoteEditStatus(NoteEditStatus.copiedLines);

}