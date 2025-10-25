import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_color_generator/material_color_generator.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';

import '../backend/app_data.dart';

import 'note_edit/note_edit.dart';



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

Future<void> copySelectionToClipboard() async {
  
  String buffer = getNoteSelectionText();

  setNoteEditStatus(NoteEditStatus.copiedSelection);

  if (buffer != "") {
    await Clipboard.setData(ClipboardData(text: buffer));
  }
  
  return;
}

Future<void> copyNoteToClipboard() async {
  
  String buffer = AppData.instance.noteEditData.controller.text;

  setNoteEditStatus(NoteEditStatus.copiedNote);

  if (buffer != "") {
    await Clipboard.setData(ClipboardData(text: buffer));
  }
  
  return;
}

void appLog(String log) {

  String appName    = AppData.instance.packageInfo.appName;
  String appVersion = AppData.instance.packageInfo.version;

  debugPrint("[$appName][$appVersion] $log");
}

MaterialColor generateMaterialColorData(Color color) {

  MaterialColor materialColor = generateMaterialColor(color: color);

  return materialColor;
}

Widget getProfilePicture(bool wrapInsideAvatar) {
  
  BoringAvatarType type = BoringAvatarType.marble;
  int seed = Random().nextInt(6);

  switch (seed) {
    case 1:
      type = BoringAvatarType.marble;
      break;
    case 2:
      type = BoringAvatarType.beam;
      break;
    case 3:
      type = BoringAvatarType.pixel;
      break;
    case 4:
      type = BoringAvatarType.sunset;
      break;
    case 5:
      type = BoringAvatarType.bauhaus;
      break;
    case 6:
      type = BoringAvatarType.ring;
      break;
  }

  BoringAvatar boringAvatar = BoringAvatar(name: AppData.instance.sessionData.username, type: type);

  Widget fill = Positioned.fill(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: const Color.fromARGB(25, 0, 0, 0),
        highlightColor: Colors.transparent,
      ),
    ),
  );

  if (AppData.instance.sessionData.profilePicture != null) {
    
    Widget stack = Stack(
      fit: StackFit.expand,
      children: [
        fill
      ],
    );

    ClipOval clip = ClipOval(
      clipBehavior: Clip.antiAlias,
      child: stack
    );
    
    CircleAvatar avatar = CircleAvatar(
      radius: 50,
      backgroundImage: AppData.instance.sessionData.profilePicture!,
      backgroundColor: Colors.transparent,
      child: clip
    );

    if (wrapInsideAvatar) {
      return avatar; // Something is wrong
    }
    else {
      return ClipOval(
        child: Image(image: AppData.instance.sessionData.profilePicture!)
      );
    }
  }
  
  Widget stack = Stack(
    fit: StackFit.expand,
    children: [
      boringAvatar,
      fill
    ],
  );

  Widget clip = ClipOval(
    clipBehavior: Clip.antiAlias,
    child: stack,
  );

  CircleAvatar avatar = CircleAvatar(
    radius: 50,
    backgroundColor: Colors.white,
    child: clip
  );

  if (wrapInsideAvatar) {
    return avatar;
  }
  else {
    return ClipOval(child: boringAvatar);
  }
}