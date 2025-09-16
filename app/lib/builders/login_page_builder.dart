import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_icons/simple_icons.dart';

import '../backend/supabase/auth_access.dart';

import '../backend/app_data.dart';

import '../new_primitives/login_page.dart';

import '../static/ui_utils.dart';

import '../themes.dart';



Widget loginPageBuilder(BuildContext context) {

  String appName     = AppData.instance.queriesData.version["name"] ?? "NNotes";
  String description = AppData.instance.queriesData.version["description"] ?? "Write simple monospace notes everywhere";

  Text title = Text(" $appName!", style: GoogleFonts.robotoMono(fontSize: 36, fontWeight: FontWeight.bold));

  Text subtitle = Text(description, style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold));

  int authProviders = LoginAuthProviders.google | LoginAuthProviders.github;

  List<Widget> authProvidersWidgets = [];

    if (authProviders & LoginAuthProviders.google != 0) {
      authProvidersWidgets.add(
        wrapIconTextButton(const Icon(SimpleIcons.google),
            const Text("Sign In with Google"), () => googleLogin()),
      );
    }

    if (authProviders & LoginAuthProviders.github != 0) {
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
            children: [
              const Icon(Icons.rocket_launch_rounded), title
            ]
        ),
        const SizedBox(height: 20.0),
        subtitle,
        const SizedBox(height: 60.0),
        Text(AppData.instance.loginData.errorMessage),
        const SizedBox(height: 16.0),
        Wrap(
          direction: Axis.horizontal,
          spacing: 30,
          runSpacing: 8,
          children: authProvidersWidgets
        ),
        const SizedBox(height: 60.0),
      ]
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