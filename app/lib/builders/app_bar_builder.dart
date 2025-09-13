import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/app_data.dart';
import '../backend/supabase/queries.dart';
import '../backend/utils.dart';
import '../backend/note_edit.dart';

import '../static/info_settings_dialogs.dart';
import '../static/supabase_dialogs.dart';

import '../themes.dart';



AppBar mainAppBarBuilder(BuildContext context) {

  List<Widget> mainAppBarLeftChildren = [
    Text(AppData.instance.version["name"] ?? "none", style: GoogleFonts.robotoMono(fontSize: 25, fontWeight: FontWeight.bold)),
    const SizedBox(width: 12),
    Column(
      children: [
        Wrap(
          children: [
            Text(
              AppData.instance.version["version"] ?? "",
              style: GoogleFonts.robotoMono(fontSize: 10),
            ),
          ] 
        ),
        const SizedBox(height: 4)
      ]
    )
  ];

  if (AppData.instance.noteEditStatus == NoteEditStatus.lostConnection) {
    mainAppBarLeftChildren.add(
      Padding(
        padding: const EdgeInsetsGeometry.only(left: 12),
        child: IconButton(
          icon: const Icon(Icons.signal_wifi_connected_no_internet_4_rounded),
          onPressed: () {
            AppData.instance.noteEditStatus = NoteEditStatus.dismissedErrors;
            AppData.instance.notesPageViewInfo.key.currentState!.graphicsUpdate();
          }
        )
          
      )
    );
  }

  AppBar appBar = AppBar(
    leading: IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => showDialog(context: context, builder: (BuildContext context) => newNoteDialog(context))
    ),
    title: Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: mainAppBarLeftChildren
    ),
    actions: [
      IconButton(
        icon: ClipOval(
          child: Image.network(Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? ""),
        ),
        onPressed: () => showDialog(context: context, builder: (BuildContext context) => userInfoDialog(context))
      ),
      const SizedBox(width: 8.0)
    ],
  );

  return appBar;
}

AppBar noteAppBarBuilder(BuildContext context, String errorMessage) {

  String title = AppData.instance.selectedNote["title"] ?? "";


  //if (AppData.instance.noteCodeController.text != AppData.instance.selectedNote["content"]) {
  //  leftColor = Colors.yellow;
  //}

  //if (errorMessage != "") {
  //  leftColor = Colors.red;
  //}

  List<Widget> noteAppBarLeftChildren = [
    Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 8.0, right: 4.0),
      child: Icon(Icons.circle, color: AppData.instance.noteEditColor, size: 14.0,),
    ),
    TextButton(
      child: Text(
        title, 
        style: GoogleFonts.robotoMono(
          fontSize: 25,
          fontWeight: FontWeight.bold, 
          color: getCurrentThemePalette(context).primaryVividColor
        )
      ),
      onPressed: () => showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context)),
    ),
    //Column(
    //  children: [
    //    Wrap(
    //      children: [
    //        const SizedBox(width: 12.0),
    //        Text(
    //          "Last edit ${formatDateTime(AppData.instance.selectedNote["last_edit"] ?? "")}",
    //          style: GoogleFonts.robotoMono(fontSize: 10),
    //        ),
    //      ] 
    //    ),
    //    const SizedBox(height: 6)
    //  ]
    //)
  ];

  //if (errorMessage != "") {
  //  noteAppBarLeftChildren.addAll([
  //    const SizedBox(width: 12.0),
  //    connectionErrorWidget(errorMessage, AppData.instance.notePageViewInfo.key.currentState!.graphicsDismissWarningMessage)
  //  ]);
  //}

  AppBar appBar = AppBar(
    title: Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: noteAppBarLeftChildren
    ),
    actions: [ 
      //IconButton(icon: const Icon(Icons.undo_sharp), onPressed: (){}),
      //IconButton(icon: const Icon(Icons.redo_sharp), onPressed: (){}),
      IconButton(
        icon: const Icon(Icons.copy_sharp),
        onPressed: () async => await copySelectionToClipboardOrNot()
      ),
      IconButton(
        icon: const Icon(Icons.copy_all_sharp),
        onPressed: () async => await copyNoteToClipboardOrNot()
      ),
      IconButton(
        icon: const Icon(Icons.save_outlined),
        onPressed: () async => await saveNoteContent()
      ),
      IconButton(
        icon: ClipOval(
          child: Image.network(Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? ""),
        ),
        onPressed: () => showDialog(context: context, builder: (BuildContext context) => userInfoDialog(context))
      ),
      const SizedBox(width: 8.0)
      //For future updates
      //IconButton(
      //  icon: const Icon(Icons.menu_outlined),
      //  onPressed: () => showDialog(context: context, builder: (BuildContext context) => settingsDialog(context))
      //)
    ],
  );

  return appBar;
}