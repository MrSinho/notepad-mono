import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template/builders/text_field_builder.dart';

import 'app_data.dart';

import '../builders/app_bar_builder.dart';



void selectNote(BuildContext context, Map<String, dynamic> note) {
  AppData.instance.selectedNote = note;

  AppData.instance.noteTextEditingController = TextEditingController(text: note["content"] ?? "");

  //Cannot update immediately the noteAppBarViewInfo app bar because the key current state will always be null before pushing to the navigator
  WidgetsBinding.instance.addPostFrameCallback((_) {
    AppData.instance.notePageViewInfo.key.currentState?.graphicsSetAppBar(noteAppBarBuilder(context));
    AppData.instance.notePageViewInfo.key.currentState?.graphicsSetTextField(textFieldBuilder(AppData.instance.noteTextEditingController));
  });
}


