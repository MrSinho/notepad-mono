import 'package:flutter/material.dart';

import 'backend/supabase/supabase.dart';

import 'app.dart';

void main() async {
  await initializeSupabase();
  runApp(const NNoteApp());
}
