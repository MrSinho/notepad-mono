import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:nnotes/backend/notify_ui.dart';
import 'package:nnotes/backend/supabase/queries.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../app_data.dart';
import '../utils.dart';
import '../color_palette.dart';



class LoginData {
  String accessToken = "";

  String errorMessage = "";
  
  String authProvider = "";
  String email        = "";
  String username     = "";

  String profilePictureUrl = "";
  MemoryImage? profilePicture;
}

class LoginAuthProviders {
  static const int google = 1 << 0;
  static const int github = 1 << 1;
  static const int azure  = 1 << 2;
}

Future<int> logout() async {

  try {

    await Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
    clearSessionInfo();

  } catch (error) {

    appLog("Error signing out: $error", true);

  }

  return 1;
}

Future<int> googleLogin() async {

  await dotenv.load(fileName: ".env");

  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: dotenv.env['GOOGLE_REDIRECT_URL']
  );

  if (!r) {
    appLog("Google login failed", true);
  }

  return 1;
}

Future<int> githubLogin() async {

  await dotenv.load(fileName: ".env");

  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.github,
    redirectTo: dotenv.env['GITHUB_REDIRECT_URL']
  );

  if (!r) {
    appLog("Github login failed", true);
  }

  return 1;
}

Future<int> azureLogin() async {

  await dotenv.load(fileName: ".env");

  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.azure,
    redirectTo: dotenv.env['AZURE_REDIRECT_URL'],
    // For a valid response, see the requisites https://learn.microsoft.com/en-us/graph/api/profilephoto-get?view=graph-rest-1.0&tabs=http
    scopes: 'email openid profile User.Read ProfilePhoto.Read.All', // very important, see also authorizations on your azure console
  );

  if (!r) {
    appLog("Microsoft azure login failed", true);
  }

  return 1;
}

void startAuthServer() async {
  final authServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000); // Listen on port 3000 for incoming auth requests 
  
  await for (HttpRequest request in authServer) {

    appLog("Found request. Query parameters: ${request.uri.toString()}. Path: ${request.uri.path.toString()}", true);

    if (request.uri.queryParameters["code"] != null) { // Google and Github
      await authExchangeCodeForSession(request);
    }

  }

}

void stopAuthServer() async {
  await AppData.instance.authServer.close();
}

Future<void> authExchangeCodeForSession(HttpRequest authRequest) async {
  try {

    String authCode = authRequest.uri.queryParameters["code"] ?? "invalid";

    await Supabase.instance.client.auth.exchangeCodeForSession(authCode);

    await storeUserData();
    
    String appName   = AppData.instance.queriesData.version["name"] ?? "Application";
    String copyright = AppData.instance.queriesData.version["copyright_notice"] ?? "";

    String htmlResponse = await readFile("assets/login_success.html");

    htmlResponse = htmlResponse.replaceAll("\$appName",   appName);
    htmlResponse = htmlResponse.replaceAll("\$copyright", copyright);

    ColorPaletteData paletteData = generateRandomColorPalette(6, false);

    for (int i = 0; i < paletteData.colorCount; i++) {
      htmlResponse = htmlResponse.replaceAll("\$color${i+1}", paletteData.asStrings[i]);
    }

    authRequest.response.statusCode = HttpStatus.ok;
    authRequest.response.headers.contentType = ContentType.html;
    authRequest.response.write(htmlResponse);

    await authRequest.response.close();

    appLog("Login with auth provider successfull, sending http response", true);

  } catch (error) {
  
    String errorMessage = "Failed getting json web token for session: $error";
  
    appLog(errorMessage, true);
  
    authRequest.response.statusCode = HttpStatus.badRequest;
    authRequest.response.write(errorMessage);

    AppData.instance.loginData.errorMessage = errorMessage;
    notifyLoginPageUpdate();

    await authRequest.response.close();
  
  }

}

void clearSessionInfo() {
  AppData.instance.loginData = LoginData();
}

void copySessionInfo() {
  Session session = Supabase.instance.client.auth.currentSession!;
  AppData.instance.loginData.accessToken = session.providerToken ?? "";

  AppData.instance.loginData.authProvider      = Supabase.instance.client.auth.currentUser?.appMetadata["provider"] ?? "";
  AppData.instance.loginData.email             = Supabase.instance.client.auth.currentUser?.email ?? "";
  AppData.instance.loginData.username          = Supabase.instance.client.auth.currentUser?.userMetadata?["user_name"] ?? "";
  AppData.instance.loginData.profilePictureUrl = Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? "";

  if (AppData.instance.loginData.username == "") {
    AppData.instance.loginData.username = AppData.instance.loginData.email.split("@")[0];
  }
}

Future<void> storeUserData() async {

  copySessionInfo();

  if (AppData.instance.loginData.profilePictureUrl != "") {

    appLog("Retrieving profile picture through URL", true);

    var response = await http.get(Uri.parse(AppData.instance.loginData.profilePictureUrl));

    if (response.statusCode == 200) {
      appLog("Download successfull, storing profile picture", true);
      AppData.instance.loginData.profilePicture = MemoryImage(response.bodyBytes);
    }
    else {
      appLog("Failed downloading profile picture through url: ${response.body.toString()}", true);
    }
  }

  if (AppData.instance.loginData.authProvider == "azure") { // Get profile picture with Microsoft Graph

    appLog("Using Microsoft Graph to retrieve profile picture", true);

    // For a valid response, see the requisites https://learn.microsoft.com/en-us/graph/api/profilephoto-get?view=graph-rest-1.0&tabs=http
    var response = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me/photo/\$value"),
      headers: {"Authorization": "Bearer ${AppData.instance.loginData.accessToken}"},
    );

    if (response.statusCode == 200) {
      appLog("Download successfull, storing profile picture from Microsoft Graph", true);
      AppData.instance.loginData.profilePicture = MemoryImage(response.bodyBytes);
    }
    else {
      appLog("Cannot retrieve profile picture with Microsoft graph: ${response.body.toString()}", true);
    }

  }

}