import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/supabase/listen.dart';
import '../backend/supabase/session.dart';

import '../backend/app_data.dart';



StreamBuilder<AuthState> authStreamBuilder(BuildContext context) {

  StreamBuilder<AuthState> builder = StreamBuilder<AuthState>(
    stream: Supabase.instance.client.auth.onAuthStateChange,

    builder: (context, snapshot) {

      listenToVersions();
      //setupWithContext(context)
      
      if (snapshot.data != null && snapshot.data!.session != null) {

        FutureBuilder builder = FutureBuilder<void>(
          future: storeUserData(),
          builder: (context, userSnapshot) {

            if (userSnapshot.connectionState == ConnectionState.waiting) {// Loading screen
              
              Scaffold loadingScaffold = const Scaffold(
                body: SizedBox(width: 10.0, height: 10.0)
              );

              return loadingScaffold;
            }

            listenToNotes();

            return AppData.instance.homePage;
          }
        );

        return builder;
      }

      else {
        return AppData.instance.loginPage;
      }

    }
  );

  return builder;
}