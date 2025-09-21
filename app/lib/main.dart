import 'package:flutter/material.dart';
import 'package:feedback/feedback.dart';

import 'backend/supabase/supabase.dart';

import 'app.dart';



void main() async {
  await initializeSupabase();
  runApp(
    const BetterFeedback(
      child: NoteApp()
    )
  );
}
