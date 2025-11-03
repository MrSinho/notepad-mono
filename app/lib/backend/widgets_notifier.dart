import 'package:flutter/material.dart';

import 'utils/utils.dart';

import 'app_data.dart';



class WidgetsNotifier {
  final ValueNotifier<int> rootPageUpdates     = ValueNotifier(0);
  final ValueNotifier<int> loginPageUpdates    = ValueNotifier(0);
  final ValueNotifier<int> homePageUpdates     = ValueNotifier(0);
  final ValueNotifier<int> notesViewUpdates    = ValueNotifier(0);
  final ValueNotifier<int> noteEditBarsUpdates = ValueNotifier(0);
  final ValueNotifier<int> inputFieldUpdates   = ValueNotifier(0);
}



void notifyRootPageUpdate() { // Updates both login page and home page
  appLog("Notifying builder update for root page");
  AppData.instance.widgetsNotifier.rootPageUpdates.value++;
}

void notifyLoginPageUpdate() {
  appLog("Notifying builder update for login page");
  AppData.instance.widgetsNotifier.loginPageUpdates.value++;
}

void notifyHomePageUpdate() {
  appLog("Notifying builder update for home page");
  AppData.instance.widgetsNotifier.homePageUpdates.value++;
}

void notifyNotesViewUpdate() {
  appLog("Notifying builder update for notes view");
  AppData.instance.widgetsNotifier.notesViewUpdates.value++;
}

void notifyNoteEditBarsUpdate() {
  appLog("Notifying builder update for note edit page");
  AppData.instance.widgetsNotifier.noteEditBarsUpdates.value++;
}

void notifyNoteEditFieldUpdate() {
  appLog("Notifying builder update for note edit page");
  AppData.instance.widgetsNotifier.inputFieldUpdates.value++;
}

void notifyAllPagesUpdate() {
  notifyRootPageUpdate();
  notifyNotesViewUpdate();
  notifyNoteEditBarsUpdate();
  notifyNoteEditFieldUpdate();
}