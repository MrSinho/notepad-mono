import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit.dart';
import '../utils.dart';


void listenToVersions(BuildContext context) {

  try {

    SupabaseQueryBuilder table = Supabase.instance.client.from("Versions");

    table.stream(primaryKey: ["id"]).listen(

      (dynamic data) async {

        List<Map<String, dynamic>> versions = (data as List).whereType<Map<String, dynamic>>().toList();

        versions.sort((a, b) {
          final aTime = DateTime.tryParse(a["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bTime = DateTime.tryParse(b["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bTime.compareTo(aTime);
        });

        AppData.instance.version = versions.first;

        AppData.instance.notesPageViewInfo.key.currentState?.graphicsUpdate();
      },

      onError: (error) {
        setNoteEditStatus(NoteEditStatus.lostConnection);
        //AppData.instance.notesPageViewInfo.key.currentState?.graphicsUpdate();
      }

    );
    return;
  }
  catch (exception) {
    appLog("Failed listening to new notes: $exception");
  }

}

void listenToNotes(BuildContext context) {

    try {

      SupabaseQueryBuilder table = Supabase.instance.client.from("Notes");

      table.stream(primaryKey: ["id"]).listen(

        (dynamic data) async {

          //safely cast data as a List<Map<String, dynamic>>
          List<Map<String, dynamic>> notes = (data as List).whereType<Map<String, dynamic>>().toList();

          notes.sort((a, b) {
            final aTime = DateTime.tryParse(a["last_edit"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = DateTime.tryParse(b["last_edit"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

          AppData.instance.notes = notes;

          AppData.instance.notesPageViewInfo.key.currentState?.graphicsUpdate();

          appLog("Pulled notes from listen callback");
          
          //Update selected note
          for (Map<String, dynamic> note in notes) {
            if (note["id"] == AppData.instance.selectedNote["id"]) {

              selectNote(note, false);
              
              if (note["content"] != AppData.instance.noteCodeController.text) {
                setNoteEditStatus(NoteEditStatus.pulledChanges);
              }


              //if (changeStatus) {
              //  WidgetsBinding.instance.addPostFrameCallback((_) {//Notify changes to the editor
              //    setNoteEditStatus(NoteEditStatus.pulledChanges);
              //  });
              //}

              //WidgetsBinding.instance.addPostFrameCallback((_) {//Apply changes to the editor
              //  AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdate();//It will check alone the selected note and make the correct app bar
              //});
            }
          }
        },

        onError: (error) {
          setNoteEditStatus(NoteEditStatus.lostConnection);
          //AppData.instance.notesPageViewInfo.key.currentState?.graphicsUpdate();
        }

      );

      return;

    }
    catch (exception) {
      appLog("Failed listening to new notes: $exception");
    }

  }

