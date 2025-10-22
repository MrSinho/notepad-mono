import 'package:flutter/widgets.dart';

import 'app_data.dart';
import 'utils.dart';
import 'router.dart';



void notifyNoteEditBarsUpdate() {
  appLog("Notifying builder update for note edit page", true);
  AppData.instance.noteEditBarsUpdates.value++;
}

void notifyNoteEditFieldUpdate() {
  appLog("Notifying builder update for note edit page", true);
  AppData.instance.inputFieldUpdates.value++;
}

//void notifyHomePageUpdate() {
//  appLog("Notifying builder update for home page", true);
//  AppData.instance.homePageUpdates.value++; 
//}

void notifyRootPageUpdate() {
  appLog("Notifying builder update for root page", true);
  AppData.instance.rootPageUpdates.value++;
}

//void notifyNotesListenerCallback() {
//  appLog("Notifying builder update after notes listener callback", true);
//  AppData.instance.notesListenerUpdates.value++;
//}
//
//void notifyVersionsListenerCallback() {
//  appLog("Notifying builder update after versions listener callback", true);
//  AppData.instance.versionsListenerUpdates.value++;
//}

void notifyCurrentPageUpdate(BuildContext context) {
  String route = getCurrentRoute(context);

  if (route == RoutesPaths.rootPage.path) {
    notifyRootPageUpdate();
  }
  else if (route == RoutesPaths.noteEditPage.path) {
    notifyNoteEditBarsUpdate();
  }

}

void notifyAllPagesUpdate() {
  notifyRootPageUpdate();
  notifyNoteEditBarsUpdate();
  notifyNoteEditFieldUpdate();
}