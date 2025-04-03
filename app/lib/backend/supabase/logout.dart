import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../handle.dart';



Future<int> logout(
  Handle handle
) async {

  try {
    await Supabase.instance.client.auth.signOut();
  } catch (error) {
    debugPrint('Error signing out: $error');
  }

  return 1;
}