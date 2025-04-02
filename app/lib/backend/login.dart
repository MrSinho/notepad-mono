import '../types/supabase.dart';
import '../types/handle.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<int> googleLogin(
  Handle handle
) async {

  await handle.supabase_objects.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: "https://oofcqqefirmebbwdztvk.supabase.co/auth/v1/callback"
  );

  return 1;
}

Future<int> githubLogin(
  Handle handle
) async {

  await handle.supabase_objects.auth.signInWithOAuth(
    OAuthProvider.github,
    redirectTo: "https://oofcqqefirmebbwdztvk.supabase.co/auth/v1/callback"
  );

  return 1;
}