import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:http/http.dart' as http;

import '../app_data.dart';
import '../utils/utils.dart';



class SessionData {
  String accessToken = "";

  String errorMessage = "";
  
  String userID       = "";
  String authProvider = "";
  String email        = "";
  String username     = "";

  String profilePictureUrl = "";
  MemoryImage? profilePicture;

  late HttpServer authServer;
  late AppLinks appLinks;
  late StreamSubscription uriListenSubscription;
}



void copySessionInfo() {
  Session session = Supabase.instance.client.auth.currentSession!;
  AppData.instance.sessionData.accessToken = session.providerToken ?? "";

  AppData.instance.sessionData.userID            = Supabase.instance.client.auth.currentUser?.id ?? "";
  AppData.instance.sessionData.authProvider      = Supabase.instance.client.auth.currentUser?.appMetadata["provider"] ?? "";
  AppData.instance.sessionData.email             = Supabase.instance.client.auth.currentUser?.email ?? "";
  AppData.instance.sessionData.username          = Supabase.instance.client.auth.currentUser?.userMetadata?["user_name"] ?? "";
  AppData.instance.sessionData.profilePictureUrl = Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? "";

  if (AppData.instance.sessionData.username == "") {
    AppData.instance.sessionData.username = AppData.instance.sessionData.email.split("@")[0];
  }
}

Future<void> storeUserData() async {

  copySessionInfo();

  if (AppData.instance.sessionData.profilePictureUrl != "") {

    appLog("Retrieving profile picture through URL");

    var response = await http.get(Uri.parse(AppData.instance.sessionData.profilePictureUrl));

    if (response.statusCode == 200) {
      appLog("Download successfull, storing profile picture");
      AppData.instance.sessionData.profilePicture = MemoryImage(response.bodyBytes);
    }
    else {
      appLog("Failed downloading profile picture through url: ${response.body.toString()}");
    }
  }

  if (AppData.instance.sessionData.authProvider == "azure") { // Get profile picture with Microsoft Graph

    appLog("Using Microsoft Graph to retrieve profile picture");

    // For a valid response, see the requisites https://learn.microsoft.com/en-us/graph/api/profilephoto-get?view=graph-rest-1.0&tabs=http
    var response = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me/photo/\$value"),
      headers: {"Authorization": "Bearer ${AppData.instance.sessionData.accessToken}"},
    );

    if (response.statusCode == 200) {
      appLog("Download successfull, storing profile picture from Microsoft Graph");
      AppData.instance.sessionData.profilePicture = MemoryImage(response.bodyBytes);
    }
    else {
      appLog("Cannot retrieve profile picture with Microsoft graph: ${response.body.toString()}");
    }

  }

}

Widget getProfilePicture(bool wrapInsideAvatar) {
  
  BoringAvatarType type = BoringAvatarType.marble;
  int seed = Random().nextInt(6);

  switch (seed) {
    case 1:
      type = BoringAvatarType.marble;
      break;
    case 2:
      type = BoringAvatarType.beam;
      break;
    case 3:
      type = BoringAvatarType.pixel;
      break;
    case 4:
      type = BoringAvatarType.sunset;
      break;
    case 5:
      type = BoringAvatarType.bauhaus;
      break;
    case 6:
      type = BoringAvatarType.ring;
      break;
  }

  BoringAvatar boringAvatar = BoringAvatar(name: AppData.instance.sessionData.username, type: type);

  Widget fill = Positioned.fill(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: const Color.fromARGB(25, 0, 0, 0),
        highlightColor: Colors.transparent,
      ),
    ),
  );

  if (AppData.instance.sessionData.profilePicture != null) {
    
    Widget stack = Stack(
      fit: StackFit.expand,
      children: [
        fill
      ],
    );

    ClipOval clip = ClipOval(
      clipBehavior: Clip.antiAlias,
      child: stack
    );
    
    CircleAvatar avatar = CircleAvatar(
      radius: 50,
      backgroundImage: AppData.instance.sessionData.profilePicture!,
      backgroundColor: Colors.transparent,
      child: clip
    );

    if (wrapInsideAvatar) {
      return avatar; // Something is wrong
    }
    else {
      return ClipOval(
        child: Image(image: AppData.instance.sessionData.profilePicture!)
      );
    }
  }
  
  Widget stack = Stack(
    fit: StackFit.expand,
    children: [
      boringAvatar,
      fill
    ],
  );

  Widget clip = ClipOval(
    clipBehavior: Clip.antiAlias,
    child: stack,
  );

  CircleAvatar avatar = CircleAvatar(
    radius: 50,
    backgroundColor: Colors.white,
    child: clip
  );

  if (wrapInsideAvatar) {
    return avatar;
  }
  else {
    return ClipOval(child: boringAvatar);
  }
}