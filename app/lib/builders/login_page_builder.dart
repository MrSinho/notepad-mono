import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:gap/gap.dart';

import '../backend/supabase/auth_access.dart';
import '../backend/color_palette.dart';
import '../backend/app_data.dart';

import '../static/ui_utils.dart';

import '../themes.dart';



Widget loginPageBuilder(BuildContext context) {

  String appName     = AppData.instance.queriesData.version["name"] ?? "";
  String description = AppData.instance.queriesData.version["description"] ?? "Write simple monospace notes everywhere";

  Text title    = Text(" $appName!", style: GoogleFonts.robotoMono(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white));
  Text subtitle = Text(description,  style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold));

  int authProviders = LoginAuthProviders.google | LoginAuthProviders.github | LoginAuthProviders.azure;

  ColorPaletteData loginPalette = generateRandomColorPalette(2, isThemeBright(context));

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

    if (authProviders & LoginAuthProviders.azure != 0) {
      authProvidersWidgets.add(
        // https://github.com/simple-icons/simple-icons/issues/11236
        wrapIconTextButton(const Icon(Icons.window_rounded), // Microsoft being microsoft and their legal team
          const Text("Sign In with Microsoft"), () => azureLogin()),
      );
    }

    ShaderMask titleRow = paletteGradientShaderMask(
      loginPalette,
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const Icon(Icons.rocket_launch_rounded, color: Colors.white), 
            title
          ]
      )
    );

    Column column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        titleRow,
        const Gap(20.0),
        subtitle,
        const Gap(60.0),
        Text(AppData.instance.sessionData.errorMessage),
        const Gap(16.0),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          spacing: 30,
          runSpacing: 8,
          children: authProvidersWidgets
        ),
        const Gap(60.0),
      ]
    );

    Padding signupPad = Padding(
      padding: const EdgeInsets.all(16),
      child: column,
    );

    FractionallySizedBox signupBox = FractionallySizedBox(
      widthFactor: 0.65,
      heightFactor: 0.65,
      child: Card(child: signupPad),
    );

    const double minWidth = 800;
    if (MediaQuery.of(context).size.width < minWidth) {
      signupBox = FractionallySizedBox(
        child: signupPad,
      );
    }

    Center signupCenter = Center(
      child: signupBox,
    );

    BoxDecoration containerDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: loginPalette.asColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    if (MediaQuery.of(context).size.width < minWidth) {
      containerDecoration = BoxDecoration();// Keep default theme
    }

    Container container = Container(
      decoration: containerDecoration,
      child: signupCenter
    );


    Scaffold scaffold = Scaffold(
      body: SafeArea(child: container),
    );

  return scaffold;
}