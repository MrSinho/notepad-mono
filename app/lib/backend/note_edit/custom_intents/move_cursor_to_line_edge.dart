import 'package:flutter/material.dart';

import '../../app_data.dart';



class MoveCursorToEndOfLineIntent extends Intent {
  const MoveCursorToEndOfLineIntent();
}

class MoveCursorToEndOfLineAction extends Action<MoveCursorToEndOfLineIntent> {
  MoveCursorToEndOfLineAction();

  @override
  Object? invoke(MoveCursorToEndOfLineIntent intent) {
    moveCursorToLineEdge(true);
    return null;
  }
  
}

class MoveCursorToStartOfLineIntent extends Intent {
  const MoveCursorToStartOfLineIntent();
}

class MoveCursorToStartOfLineAction extends Action<MoveCursorToStartOfLineIntent> {
  MoveCursorToStartOfLineAction();

  @override
  Object? invoke(MoveCursorToStartOfLineIntent intent) {
    moveCursorToLineEdge(false);
    return null;
  }
  
}

void moveCursorToLineEdge(bool toEnd) {
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int offset = selection.baseOffset;

  if (offset <= 0) {
    return;//Don't mess with it
  }

  int startLineIndex = text.lastIndexOf('\n', offset - 1) + 1;
  
  int endLineIndex = text.indexOf('\n', offset);
  int endLine      = endLineIndex == -1 ? text.length : endLineIndex;

  int newOffset = toEnd ? endLine : startLineIndex;

  controller.selection = TextSelection.collapsed(offset: newOffset);
}


