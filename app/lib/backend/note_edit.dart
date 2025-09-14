import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import 'utils.dart';
import 'notify_ui.dart';
import 'app_data.dart';



typedef NoteEditStatusValue = int; 

class NoteEditStatus {

  static const NoteEditStatusValue uninitialized       =  0;
  static const NoteEditStatusValue lostConnection      =  1;
  static const NoteEditStatusValue selectedNote        =  2;
  static const NoteEditStatusValue savedChanges        =  3;
  static const NoteEditStatusValue typingCharacters    =  4;
  static const NoteEditStatusValue selectedCharacters  =  5;
  static const NoteEditStatusValue unsavedChanges      =  6;
  static const NoteEditStatusValue pulledChanges       =  7;
  static const NoteEditStatusValue copiedSelection     =  8;
  static const NoteEditStatusValue copiedNote          =  9;
  static const NoteEditStatusValue renamedNote         = 10;
  static const NoteEditStatusValue dismissedErrors     = 11;

}

void setNoteEditStatus(NoteEditStatusValue noteEditStatus) {

  AppData.instance.noteEditStatusData.status = noteEditStatus;

  switch (AppData.instance.noteEditStatusData.status) {
    case NoteEditStatus.uninitialized:
      AppData.instance.noteEditStatusData.color = Colors.deepOrange;
      break;
    case NoteEditStatus.lostConnection:
      AppData.instance.noteEditStatusData.color = Colors.red;
      break;
    case NoteEditStatus.selectedNote:
      AppData.instance.noteEditStatusData.color = Colors.lightGreenAccent;
      break;
    case NoteEditStatus.renamedNote:
      AppData.instance.noteEditStatusData.color = Colors.greenAccent;
      break;
    case NoteEditStatus.savedChanges:
      AppData.instance.noteEditStatusData.color = Colors.green;
      break;
    case NoteEditStatus.typingCharacters:
      AppData.instance.noteEditStatusData.color = Colors.yellow;
      break;
    case NoteEditStatus.selectedCharacters:
      AppData.instance.noteEditStatusData.color = Colors.lime;
      break;
    case NoteEditStatus.unsavedChanges:
      AppData.instance.noteEditStatusData.color = Colors.orange;
      break;
    case NoteEditStatus.pulledChanges:
      AppData.instance.noteEditStatusData.color = Colors.lightBlue;
      break;
    case NoteEditStatus.copiedNote:
      AppData.instance.noteEditStatusData.color = Colors.purple;
      break;
    case NoteEditStatus.copiedSelection:
      AppData.instance.noteEditStatusData.color = Colors.deepPurpleAccent;
      break;
    default:
      AppData.instance.noteEditStatusData.color = Colors.brown;
  }

  switch (AppData.instance.noteEditStatusData.status) {
    case NoteEditStatus.lostConnection:
      AppData.instance.noteEditStatusData.message = "Lost connection";
      break;
    case NoteEditStatus.selectedNote:
      AppData.instance.noteEditStatusData.message = "Selected note";
      break;
    case NoteEditStatus.renamedNote:
      AppData.instance.noteEditStatusData.message = "Renamed note";
      break;
    case NoteEditStatus.savedChanges:
      AppData.instance.noteEditStatusData.message = "Saved ${AppData.instance.noteEditData.savedContentLength} characters, ${AppData.instance.noteEditData.savedContentLines} lines. Last save ${formatDateTime(AppData.instance.queriesData.selectedNote["last_edit"] ?? "")}";
      break;
    case NoteEditStatus.typingCharacters:
      AppData.instance.noteEditStatusData.message = "Typing characters";
      break;
    case NoteEditStatus.selectedCharacters:
      AppData.instance.noteEditStatusData.message = "Selected ${AppData.instance.noteEditData.selectionLength} characters, ${AppData.instance.noteEditData.selectionLines} lines";
      break;
    case NoteEditStatus.unsavedChanges:
      AppData.instance.noteEditStatusData.message = "Buffer with ${AppData.instance.noteEditData.bufferLength} characters, ${AppData.instance.noteEditData.bufferLines} lines";
      break;
    case NoteEditStatus.pulledChanges:
      AppData.instance.noteEditStatusData.message = "Pulled changes from another device";
      break;
    case NoteEditStatus.copiedNote:
      AppData.instance.noteEditStatusData.message = "Copied note to clipboard";
      break;
    case NoteEditStatus.copiedSelection:
      AppData.instance.noteEditStatusData.message = "Copied selection to clipboard";
      break;
  }

  appLog("New note edit status: ${AppData.instance.noteEditStatusData.message}");
  
  notifyNoteEditUpdate();
}

void setNoteControllerText(String text) {
  
  AppData.instance.noteEditData.controller.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );

}

void selectNote(Map<String, dynamic> note, bool changeNoteEditStatus) {
  AppData.instance.queriesData.selectedNote = note;

  appLog("Selected note ${note["title"]}");

  setNoteControllerText(note["content"] ?? "");
  getNoteTextData();
  getNoteCursorData();

  if (!changeNoteEditStatus && AppData.instance.noteEditStatusData.status != NoteEditStatus.pulledChanges) {
    appLog("Changing note edit status after note selection");
    setNoteEditStatus(NoteEditStatus.savedChanges);
  }
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
    AppData.instance.noteEditStatusData.status != NoteEditStatus.renamedNote &&
    AppData.instance.noteEditStatusData.status != NoteEditStatus.pulledChanges &&
    AppData.instance.noteEditStatusData.status != NoteEditStatus.savedChanges &&
    AppData.instance.noteEditStatusData.status != NoteEditStatus.selectedNote &&
    controller.text == AppData.instance.queriesData.selectedNote["content"]?.toString()
  ) {
    setNoteEditStatus(NoteEditStatus.savedChanges);
  }
  if (AppData.instance.noteEditData.selectionLength > 0) {
    setNoteEditStatus(NoteEditStatus.selectedCharacters);
  }
}

void listenToCursor() {
  appLog("Cursor listen callback triggered");
  getNoteCursorData();
  getNoteTextData();
  checkCursorNoteEditStatus();
}