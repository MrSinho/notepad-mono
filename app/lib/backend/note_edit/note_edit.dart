import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../static/note_dialogs.dart';

import '../utils.dart';
import '../notify_ui.dart';
import '../app_data.dart';
import '../color_palette.dart';
import '../navigator.dart';

import '../../themes.dart';


class NoteEditStatusData {
  
  late NoteEditStatus status;
  late String         message;

  NoteEditStatusData(
    {
      this.status = NoteEditStatus.uninitialized,
      this.message = ""
    }
  );

}

class NoteEditData {

  late CodeController controller;
  late FocusNode      focusNode;

  int savedContentLength = 0;
  int savedContentLines  = 0;
  int selectionLength    = 0;
  int selectionLines     = 0;
  int bufferLength       = 0;
  int bufferLines        = 0;
  int unsavedBytes       = 0;
  int cursorRow          = 0;
  int cursorColumn       = 0;

  int currentCursorStart = 0;

  String lastEdit = "";
}

enum NoteEditStatus {
  uninitialized(0, Colors.brown),
  lostConnection(1, Colors.deepOrange),
  selectedNote(2, Colors.lightGreenAccent),
  renamedNote(3, Colors.greenAccent),
  savedChanges(4, Colors.green),
  failedSave(5, Colors.red),
  selectedCharacters(6, Colors.lime),
  unsavedChanges(7, Colors.orange),
  pulledChanges(8, Colors.lightBlue),
  copiedSelection(9, Colors.deepPurpleAccent),
  copiedNote(10, Colors.purple),
  addedToFavorites(11, Colors.amber),
  removedFromFavorites(12, Colors.amberAccent),
  dismissedErrors(13, Colors.brown);

  final int   code;
  final Color color;

  const NoteEditStatus(this.code, this.color);
}


void setNoteEditStatus(NoteEditStatus status) {


  String message = "";

  switch (status) {
    case NoteEditStatus.uninitialized:
      message = "Uninitialized";
      break;
    case NoteEditStatus.lostConnection:
      message = "Lost connection";
      break;
    case NoteEditStatus.selectedNote:
      message = "Selected note, ${AppData.instance.noteEditData.savedContentLength} characters, ${AppData.instance.noteEditData.savedContentLines} lines. Last save ${AppData.instance.noteEditData.lastEdit}";
      break;
    case NoteEditStatus.renamedNote:
      message = "Renamed note";
      break;
    case NoteEditStatus.savedChanges:
      message = "Saved ${AppData.instance.noteEditData.savedContentLength} characters, ${AppData.instance.noteEditData.savedContentLines} lines. Last save ${AppData.instance.noteEditData.lastEdit}";
      break;
    case NoteEditStatus.failedSave:
      message = "Failed saving note, connection lost";
      break;
    case NoteEditStatus.selectedCharacters:
      message = "Selected ${AppData.instance.noteEditData.selectionLength} characters, ${AppData.instance.noteEditData.selectionLines} lines";
      break;
    case NoteEditStatus.unsavedChanges:
      message = "Buffer with ${AppData.instance.noteEditData.bufferLength} characters, ${AppData.instance.noteEditData.bufferLines} lines";
      break;
    case NoteEditStatus.pulledChanges:
      message = "Pulled changes from another device";
      break;
    case NoteEditStatus.copiedNote:
      message = "Copied note to clipboard";
      break;
    case NoteEditStatus.copiedSelection:
      message = "Copied selection to clipboard";
      break;
    case NoteEditStatus.addedToFavorites:
      message = "Note added to favorites";
      break;
    case NoteEditStatus.removedFromFavorites:
      message = "Note removed favorites";
      break;
    case NoteEditStatus.dismissedErrors:
      message = "Dismissed errors";
      break;
  }

  AppData.instance.noteEditStatusData.status  = status;
  AppData.instance.noteEditStatusData.message = message;

  appLog("New note edit status: $message", true);
  
  notifyNoteEditUpdate();
  notifyHomePageUpdate();
}

void setNoteControllerText(String text) {
  
  int cursorStart = AppData.instance.noteEditData.currentCursorStart;

  if (cursorStart >= text.length) {
    cursorStart = text.length - 1;
    AppData.instance.noteEditData.currentCursorStart = cursorStart;
  }

  appLog("Cursor start: $cursorStart", true);

  AppData.instance.noteEditData.controller.text = text;

  AppData.instance.noteEditData.controller.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: cursorStart),
  );

  AppData.instance.noteEditData.controller.selection = TextSelection.collapsed(offset: cursorStart);

}

void selectNote(Map<String, dynamic> note, bool changeStatus, BuildContext context) {
  AppData.instance.queriesData.selectedNote = note;

  appLog("Selected note ${note["title"]}", true);

  setNoteControllerText(note["content"] ?? "");
  getNoteTextData();
  getNoteCursorData();

  AppData.instance.editColorPaletteData = generateRandomColorPalette(2, isThemeBright(context));

  if (changeStatus) {
    setNoteEditStatus(NoteEditStatus.selectedNote);
  }
}

void getNoteTextData() {
  appLog("Getting note text data", true);

  AppData.instance.noteEditData.bufferLength = AppData.instance.noteEditData.controller.text.length;
  AppData.instance.noteEditData.bufferLines = '\n'.allMatches(AppData.instance.noteEditData.controller.text).length + 1;

  String savedContent = (AppData.instance.queriesData.selectedNote["content"] ?? "").toString();
  AppData.instance.noteEditData.savedContentLength = savedContent.length;
  AppData.instance.noteEditData.savedContentLines = "\n".allMatches(savedContent).length + 1;

  AppData.instance.noteEditData.unsavedBytes = (AppData.instance.noteEditData.bufferLength - AppData.instance.queriesData.selectedNote["content"].toString().length).abs();

  appLog("Buffer length: ${AppData.instance.noteEditData.bufferLength}, lines: ${AppData.instance.noteEditData.bufferLines}", true);
  appLog("Saved content length: ${AppData.instance.noteEditData.savedContentLength}, lines: ${AppData.instance.noteEditData.savedContentLines}", true);

}

String getNoteSelectionText() {

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

  String selection = getNoteSelectionText();

  AppData.instance.noteEditData.currentCursorStart = controller.selection.start;
  
  AppData.instance.noteEditData.selectionLength = selection.length;
  AppData.instance.noteEditData.selectionLines = "\n".allMatches(selection).length + 1;

  String textBeforeCursor = controller.text.substring(0, AppData.instance.noteEditData.currentCursorStart);

  AppData.instance.noteEditData.cursorRow = "\n".allMatches(textBeforeCursor).length + 1;

  int lastNewlineIndex = textBeforeCursor.lastIndexOf('\n');
  AppData.instance.noteEditData.cursorColumn = AppData.instance.noteEditData.currentCursorStart - (lastNewlineIndex + 1);

  appLog("Cursor row: ${AppData.instance.noteEditData.cursorRow}, column: ${AppData.instance.noteEditData.cursorColumn}", true);
  appLog("Selection length: ${AppData.instance.noteEditData.selectionLength}, lines: ${AppData.instance.noteEditData.selectionLines}", true);
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
    controller.text == AppData.instance.queriesData.selectedNote["content"]?.toString() &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.renamedNote.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.pulledChanges.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.savedChanges.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.selectedNote.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.addedToFavorites.code 
  ) {
    setNoteEditStatus(NoteEditStatus.savedChanges);
  }

  if (AppData.instance.noteEditData.selectionLength > 0) {
    setNoteEditStatus(NoteEditStatus.selectedCharacters);
  }
}

void noteEditCallback() {
  appLog("Cursor listen callback triggered", true);
  getNoteCursorData();
  getNoteTextData();
  checkCursorNoteEditStatus();
}

void exitNoteEditPage(BuildContext context) {

  if (AppData.instance.noteEditData.controller.text != AppData.instance.queriesData.selectedNote["content"]) {
    appLog("Unsaved changes!!", true);
    showDialog(context: context, builder: (BuildContext context) => unsavedChangesDialog(context));
  }
  else {
    NavigatorInfo.getState()?.pop(context);
  }

}

