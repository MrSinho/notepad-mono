import 'package:flutter/material.dart';

import '../backend/supabase/listen.dart';
import '../backend/app_data.dart';

import '../builders/login_page_builder.dart';



class LoginAuthProviders {
  static const int google = 1 << 0;
  static const int github = 1 << 1;
}

class LoginPage extends StatefulWidget {
  const LoginPage(
    {
      super.key
    }
  );

  @override
  State<LoginPage> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();
    listenToVersions(context);
  }

  @override
  Widget build(BuildContext context) {
    
    ValueListenableBuilder builder = ValueListenableBuilder(
      valueListenable: AppData.instance.loginPageUpdates,
      builder: (context, value, child) => loginPageBuilder(context)
    );

    return builder;
  }
}
