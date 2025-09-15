import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../app_data.dart';
import '../utils.dart';



Future<int> logout() async {

  try {

    await Supabase.instance.client.auth.signOut();

  } catch (error) {

    appLog("Error signing out: $error");

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
    appLog("Google login failed");
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
    appLog("Github login failed");
  }

  return 1;
}

void startAuthServer() async {
  final authServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000); // Listen on port 3000 for incoming auth requests 
  
  await for (HttpRequest request in authServer) {
    await authExchangeCodeForSession(request);
  }

}

void stopAuthServer() async {
  await AppData.instance.authServer.close();
}

Future<void> authExchangeCodeForSession(HttpRequest authRequest) async {
  try {

    await Supabase.instance.client.auth.exchangeCodeForSession(authRequest.uri.queryParameters['code']!);

    String appName   = AppData.instance.queriesData.version["name"];
    String copyright = AppData.instance.queriesData.version["copyright_notice"];

    String htmlResponse = await readFile("assets/login_success.html");

    htmlResponse = htmlResponse.replaceAll("\$appName",   appName);
    htmlResponse = htmlResponse.replaceAll("\$copyright", copyright);

    authRequest.response.statusCode = HttpStatus.ok;
    authRequest.response.headers.contentType = ContentType.html;
    authRequest.response.write(htmlResponse);

    await authRequest.response.close();

    appLog("Login with auth provider successfull, sending http response");

  } catch (error) {

    appLog("Failed getting json web token for session");

    authRequest.response.statusCode = HttpStatus.badRequest;
    authRequest.response.write("Missing \"\" query parameter");
    await authRequest.response.close();

  }

}