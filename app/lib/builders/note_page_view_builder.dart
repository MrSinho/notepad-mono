import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/note_edit.dart';

import '../themes.dart';

import 'app_bar_builder.dart';
import 'input_field_builder.dart';



Widget notePageViewBuilder(BuildContext context) {
  getNoteTextData();
  getNoteCursorData();

  Padding textFieldPad = Padding(
    padding: const EdgeInsets.all(8.0),
    child: noteCodeFieldBuilder(AppData.instance.noteEditData.controller, context)
  );

  Row noteBottomInfo = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Row ${AppData.instance.noteEditData.cursorRow}, column ${AppData.instance.noteEditData.cursorColumn}")
        ) 
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Selected ${AppData.instance.noteEditData.selectionLength} characters, ${AppData.instance.noteEditData.selectionLines} lines")
        )
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text("Buffer with ${AppData.instance.noteEditData.bufferLength} characters, ${AppData.instance.noteEditData.bufferLines} lines")
        ) 
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text("Saved ${AppData.instance.noteEditData.savedContentLength} characters, ${AppData.instance.noteEditData.savedContentLines} lines")
        ) 
      ),
    ],
  );

  Center noteTopInfo = Center(
    child: Card(
      shadowColor: AppData.instance.noteEditStatusData.color,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(8.0),
        child: Text(AppData.instance.noteEditStatusData.message, style: TextStyle(color: getCurrentThemePalette(context).primaryForegroundColor, fontWeight: FontWeight.normal)),
      ),
    )
  );
    
  Column noteBody = Column(
    children: [
      Padding(
        padding: const EdgeInsetsGeometry.directional(start: 8.0, end: 8.0),
        child: noteTopInfo,
      ),
      Expanded(child: textFieldPad),
      Padding(
        padding: const EdgeInsetsGeometry.directional(start: 8.0, end: 8.0),
        child: noteBottomInfo,
      ),
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar: noteAppBarBuilder(context),
    body: noteBody,
  );

  return scaffold;
}