import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/app_data.dart';

import '../static/easy_dialogs.dart';

import '../types/app_bar_view.dart';
import '../types/text_field_view.dart';


class NotePageView extends StatefulWidget {
  const NotePageView({
      super.key,
      required this.appBar,
      required this.textField,
    }
  );

  final AppBar appBar;
  final TextField textField;
  
  @override
  State<NotePageView> createState() => NotePageViewState();
}

class NotePageViewInfo {
  
  late GlobalKey<NotePageViewState> key;
  late NotePageView                 widget;

  NotePageViewInfo({required AppBar appBar, required TextField textField}) {
    
    key    = GlobalKey<NotePageViewState>();
    widget = NotePageView(key: key, appBar: appBar, textField: textField);

  }

}



class NotePageViewState extends State<NotePageView> {

  late AppBar appBar;
  late TextField textField;

  @override
  void initState() {
    appBar = widget.appBar;
    textField = widget.textField;
    super.initState();
  }

  void graphicsSetAppBar(AppBar newAppBar) {
    setState(() {
      appBar = newAppBar;
    });
  }

  void graphicsSetTextField(TextField newTextField) {
    setState(() {
      textField = newTextField;
    });
  }

  @override
  Widget build(BuildContext context) {

    print("BUILDING NOTE PAGE!!");

    Padding textFieldPad = Padding(
      padding: const EdgeInsets.all(16.0),
      child: textField
    );

    String noteLength = AppData.instance.noteTextEditingController.text.length.toString();
    String rowCount = ('\n'.allMatches(AppData.instance.noteTextEditingController.text).length + 1).toString();
    String selectionLenth = AppData.instance.noteTextEditingController.selection.toString().length.toString();

    Row noteInfo = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Row 8, col. 23")
          ) 
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("${rowCount} lines")
          ) 
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Selection length ${selectionLenth}")
          ) 
        ),
        Expanded(
          child: Align(
            //alignment: Alignment.centerLeft,
            child: Text("Saved ${noteLength} characters")
          ) 
        ),
        Expanded(
          child: Align(
            //alignment: Alignment.centerLeft,
            child: Text("Auth provider: ${Supabase.instance.client.auth.currentUser?.appMetadata["provider"] ?? "none"}")
          ) 
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text("UTF-8")
          ) 
        )
      ],
    );

    Column noteBody = Column(
      children: [
        Expanded(child: textFieldPad),
        noteInfo,
      ],
    );

    Scaffold scaffold = Scaffold(
      appBar: appBar,
      body: noteBody,
    );

    return scaffold;

  }
}