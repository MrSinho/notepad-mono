import 'package:flutter/material.dart';

import '../backend/app_data.dart';

import '../builders/note_page_view_builder.dart';



class NoteEditPage extends StatefulWidget {
  const NoteEditPage({
      super.key,
    }
  );

  @override
  State<NoteEditPage> createState() => NoteEditPageState();
}

class NoteEditPageState extends State<NoteEditPage> {

  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder<int> builder = ValueListenableBuilder<int>(
      valueListenable: AppData.instance.notePageViewUpdates,
      builder: (context, value, child) => notePageViewBuilder(context)
    );

    return builder;

  }
}