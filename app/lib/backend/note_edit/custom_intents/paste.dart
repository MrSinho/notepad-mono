import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_data.dart';
import '../../note_edit/note_edit.dart';



class PasteIntent extends Intent {
  const PasteIntent();
}

class PasteAction extends Action<PasteIntent> {
  PasteAction();

  @override
  Object? invoke(PasteIntent intent) {
    pasteContent();
    return null;
  }
  
}

void pasteContent() async {
  
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int start = selection.start;
  int end   = selection.end;

  ClipboardData? clipboardData = await Clipboard.getData("text/plain");

  if (clipboardData == null) {
    return;
  }

  String clipboardContent = clipboardData.text ?? "";

  if (clipboardContent == "") {
    return;
  }

  String newText = text.replaceRange(start, end, clipboardContent);

  controller.value = controller.value.copyWith(
    text: newText,
    selection: TextSelection.collapsed(
      offset: start.clamp(0, newText.length),
    )
  );

  setNoteEditStatus(NoteEditStatus.pastedContent);
}