import 'package:flutter/material.dart';
import 'home.dart';
import 'handle.dart';
import 'login.dart';
import 'supabase.dart';

import 'package:supabase/supabase.dart';
import "package:supabase_flutter/supabase_flutter.dart";



class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    const String title = 'Flutter template';
    //
    //const MaterialApp app = MaterialApp(
    //  title: title,
    //  home : Home(title: title),
    //);

    Handle handle = Handle();

    initializeSupabase(handle);

    MaterialApp app = MaterialApp(
    title: "",

    home: StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.session != null) {
          handle.email = snapshot.data!.session!.user.email!;
          return FutureBuilder(
            future: checkUserInfo(handle),
            builder: (context, futureSnapshot) {
              return const Home(title: title);
              //return Text("Headless test");
            }
          );
        }
        else {
          return Login(handle: handle);
          //return Text("Headless test");
        }
      }
    )
    );


    return app;
  }
}