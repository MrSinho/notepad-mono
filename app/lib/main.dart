import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notepad_mono/backend/supabase/queries.dart';
//import 'package:sentry_flutter/sentry_flutter.dart';
//import 'package:feedback/feedback.dart';

import 'backend/supabase/supabase.dart';
import 'backend/supabase/auth_access.dart';

import 'app.dart';




void main() async {
  
  await dotenv.load(
    fileName: ".safeEnv",
    isOptional: true
  );

  await initializeSupabase();

  /*
  await SentryFlutter.init(
    (options) {
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.tracesSampleRate = 1.0; // Capture 100% of transactions for tracing
      options.profilesSampleRate = 1.0; // Profile 100% of sampled transactions
    },
    appRunner: () => runApp(
      SentryWidget(child: 
        const BetterFeedback(
          child: NoteApp()
        )
      )
    )
  );
  */

  //runApp(
  //  const BetterFeedback(
  //    child: NoteApp()
  //  )
  //);

  /*
  if (Platform.isAndroid || Platform.isIOS) {
    listenToUriLinks();
  } else {
    startAuthHttpServer();
  }
  */

  if (Platform.isAndroid || Platform.isIOS) {
    listenToUriLinks();
  }
  else {// Desktop
    startAuthHttpServer();
  }

  runApp(const NoteApp());

}
