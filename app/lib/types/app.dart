import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/supabase/listen.dart';
import '../backend/supabase/queries.dart';
import '../backend/handle.dart';




class App extends StatelessWidget {
  const App({super.key, required this.handle});

  final Handle handle;

  @override
  Widget build(BuildContext context) {
      

    MaterialApp app = MaterialApp(
      title: "Template",

      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.session != null) {
            handle.profile.private.email = snapshot.data!.session!.user.email!;
            return FutureBuilder(
              future: queryProfileInfo(handle),
              builder: (context, futureSnapshot) {
                listenToProfile(handle);
                return handle.types.collection_dashboard.widget;
              }
            );
          }
          else {
            return handle.types.collection_login.widget;
          }
        }
      )
    );


    return app;
  }
}