import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit/note_edit.dart';
import '../utils/utils.dart';



class QueriesData {
  Map<String, Map<String, dynamic>> versions = {};
  Map<String, dynamic>       currentVersion  = { "name": "Notepad Mono", "version": "v0.1.0" };
  Map<String, dynamic>       latestVersion   = {};
  List<Map<String, dynamic>> notes           = [];
  Map<String, dynamic>       selectedNote    = {};

  StreamSubscription? streamSubscription;
  StreamSubscription? versionsSubscription;
}

/*
Future<void> queryVersions() async {

  List<Map<String, dynamic>> versions = await Supabase.instance.client.from("Versions").select();

  //Sort notes by last edit date
  versions.sort((a, b) {
    final aTime = DateTime.tryParse(a["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bTime = DateTime.tryParse(b["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bTime.compareTo(aTime);
  });

  Map<String, dynamic> latest = versions.first;

  AppData.instance.queriesData.latestVersion = latest;

  notifyRootPageUpdate();

  return;
}
*/

Future<void> queryNotes() async {
  
  try {

    List<Map<String, dynamic>> notes = await Supabase.instance.client.from("Notes").select();

    AppData.instance.queriesData.notes = notes;

    return;

  }
  catch (exception) {
    appLog("Failed listening to new notes: $exception");
  }


}

Future<bool> saveNote() async {

  try {

    String lastEdit = DateTime.now().toUtc().toString();

    await Supabase.instance.client.from("Notes").update(
      {
        "content": AppData.instance.noteEditData.controller.text,
        "last_edit": lastEdit
      }
    ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");

    AppData.instance.queriesData.selectedNote["content"] = AppData.instance.noteEditData.controller.text;

    AppData.instance.noteEditData.savedContentLength = AppData.instance.noteEditData.bufferLength;
    AppData.instance.noteEditData.savedContentLines  = AppData.instance.noteEditData.bufferLines;
    AppData.instance.noteEditData.lastEdit           = formatDateTime(lastEdit);

    setNoteEditStatus(NoteEditStatus.savedChanges);

    return true;
  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.failedSave);

    return false;
  }

}

Future<void> createNewNote(String title) async {
  await Supabase.instance.client.from("Notes").insert(
    {
      "title": title,
      "owner": Supabase.instance.client.auth.currentSession!.user.email,
      //date time set automatically
      "content": "# $title\n\n_Write something..._",
    }
  );
}

Future<void> renameNote(String title) async {

  try {
    await Supabase.instance.client.from("Notes").update(
      {
        "title": title,
        "content": AppData.instance.noteEditData.controller.text,
        "last_edit": DateTime.now().toUtc().toString()
      }
    ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");

    setNoteEditStatus(NoteEditStatus.renamedNote);

  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.lostConnection);
  }
  
}

Future<void> deleteSelectedNote() async {
  await Supabase.instance.client.from("Notes").delete(
  ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");
}

Future<void> flipFavoriteNote() async {

  try {
    bool isFavorite = AppData.instance.queriesData.selectedNote["is_favorite"];

    await Supabase.instance.client.from("Notes").update(
      {
        "is_favorite": !isFavorite,
        "content": AppData.instance.noteEditData.controller.text
      }
    ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");

    if (!isFavorite) {//was favorite
      setNoteEditStatus(NoteEditStatus.addedToFavorites);
    }
    else {
      setNoteEditStatus(NoteEditStatus.removedFromFavorites);
    }

  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.lostConnection);
    appLog("Failed flipping favorite note: $error");
  }
  
}

