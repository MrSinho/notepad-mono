import 'dart:async';

import '../supabase/queries.dart';

import '../app_data.dart';
import '../utils.dart';



void timerCallback(Timer timer) {
  AppData.instance.noteEditData.editTime++;

  if (AppData.instance.noteEditData.editTime % 3 != 0) {
    return;
  }

  if (AppData.instance.noteEditData.controller.text != AppData.instance.queriesData.selectedNote["content"]) {
    appLog("Triggered autosave!", true);
    saveNoteContent();
  }
}

void startEditTimer() {

  resetEditTimer();
  AppData.instance.noteEditData.saveTimer = Timer.periodic(const Duration(seconds: 1), timerCallback);

}

void resetEditTimer() {

  AppData.instance.noteEditData.editTime = 0;

}

void stopEditTimer() {

  AppData.instance.noteEditData.saveTimer.cancel();

}