import 'package:flutter/material.dart';
import 'package:nnotes/backend/supabase/auth_access.dart';
import 'package:nnotes/static/ui_utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'backend/app_data.dart';
import 'backend/navigator.dart';

import 'themes.dart';



WidgetBuilder futureBuilder(
  Future<dynamic> async_widget,
) {

  return (BuildContext context) { return futureBuilderWidget(async_widget); };

}

Future<Widget> goToHomePage() async {
  await storeUserData();
  return Text("Hello");
}


class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {

    MaterialApp app = MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorInfo.key,

      home: StreamBuilder<AuthState>(

        stream: Supabase.instance.client.auth.onAuthStateChange,

        builder: (context, snapshot) {

          AppData.instance.setupWithContext(context);
          
          if (snapshot.data != null && snapshot.data!.session != null) {

            FutureBuilder builder = FutureBuilder<void>(
              future: storeUserData(),
              builder: (context, userSnapshot) {

                if (userSnapshot.connectionState == ConnectionState.waiting) {// Loading screen
                  
                  Scaffold loadingScaffold = const Scaffold(
                    body: SizedBox(width: 2.0, height: 2.0)
                  );
                  
                  return loadingScaffold;
                }

                return AppData.instance.homePage;
              }
            );

            return builder;
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