import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/app_data.dart';
import '../backend/navigator.dart';
import '../backend/inputs.dart';
import '../backend/utils.dart';
import '../backend/color_palette.dart';

import 'sign_out_dialog.dart';
import 'ui_utils.dart';

import '../themes.dart';

Widget userInfoDialog(BuildContext context) {
  Row userRow = Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
          padding: const EdgeInsetsGeometry.all(16.0),
          child: getProfilePicture(true)),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          paletteGradientShaderMask(
              generateRandomColorPalette(2, isThemeBright(context)),
              Text(AppData.instance.sessionData.username,
                  style: GoogleFonts.robotoMono(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white))),
          const Gap(4),
          Text(AppData.instance.sessionData.email,
              style: GoogleFonts.robotoMono(fontSize: 14)),
          const Gap(4),
          Text(
              "First auth provider: ${AppData.instance.sessionData.authProvider}",
              style: GoogleFonts.robotoMono(fontSize: 14),
              textAlign: TextAlign.left)
        ],
      )
    ],
  );

  // Different encryption key icon if encryption is enabled or disabled

  List<Widget> userInfoContents = [
    userRow,
    const Gap(20),
    wrapIconTextButton(
        const Icon(Icons.bug_report_rounded),
        Text("Report a bug", style: GoogleFonts.robotoMono()),
        () => BetterFeedback.of(context).showAndUploadToSentry(
              // https://xxx-xxx.sentry.io/issues/feedback/
              name: AppData.instance.sessionData.username,
              email: AppData.instance.sessionData.email,
            )),
    const Gap(20),
    wrapIconTextButton(const Icon(Icons.logout_outlined),
        Text("Log out", style: GoogleFonts.robotoMono()), () {
      NavigatorInfo.getState()?.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => signOutDialog(context));
    })
  ];

  userInfoContents.addAll(footerWidgets(context));

  Column column = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: userInfoContents);

  Dialog dialog = Dialog(
      child: Padding(
    padding: const EdgeInsets.all(48.0),
    child: column,
  ));

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: dialog,
    onKeyEvent: (KeyEvent event) => userInfoInputListener(context, event),
  );

  return listener;
}

List<Widget> footerWidgets(BuildContext context) {
  String author = AppData.instance.queriesData.version["author"] ?? "mrsinho";
  String appName =
      AppData.instance.queriesData.version["name"] ?? "Notepad Mono";
  String version = AppData.instance.queriesData.version["version"] ?? "0.1.0";
  String versionTag = AppData.instance.queriesData.version["tag"] ?? "vanilla";
  String appWebsite = AppData.instance.queriesData.version["app_website"] ??
      "https://www.github.com/mrsinho/nnotes";
  String devWebsite =
      AppData.instance.queriesData.version["developer_website"] ??
          "https://www.github.com/mrsinho";

  List<Widget> footer = [
    const Gap(40),
    Text("$appName, build version: $version, tag: $versionTag",
        style: TextStyle(
            fontSize: 12,
            color: getCurrentThemePalette(context).quaternaryForegroundColor)),
    Text(
      AppData.instance.queriesData.version["copyright_notice"] ?? "",
      style: TextStyle(
          fontSize: 12,
          color: getCurrentThemePalette(context).quaternaryForegroundColor),
    ),
    const Gap(8),
    Wrap(
      children: [
        InkWell(
          child: Text(appName, style: const TextStyle(fontSize: 12)),
          onTap: () => launchUrl(Uri.parse(appWebsite)),
        ),
        const SizedBox(width: 12),
        InkWell(
          child: Text(author, style: const TextStyle(fontSize: 12)),
          onTap: () => launchUrl(Uri.parse(devWebsite)),
        )
      ],
    )
  ];

  return footer;
}

Dialog settingsDialog(BuildContext context) {
  List<Widget> settingsContents = [
    //Waiting for future updates...
    //THEME SETTINGS
    //DELETED NOTES SETTINGS
  ];

  settingsContents.addAll(footerWidgets(context));

  Column dialogContent = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: settingsContents);

  Dialog dialog = Dialog(
      child: Padding(
    padding: const EdgeInsets.all(48.0),
    child: dialogContent,
  ));

  return dialog;
}
