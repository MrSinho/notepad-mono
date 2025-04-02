import 'package:supabase/supabase.dart';
import "package:supabase_flutter/supabase_flutter.dart";

import 'handle.dart';


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
    print('Failed to initialize Supabase: $exception');
    return 0;
  }
  
}

Future<int> checkUserInfo(
  Handle handle,
) async {

  //await SQLCreateUserProfile(handle, handle.private_profile.email);
  //await GetCurrentProfileInfo(handle, handle.private_profile.email);

  return 1;
}