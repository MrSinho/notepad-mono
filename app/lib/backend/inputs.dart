import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'supabase/queries.dart';

import 'app_data.dart';
import 'utils.dart';
import 'note_edit/note_edit.dart';

import '../static/info_settings_widget.dart';
import '../static/note_dialogs.dart';
import '../static/shortcuts_map.dart';



class InputData {

  Set<LogicalKeyboardKey> keysPressed = {};
  
}



void homeInputListener(BuildContext context, KeyEvent event) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);
      
    bool ctrl  = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyM)) {
      showUserInfoWidget(context);
    }

    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyN)) {
      showDialog(context: context, builder: (BuildContext context) => newNoteDialog(context));
    }

  } 
  else {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void editInputListener(BuildContext context, KeyEvent event) {

  InputData inputData = AppData.instance.inputData;
  
  if (event is KeyDownEvent) {
    inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${inputData.keysPressed.toString()}", true);
      
    bool ctrl  = inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || inputData.keysPressed.contains(LogicalKeyboardKey.control);
    bool shift = inputData.keysPressed.contains(LogicalKeyboardKey.shiftLeft) || inputData.keysPressed.contains(LogicalKeyboardKey.shiftRight) || inputData.keysPressed.contains(LogicalKeyboardKey.shift);
    bool alt   = inputData.keysPressed.contains(LogicalKeyboardKey.altLeft) || inputData.keysPressed.contains(LogicalKeyboardKey.altRight) || inputData.keysPressed.contains(LogicalKeyboardKey.alt);

    if (ctrl && !alt && !shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyS)) {
      saveNoteContent();
    }

    if (ctrl && !alt && shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyS)) {
      //Save as
    }

    //if (ctrl && alt && !shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyC)) {//create custom intent
    //  copyNoteToClipboard();
    //  AppData.instance.inputData.keysPressed.clear();
    //}

    if (ctrl && !alt && !shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyT)) {
      flipFavoriteNote();
    }

    if (ctrl && !alt && !shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyR)) {
      showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context));
    }

    if (ctrl && !alt && !shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyN)) {
      showShortCutsMap(context);
    }

    if (ctrl && !alt && !shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyM)) {
      showUserInfoWidget(context);
    }

    if (ctrl && !alt && !shift && inputData.keysPressed.contains(LogicalKeyboardKey.keyQ)) {
      AppData.instance.inputData.keysPressed.clear();
      exitNoteEditPage(context);
    }

    if (ctrl && !alt && !shift && 
        (
          inputData.keysPressed.contains(LogicalKeyboardKey.add) ||
          inputData.keysPressed.contains(LogicalKeyboardKey.numpadAdd)
        )
    ) {
      addToEditFontSize(1.0);
    }

    if (ctrl && !alt && !shift && 
        (
          inputData.keysPressed.contains(LogicalKeyboardKey.minus) ||
          inputData.keysPressed.contains(LogicalKeyboardKey.numpadSubtract)
        )
    ) {
      addToEditFontSize(-1.0);
    }

  } 
  else {
    inputData.keysPressed.remove(event.logicalKey);
  }

}

void newNoteInputListener(BuildContext context, KeyEvent event, TextEditingController controller) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);
      
    bool ctrl = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
    
    if (ctrl & AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyN)) {
      renameNote(controller.text);
    }

  } 
  else {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void renameInputListener(BuildContext context, KeyEvent event, TextEditingController controller) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);

    bool ctrl = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
      
    if (ctrl & AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyR)) {
      context.pop();
    }

  } 
  else {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void userInfoInputListener(BuildContext context, KeyEvent event) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);

    bool ctrl = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
      
    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyM)) {
      context.pop();
    }

  } 
  else {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}

void shortcutsMapInputListener(BuildContext context, KeyEvent event) {

  if (event is KeyDownEvent) {
    AppData.instance.inputData.keysPressed.add(event.logicalKey);
    appLog("Keys pressed: ${AppData.instance.inputData.keysPressed.toString()}", true);

    bool ctrl = AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlLeft) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.controlRight) || AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.control);
      
    if (ctrl && AppData.instance.inputData.keysPressed.contains(LogicalKeyboardKey.keyN)) {
      context.pop();
    }

  } 
  else {
    AppData.instance.inputData.keysPressed.remove(event.logicalKey);
  }

}