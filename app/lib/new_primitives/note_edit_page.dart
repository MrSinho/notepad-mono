import 'package:flutter/material.dart';

import '../backend/utils/utils.dart';

import '../builders/edit_page_builder.dart';



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
  void initState() {
    super.initState();
    appLog("Initialized NoteEditPageState");
  }

  @override
  Widget build(BuildContext context) {

    Widget builder = noteEditPageBuilder(context);

    return builder;

  }
}