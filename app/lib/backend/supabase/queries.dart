import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../../new_primitives/navigation/handle.dart';

import '../app_data.dart';



Future<int> pingDatabase() async {
  return 1;
}

Future<int> queryNotes() async {
  
  try {

    List<Map<String, dynamic>> notes = await Supabase.instance.client.from("Notes").select();

    print(notes);

    AppData.instance.notes = notes;

    return 1;

  }
  catch (exception) {
    debugPrint('Failed listening to new notes: $exception');
    return 0;
  }


}

Future<void> saveNoteContent() async {

  await Supabase.instance.client.from("Notes").update(
    {
      "content": AppData.instance.noteTextEditingController.text,
      //"last_edit": TODO
    }
  ).eq("id", AppData.instance.selectedNote["id"]);

}

Future<void> renameNote(String title) async {
  await Supabase.instance.client.from("Notes").update(
    {
      "title": title
    }
  ).eq("id", AppData.instance.selectedNote["id"]);
}