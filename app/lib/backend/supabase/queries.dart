import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../app_data.dart';



Future<void> pingDb() async {

  //Nothing to do here...

  return;
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

  AppData.instance.version = latest;

  return;
}

Future<void> queryNotes() async {
  
  try {

    List<Map<String, dynamic>> notes = await Supabase.instance.client.from("Notes").select();

    AppData.instance.notes = notes;

    return;

  }
  catch (exception) {
    debugPrint("[NNotes] Failed listening to new notes: $exception");
  }


}

Future<void> saveNoteContent() async {

  await Supabase.instance.client.from("Notes").update(
    {
      "content": AppData.instance.noteCodeController.text,
      "last_edit": DateTime.now().toUtc().toString()
    }
  ).eq("id", AppData.instance.selectedNote["id"]??"");

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
      "title": title
      //it"s just a rename, no need to change date time
    }
  ).eq("id", AppData.instance.selectedNote["id"]??"");
}

Future<void> deleteSelectedNote() async {
  await Supabase.instance.client.from("Notes").delete(
  ).eq("id", AppData.instance.selectedNote["id"]??"");
}

