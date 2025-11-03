import 'dart:io';
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';

import '../app_data.dart';
import '../environment.dart';
import '../utils/utils.dart';
import '../widgets_notifier.dart';
import '../utils/color_utils.dart';

import 'session.dart';



class LoginAuthProviders {
  static const int google = 1 << 0;
  static const int github = 1 << 1;
  static const int azure  = 1 << 2;
}

Future<int> logout() async {

  try {

    await Supabase.instance.client.auth.signOut(scope: SignOutScope.local);
    clearAppData();

  } catch (error) {

    appLog("Error signing out: $error");

  }

  return 1;
}

Future<int> createUser() async {

  try {

    List<Map<String, dynamic>> data = await Supabase.instance.client.from("Users")
      .select()
      .eq("id", AppData.instance.sessionData.userID);

    if (data.isEmpty) {
      appLog("User not found in users table, creating a new user");

      await Supabase.instance.client.from("Users").insert(
        {
          "id": AppData.instance.sessionData.userID
        }
      );
      
      appLog("New user created successfully!");
    }
    else {
      appLog("User already registered");
    }


  } catch (error) {
    appLog("Error creating user: $error");

  }

  return 1;
}

Future<int> deleteUser() async {

  try {
    appLog("Deleting user through edge function");
    await Supabase.instance.client.functions.invoke("delete-user");

    logout();

  } catch (error) {
    appLog("Error deleting user: $error");

  }

  return 1;
}

String getRedirectPath() {
  
  if (Platform.isAndroid || Platform.isIOS) {
    return getEnvironmentParameterValue("DEEP_REDIRECT_URL");
  }

  return getEnvironmentParameterValue("HTTP_REDIRECT_URL");

}

Future<int> googleLogin() async {

  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: getRedirectPath()
  );

  if (!r) {
    appLog("Google login failed");
  }

  return 1;
}

Future<int> githubLogin() async {

  bool r = await Supabase.instance.client.auth.signInWithOAuth(
    OAuthProvider.github,
    redirectTo: getRedirectPath()
  );

  if (!r) {
    appLog("Github login failed");
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
    appLog("Microsoft azure login failed");
  }

  return 1;
}

Future<void> getAuthSessionCode(HttpRequest? request, Uri uri) async {
  String? authCode = uri.queryParameters["code"];// http://localhost:4516/?code=... or notepad-mono://?code=...

  if (authCode != null) {
    appLog("Received login callback uri link");
    await authExchangeCodeForSession(request, authCode);
  }
  else {
    appLog("Invalid code parameter in login callback uri");
    //error = true;
  }

}

Future<void> getSessiontDummyKey(HttpRequest? request, Uri uri) async {
  String? key = uri.queryParameters["key"]; // XXX://dummy/?key=
  
  if (key == null) {
    return;
  }

  appLog("Received dummy uri link");
  appLog("Got key: $key");

  if (key == getEnvironmentParameterValue("DUMMY_USER_KEY")) {
    appLog("Dummy key valid, starting dummy user session");
    
    logout(); // just in case
    createDummySession();

    if (request != null) {
      await sendHttpSuccess(request);
    }
  }
  else {
    appLog("Invalid key parameter in dummy uri");
    //error = true;
  }

}

Future<void> evaluateUriLink(HttpRequest? request, Uri uri) async {
  appLog("Evaluating uri link");
  
  if (request != null) {
    appLog("Got request: ${request.requestedUri.toString()}");
  }
  appLog("Query parameters: ${uri.toString()}");

  //bool error = false; 

  // Skip favicon.ico requests
  if (uri.path == "/favicon.ico") { // http://localhost:4516/favicon.ico
    return;
  }

  getEnvironmentParameterValue("LOGIN_URI_HOST");// I put it here just for logging purposes
  //  == getEnvironmentParameterValue("LOGIN_URI_HOST") but for some reason I have problems with empty strings from the environment
  if (uri.host == "") { // notepad-mono://?code=... or http://localhost:4516/?code=...
    getAuthSessionCode(request, uri);
  }

  else if (uri.host == getEnvironmentParameterValue("DUMMY_URI_HOST")) { // http://localhost:4516//dummy/?key=... or notepad-mono://dummy/?key=
    getSessiontDummyKey(request, uri);
  }

  //else if (uri.host.isEmpty) { // XXX://?
  //  appLog("Empty uri link host, attempting to process query parameters");
  //  getAuthSessionCode(request, uri);
  //  getSessiontDummyKey(request, uri);
  //}

  //else {
  //  appLog("Unknown uri link host: ${uri.host}");
  //  //error = true;
  //}

}

Future<void> listenToUriLinks() async {
  
  try {
    appLog("Initializing uri link stream");
    AppData.instance.sessionData.uriListenSubscription = AppData.instance.sessionData.appLinks.uriLinkStream.listen(
      (Uri? uri) async {

        if (uri == null) {
          return;
        }

        if (uri.scheme != getEnvironmentParameterValue("DEEP_URI_SCHEME")) {// notepad-mono://
          return;
        }

        appLog("Received deep uri link");

        evaluateUriLink(null, uri);

      }
    );

  }
  catch (error) {
    appLog("Failed initializing uri link stream: $error");
  }
  
}

Future<void> cancelUriStream() async {
  AppData.instance.sessionData.uriListenSubscription.cancel();
  appLog("Cancelled uri link stream");
}

Future<void> startAuthHttpServer() async {
  appLog("Initializing auth HTTP server");
  
  int port = int.parse(getEnvironmentParameterValue("HTTP_LISTEN_PORT"));
  AppData.instance.sessionData.authServer = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  
  await for (HttpRequest request in AppData.instance.sessionData.authServer) {// localhost:4516//
    appLog("Received http request");
    evaluateUriLink(request, request.uri);
  }

}

Future<void> stopAuthServer() async {
  await AppData.instance.sessionData.authServer.close();
  appLog("Stopped auth http server");
}

Future<void> authExchangeCodeForSession(HttpRequest? authRequest, String authCode) async {
  try {

    await Supabase.instance.client.auth.exchangeCodeForSession(authCode);

    await storeUserData();

    appLog("Login with auth provider successfull");

    if (authRequest != null) {
      await sendHttpSuccess(authRequest);
    }

  } catch (error) {
    appLog("Failed getting json web token for session: $error");
  }

}

Future<void> sendHttpSuccess(HttpRequest authRequest) async {

  try {

    String appName   = AppData.instance.queriesData.currentVersion["name"] ?? "Application";
    String copyright = AppData.instance.queriesData.currentVersion["copyright_notice"] ?? "";

    String htmlResponse = await rootBundle.loadString("assets/login_success.html");

    htmlResponse = htmlResponse.replaceAll("\$appName",   appName);
    htmlResponse = htmlResponse.replaceAll("\$copyright", copyright);

    ColorPaletteData paletteData = generateRandomColorPalette(6);

    for (int i = 0; i < paletteData.colorCount; i++) {
      htmlResponse = htmlResponse.replaceAll("\$color${i+1}", paletteData.asStrings[i]);
    }

    authRequest.response.statusCode = HttpStatus.ok;
    authRequest.response.headers.contentType = ContentType.html;
    authRequest.response.write(htmlResponse);

    await authRequest.response.close();

    appLog("Successfully sent http response");
  }
  catch (error) {
    String errorMessage = "Failed sending http response: $error";
  
    appLog(errorMessage);
  
    authRequest.response.statusCode = HttpStatus.badRequest;
    authRequest.response.write(errorMessage);

    AppData.instance.sessionData.errorMessage = errorMessage;
    notifyLoginPageUpdate();// To display an error message (not implemented yet)

    await authRequest.response.close();
  }

}