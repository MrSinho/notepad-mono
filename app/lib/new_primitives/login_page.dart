import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

import '../backend/supabase/auth_access.dart';

import '../static/ui_utils.dart';

import '../themes.dart';



class LoginAuthProviders {
  static const int google = 1 << 0;
  static const int github = 1 << 1;
}

class Login extends StatefulWidget {
  const Login(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.authProviders});

  final int authProviders;
  final Widget title;
  final Widget subtitle;

  @override
  State<Login> createState() {
    return LoginState();
  }
}

class LoginInfo {
  late GlobalKey<LoginState> key;
  late Login widget;

  LoginInfo(
      {required int authProviders,
      required Widget title,
      required Widget subtitle}) {
    key = GlobalKey<LoginState>();
    widget = Login(
        key: key,
        authProviders: authProviders,
        title: title,
        subtitle: subtitle);
  }
}

class LoginState extends State<Login> {
  Widget errorMessage = const Text("");

  @override
  void initState() {
    authListenRedirectCallback();
    super.initState();
  }

  void writeError(Widget errorMsg) {
    setState(() {
      errorMessage = errorMsg;
    });
  }

  void clearError() {
    setState(() {
      errorMessage = const Text("");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> authProvidersWidgets = [];

    if (widget.authProviders & LoginAuthProviders.google != 0) {
      authProvidersWidgets.add(
        wrapIconTextButton(const Icon(SimpleIcons.google),
            const Text("Sign In with Google"), () => googleLogin()),
      );
    }

    if (widget.authProviders & LoginAuthProviders.github != 0) {
      authProvidersWidgets.add(
        wrapIconTextButton(const Icon(SimpleIcons.github),
            const Text("Sign In with Github"), () => githubLogin()),
      );
    }

    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.rocket_launch_rounded), widget.title]),
        const SizedBox(height: 20.0),
        widget.subtitle,
        const SizedBox(height: 60.0),
        errorMessage,
        const SizedBox(height: 16.0),
        Wrap(
            direction: Axis.horizontal,
            spacing: 30,
            runSpacing: 8,
            children: authProvidersWidgets),
        const SizedBox(height: 60.0),
      ],
    );

    Padding signupPad = Padding(
      padding: const EdgeInsets.all(16),
      child: column,
    );

    FractionallySizedBox signupBox = FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.8,
      child: Card(child: signupPad),
    );

    Center signupCenter = Center(
      child: signupBox,
    );

    Scaffold scaffold = Scaffold(
      backgroundColor: getCurrentThemePalette(context).secondaryBackgroundColor,
      body: signupCenter,
    );

    return scaffold;
  }
}
