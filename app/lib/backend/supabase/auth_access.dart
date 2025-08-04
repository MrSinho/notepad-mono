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
    debugPrint("Google login failed");
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
    debugPrint("Github login failed");
  }

  return 1;
}

