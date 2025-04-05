
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../handle.dart';

import 'queries.dart';



Future<int> initializeSupabase(
  Handle handle
) async {

  handle.supabase_objects = SupabaseObjects();
  
  try {

    handle.supabase_objects.instance = await Supabase.initialize(
      url: 'https://oofcqqefirmebbwdztvk.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vZmNxcWVmaXJtZWJid2R6dHZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQxOTI4MDQsImV4cCI6MjAzOTc2ODgwNH0.pdjyubgLmJiMr3ZEBvPYjFE5lCT5avvGLNcHFkmXOZ8',
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(
        retryAttempts: 10,
      ),
    );

    handle.supabase_objects.client = Supabase.instance.client;
    handle.supabase_objects.auth   = Supabase.instance.client.auth;

    return 1;

  }
  catch (exception) {
    debugPrint('Failed to initialize Supabase: $exception');
    return 0;
  }
  
}

Future<bool> checkIfUserExists(User user) async {
  final session = Supabase.instance.client.auth.currentSession;

  if (session?.user != null) {

    debugPrint("User already authenticated: ${session!.user.email}");

    return true;

  } else {

    debugPrint("User not authenticated");

    return false;

  }

}



Future<int> checkUserInfo(
  Handle handle,
) async {

  await queryCreateUserProfile(handle);
  await queryProfileInfo(handle);

  return 1;
}











