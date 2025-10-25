import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit/note_edit.dart';
import '../utils.dart';
import '../notify_ui.dart';



void listenToVersions() {

  try {

    SupabaseQueryBuilder table = Supabase.instance.client.from("Versions");

    if (AppData.instance.queriesData.versionsSubscription != null) {
      appLog("Cancelling versions stream from previous session");
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

        for (Map<String, dynamic> version in versions) {
          AppData.instance.queriesData.versions.addAll(
            {
              version["version"]: version
            }
          );

          if (version["version"] == "v${AppData.instance.packageInfo.version}") {
            AppData.instance.queriesData.currentVersion = version;
          }
        }

        AppData.instance.queriesData.latestVersion = versions.first;
        notifyRootPageUpdate();
      },

      onError: (error) {
        setNoteEditStatus(NoteEditStatus.lostConnection);
      }

    );
    return;
  }
  catch (exception) {
    appLog("Failed listening to app versions: $exception");
    setNoteEditStatus(NoteEditStatus.lostConnection);
  }

}

void listenToNotes() {

  try {

    SupabaseQueryBuilder table = Supabase.instance.client.from("Notes");

    if (AppData.instance.queriesData.streamSubscription != null) {
      appLog("Canceling notes stream subscription from the previous session");
      AppData.instance.queriesData.streamSubscription!.cancel();
    }

    AppData.instance.queriesData.streamSubscription = table.stream(primaryKey: ["id"]).listen(

    (dynamic data) {

      //safely cast data as a List<Map<String, dynamic>>
      List<Map<String, dynamic>> notes = (data as List).whereType<Map<String, dynamic>>().toList();

        notes.sort((a, b) {
          final aTime = DateTime.tryParse(a["last_edit"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b["last_edit"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

        AppData.instance.queriesData.notes = notes;

        appLog("Pulled ${notes.length} notes from listen callback");

        notifyRootPageUpdate();
        notifyNoteEditBarsUpdate();

        //Update selected note
        for (Map<String, dynamic> note in notes) {
          if (note["id"] == AppData.instance.queriesData.selectedNote["id"]) {

            if (note["content"] != AppData.instance.noteEditData.controller.text) {
              setNoteEditStatus(NoteEditStatus.pulledChanges);
            }

            selectNote(note, false);
          }
        }
      },

      onError: (error) {
        appLog("Failed listening to notes");
        setNoteEditStatus(NoteEditStatus.lostConnection);
      }

    );

    return;

  }
  catch (exception) {
    appLog("Failed listening to new notes: $exception");
  }

}

