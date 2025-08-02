import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template/backend/supabase/queries.dart';

import '../backend/app_data.dart';

import '../static/easy_dialogs.dart';



AppBar mainAppBarBuilder(BuildContext context) {

  AppBar appBar = AppBar(
    title: Text("NNotes", style: GoogleFonts.robotoMono(fontSize: 25, fontWeight: FontWeight.bold)),
    actions: [ 
      
      IconButton(
        icon: ClipOval(
          child: Image.network(Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? ""),
        ),
        onPressed: () => showDialog(context: context, builder: (BuildContext context) => easySettingsDialog(context))
      ),
      IconButton(
        icon: const Icon(Icons.menu_outlined),
        onPressed: () => showDialog(context: context, builder: (BuildContext context) => easySettingsDialog(context))
      )
    ],
  );

  return appBar;
}

AppBar noteAppBarBuilder(BuildContext context) {

  String title = AppData.instance.selectedNote["title"];

  print("THITE " + title);

  AppBar appBar = AppBar(
    title: Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 10.0,
      children: [
        TextButton(
          child: Text(title, style: GoogleFonts.robotoMono(fontSize: 25, fontWeight: FontWeight.bold)),
          onPressed: () => showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context)),
        ),
        //TextButton(
        //  child: Text(
        //    "Last edit ${AppData.instance.selectedNote["last_edit"]}",
        //    style: GoogleFonts.robotoMono(fontSize: 10),
        //  ),
        //  onPressed: (){}
        //)
        Column(
          children: [
            Text(
              "Last edit ${AppData.instance.selectedNote["last_edit"]}",
              style: GoogleFonts.robotoMono(fontSize: 10),
            ),
            const SizedBox(height: 6)
          ]
        )
      ]
    ),
    actions: [ 
      IconButton(
        icon: const Icon(Icons.copy_all),
        onPressed: () async => await Clipboard.setData(ClipboardData(text: AppData.instance.noteTextEditingController.text))
      ),
      IconButton(
        icon: const Icon(Icons.save_outlined),
        onPressed: () async => await saveNoteContent()
      ), 
      IconButton(
        icon: ClipOval(
          child: Image.network(Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? ""),
        ),
        onPressed: () => showDialog(context: context, builder: (BuildContext context) => easySettingsDialog(context))
      ),
      IconButton(
        icon: const Icon(Icons.menu_outlined),
        onPressed: () => showDialog(context: context, builder: (BuildContext context) => easySettingsDialog(context))
      )
    ],
  );

  return appBar;
}