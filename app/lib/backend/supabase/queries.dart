import 'dart:async';

import 'package:notepad_mono/backend/widgets_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../note_edit/note_edit.dart';

import '../utils/utils.dart';

import '../app_data.dart';

import 'session.dart';



class QueriesData {
  Map<String, Map<String, dynamic>> versions        = {};
  Map<String, dynamic>              currentVersion  = {};
  Map<String, dynamic>              latestVersion   = {};
  List<Map<String, dynamic>>        notes           = [];
  Map<String, dynamic>              selectedNote    = {};

  StreamSubscription? notesSubscription;
  StreamSubscription? versionsSubscription;
}

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

Future<void> saveNote() async {

  if (AppData.instance.sessionData == DummySession.data) {
    dummySaveNote();
    return;
  }

  try {

    String lastEdit = DateTime.now().toUtc().toString();

    await Supabase.instance.client.from("Notes").update(
      {
        "content": AppData.instance.noteEditData.controller.text,
        "last_edit": lastEdit
      }
    ).eq("id", AppData.instance.queriesData.selectedNote["id"]??"");

    copySavedNoteData();

    setNoteEditStatus(NoteEditStatus.savedChanges);
  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.failedSave);
  }

}

void dummySaveNote() {
  appLog("Saving dummy note");

  copySavedNoteData();
  notifyHomePageUpdate();

  sortMapList(AppData.instance.queriesData.notes, "last_edit");

  setNoteEditStatus(NoteEditStatus.savedChanges);
}

void copySavedNoteData() {
  String lastEdit = DateTime.now().toUtc().toString();

  AppData.instance.queriesData.selectedNote["content"]   = AppData.instance.noteEditData.controller.text;
  AppData.instance.queriesData.selectedNote["last_edit"] = lastEdit;

  AppData.instance.noteEditData.stringData.savedContentLength = AppData.instance.noteEditData.stringData.bufferLength;
  AppData.instance.noteEditData.stringData.savedContentLines  = AppData.instance.noteEditData.stringData.bufferLines;
  AppData.instance.noteEditData.stringData.lastEdit           = formatDateTime(lastEdit);
}

Future<void> createNewNote(String title) async {

  if (AppData.instance.sessionData == DummySession.data) {
    dummyCreateNewNote(title);
    return;
  }

  try {
    await Supabase.instance.client.from("Notes").insert(
      {
        "title": title,
        "owner_id": AppData.instance.sessionData.userID,
        //date time set automatically
        "content": "# $title\n\n_Write something..._",
      }
    );
  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.failedSave);
  }
  
}

void dummyCreateNewNote(String title) {
  appLog("Creating new dummy note");

  Map<String, dynamic> newNote = {
    "id": DateTime.now().millisecondsSinceEpoch.toString(),
    "title": title,
    "owner_id": AppData.instance.sessionData.userID,
    "last_edit": DateTime.now().toUtc().toString(),
    "content": "# $title\n\n_Write something..._",
    "is_favorite": false,
  };

  AppData.instance.queriesData.notes.insert(0, newNote);

  notifyNotesViewUpdate();
}

Future<void> renameNote(String title) async {

  if (AppData.instance.sessionData == DummySession.data) {
    dummyRenameNote(title);
    return;
  }

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

void dummyRenameNote(String title) {
  appLog("Renaming dummy note");

  AppData.instance.queriesData.selectedNote["title"]     = title;
  AppData.instance.queriesData.selectedNote["content"]   = AppData.instance.noteEditData.controller.text;
  AppData.instance.queriesData.selectedNote["last_edit"] = DateTime.now().toUtc().toString();

  sortMapList(AppData.instance.queriesData.notes, "last_edit");

  notifyNotesViewUpdate();
  notifyNoteEditBarsUpdate();
}

Future<void> deleteSelectedNote() async {

  if (AppData.instance.sessionData == DummySession.data) {
    dummyDeleteSelectedNote();
    return;
  }

  try {
    await Supabase.instance.client.from("Notes").delete().eq("id", AppData.instance.queriesData.selectedNote["id"]??"");
  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.lostConnection);
  }

}

void dummyDeleteSelectedNote() {
  appLog("Deleting dummy note");

  for (Map<String, dynamic> note in AppData.instance.queriesData.notes) {
    if (note["id"] == AppData.instance.queriesData.selectedNote["id"]) {
      AppData.instance.queriesData.notes.remove(note);
      break;
    }
  }

  notifyNotesViewUpdate();
}

Future<void> deleteAllNotes() async {

  if (AppData.instance.sessionData == DummySession.data) {
    dummyDeleteAllNotes();
    return;
  }
  
  try {
    await Supabase.instance.client.from("Notes").delete().eq("owner_id", AppData.instance.sessionData.userID);
  }
  catch (error) {
    setNoteEditStatus(NoteEditStatus.lostConnection);
  }

}

void dummyDeleteAllNotes() {
  appLog("Deleting all dummy notes");

  AppData.instance.queriesData.notes.clear();

  notifyNotesViewUpdate();
}

Future<void> flipFavoriteNote() async {

  if (AppData.instance.sessionData == DummySession.data) {
    dummyFlipFavoriteNote();
    return;
  }

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

void dummyFlipFavoriteNote() {
  appLog("Flipping favorite status of dummy note");

  bool isFavorite = AppData.instance.queriesData.selectedNote["is_favorite"];
  AppData.instance.queriesData.selectedNote["is_favorite"] = !isFavorite;

  if (!isFavorite) {//was favorite
    setNoteEditStatus(NoteEditStatus.addedToFavorites);
  }
  else {
    setNoteEditStatus(NoteEditStatus.removedFromFavorites);
  }

  notifyNotesViewUpdate();
  notifyNoteEditBarsUpdate();
}

