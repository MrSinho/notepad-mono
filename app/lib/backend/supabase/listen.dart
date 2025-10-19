import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit/note_edit.dart';
import '../utils.dart';
import '../notify_ui.dart';
import '../color_palette.dart';

import '../../themes.dart';



void listenToVersions(BuildContext context) {

  try {

    SupabaseQueryBuilder table = Supabase.instance.client.from("Versions");

    if (AppData.instance.queriesData.versionsSubscription != null) {
      appLog("Cancelling versions stream from previous session", true);
      AppData.instance.queriesData.versionsSubscription!.cancel();
    }

    AppData.instance.queriesData.versionsSubscription = table.stream(primaryKey: ["id"]).listen(

      (dynamic data) async {

        List<Map<String, dynamic>> versions = (data as List).whereType<Map<String, dynamic>>().toList();

        versions.sort((a, b) {
          final aTime = DateTime.tryParse(a["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

        AppData.instance.queriesData.version = versions.first;
        notifyHomePageUpdate();
        notifyLoginPageUpdate();
      },

      onError: (error) {
        //setNoteEditStatus(NoteEditStatus.lostConnection);
      }

    );
    return;
  }
  catch (exception) {
    appLog("Failed listening to app versions: $exception", true);
  }

}

void listenToNotes(BuildContext context) {

  try {

    SupabaseQueryBuilder table = Supabase.instance.client.from("Notes");

    if (AppData.instance.queriesData.streamSubscription != null) {
      appLog("Canceling notes stream subscription from the previous session", true);
      AppData.instance.queriesData.streamSubscription!.cancel();
    }

    AppData.instance.queriesData.streamSubscription = table.stream(primaryKey: ["id"]).listen(

    (dynamic data) async {

      //safely cast data as a List<Map<String, dynamic>>
      List<Map<String, dynamic>> notes = (data as List).whereType<Map<String, dynamic>>().toList();

        notes.sort((a, b) {
          final aTime = DateTime.tryParse(a["last_edit"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b["last_edit"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

        AppData.instance.queriesData.notes = notes;

        notifyHomePageUpdate();
        notifyNoteEditBarsUpdate();

        appLog("Pulled ${notes.length} notes from listen callback", true);

        AppData.instance.editColorPaletteData = generateRandomColorPalette(2, isThemeBright(context));
          
        //Update selected note
        for (Map<String, dynamic> note in notes) {
          if (note["id"] == AppData.instance.queriesData.selectedNote["id"]) {

            if (note["content"] != AppData.instance.noteEditData.controller.text) {
              setNoteEditStatus(NoteEditStatus.pulledChanges);
            }

            selectNote(note, false, context);
          }
        }

      },

      onError: (error) {
        appLog("Failed listening to notes", true);
        setNoteEditStatus(NoteEditStatus.lostConnection);
      }

    );

    return;

  }
  catch (exception) {
    appLog("Failed listening to new notes: $exception", true);
  }

}

