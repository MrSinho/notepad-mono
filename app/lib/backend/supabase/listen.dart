import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit.dart';



void listenToProfile() {

  try {

    //Nothing to do here...

    return;

  }
  catch (exception) {
    debugPrint('Failed listening to new profile: $exception');
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
            final aTime = DateTime.tryParse(a['last_edit'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = DateTime.tryParse(b['last_edit'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

          AppData.instance.notes = notes;

          //Only update the state of the ListTilesView, never replace with a new ListTilesView widget!
          AppData.instance.notesViewInfo.key.currentState?.graphicsUpdate();
          
          //Update selected note
          for (Map<String, dynamic> note in notes) {
            if (note['id'] == AppData.instance.selectedNote['id']) {
              selectNote(context, note);
              WidgetsBinding.instance.addPostFrameCallback((_) {//In case we are editing the note while listening...
                AppData.instance.notePageViewInfo.key.currentState?.graphicsUpdateNotePageView();//It will check alone the selected note and make the correct app bar
              });
            }
          }

          /*
            Don't do this! You are replacing a widget in the tree with a brand new widget with it's own state, wrong.
              graphicsSetBody(
                ListTilesView(children: notesUI)
              );
            Nesting StatefulWidgets is not the problem.
            The real issue was replacing a StatefulWidget instance entirely instead of updating its internal state.
          */

        }

      );

      return;

    }
    catch (exception) {
      debugPrint('Failed listening to new notes: $exception');
    }

  }

