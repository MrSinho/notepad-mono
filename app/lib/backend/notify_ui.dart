import 'app_data.dart';
import 'utils.dart';



void notifyNoteEditBarsUpdate() {
  appLog("Notifying builder update for note edit page");
  AppData.instance.noteEditBarsUpdates.value++;
}

void notifyNoteEditFieldUpdate() {
  appLog("Notifying builder update for note edit page");
  AppData.instance.inputFieldUpdates.value++;
}

void notifyRootPageUpdate() {
  appLog("Notifying builder update for root page");
  AppData.instance.rootPageUpdates.value++;
}

void notifyAllPagesUpdate() {
  notifyRootPageUpdate();
  notifyNoteEditBarsUpdate();
  notifyNoteEditFieldUpdate();
}