import 'dart:async';

import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/markdown.dart';
import 'package:flutter/material.dart';

import '../../static/note_dialogs.dart';

import '../utils/utils.dart';

import '../notify_ui.dart';
import '../app_data.dart';
import '../navigation/router.dart';

import 'save_timer.dart';



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

  Timer saveTimer = Timer(Duration.zero, (){});
  int editTimeS = 0;

  late CodeController controller;
  late FocusNode      focusNode;

  double fontSize = 16.0;

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
  int currentCursorEnd   = 0;

  String lastEdit = "";
  bool   changeStatusAfterEdit = true;
}

enum NoteEditStatus {
  uninitialized(-1, Colors.brown),
  dismissedErrors(0, Colors.brown),  
  lostConnection(1, Colors.deepOrange),
  selectedNote(2, Colors.lightGreenAccent),
  renamedNote(3, Colors.greenAccent),
  addedToFavorites(4, Colors.amber),
  removedFromFavorites(5, Colors.amberAccent),

  savedChanges(6, Colors.green),
  failedSave(7, Colors.red),
  selectedCharacters(8, Colors.lime),
  unsavedChanges(9, Colors.orange),
  pulledChanges(10, Colors.lightBlue),
  copiedSelection(11, Colors.deepPurpleAccent),
  copiedNote(12, Colors.purple),
  duplicatedLines(13, Colors.orangeAccent),
  copiedLines(14, Colors.pink),
  cutLines(15, Colors.pink),
  pastedContent(16, Colors.pink),
  movedLinesUp(17, Colors.indigoAccent),
  movedLinesDown(18, Colors.indigo),
  indentLines(19, Colors.limeAccent),
  outdentLines(20, Colors.orangeAccent),
  cancCharacters(21, Colors.pinkAccent);


  final int   code;
  final Color color;

  const NoteEditStatus(this.code, this.color);
}


void setNoteEditStatus(NoteEditStatus status) {

  String message = "";

  switch (status) {
    case NoteEditStatus.uninitialized:
      message = "Uninitialized.";
      break;
    case NoteEditStatus.dismissedErrors:
      message = "Dismissed errors.";
      break;
    case NoteEditStatus.lostConnection:
      message = "Lost connection.";
      break;
    case NoteEditStatus.selectedNote:
      message = "Selected note, ${AppData.instance.noteEditData.savedContentLength} chars, ${AppData.instance.noteEditData.savedContentLines} lines.";
      break;
    case NoteEditStatus.renamedNote:
      message = "Renamed note.";
      break;
    case NoteEditStatus.addedToFavorites:
      message = "Note added to favorites.";
      break;
    case NoteEditStatus.removedFromFavorites:
      message = "Note removed from favorites.";
      break;
    case NoteEditStatus.savedChanges:
      message = "Saved ${AppData.instance.noteEditData.savedContentLength} chars, ${AppData.instance.noteEditData.savedContentLines} lines.";
      break;
    case NoteEditStatus.failedSave:
      message = "Failed saving note, connection lost";
      break;
    case NoteEditStatus.selectedCharacters:
      message = "Selected ${AppData.instance.noteEditData.selectionLength} chars, ${AppData.instance.noteEditData.selectionLines} lines.";
      break;
    case NoteEditStatus.unsavedChanges:
      message = "Buffer with ${AppData.instance.noteEditData.bufferLength} chars, ${AppData.instance.noteEditData.bufferLines} lines.";
      break;
    case NoteEditStatus.pulledChanges:
      message = "Pulled changes from another device.";
      break;
    case NoteEditStatus.copiedNote:
      message = "Copied note to clipboard.";
      break;
    case NoteEditStatus.copiedSelection:
      message = "Copied selection to clipboard.";
      break;
    case NoteEditStatus.duplicatedLines:
      message = "Duplicated lines.";
      break;
    case NoteEditStatus.copiedLines:
      message = "Copied lines.";
      break;
    case NoteEditStatus.cutLines:
      message = "Lines cut.";
      break;
    case NoteEditStatus.pastedContent:
      message = "Pasted content from clipboard.";
      break;
    case NoteEditStatus.movedLinesUp:
      message = "Moved lines up.";
      break;
    case NoteEditStatus.movedLinesDown:
      message = "Moved lines down.";
      break;
    case NoteEditStatus.indentLines:
      message = "Indented lines.";
      break;
    case NoteEditStatus.outdentLines:
      message = "Outdented lines.";
      break;
    case NoteEditStatus.cancCharacters:
      message = "Cancelled character/s.";
      break;
  }

  AppData.instance.noteEditStatusData.status  = status;
  AppData.instance.noteEditStatusData.message = message;

  appLog("New note edit status: $message");
  
  notifyNoteEditBarsUpdate();
  notifyRootPageUpdate();
}

CodeController setupEditController() {
  CodeController controller = CodeController(
    language: markdown,// currently only markdown linting
    namedSectionParser: const BracketsStartEndNamedSectionParser(),
  );
    
  controller.popupController.enabled = true;

  controller.addListener(noteEditCallback);

  return controller;
}

void setNoteControllerText(String text) {
  
  int cursorStart = AppData.instance.noteEditData.currentCursorStart;

  if (cursorStart > text.length) {
    cursorStart = text.length - 1;
    AppData.instance.noteEditData.currentCursorStart = cursorStart;
  }

  appLog("Cursor start: $cursorStart");

  AppData.instance.noteEditData.controller.text = text;

  AppData.instance.noteEditData.controller.value = TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: cursorStart),
  );

  AppData.instance.noteEditData.controller.selection = TextSelection.collapsed(offset: cursorStart);

}

void selectNote(Map<String, dynamic> note, bool changeStatus) {
  AppData.instance.queriesData.selectedNote = note;

  appLog("Selected note ${note["title"]}");

  setNoteControllerText(note["content"] ?? "");
  getNoteTextData();
  getNoteCursorData();

  if (changeStatus) {
    setNoteEditStatus(NoteEditStatus.selectedNote);
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

  appLog("Buffer length: ${AppData.instance.noteEditData.bufferLength}, lines: ${AppData.instance.noteEditData.bufferLines}");
  appLog("Saved content length: ${AppData.instance.noteEditData.savedContentLength}, lines: ${AppData.instance.noteEditData.savedContentLines}");

}

String getNoteSelectionText() {

  CodeController controller = AppData.instance.noteEditData.controller;
  String text = controller.text;

  TextSelection selection = controller.selection;

  if (!selection.isValid || selection.isCollapsed) {
    return "";
  }

  int cursorStart = controller.selection.start;
  int cursorEnd   = controller.selection.end;

  int selectionStart = cursorStart < cursorEnd ? cursorStart : cursorEnd;
  int selectionEnd   = cursorStart > cursorEnd ? cursorStart : cursorEnd;

  return text.substring(selectionStart, selectionEnd);
}

void getCursorPosition() {

  CodeController controller = AppData.instance.noteEditData.controller;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  TextSelection selection = controller.selection;
  int cursorOffset = selection.extentOffset;
  String text = controller.text;

  int safeOffset = cursorOffset.clamp(0, text.length);

  String textBeforeCursor = text.substring(0, safeOffset);

  int row = '\n'.allMatches(textBeforeCursor).length + 1;
  int lastNewlineIndex = textBeforeCursor.lastIndexOf('\n');
  int column = safeOffset - (lastNewlineIndex + 1);

  AppData.instance.noteEditData.cursorRow    = row;
  AppData.instance.noteEditData.cursorColumn = column;

}


void getNoteCursorData() {
  CodeController controller = AppData.instance.noteEditData.controller;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  AppData.instance.noteEditData.currentCursorStart = controller.selection.start;
  AppData.instance.noteEditData.currentCursorEnd   = controller.selection.end;

  String selection = getNoteSelectionText();
  
  AppData.instance.noteEditData.selectionLength = selection.length;
  AppData.instance.noteEditData.selectionLines = "\n".allMatches(selection).length + 1;

  getCursorPosition();

  appLog("Cursor row: ${AppData.instance.noteEditData.cursorRow}, column: ${AppData.instance.noteEditData.cursorColumn}");
  appLog("Selection length: ${AppData.instance.noteEditData.selectionLength}, lines: ${AppData.instance.noteEditData.selectionLines}");
}

void checkCursorNoteEditStatus() {

  CodeController controller = AppData.instance.noteEditData.controller;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }
  
  if (
    AppData.instance.noteEditData.changeStatusAfterEdit ||
    (controller.text != AppData.instance.queriesData.selectedNote["content"]?.toString() &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.duplicatedLines.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.cutLines.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.movedLinesUp.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.movedLinesDown.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.indentLines.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.outdentLines.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.cancCharacters.code)
  ) {
    setNoteEditStatus(NoteEditStatus.unsavedChanges);
  }

  if (
    controller.text == AppData.instance.queriesData.selectedNote["content"]?.toString() &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.selectedNote.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.renamedNote.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.addedToFavorites.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.removedFromFavorites.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.pulledChanges.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.savedChanges.code
  ) {
    setNoteEditStatus(NoteEditStatus.savedChanges);
  }  

  if (
    AppData.instance.noteEditData.changeStatusAfterEdit ||
    (AppData.instance.noteEditData.selectionLength > 0 &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.duplicatedLines.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.cutLines.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.movedLinesUp.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.movedLinesDown.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.indentLines.code &&
    AppData.instance.noteEditStatusData.status.code != NoteEditStatus.outdentLines.code)
  ) {
    setNoteEditStatus(NoteEditStatus.selectedCharacters);
  }

  switch (AppData.instance.noteEditStatusData.status) {
    case NoteEditStatus.unsavedChanges:
      AppData.instance.noteEditData.changeStatusAfterEdit = false;
      break;
    case NoteEditStatus.duplicatedLines:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    case NoteEditStatus.cutLines:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    case NoteEditStatus.pastedContent:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    case NoteEditStatus.movedLinesUp:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    case NoteEditStatus.movedLinesDown:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    case NoteEditStatus.indentLines:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    case NoteEditStatus.outdentLines:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    case NoteEditStatus.selectedCharacters:
      AppData.instance.noteEditData.changeStatusAfterEdit = false;
      break;
    case NoteEditStatus.cancCharacters:
      AppData.instance.noteEditData.changeStatusAfterEdit = true;
      break;
    default:
  }

}

void noteEditCallback() {
  appLog("Cursor listen callback triggered");
  getNoteCursorData();
  getNoteTextData();
  checkCursorNoteEditStatus();
  notifyNoteEditBarsUpdate();
  resetEditTimer();
}

void exitNoteEditPage(BuildContext context) {

  if (AppData.instance.noteEditData.controller.text != AppData.instance.queriesData.selectedNote["content"]) {
    appLog("Unsaved changes!!");
    showDialog(context: context, builder: (BuildContext context) => unsavedChangesDialog(context));
  }
  else {
    goToRootPage();
  }

}

void addToEditFontSize(double value) {
  AppData.instance.noteEditData.fontSize += value;
  notifyNoteEditFieldUpdate();
}