import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import '../backend/utils.dart';

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

  AppData.instance.noteEditStatus = noteEditStatus;

  switch (AppData.instance.noteEditStatus) {
    case NoteEditStatus.uninitialized:
      AppData.instance.noteEditColor = Colors.deepOrange;
      break;
    case NoteEditStatus.lostConnection:
      AppData.instance.noteEditColor = Colors.red;
      break;
    case NoteEditStatus.selectedNote:
      AppData.instance.noteEditColor = Colors.lightGreenAccent;
      break;
    case NoteEditStatus.renamedNote:
      AppData.instance.noteEditColor = Colors.greenAccent;
      break;
    case NoteEditStatus.savedChanges:
      AppData.instance.noteEditColor = Colors.green;
      break;
    case NoteEditStatus.typingCharacters:
      AppData.instance.noteEditColor = Colors.yellow;
      break;
    case NoteEditStatus.selectedCharacters:
      AppData.instance.noteEditColor = Colors.lime;
      break;
    case NoteEditStatus.unsavedChanges:
      AppData.instance.noteEditColor = Colors.orange;
      break;
    case NoteEditStatus.pulledChanges:
      AppData.instance.noteEditColor = Colors.lightBlue;
      break;
    case NoteEditStatus.copiedNote:
      AppData.instance.noteEditColor = Colors.purple;
      break;
    case NoteEditStatus.copiedSelection:
      AppData.instance.noteEditColor = Colors.deepPurpleAccent;
      break;
    default:
      AppData.instance.noteEditColor = Colors.brown;
  }

  switch (AppData.instance.noteEditStatus) {
    case NoteEditStatus.lostConnection:
      AppData.instance.noteEditMessage = "Lost connection";
      break;
    case NoteEditStatus.selectedNote:
      AppData.instance.noteEditMessage = "Selected note";
      break;
    case NoteEditStatus.renamedNote:
      AppData.instance.noteEditMessage = "Renamed note";
      break;
    case NoteEditStatus.savedChanges:
      AppData.instance.noteEditMessage = "Saved ${AppData.instance.savedContentLength} characters, ${AppData.instance.savedContentLines} lines. \t\t\t\t Last save ${formatDateTime(AppData.instance.selectedNote["last_edit"] ?? "")}";
      break;
    case NoteEditStatus.typingCharacters:
      AppData.instance.noteEditMessage = "Typing characters";
      break;
    case NoteEditStatus.selectedCharacters:
      AppData.instance.noteEditMessage = "Selected ${AppData.instance.selectionLength} characters, ${AppData.instance.selectionLines} lines";
      break;
    case NoteEditStatus.unsavedChanges:
      AppData.instance.noteEditMessage = "Buffer with ${AppData.instance.bufferLength} characters, ${AppData.instance.bufferLines} lines";
      break;
    case NoteEditStatus.pulledChanges:
      AppData.instance.noteEditMessage = "Pulled changes from another device";
      break;
    case NoteEditStatus.copiedNote:
      AppData.instance.noteEditMessage = "Copied note to clipboard";
      break;
    case NoteEditStatus.copiedSelection:
      AppData.instance.noteEditMessage = "Copied selection to clipboard";
      break;
  }

  appLog(AppData.instance.noteEditMessage);
  
  AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdate();
}

void setNoteControllerText(String text) {
  
  AppData.instance.noteCodeController.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: text.length),
  );
  
}

void selectNote(Map<String, dynamic> note, bool changeStatus) {
  AppData.instance.selectedNote = note;

  setNoteControllerText(note["content"] ?? "");

  if (!changeStatus && AppData.instance.noteEditStatus != NoteEditStatus.pulledChanges) {
    setNoteEditStatus(NoteEditStatus.savedChanges);
    return;
  }
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

  String selection = getNoteSelectionText();

  int cursorStart = controller.selection.start;

  AppData.instance.selectionLength = selection.length;
  AppData.instance.selectionLines = "\n".allMatches(selection).length;

  String textBeforeCursor = controller.text.substring(0, cursorStart);

  AppData.instance.cursorRow = "\n".allMatches(textBeforeCursor).length + 1;

  int lastNewlineIndex = textBeforeCursor.lastIndexOf('\n');
  AppData.instance.cursorColumn = cursorStart - (lastNewlineIndex + 1);

  //Note is already selected (widgets already built, no need for a post frame callback)

  //ARRIVATO QUI!!
  if (controller.text != AppData.instance.selectedNote["content"]?.toString()) {
    setNoteEditStatus(NoteEditStatus.unsavedChanges);
  }
  else if (
    AppData.instance.noteEditStatus != NoteEditStatus.renamedNote &&
    AppData.instance.noteEditStatus != NoteEditStatus.pulledChanges &&
    AppData.instance.noteEditStatus != NoteEditStatus.savedChanges &&
    AppData.instance.noteEditStatus != NoteEditStatus.selectedNote &&
    controller.text == AppData.instance.selectedNote["content"]?.toString()
  ) {
    setNoteEditStatus(NoteEditStatus.savedChanges);
  }

  if (AppData.instance.selectionLength > 0) {
    setNoteEditStatus(NoteEditStatus.selectedCharacters);
  }
}