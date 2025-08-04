import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'backend/app_data.dart';
import 'backend/navigator.dart';
import 'backend/supabase/supabase.dart';

import 'new_primitives/login_page.dart';

import 'builders/text_builder.dart';

import 'types/text_view.dart';

import 'themes.dart';




void main() async {
  //No need to initialize AppData
  await initializeSupabase();
  runApp(const NNoteApp());
}

LoginInfo makeLogin() {

  TextViewInfo titleViewInfo = TextViewInfo(
    text: loginTitleBuilder()
  );

  TextViewInfo subtitleViewInfo = TextViewInfo(
    text: loginSubtitleBuilder()
  );

  LoginInfo login = LoginInfo(
    authProviders: LoginAuthProviders.google | LoginAuthProviders.github,
    title:    titleViewInfo.widget.text,
    subtitle: subtitleViewInfo.widget.text
  );

  return login;
}



class NNoteApp extends StatelessWidget {
  const NNoteApp({super.key});

  @override
  Widget build(BuildContext context) {

    LoginInfo login = makeLogin();

    MaterialApp app = MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorInfo.key,

      home: StreamBuilder<AuthState>(

        stream: Supabase.instance.client.auth.onAuthStateChange,

        builder: (context, snapshot) {

          if (snapshot.data != null && snapshot.data!.session != null) {

            return AppData.instance.enterDashboard();
          }
          else {
            return login.widget;
          }

        }
      ),

      theme: brightTheme(),

      darkTheme: darkTheme(),
//
      //highContrastTheme: darkHighContrastTheme(),

      //themeMode: ThemeMode.system,
    );

    return app; 
  }

}

