import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'supabase/queries.dart';

import 'app_data.dart';
import 'utils.dart';
import 'note_edit.dart';
import 'navigator.dart';

import '../static/info_settings_dialogs.dart';
import '../static/note_dialogs.dart';



class InputData {

  List<LogicalKeyboardKey> keysPressed = [];
  
}



void homeInputListener(BuildContext context, KeyEvent event) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);
      
    bool ctrl  = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
    bool shift = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.shiftLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.shiftRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.shift);
    bool alt   = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.altLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.altRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.alt);

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyI)) {
      showDialog(context: context, builder: (BuildContext context) => userInfoDialog(context));
      AppData.instance.inputData.keysPressed.clear();
    }

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyN)) {
      showDialog(context: context, builder: (BuildContext context) => newNoteDialog(context));
      AppData.instance.inputData.keysPressed.clear();
    }

  } 
  else if (event is KeyUpEvent) {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void editInputListener(BuildContext context, KeyEvent event) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);
      
    bool ctrl  = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
    bool shift = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.shiftLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.shiftRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.shift);
    bool alt   = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.altLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.altRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.alt);

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyS)) {
      saveNoteContent();
    }

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyC)) {
      setNoteEditStatus(NoteEditStatus.copiedSelection);          
    }

    if (ctrl && alt && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyC)) {
      copyNoteToClipboardOrNot();
    }

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyF)) {
      flipFavoriteNote();
    }

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyR)) {
      showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context));
      AppData.instance.inputData.keysPressed.clear();
    }

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyI)) {
      showDialog(context: context, builder: (BuildContext context) => userInfoDialog(context));
      AppData.instance.inputData.keysPressed.clear();
    }

    if (alt && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      exitNoteEditPage(context);
      AppData.instance.inputData.keysPressed.clear();
    }
  } 
  else if (event is KeyUpEvent) {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void newNoteInputListener(BuildContext context, KeyEvent event, TextEditingController controller) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);
      
    bool ctrl = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
    
    if (ctrl & AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyN)) {
      renameNote(controller.text);
      AppData.instance.inputData.keysPressed.clear();
    }

  } 
  else if (event is KeyUpEvent) {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void renameInputListener(BuildContext context, KeyEvent event, TextEditingController controller) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);

    bool ctrl = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
      
    if (ctrl & AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyR)) {
      NavigatorInfo.getState()?.pop(context);
      AppData.instance.inputData.keysPressed.clear();
    }

  } 
  else if (event is KeyUpEvent) {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void userInfoInputListener(BuildContext context, KeyEvent event) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);

    bool ctrl = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
      
    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyI)) {
      NavigatorInfo.getState()?.pop(context);
      AppData.instance.inputData.keysPressed.clear();
    }

  } 
  else if (event is KeyUpEvent) {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}