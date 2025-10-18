import 'app_data.dart';
import 'utils.dart';



void notifyNoteEditBarsUpdate() {
  appLog("Notifying builder update for note edit page", true);
  AppData.instance.noteEditBarsUpdates.value++;
}

void notifyNoteEditFieldUpdate() {
  appLog("Notifying builder update for note edit page", true);
  AppData.instance.inputFieldUpdates.value++;
}

void notifyHomePageUpdate() {
  appLog("Notifying builder update for home page", true);
  AppData.instance.homePageUpdates.value++; 
}

void notifyLoginPageUpdate() {
  appLog("Notifying builder update for login page", true);
  AppData.instance.loginPageUpdates.value++;
}