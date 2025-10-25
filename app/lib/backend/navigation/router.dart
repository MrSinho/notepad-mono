import 'package:go_router/go_router.dart';

import '../../builders/auth_stream_builder.dart';

import '../note_edit/save_timer.dart';

import '../notify_ui.dart';

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
      GoRoute(path: RoutesPaths.rootPage.path, builder: (context, state) => authStreamBuilder(context)),
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