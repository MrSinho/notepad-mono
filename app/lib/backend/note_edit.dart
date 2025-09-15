import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import 'utils.dart';
import 'notify_ui.dart';
import 'app_data.dart';



class NoteEditStatusData {
  
  late int    code;
  late Color  color;
  late String message;

  NoteEditStatusData(
    {
      required this.code,
      required this.color,
      required this.message
    }
  );

}

class NoteEditStatus {

  static NoteEditStatusData uninitialized = NoteEditStatusData(
    code:  0, color: Colors.deepOrange,
    message: "Uninitialized"
  );
  static NoteEditStatusData lostConnection = NoteEditStatusData(
    code:  1, color: Colors.red,
    message: "Lost connection"
  );
  static NoteEditStatusData selectedNote = NoteEditStatusData(
    code:  2, color: Colors.lightGreenAccent,
    message: "Selected note, ${AppData.instance.noteEditData.savedContentLength} characters, ${AppData.instance.noteEditData.savedContentLines} lines. Last save ${formatDateTime(AppData.instance.queriesData.selectedNote["last_edit"] ?? "")}"
  );
  static NoteEditStatusData renamedNote = NoteEditStatusData(
    code:  3, color: Colors.greenAccent,
    message: "Renamed note"
  );
  static NoteEditStatusData savedChanges = NoteEditStatusData(
    code:  4, color: Colors.green,
    message: "Saved ${AppData.instance.noteEditData.savedContentLength} characters, ${AppData.instance.noteEditData.savedContentLines} lines. Last save ${formatDateTime(AppData.instance.queriesData.selectedNote["last_edit"] ?? "")}"
  );
  static NoteEditStatusData failedSave = NoteEditStatusData(
    code: 5, color: Colors.red,
    message: "Failed saving note, connection lost"
  );
  static NoteEditStatusData selectedCharacters = NoteEditStatusData(
    code:  6, color: Colors.lime,
    message: "Selected ${AppData.instance.noteEditData.selectionLength} characters, ${AppData.instance.noteEditData.selectionLines} lines"
  );
  static NoteEditStatusData unsavedChanges = NoteEditStatusData(
    code:  7, color: Colors.orange,
    message: "Buffer with ${AppData.instance.noteEditData.bufferLength} characters, ${AppData.instance.noteEditData.bufferLines} lines"
  );
  static NoteEditStatusData pulledChanges = NoteEditStatusData(
    code:  8, color: Colors.lightBlue,
    message: "Pulled changes from another device"
  );
  static NoteEditStatusData copiedNote = NoteEditStatusData(
    code: 10, color: Colors.purple,
    message: "Copied note to clipboard"
  );
  static NoteEditStatusData copiedSelection = NoteEditStatusData(
    code:  9, color: Colors.deepPurpleAccent,
    message: "Copied selection to clipboard"
  );
  static NoteEditStatusData dismissedErrors = NoteEditStatusData(
    code: 11, color: Colors.brown,
    message: "Dismissed errors"
  );

}

void setNoteEditStatus(NoteEditStatusData data) {

  AppData.instance.noteEditStatusData = data;

  appLog("New note edit status: ${AppData.instance.noteEditStatusData.message}");
  
  notifyNoteEditUpdate();
  notifyHomePageUpdate();
}

void setNoteControllerText(String text) {
  
  AppData.instance.noteEditData.controller.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );

}

void selectNote(Map<String, dynamic> note) {
  AppData.instance.queriesData.selectedNote = note;

  appLog("Selected note ${note["title"]}");

  setNoteControllerText(note["content"] ?? "");
  getNoteTextData();
  getNoteCursorData();

  setNoteEditStatus(NoteEditStatus.selectedNote);
}

void getNoteTextData() {
  appLog("Getting note text data");

  AppData.instance.noteEditData.bufferLength = AppData.instance.noteEditData.controller.text.length;
  AppData.instance.noteEditData.bufferLines = '\n'.allMatches(AppData.instance.noteEditData.controller.text).length + 1;

  String savedContent = (AppData.instance.queriesData.selectedNote["content"] ?? "").toString();
  AppData.instance.noteEditData.savedContentLength = savedContent.length;
  AppData.instance.noteEditData.savedContentLines = "\n".allMatches(savedContent).length + 1;

  AppData.instance.noteEditData.unsavedBytes = (AppData.instance.noteEditData.bufferLength - AppData.instance.queriesData.selectedNote["content"].toString().length).abs();
}

String getNoteSelectionText() {

  appLog("Getting note selection data");

  CodeController controller = AppData.instance.noteEditData.controller;
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


void getNoteCursorData() {
  CodeController controller = AppData.instance.noteEditData.controller;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  appLog("Getting note cursor data");

  String selection = getNoteSelectionText();

  int cursorStart = controller.selection.start;

  AppData.instance.noteEditData.selectionLength = selection.length;
  AppData.instance.noteEditData.selectionLines = "\n".allMatches(selection).length;

  String textBeforeCursor = controller.text.substring(0, cursorStart);

  AppData.instance.noteEditData.cursorRow = "\n".allMatches(textBeforeCursor).length + 1;

  int lastNewlineIndex = textBeforeCursor.lastIndexOf('\n');
  AppData.instance.noteEditData.cursorColumn = cursorStart - (lastNewlineIndex + 1);
}

void checkCursorNoteEditStatus() {

  CodeController controller = AppData.instance.noteEditData.controller;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  if (controller.text != AppData.instance.queriesData.selectedNote["content"]?.toString()) {
    setNoteEditStatus(NoteEditStatus.unsavedChanges);
  }
  else if (
    AppData.instance.noteEditStatusData != NoteEditStatus.renamedNote &&
    AppData.instance.noteEditStatusData != NoteEditStatus.pulledChanges &&
    AppData.instance.noteEditStatusData != NoteEditStatus.savedChanges &&
    AppData.instance.noteEditStatusData != NoteEditStatus.selectedNote &&
    controller.text == AppData.instance.queriesData.selectedNote["content"]?.toString()
  ) {
    setNoteEditStatus(NoteEditStatus.savedChanges);
  }
  if (AppData.instance.noteEditData.selectionLength > 0) {
    setNoteEditStatus(NoteEditStatus.selectedCharacters);
  }
}

void noteEditCallback() {
  appLog("Cursor listen callback triggered");
  getNoteCursorData();
  getNoteTextData();
  checkCursorNoteEditStatus();
}