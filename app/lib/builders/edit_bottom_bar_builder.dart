import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils/utils.dart';



Widget editBottomBarBuilder(BuildContext context) {

  appLog("Updating edit bottom bar");

  Row content = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Row ${AppData.instance.noteEditData.stringData.cursorRow}, column ${AppData.instance.noteEditData.stringData.cursorColumn}")
        ) 
      ),
      //Expanded(
      //  child: Align(
      //    alignment: Alignment.centerLeft,
      //    child: Text("Selected ${AppData.instance.noteEditData.stringData.selectionLength} characters, ${AppData.instance.noteEditData.stringData.selectionLines} lines")
      //  )
      //),
      Expanded(
        child: Align(
          alignment: Alignment.center,
          child: Text("*${AppData.instance.noteEditData.stringData.bufferLength} chars, ${AppData.instance.noteEditData.stringData.bufferLines} lines")
        ) 
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: Text("Saved ${AppData.instance.noteEditData.stringData.savedContentLength} chars, ${AppData.instance.noteEditData.stringData.savedContentLines} lines")
        ) 
      ),
    ],
  );

  return content;
}