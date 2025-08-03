import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template/backend/note_edit.dart';
import 'package:template/backend/supabase/queries.dart';
import 'package:template/static/utils.dart';
import 'package:template/themes.dart';


import '../backend/app_data.dart';

import '../static/info_settings_dialogs.dart';
import '../static/supabase_dialogs.dart';



AppBar mainAppBarBuilder(BuildContext context) {

  AppBar appBar = AppBar(
    title: Text(AppData.instance.version["name"] ?? "none", style: GoogleFonts.robotoMono(fontSize: 25, fontWeight: FontWeight.bold)),
    leading: IconButton(
      icon: Icon(Icons.add),
      onPressed: () => showDialog(context: context, builder: (BuildContext context) => newNoteDialog(context))
    ),
    actions: [
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

AppBar noteAppBarBuilder(BuildContext context) {


  String title = AppData.instance.selectedNote["title"] ?? "";

  if (AppData.instance.noteCodeController.text != AppData.instance.selectedNote["content"]) {
    title = "*$title";
  }

  AppBar appBar = AppBar(
    title: Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
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
      ]
    ),
    actions: [ 
      IconButton(
        icon: const Icon(Icons.copy_sharp),
        onPressed: () async => await Clipboard.setData(ClipboardData(text: getNoteSelectionText()))
      ),
      IconButton(
        icon: const Icon(Icons.copy_all_sharp),
        onPressed: () async => await Clipboard.setData(ClipboardData(text: AppData.instance.noteCodeController.text))
      ),
      IconButton(
        icon: const Icon(Icons.save_outlined),
        onPressed: () async => await saveNoteContent()
      ),
      //TODO: save as button
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