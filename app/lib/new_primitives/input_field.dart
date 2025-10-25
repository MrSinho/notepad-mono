import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';

import '../builders/input_field_builder.dart';



class NoteInputField extends StatefulWidget {
  const NoteInputField({
      super.key,
    }
  );

  @override
  State<NoteInputField> createState() => NoteInputFieldState();
}

class NoteInputFieldState extends State<NoteInputField> {

  @override
  void initState() {
    super.initState();
    appLog("Initialized NoteInputFieldState");
  }

  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder<int> builder = ValueListenableBuilder<int>(
      valueListenable: AppData.instance.inputFieldUpdates,
      builder: (context, value, child) => inputFieldBuilder(context)
    );

    return builder;

  }
}