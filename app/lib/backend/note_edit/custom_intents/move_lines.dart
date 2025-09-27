import 'package:flutter/material.dart';

import '../../app_data.dart';



class MoveLinesUpIntent extends Intent {
  const MoveLinesUpIntent();
}

class MoveLinesUpAction extends Action<MoveLinesUpIntent> {
  MoveLinesUpAction();

  @override
  Object? invoke(MoveLinesUpIntent intent) {
    moveSelectionLine(true);
    return null;
  }
  
}

class MoveLinesDownIntent extends Intent {
  const MoveLinesDownIntent();
}

class MoveLinesDownAction extends Action<MoveLinesDownIntent> {
  MoveLinesDownAction();

  @override
  Object? invoke(MoveLinesDownIntent intent) {
    moveSelectionLine(false);
    return null;
  }
  
}

void moveSelectionLine(bool up) {
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;


  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int start = selection.start;
  int end   = selection.end;

  if (start <= 0 || end < 0) {
    return;//Don't mess with it
  }

  int startLine    = text.lastIndexOf('\n', start - 1) + 1;
  int endLineIndex = text.indexOf('\n', end);
  int endLine      = endLineIndex == -1 ? text.length : endLineIndex;

  String selectedText = text.substring(startLine, endLine);

  if (up) {//move up

    if (startLine == 0) {//already at top
      return;
    }

    int    previousLineStart = text.lastIndexOf('\n', startLine - 2) + 1;
    int    previousLineEnd   = startLine - 1;
    String previousLine      = text.substring(previousLineStart, previousLineEnd);

    String newText = text.replaceRange(
      previousLineStart,
      endLine,
      '$selectedText\n$previousLine',
    );

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection(
        baseOffset: previousLineStart,
        extentOffset: previousLineStart + selectedText.length
      )
    );

  } else {//move down

    if (endLine >= text.length) {//already at bottom
      return;
    }

    int    nextLineEnd   = text.indexOf('\n', endLine + 1);
    int    nextLineFinal = nextLineEnd == -1 ? text.length : nextLineEnd;
    String nextLine      = text.substring(endLine + 1, nextLineFinal);

    String newText = text.replaceRange(
      startLine,
      nextLineFinal,
      '$nextLine\n$selectedText',
    );

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection(
        baseOffset: startLine + nextLine.length + 1,
        extentOffset: startLine + nextLine.length + 1 + selectedText.length,
      ),
    );

  }

}