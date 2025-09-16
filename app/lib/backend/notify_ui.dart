import 'app_data.dart';
import 'utils.dart';



void notifyNoteEditUpdate() {
  appLog("Notifying builder update for note edit page");
  AppData.instance.noteEditUpdates.value++;
}

void notifyHomePageUpdate() {
  appLog("Notifying builder update for home page");
  AppData.instance.homePageUpdates.value++; 
}

void notifyLoginPageUpdate() {
  appLog("Notifying builder update for login page");
  AppData.instance.loginPageUpdates.value++;
}