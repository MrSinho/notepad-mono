import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



Future<int> logout() async {

  try {
    await Supabase.instance.client.auth.signOut();
  } catch (error) {
    debugPrint('Error signing out: $error');
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
    debugPrint("[NNotes] Google login failed");
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
    debugPrint("[NNotes] Github login failed");
  }

  return 1;
}

void authListenRedirectCallback() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000); // Listen on port 3000 for incoming auth requests 
    await for (HttpRequest request in server) {
      await authExchangeCodeForSession(request);
    }
  }

Future<void> authExchangeCodeForSession(HttpRequest authRequest) async {
  Supabase.instance.client.auth.exchangeCodeForSession(authRequest.uri.queryParameters['code']!);
}