import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/utils.dart';
import '../environment.dart';



Future<int> initializeSupabase() async {
  try {
    
    await Supabase.initialize(

      url: getEnvironmentParameterValue('SUPABASE_PROJECT_URL'),

      anonKey: getEnvironmentParameterValue('SUPABASE_ANON_KEY'),

      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
        autoRefreshToken: true,
      ),

      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),

      storageOptions: const StorageClientOptions(
        retryAttempts: 10,
      ),

    );

    return 1;
    
  } catch (exception) {

    appLog("Failed to initialize Supabase: $exception");

    return 0;
  }
}
