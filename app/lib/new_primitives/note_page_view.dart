import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import '../builders/app_bar_builder.dart';
import '../builders/input_field_builder.dart';

import '../backend/app_data.dart';



class NotePageView extends StatefulWidget {
  const NotePageView({
      super.key,
    }
  );

  @override
  State<NotePageView> createState() => NotePageViewState();
}

class NotePageViewInfo {
  
  late GlobalKey<NotePageViewState> key;
  late NotePageView                 widget;

  NotePageViewInfo({required CodeField noteCodeField}) {
    
    key    = GlobalKey<NotePageViewState>();
    widget = NotePageView(key: key);

  }

}



class NotePageViewState extends State<NotePageView> {

  int copiedLength = 0;
  int copiedLines = 0;

  int cursorRow = 0;
  int cursorColumn = 0;

  int selectionLength = 0;
  int selectionLines = 0;
  
  //Saved length and lines are already updated when listening to the notes table

  @override
  void initState() {
    super.initState();
  }

  //void graphicsSetAppBar(AppBar newAppBar) {
  //  setState(() {
  //    appBar = newAppBar;
  //  });
  //}

  void graphicsUpdateNotePageView() {//to update the title in case of unsaved buffers
    setState((){});
  }

  void graphicsSetCursorInfo(int newCursorRow, int newCursorColumn, int newSelectionLength, int newSelectionLines) {
    setState(() {
      cursorRow = newCursorRow;
      cursorColumn = newCursorColumn;
      selectionLength = newSelectionLength;
      selectionLines = newSelectionLines;
    });
  }

  @override
  Widget build(BuildContext context) {

    Padding textFieldPad = Padding(
      padding: const EdgeInsets.all(16.0),
      child: noteCodeFieldBuilder(AppData.instance.noteCodeController, context)
    );

    int bufferLength = AppData.instance.noteCodeController.text.length;
    int bufferLines = '\n'.allMatches(AppData.instance.noteCodeController.text).length + 1;

    String savedContent = (AppData.instance.selectedNote["content"] ?? "").toString();
    int savedLength = savedContent.length;
    int savedLines = "\n".allMatches(savedContent).length + 1;

    Row noteInfo = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Row $cursorRow, column $cursorColumn")
          ) 
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Selected $selectionLength characters, $selectionLines lines")
          )
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Buffer with $bufferLength characters, $bufferLines lines")
          ) 
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Saved $savedLength characters, $savedLines lines")
          ) 
        ),
      ],
    );

    Column noteBody = Column(
      children: [
        Expanded(child: textFieldPad),
        Padding(
          padding: const EdgeInsetsGeometry.directional(start: 4.0, end: 4.0),
          child: noteInfo,
        ),
      ],
    );

    Scaffold scaffold = Scaffold(
      appBar: noteAppBarBuilder(context),
      body: noteBody,
    );

    return scaffold;

  }
}