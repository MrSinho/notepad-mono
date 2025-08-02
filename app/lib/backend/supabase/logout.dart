import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';



Future<int> logout() async {

  try {
    await Supabase.instance.client.auth.signOut();
  } catch (error) {
    debugPrint('Error signing out: $error');
  }

  return 1;
}