import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';

import '../themes.dart';

import '../builders/app_bar_builder.dart';
import '../builders/input_field_builder.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';



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

  bool newEditNotification = false;
  
  //Saved length and lines are already updated when listening to the notes table

  @override
  void initState() {
    super.initState();
  }

  void graphicsUpdate() {
    appLog("Updating graphics for NotePageView");
    setState((){});
  }

  void graphicsSetCursorInfo(int newCursorRow, int newCursorColumn, int newSelectionLength, int newSelectionLines) {
  }


  //void graphicsSetWarningMessage(String errorMsg) {
  //  setState(() {
  //    AppData.instance.errorMessage = errorMsg; 
  //    //ScaffoldMessenger.of(context).showMaterialBanner(
  //    //  errorMaterialBannerBuilder(errorMessage)
  //    //);
  //  });
  //}

  //void graphicsDismissWarningMessage() {
  //  setState(() {
  //    AppData.instance.errorMessage = "";
  //    //ScaffoldMessenger.of(context).clearMaterialBanners();
  //  });
  //}

  //void graphicsNotifyNewEdit() {
  //  setState(() {
  //    newEditNotification = true;
  //  });
  //}

  //void graphicsDismissNewEditNotification() {
  //  setState(() {
  //    newEditNotification = false;
  //  });
  //}

  @override
  Widget build(BuildContext context) {

    Padding textFieldPad = Padding(
      padding: const EdgeInsets.all(8.0),
      child: noteCodeFieldBuilder(AppData.instance.noteCodeController, context)
    );

    AppData.instance.bufferLength = AppData.instance.noteCodeController.text.length;
    AppData.instance.bufferLines = '\n'.allMatches(AppData.instance.noteCodeController.text).length + 1;

    String savedContent = (AppData.instance.selectedNote["content"] ?? "").toString();
    AppData.instance.savedContentLength = savedContent.length;
    AppData.instance.savedContentLines = "\n".allMatches(savedContent).length + 1;

    AppData.instance.unsavedBytes = (AppData.instance.bufferLength - AppData.instance.selectedNote["content"].toString().length).abs();

    Row noteBottomInfo = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Row ${AppData.instance.cursorRow}, column ${AppData.instance.cursorColumn}")
          ) 
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Selected ${AppData.instance.selectionLength} characters, ${AppData.instance.selectionLines} lines")
          )
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Buffer with ${AppData.instance.bufferLength} characters, ${AppData.instance.bufferLines} lines")
          ) 
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("Saved ${AppData.instance.savedContentLength} characters, ${AppData.instance.savedContentLines} lines")
          ) 
        ),
      ],
    );

    Center noteTopInfo = Center(
      child: Card(
        shadowColor: AppData.instance.noteEditColor,
        child: Padding(
          padding: const EdgeInsetsGeometry.all(8.0),
          child: Text(AppData.instance.noteEditMessage, style: TextStyle(color: getCurrentThemePalette(context).primaryForegroundColor, fontWeight: FontWeight.normal)),
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
      appBar: noteAppBarBuilder(context, AppData.instance.errorMessage),
      body: noteBody,
    );

    return scaffold;

  }
}