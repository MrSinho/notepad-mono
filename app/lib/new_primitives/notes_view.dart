import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils/utils.dart';

import '../builders/notes_view_builder.dart';



class NotesView extends StatefulWidget {
  const NotesView({
      super.key
    }
  );

  @override
  State<NotesView> createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {

  @override
  void initState() {
    super.initState();
    appLog("Initialized NotesViewState");
  }
  
  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder builder = ValueListenableBuilder(
      valueListenable: AppData.instance.widgetsNotifier.notesViewUpdates,
      builder: (context, value, child) => notesViewBuilder(context)
    );

    return builder;
  }
}