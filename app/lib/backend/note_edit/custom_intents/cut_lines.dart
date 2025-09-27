import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_data.dart';
import '../../note_edit/note_edit.dart';



class CutLinesIntent extends Intent {
  const CutLinesIntent();
}

class CutLinesAction extends Action<CutLinesIntent> {
  CutLinesAction();

  @override
  Object? invoke(CutLinesIntent intent) {
    cutLines();
    return null;
  }
  
}

void cutLines() {
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int start = selection.start;
  int end   = selection.end;

  if (start != end) {
    return;
  }

  int startLine    = text.lastIndexOf('\n', start - 1) + 1;
  int endLineIndex = text.indexOf('\n', start);
  int endLine      = endLineIndex == -1 ? text.length : endLineIndex;

  String line = text.substring(startLine, endLine);

  Clipboard.setData(ClipboardData(text: line));

  String newText = text.replaceRange(startLine, endLine == text.length ? endLine : endLine + 1, '');

  controller.value = controller.value.copyWith(
    text: newText,
    selection: TextSelection.collapsed(
      offset: startLine.clamp(0, newText.length),
    )
  );

  setNoteEditStatus(NoteEditStatus.cutLines);

}