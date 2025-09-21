
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:feedback/feedback.dart';

import 'backend/supabase/supabase.dart';

import 'app.dart';




void main() async {

  await initializeSupabase();

  await dotenv.load(fileName: ".env");

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

}
