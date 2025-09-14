import 'app_data.dart';
import 'utils.dart';



class Notifiers {



}

void notifyNotePageViewUpdate() {
  appLog("Notifying builder update for NotePageView");
  AppData.instance.notePageViewUpdates.value++;
}

void notifyNotesPageViewUpdate() {
  appLog("Notifying builder update for NotesPageView");
  AppData.instance.homePageViewUpdates.value++; 
}