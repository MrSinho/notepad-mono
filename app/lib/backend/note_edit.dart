import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template/builders/input_field_builder.dart';

import 'app_data.dart';

import '../builders/app_bar_builder.dart';



void selectNote(BuildContext context, Map<String, dynamic> note) {
  AppData.instance.selectedNote = note;

  AppData.instance.noteCodeController.text = note["content"] ?? "";

  //AppData.instance.noteCodeController.addListener(
  //    setNoteCursorData
  //);

  //Cannot update immediately the noteAppBarViewInfo app bar because the key current state will always be null before pushing to the navigator
  WidgetsBinding.instance.addPostFrameCallback((_) {
    //AppData.instance.notePageViewInfo.key.currentState?.graphicsSetAppBar(noteAppBarBuilder(context));
    AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdateNotePageView();//It will check alone the selected note and make the correct app bar
  });
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

  //Selection and cursor info

  int cursorStart = controller.selection.start;
  int cursorEnd = controller.selection.end;

  int selectionStart = cursorStart < cursorEnd ? cursorStart : cursorEnd;
  int selectionEnd = cursorStart > cursorEnd ? cursorStart : cursorEnd;

  String selection = controller.text.substring(selectionStart, selectionEnd);

  int selectionLength = selection.length;
  int selectionLines = "\n".allMatches(selection).length;

  String textBeforeCursor = controller.text.substring(0, cursorStart);

  int cursorRow = "\n".allMatches(textBeforeCursor).length + 1;

  int lastNewlineIndex = textBeforeCursor.lastIndexOf('\n');
  int cursorColumn = cursorStart - (lastNewlineIndex + 1);

  //Note is already selected (widgets already built, no need for a post frame callback)
    
  AppData.instance.notePageViewInfo.key.currentState?.graphicsSetCursorInfo(cursorRow, cursorColumn, selectionLength, selectionLines);
  //During note page rebuild it will also check for the app bar title, so no need to do more

}