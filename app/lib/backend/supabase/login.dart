import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../handle.dart';



Future<int> googleLogin(
  Handle handle
) async {

  bool r = await handle.supabase_objects.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: "https://oofcqqefirmebbwdztvk.supabase.co/auth/v1/callback"
  );

  if (!r) {
    debugPrint("Google login failed");
  }

  return 1;
}

Future<int> githubLogin(
  Handle handle
) async {

  bool r = await handle.supabase_objects.auth.signInWithOAuth(
    OAuthProvider.github,
    redirectTo: "https://oofcqqefirmebbwdztvk.supabase.co/auth/v1/callback"
  );

  if (!r) {
    debugPrint("Github login failed");
  }

  return 1;
}