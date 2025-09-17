import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_data.dart';
import '../note_edit.dart';
import '../utils.dart';



class QueriesData {
  Map<String, dynamic>       version      = {};
  List<Map<String, dynamic>> notes        = [];
  Map<String, dynamic>       selectedNote = {};
}

Future<void> pullVersion() async {

  List<Map<String, dynamic>> versions = await Supabase.instance.client.from("Versions").select();

  //Sort notes by last edit date
  versions.sort((a, b) {
    final aTime = DateTime.tryParse(a["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bTime = DateTime.tryParse(b["release_date"] ?? "") ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bTime.compareTo(aTime);
  });

  Map<String, dynamic> latest = versions.first;

  AppData.instance.queriesData.version = latest;

  return;
}

Future<void> queryNotes() async {
  
  try {

    List<Map<String, dynamic>> notes = await Supabase.instance.client.from("Notes").select();

    AppData.instance.queriesData.notes = notes;

    return;

  }
  catch (exception) {
    appLog("Failed listening to new notes: $exception", true);
  }


}

Future<void> saveNoteContent() async {

  try {
    await Supabase.instance.client.from("Notes").update(
      {
        "content": AppData.instance.noteEditData.controller.text,
        "last_edit": DateTime.now().toUtc().toString()
      }
    ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");

    setNoteEditStatus(NoteEditStatus.savedChanges);

  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.failedSave);
  }

}

Future<void> createNewNote(String title) async {
  await Supabase.instance.client.from("Notes").insert(
    {
      "title": title,
      "owner": Supabase.instance.client.auth.currentSession!.user.email,
      //date time set automatically
    }
  );
}

Future<void> renameNote(String title) async {
  await Supabase.instance.client.from("Notes").update(
    {
      "title": title,
      "content": AppData.instance.noteEditData.controller.text,
      "last_edit": DateTime.now().toUtc().toString()
    }
  ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");

  setNoteEditStatus(NoteEditStatus.renamedNote);
}

Future<void> deleteSelectedNote() async {
  await Supabase.instance.client.from("Notes").delete(
  ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");
}

Future<void> flipFavoriteNote() async {

  bool isFavorite = AppData.instance.queriesData.selectedNote["is_favorite"];

  await Supabase.instance.client.from("Notes").update(
    {
      "is_favorite": !isFavorite,
    }
  ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");

  if (!isFavorite) {//was favorite
    setNoteEditStatus(NoteEditStatus.addedToFavorites);
  }
  else {
    setNoteEditStatus(NoteEditStatus.removedFromFavorites);
  }
}

