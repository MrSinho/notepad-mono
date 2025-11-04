import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:feedback_sentry/feedback_sentry.dart';
import 'package:gap/gap.dart';
import 'package:notepad_mono/backend/navigation/router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/supabase/session.dart';

import '../backend/app_data.dart';
import '../backend/inputs.dart';
import '../backend/utils/color_utils.dart';

import 'ui_utils.dart';
import 'sign_out_dialog.dart';
import 'delete_account_dialog.dart';

import '../themes.dart';



void showUserInfoWidget(BuildContext context) {
  
  Widget userData = Row(// Desktop
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsetsGeometry.all(16.0),
        child: getProfilePicture(true)
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          paletteGradientShaderMask(
            generateRandomColorPalette(3),
            Text(AppData.instance.sessionData.username,
              style: GoogleFonts.robotoMono(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
              )
            )
          ),
          const Gap(4),
          Text(AppData.instance.sessionData.email, style: GoogleFonts.robotoMono(fontSize: 14)),
          const Gap(4),
          Text("First auth provider: ${AppData.instance.sessionData.authProvider}", style: GoogleFonts.robotoMono(fontSize: 14), textAlign: TextAlign.left)
        ],
      )
    ],
  );

  const double minWidth  = 600;
  const double minHeight = 500;
  if (MediaQuery.of(context).size.width < minWidth || MediaQuery.of(context).size.height < minHeight) {
    userData = Column(
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.all(16.0),
          child: getProfilePicture(true)
        ),
        paletteGradientShaderMask(
          generateRandomColorPalette(3),
          Text(AppData.instance.sessionData.username,
            style: GoogleFonts.robotoMono(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white
            )
          )
        ),
        const Gap(4),
        Text(AppData.instance.sessionData.email, style: GoogleFonts.robotoMono(fontSize: 14)),
        const Gap(4),
        Text("First auth provider: ${AppData.instance.sessionData.authProvider}", style: GoogleFonts.robotoMono(fontSize: 14), textAlign: TextAlign.left)
      ],
    );
  }

  String issuesSite = AppData.instance.queriesData.currentVersion["issues_website"] ?? "https://www.github.com/mrsinho/notepad-mono/issues";

  Widget sessionActions = Wrap(
    direction: Axis.horizontal,
    children: [
      wrapIconTextButton(
        const Icon(Icons.logout_outlined),
        Text("Log out", style: GoogleFonts.robotoMono()), 
        () {
          showDialog(
            context: context,
            builder: (BuildContext context) => signOutDialog(context)
          );
        }
      ),
      SizedBox(width: 16),
      wrapIconTextButton(
        const Icon(Icons.warning_rounded, color: Colors.red),
        Text("Delete account", style: GoogleFonts.robotoMono()), 
        () {
          showDialog(
            context: context,
            builder: (BuildContext context) => deleteAccountDialog(context)
          );
        }
      )
    ]
  );

  if (AppData.instance.sessionData == DummySession.data) {
    sessionActions = wrapIconTextButton(
      const Icon(Icons.logout_outlined, color: Colors.orange),
      Text("Exit dummy session", style: GoogleFonts.robotoMono(color: Colors.orange)), 
      () {
        clearUserRelatedAppData();
        context.pop();
        goToRootPage();
      }
    );
  }

  List<Widget> userInfoContents = [
    userData,
    const Gap(20),
    //wrapIconTextButton(
    //  const Icon(Icons.bug_report_rounded),
    //  Text("Report a bug", style: GoogleFonts.robotoMono()),
    //  () => BetterFeedback.of(context).showAndUploadToSentry(
    //    // https://xxx-xxx.sentry.io/issues/feedback/
    //    name: AppData.instance.sessionData.username,
    //    email: AppData.instance.sessionData.email,
    //  )
    //),
    wrapIconTextButton(
      const Icon(Icons.bug_report_rounded),
      Text("Report an issue", style: GoogleFonts.robotoMono()),
      () => launchUrl(Uri.parse(issuesSite)),
    ),    
    const Gap(20),
    sessionActions
  ];

  userInfoContents.addAll(footerWidgets(context));

  Column column = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: userInfoContents
  );

  if (MediaQuery.of(context).size.width < minWidth || MediaQuery.of(context).size.height < minHeight) {

    SingleChildScrollView scroll = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 48.0),
        child: column
      )
    );

    KeyboardListener listener = KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      child: scroll,
      onKeyEvent: (KeyEvent event) => userInfoInputListener(context, event),
    );

    ConstrainedBox box = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: listener
    );

    showModalBottomSheet(
      context: context, 
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => SafeArea(child: box)
    );

    return;
  }

  Dialog dialog = Dialog(
      child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: column,
    )
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: dialog,
    onKeyEvent: (KeyEvent event) => userInfoInputListener(context, event),
  );

  showDialog(context: context, builder: (BuildContext context) => listener);
}

List<Widget> footerWidgets(BuildContext context) {
  String currentVersion = "v${AppData.instance.packageInfo.version}";

  Map<String, dynamic> versionData = AppData.instance.queriesData.versions[currentVersion] ?? {};

  String author     = versionData["author"]            ?? "mrsinho";
  String appName    = versionData["name"]              ?? "Notepad Mono";
  String appWebsite = versionData["app_website"]       ?? "https://www.github.com/mrsinho/notepad-mono";
  String devWebsite = versionData["developer_website"] ?? "https://www.github.com/mrsinho";


  List<Widget> footer = [
    const Gap(40),
    Text(
      "$appName, build version: $currentVersion",
      style: TextStyle(
        fontSize: 12,
        color: getCurrentThemePalette().quaternaryForegroundColor
      )
    ),
    Text(
      AppData.instance.queriesData.currentVersion["copyright_notice"] ?? "",
      style: TextStyle(
        fontSize: 12,
        color: getCurrentThemePalette().quaternaryForegroundColor
      )
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
    children: settingsContents
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialogContent,
    )
  );

  return dialog;
}
