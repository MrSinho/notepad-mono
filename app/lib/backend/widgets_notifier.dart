import 'package:flutter/material.dart';

import 'utils/utils.dart';

import 'app_data.dart';



class WidgetsNotifier {
  final ValueNotifier<int> rootPageUpdates     = ValueNotifier(0);
  final ValueNotifier<int> notesViewUpdates    = ValueNotifier(0);
  final ValueNotifier<int> noteEditBarsUpdates = ValueNotifier(0);
  final ValueNotifier<int> inputFieldUpdates   = ValueNotifier(0);
}



void notifyNoteEditBarsUpdate() {
  appLog("Notifying builder update for note edit page");
  AppData.instance.widgetsNotifier.noteEditBarsUpdates.value++;
}

void notifyNoteEditFieldUpdate() {
  appLog("Notifying builder update for note edit page");
  AppData.instance.widgetsNotifier.inputFieldUpdates.value++;
}

void notifyRootPageUpdate() {
  appLog("Notifying builder update for root page");
  AppData.instance.widgetsNotifier.rootPageUpdates.value++;
}

void notifyNotesViewUpdate() {
  appLog("Notifying builder update for notes view");
  AppData.instance.widgetsNotifier.notesViewUpdates.value++;
}

void notifyAllPagesUpdate() {
  notifyRootPageUpdate();
  notifyNoteEditBarsUpdate();
  notifyNoteEditFieldUpdate();
}