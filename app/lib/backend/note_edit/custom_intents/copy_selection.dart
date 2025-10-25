import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../note_edit/note_edit.dart';



class CopySelectionIntent extends Intent {
  const CopySelectionIntent();
}

class CopySelectionAction extends Action<CopySelectionIntent> {
  CopySelectionAction();

  @override
  Object? invoke(CopySelectionIntent intent) {
    copySelection();
    return null;
  }
  
}

void copySelection() async {
  
  String buffer = getNoteSelectionText();

  if (buffer != "") {
    Clipboard.setData(ClipboardData(text: buffer));
  }
  
  setNoteEditStatus(NoteEditStatus.copiedSelection);

  return;
}