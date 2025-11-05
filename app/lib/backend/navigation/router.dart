import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../note_edit/save_timer.dart';

import '../widgets_notifier.dart';

import '../app_data.dart';

import 'navigator.dart';



enum RoutesPaths {
  rootPage("/"),
  noteEditPage("/note_edit");
   
  final String path;

  const RoutesPaths(this.path);
}

GoRouter setupRouter() {
  GoRouter router = GoRouter(
    navigatorKey: NavigatorInfo.key,
    routes: <RouteBase>[
      GoRoute(path: RoutesPaths.rootPage.path, builder: (context, state) => AppData.instance.rootPage),
      GoRoute(path: RoutesPaths.noteEditPage.path, builder: (context, state) => AppData.instance.noteEditPage),
    ]
  );

  return router;
}

void goToNoteEditPage() {
  getNavigatorContext()?.go(RoutesPaths.noteEditPage.path);
  startEditTimer();
  notifyNoteEditBarsUpdate();
  notifyNoteEditFieldUpdate();
}

void goToRootPage() {
  getNavigatorContext()?.go(RoutesPaths.rootPage.path);
  stopEditTimer();
  notifyRootPageUpdate();
}

void popAll(BuildContext context) {
  while (context.canPop()) {
    context.pop();
  }
}