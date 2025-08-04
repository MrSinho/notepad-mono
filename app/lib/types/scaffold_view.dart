/*
import 'package:flutter/material.dart';

import 'app_bar_view.dart';

import '../backend/supabase/listen.dart';



class NotesView extends StatefulWidget {
  const NotesView({
    super.key,
  });

  @override
  State<NotesView> createState() {
    return NotesViewState();
  }

}

class NotesViewInfo {

  late GlobalKey<NotesViewState> key;
  late NotesView                 widget;

  NotesViewInfo() {
    key = GlobalKey<NotesViewState>();
    widget = NotesView(key: key);
  }

}

class NotesViewState extends State<NotesView> {

  AppBarViewInfo? appBarViewInfo = AppBarViewInfo(appBar: AppBar());
  Widget body = const Text("");

  @override
  void initState() {
    super.initState();
    listenToNotes(context);
  }

  void graphicsSetErrorMessage() {

  }

  @override
  Widget build(BuildContext context) {

    Scaffold scaffold = Scaffold(
      appBar: appBarViewInfo?.widget.appBar, 
      body: body,//If you want to change the state of the body you better save the Stateful widget data in AppData
    );

    return scaffold;
  }

}

*/