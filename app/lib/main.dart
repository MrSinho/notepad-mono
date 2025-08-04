import 'package:flutter/material.dart';
import 'backend/supabase/supabase.dart';

import 'app.dart';



void main() async {
  //No need to initialize AppData
  await initializeSupabase();
  runApp(const NNoteApp());
}