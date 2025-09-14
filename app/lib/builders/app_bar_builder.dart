import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nnotes/backend/notify_ui.dart';
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
    Text(AppData.instance.queriesData.version["name"] ?? "none", style: GoogleFonts.robotoMono(fontSize: 25, fontWeight: FontWeight.bold)),
    const SizedBox(width: 12),
    Column(
      children: [
        Wrap(
          children: [
            Text(
              AppData.instance.queriesData.version["version"] ?? "",
              style: GoogleFonts.robotoMono(fontSize: 10),
            ),
          ] 
        ),
        const SizedBox(height: 4)
      ]
    )
  ];

  if (AppData.instance.noteEditStatusData.status == NoteEditStatus.lostConnection) {
    mainAppBarLeftChildren.add(
      Padding(
        padding: const EdgeInsetsGeometry.only(left: 12),
        child: IconButton(
          icon: const Icon(Icons.signal_wifi_connected_no_internet_4_rounded),
          onPressed: () {
            AppData.instance.noteEditStatusData.status = NoteEditStatus.dismissedErrors;
            notifyHomePageUpdate();
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

Widget editAppBarContentBuilder(BuildContext context) {
  appLog("Updating edit app bar content");

  String title = AppData.instance.queriesData.selectedNote["title"] ?? "";

  List<Widget> leftChildren = [
    Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 8.0, right: 4.0),
      child: Icon(Icons.circle, color: AppData.instance.noteEditStatusData.color, size: 14.0,),
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
  ];

  Wrap content = Wrap(
    direction: Axis.horizontal,
    crossAxisAlignment: WrapCrossAlignment.end,
    children: leftChildren
  );

  return content;
}

AppBar editAppBarBuilder(BuildContext context) {

  AppBar appBar = AppBar(
    title: AppData.instance.editAppBarContent,
    actions: [ 
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
    ],
  );

  return appBar;
}