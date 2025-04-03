import 'package:flutter/material.dart';
import 'package:template/backend/supabase/listen.dart';
import 'package:template/backend/supabase/queries.dart';
import 'package:template/static/utils.dart';

import '../backend/handle.dart';
import '../backend/supabase/supabase.dart';


import 'package:supabase/supabase.dart';
import "package:supabase_flutter/supabase_flutter.dart";



class App extends StatelessWidget {
  App({super.key, required this.handle});

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