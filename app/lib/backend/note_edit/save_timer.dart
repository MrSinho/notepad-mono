import 'dart:async';

import '../supabase/queries.dart';

import '../app_data.dart';

import '../utils/utils.dart';



void timerCallback(Timer timer) {
  AppData.instance.noteEditData.editTimeS++;

  if (AppData.instance.noteEditData.editTimeS % 2 != 0) {
    return;
  }

  if (AppData.instance.noteEditData.controller.text != AppData.instance.queriesData.selectedNote["content"]) {
    appLog("Triggered autosave!");
    saveNote();
  }
}

void startEditTimer() {

  AppData.instance.noteEditData.saveTimer = Timer.periodic(const Duration(seconds: 1), timerCallback);

}

void resetEditTimer() {

  AppData.instance.noteEditData.editTimeS = 0;

}

void stopEditTimer() {

  if (AppData.instance.noteEditData.saveTimer.isActive) {
    AppData.instance.noteEditData.saveTimer.cancel();
  }

}