import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import 'app_data.dart';



void selectNote(BuildContext context, Map<String, dynamic> note) {
  AppData.instance.selectedNote = note;

  AppData.instance.noteCodeController.text = note["content"] ?? "";

}

String getNoteSelectionText() {
  CodeController controller = AppData.instance.noteCodeController;
  String text = controller.text;
  TextSelection selection = controller.selection;

  if (!selection.isValid || selection.isCollapsed) {
    return "";
  }

  int cursorStart = controller.selection.start;
  int cursorEnd = controller.selection.end;

  int selectionStart = cursorStart < cursorEnd ? cursorStart : cursorEnd;
  int selectionEnd = cursorStart > cursorEnd ? cursorStart : cursorEnd;

  return text.substring(selectionStart, selectionEnd);
}

void setNoteCursorData() {

  CodeController controller = AppData.instance.noteCodeController;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  //Selection and cursor info

  int cursorStart = controller.selection.start;

  String selection = getNoteSelectionText();

  int selectionLength = selection.length;
  int selectionLines = "\n".allMatches(selection).length;

  String textBeforeCursor = controller.text.substring(0, cursorStart);

  int cursorRow = "\n".allMatches(textBeforeCursor).length + 1;

  int lastNewlineIndex = textBeforeCursor.lastIndexOf('\n');
  int cursorColumn = cursorStart - (lastNewlineIndex + 1);

  //Note is already selected (widgets already built, no need for a post frame callback)
    
  AppData.instance.notePageViewInfo.key.currentState?.graphicsSetCursorInfo(cursorRow, cursorColumn, selectionLength, selectionLines);
  //During the note page rebuilding process it will also check for the app bar title, so no need to do more

}