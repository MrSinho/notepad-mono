import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit/note_edit.dart';
import '../utils/utils.dart';
import '../widgets_notifier.dart';



void listenToVersions() {

  try {

    SupabaseQueryBuilder table = Supabase.instance.client.from("Versions");

    if (AppData.instance.queriesData.versionsSubscription != null) {
      cancelVersionsStream();
    }

    AppData.instance.queriesData.versionsSubscription = table.stream(primaryKey: ["id"]).listen(

      (dynamic data) async {

        List<Map<String, dynamic>> versions = (data as List).whereType<Map<String, dynamic>>().toList();

        sortMapList(versions, "release_date");

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
        notifyHomePageUpdate();
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

void cancelVersionsStream() {
  appLog("Cancelling versions stream from previous session");

  if (AppData.instance.queriesData.versionsSubscription == null) {
    appLog("Already invalid stream subscription, nothing to cancel");
    return;
  }

  AppData.instance.queriesData.versionsSubscription!.cancel();

}

void listenToNotes() {

  try {

    SupabaseQueryBuilder table = Supabase.instance.client.from("Notes");

    if (AppData.instance.queriesData.notesSubscription != null) {
      cancelNotesStream();
    }

    AppData.instance.queriesData.notesSubscription = table.stream(primaryKey: ["id"]).listen(

    (dynamic data) {

      //safely cast data as a List<Map<String, dynamic>>
      List<Map<String, dynamic>> notes = (data as List).whereType<Map<String, dynamic>>().toList();

        sortMapList(notes, "last_edit");

        AppData.instance.queriesData.notes = notes;

        appLog("Pulled ${notes.length} notes from listen callback");

        notifyNotesViewUpdate();
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

void cancelNotesStream() {
  appLog("Cancelling notes stream from previous session");

  if (AppData.instance.queriesData.notesSubscription == null) {
    appLog("Already invalid stream subscription, nothing to cancel");
    return;
  }

  AppData.instance.queriesData.notesSubscription!.cancel();

}

