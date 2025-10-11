import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import '../app_data.dart';
import '../environment.dart';
import '../utils.dart';
import '../notify_ui.dart';
import '../color_palette.dart';



class SessionData {
  String accessToken = "";

  String errorMessage = "";
  
  String authProvider = "";
  String email        = "";
  String username     = "";

  String profilePictureUrl = "";
  MemoryImage? profilePicture;

  late HttpServer authServer;
  late AppLinks appLinks;
  late StreamSubscription uriListenSubscription;
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

String getRedirectPath() {
  
  if (Platform.isAndroid || Platform.isIOS) {
    return getEnvironmentParameterValue("DEEP_LINK_REDIRECT_URL");
  }

  return getEnvironmentParameterValue("HTTP_REDIRECT_URL");

}

Future<int> googleLogin() async {
  
  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: getRedirectPath()
  );

  if (!r) {
    appLog("Google login failed", true);
  }

  return 1;
}

Future<int> githubLogin() async {

  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.github,
    redirectTo: getRedirectPath()
  );

  if (!r) {
    appLog("Github login failed", true);
  }

  return 1;
}

Future<int> azureLogin() async {

  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.azure,
    redirectTo: getRedirectPath(),
    // For a valid response, see the requisites https://learn.microsoft.com/en-us/graph/api/profilephoto-get?view=graph-rest-1.0&tabs=http
    scopes: 'email openid profile User.Read ProfilePhoto.Read.All', // very important, see also authorizations on your azure console
  );

  if (!r) {
    appLog("Microsoft azure login failed", true);
  }

  return 1;
}

Future<void> listenToUriLinks() async {
  
  try {
    appLog("Initializing uri link stream", true);
    AppData.instance.sessionData.uriListenSubscription = AppData.instance.sessionData.appLinks.uriLinkStream.listen(
      (Uri? uri) async {
      
        if (uri != null && uri.scheme == getEnvironmentParameterValue("URI_SCHEME") && uri.host == getEnvironmentParameterValue("URI_HOST")) {
          
          String? authCode = uri.queryParameters["code"];

          if (authCode != null) {
            await authExchangeCodeForSession(authCode, null);
          }
        }
      }
    );

  }
  catch (error) {
    appLog("Failed initializing uri link stream: $error", true);
  }
  
}

Future<void> cancelUriStream() async {
  AppData.instance.sessionData.uriListenSubscription.cancel();
  appLog("Cancelled uri link stream", true);
}

Future<void> startAuthHttpServer() async {

  appLog("Initializing HTTP auth server", true);
  
  int port = int.parse(getEnvironmentParameterValue("HTTP_LISTEN_PORT"));
  AppData.instance.sessionData.authServer = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  
  await for (HttpRequest request in AppData.instance.sessionData.authServer) {

    appLog("Found request. Query parameters: ${request.uri.toString()}. Path: ${request.uri.path.toString()}", true);

    String? authCode = request.uri.queryParameters["code"];

    if (authCode != null) {
      await authExchangeCodeForSession(authCode, request);
    }

  }

}

Future<void> stopAuthServer() async {
  await AppData.instance.sessionData.authServer.close();
  appLog("Stopped auth http server", true);
}

Future<void> authExchangeCodeForSession(String authCode, HttpRequest? authRequest) async {
  try {

    await Supabase.instance.client.auth.exchangeCodeForSession(authCode);

    await storeUserData();

    appLog("Login with auth provider successfull", true);

    if (authRequest != null) {
      await sendHttpResponse(authRequest);
    }

  } catch (error) {
    appLog("Failed getting json web token for session: $error", true);
  }

}

Future<void> sendHttpResponse(HttpRequest authRequest) async {

  try {

    String appName   = AppData.instance.queriesData.version["name"] ?? "Application";
    String copyright = AppData.instance.queriesData.version["copyright_notice"] ?? "";

    String htmlResponse = await rootBundle.loadString("assets/login_success.html");

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

    appLog("Successfully sent http response", true);
  }
  catch (error) {
    String errorMessage = "Failed sending http response: $error";
  
    appLog(errorMessage, true);
  
    authRequest.response.statusCode = HttpStatus.badRequest;
    authRequest.response.write(errorMessage);

    AppData.instance.sessionData.errorMessage = errorMessage;
    notifyLoginPageUpdate();

    await authRequest.response.close();
  }

}

void clearSessionInfo() {
  AppData.instance.sessionData = SessionData();
}

void copySessionInfo() {
  Session session = Supabase.instance.client.auth.currentSession!;
  AppData.instance.sessionData.accessToken = session.providerToken ?? "";

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

    appLog("Retrieving profile picture through URL", true);

    var response = await http.get(Uri.parse(AppData.instance.sessionData.profilePictureUrl));

    if (response.statusCode == 200) {
      appLog("Download successfull, storing profile picture", true);
      AppData.instance.sessionData.profilePicture = MemoryImage(response.bodyBytes);
    }
    else {
      appLog("Failed downloading profile picture through url: ${response.body.toString()}", true);
    }
  }

  if (AppData.instance.sessionData.authProvider == "azure") { // Get profile picture with Microsoft Graph

    appLog("Using Microsoft Graph to retrieve profile picture", true);

    // For a valid response, see the requisites https://learn.microsoft.com/en-us/graph/api/profilephoto-get?view=graph-rest-1.0&tabs=http
    var response = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me/photo/\$value"),
      headers: {"Authorization": "Bearer ${AppData.instance.sessionData.accessToken}"},
    );

    if (response.statusCode == 200) {
      appLog("Download successfull, storing profile picture from Microsoft Graph", true);
      AppData.instance.sessionData.profilePicture = MemoryImage(response.bodyBytes);
    }
    else {
      appLog("Cannot retrieve profile picture with Microsoft graph: ${response.body.toString()}", true);
    }

  }

}