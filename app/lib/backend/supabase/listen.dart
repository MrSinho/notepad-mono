import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit.dart';



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
        AppData.instance.notePageViewInfo.key.currentState?.graphicsSetWarningMessage("Connection lost!");
        AppData.instance.notesPageViewInfo.key.currentState?.graphicsSetWarningMessage("Connection lost!");
      }

    );
    return;
  }
  catch (exception) {
    debugPrint("[NNotes] Failed listening to new notes: $exception");
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
          
          //Update selected note
          for (Map<String, dynamic> note in notes) {
            if (note["id"] == AppData.instance.selectedNote["id"]) {
              
              if (note["content"] != AppData.instance.noteCodeController.text) {
                WidgetsBinding.instance.addPostFrameCallback((_) {//Notify changes to the editor
                  AppData.instance.notePageViewInfo.key.currentState?.graphicsSetWarningMessage("Changes from new device!");
                });
              }

              selectNote(note);

              WidgetsBinding.instance.addPostFrameCallback((_) {//Apply changes to the editor
                AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdateNotePageView();//It will check alone the selected note and make the correct app bar
              });
            }
          }
        },

        onError: (error) {
          //In case the error appeared while editing...
          AppData.instance.notePageViewInfo.key.currentState?.graphicsSetWarningMessage("Connection lost!");
          
          //In case the error appeared the notes list view...
          AppData.instance.notesPageViewInfo.key.currentState?.graphicsSetWarningMessage("Connection lost!");
        }

      );

      return;

    }
    catch (exception) {
      debugPrint("[NNotes] Failed listening to new notes: $exception");
    }

  }

