import 'package:NNotes/static/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/app_data.dart';
import '../backend/note_edit.dart';
import '../backend/supabase/queries.dart';
import '../backend/utils.dart';

import '../static/info_settings_dialogs.dart';
import '../static/supabase_dialogs.dart';

import '../themes.dart';



AppBar mainAppBarBuilder(BuildContext context, String errorMessage) {

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

  if (errorMessage != "") {
    mainAppBarLeftChildren.addAll([
      const SizedBox(width: 12),
      connectionErrorWidget(errorMessage, AppData.instance.notesPageViewInfo.key.currentState!.graphicsDismissWarningMessage)
    ]);
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
      )
    ],
  );

  return appBar;
}

AppBar noteAppBarBuilder(BuildContext context, String errorMessage) {

  String title = AppData.instance.selectedNote["title"] ?? "";

  if (AppData.instance.noteCodeController.text != AppData.instance.selectedNote["content"]) {
    title = "*$title";
  }

  List<Widget> noteAppBarLeftChildren = [
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
    Column(
      children: [
        Wrap(
          children: [
            const SizedBox(width: 12.0),
            Text(
              "Last edit ${formatDateTime(AppData.instance.selectedNote["last_edit"] ?? "")}",
              style: GoogleFonts.robotoMono(fontSize: 10),
            ),
          ] 
        ),
        const SizedBox(height: 6)
      ]
    )
  ];

  if (errorMessage != "") {
    noteAppBarLeftChildren.addAll([
      const SizedBox(width: 12.0),
      connectionErrorWidget(errorMessage, AppData.instance.notePageViewInfo.key.currentState!.graphicsDismissWarningMessage)
    ]);
  }

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
      //For future updates
      //IconButton(
      //  icon: const Icon(Icons.menu_outlined),
      //  onPressed: () => showDialog(context: context, builder: (BuildContext context) => settingsDialog(context))
      //)
    ],
  );

  return appBar;
}