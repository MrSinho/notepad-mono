import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'backend/app_data.dart';
import 'backend/navigator.dart';

import 'new_primitives/login_page.dart';

import 'builders/login_page_builder.dart';

import 'themes.dart';



class NNoteApp extends StatelessWidget {
  const NNoteApp({super.key});

  @override
  Widget build(BuildContext context) {

    MaterialApp app = MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorInfo.key,

      home: StreamBuilder<AuthState>(

        stream: Supabase.instance.client.auth.onAuthStateChange,

        builder: (context, snapshot) {

          if (snapshot.data != null && snapshot.data!.session != null) {
            return AppData.instance.homePage;
          }
          else {
            return AppData.instance.loginPage;
          }

        }
      ),

      theme: brightTheme(),

      darkTheme: darkTheme(),

      highContrastTheme: brightThemeHighContrast(),

      highContrastDarkTheme: darkThemeHighContrast()
    );

    return app; 
  }

}