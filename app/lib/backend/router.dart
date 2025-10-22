import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepad_mono/backend/notify_ui.dart';

import 'note_edit/edit_timer.dart';

import 'utils.dart';



enum RoutesPaths {
  rootPage("/"),
  noteEditPage("/note_edit");
   
  final String path;

  const RoutesPaths(this.path);
}


String getCurrentRoute(BuildContext context) {
  String route = GoRouterState.of(context).uri.toString();
  appLog("Current route: $route", true);
  return route;
}

//void goToHomePage(BuildContext context) {
//  context.go(RoutesPaths.homePage.path);
//  stopEditTimer();
//  notifyHomePageUpdate();
//}

void goToNoteEditPage(BuildContext context) {
  context.go(RoutesPaths.noteEditPage.path);
  startEditTimer();
  notifyNoteEditBarsUpdate();
  notifyNoteEditFieldUpdate();
}

void goToRootPage(BuildContext context) {
  context.go(RoutesPaths.rootPage.path);
  stopEditTimer();
  notifyRootPageUpdate();
}