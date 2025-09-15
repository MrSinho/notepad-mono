import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../backend/app_data.dart';
import '../backend/note_edit.dart';



Future<String> readFile(String path) async {
  
  String text = "";

  try {

    final File file = File(path);
    text = await file.readAsString();

  } catch (error) {

    appLog("Couldn't read file: $error");

  }
  return text;
}


String formatDateTime(String src) {

  DateTime localTime = DateTime.parse(src).toLocal();

  String formatted = DateFormat('dd/MM/yyyy HH:mm').format(localTime);

  return formatted;
}

Future<void> copySelectionToClipboardOrNot() async {
  
  String buffer = getNoteSelectionText();

  setNoteEditStatus(NoteEditStatus.copiedSelection);

  if (buffer != "") {
    await Clipboard.setData(ClipboardData(text: buffer));
  }
  
  return;
}

Future<void> copyNoteToClipboardOrNot() async {
  
  String buffer = AppData.instance.noteEditData.controller.text;

  setNoteEditStatus(NoteEditStatus.copiedNote);

  if (buffer != "") {
    await Clipboard.setData(ClipboardData(text: buffer));
  }
  
  return;
}

void appLog(String log) {
  debugPrint("[${AppData.instance.queriesData.version["name"]}][${AppData.instance.queriesData.version["version"]}] $log");
}