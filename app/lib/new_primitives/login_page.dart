import 'package:flutter/material.dart';

import '../backend/app_data.dart';

import '../builders/login_page_builder.dart';



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
  }

  @override
  Widget build(BuildContext context) {
    
    ValueListenableBuilder builder = ValueListenableBuilder(
      valueListenable: AppData.instance.widgetsNotifier.rootPageUpdates,
      builder: (context, value, child) => loginPageBuilder(context)
    );

    return builder;
  }
}
