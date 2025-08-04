import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../backend/app_data.dart';
import '../backend/note_edit.dart';



String formatDateTime(String src) {

  DateTime localTime = DateTime.parse(src).toLocal();

  String formatted = DateFormat('dd/MM/yyyy HH:mm').format(localTime);

  return formatted;
}

Future<void> copySelectionToClipboardOrNot() async {
  
  String buffer = getNoteSelectionText();

  if (buffer != "") {
    await Clipboard.setData(ClipboardData(text: buffer));
  }
  
  return;
}

Future<void> copyNoteToClipboardOrNot() async {
  
  String buffer = AppData.instance.noteCodeController.text;

  if (buffer != "") {
    await Clipboard.setData(ClipboardData(text: buffer));
  }
  
  return;
}

