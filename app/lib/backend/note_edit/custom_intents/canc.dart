import 'package:flutter/material.dart';

import '../../app_data.dart';
import '../../note_edit/note_edit.dart';



class CancIntent extends Intent {
  const CancIntent();
}

class CancAction extends Action<CancIntent> {
  CancAction();

  @override
  Object? invoke(CancIntent intent) {
    canc();
    return null;
  }
  
}

void canc() {
  
  TextEditingController controller = AppData.instance.noteEditData.controller;
  String                text       = controller.text;
  TextSelection         selection  = controller.selection;

  if (!controller.selection.isValid || controller.selection.start < 0 || controller.selection.end < 0) {
    return; //Too early
  }

  int start = selection.start;
  int end   = selection.end;

  if (start != end) {

    String newText = text.replaceRange(start, end, '');

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: start,
      )
    );
    
  }
  else {

    if (start == text.length) {
      return;
    }

    String newText = text.replaceRange(start, start + 1, '');

    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: start.clamp(0, newText.length),
      )
    );

  }
  
  setNoteEditStatus(NoteEditStatus.cancCharacters);

}