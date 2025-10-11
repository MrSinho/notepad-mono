import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';



Widget editBottomBarBuilder(BuildContext context) {

  appLog("Updating edit bottom bar", true);

  Row content = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Row ${AppData.instance.noteEditData.cursorRow}, column ${AppData.instance.noteEditData.cursorColumn}")
        ) 
      ),
      //Expanded(
      //  child: Align(
      //    alignment: Alignment.centerLeft,
      //    child: Text("Selected ${AppData.instance.noteEditData.selectionLength} characters, ${AppData.instance.noteEditData.selectionLines} lines")
      //  )
      //),
      Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Text("*${AppData.instance.noteEditData.bufferLength} chars, ${AppData.instance.noteEditData.bufferLines} loc")
        ) 
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text("Saved ${AppData.instance.noteEditData.savedContentLength} chars, ${AppData.instance.noteEditData.savedContentLines} loc")
        ) 
      ),
    ],
  );

  return content;
}