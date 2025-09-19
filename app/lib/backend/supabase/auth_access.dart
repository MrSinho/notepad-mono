import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../app_data.dart';
import '../utils.dart';
import '../color_palette.dart';



class LoginData {
  String errorMessage = "";
}

Future<int> logout() async {

  try {

    await Supabase.instance.client.auth.signOut();

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

void startAuthServer() async {
  final authServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000); // Listen on port 3000 for incoming auth requests 
  
  await for (HttpRequest request in authServer) {
    appLog("Found request: ${request.toString()}", true);
    if (request.uri.queryParameters["code"] != null) {
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
    await authRequest.response.close();
  
  }

}