import 'package:flutter/material.dart';

//import '../backend/app_data.dart';

import '../builders/note_edit_page_builder.dart';



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

    Widget builder = noteEditPageBuilder(context);

    return builder;

  }
}