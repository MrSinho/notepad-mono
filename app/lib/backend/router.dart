import 'package:go_router/go_router.dart';

import 'note_edit/edit_timer.dart';

import 'notify_ui.dart';
import 'navigator.dart';



enum RoutesPaths {
  rootPage("/"),
  noteEditPage("/note_edit");
   
  final String path;

  const RoutesPaths(this.path);
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