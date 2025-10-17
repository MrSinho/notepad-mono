import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_data.dart';
import '../../note_edit/note_edit.dart';



class CopyNoteIntent extends Intent {
  const CopyNoteIntent();
}

class CopyNoteAction extends Action<CopyNoteIntent> {
  CopyNoteAction();

  @override
  Object? invoke(CopyNoteIntent intent) {
    copyNote();
    return null;
  }
  
}

void copyNote() {
  
  TextEditingController controller = AppData.instance.noteEditData.controller;
  
  Clipboard.setData(ClipboardData(text: controller.text));

  setNoteEditStatus(NoteEditStatus.copiedNote);
}