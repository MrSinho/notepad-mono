import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/builders/text_builder.dart';
import 'package:template/builders/text_field_builder.dart';
import 'package:template/types/text_field_view.dart';
import 'package:template/types/text_view.dart';

import 'types/list_tile_view.dart';
import 'types/app_bar_view.dart';

import 'new_primitives/list_tiles_view.dart';
import 'types/scaffold_view.dart';
import 'new_primitives/login_page.dart';

import 'static/note_bottom_sheet.dart';

import 'builders/app_bar_builder.dart';


import 'backend/supabase/supabase.dart';
import 'backend/supabase/listen.dart';
import 'backend/supabase/queries.dart';
import 'backend/app_data.dart';





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
      )
    );

    return app; 
  }

}

