import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_color_generator/material_color_generator.dart';

import '../backend/app_data.dart';
import '../backend/note_edit.dart';



Future<String> readFile(String path) async {
  
  String text = "";

  try {

    final File file = File(path);
    text = await file.readAsString();

  } catch (error) {

    appLog("Couldn't read file: $error", true);

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

void appLog(String log, triggerAppData) {

  String appName    = "AppData";
  String appVersion = "undefined";

  if (triggerAppData) {
    appName = AppData.instance.queriesData.version["name"] ?? appName;
    appVersion = AppData.instance.queriesData.version["version"] ?? appVersion;
  }

  debugPrint("[$appName][$appVersion] $log");
}

MaterialColor generateMaterialColorData(Color color) {

  MaterialColor materialColor = generateMaterialColor(color: color);

  return materialColor;
}