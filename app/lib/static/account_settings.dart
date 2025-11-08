import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../backend/navigation/router.dart';
import '../backend/supabase/session.dart';
import '../backend/supabase/auth_access.dart';

import '../backend/utils/ui_utils.dart';

import '../backend/app_data.dart';

import 'info_settings_widget.dart';
import 'privacy_policy.dart';
import 'sign_out_dialog.dart';
import 'delete_user_data.dart';
import 'delete_account_dialog.dart';



Widget accountSettingsWidget(BuildContext context) {

  Text title = Text("Account settings", textAlign: TextAlign.center, style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold));

  Widget logoutAction = wrapIconTextButton(
    const Icon(Icons.logout_outlined),
    Text("Log out", style: GoogleFonts.robotoMono()), 
    () => showDialog(context: context, builder: (BuildContext context) => signOutDialog(context))
  );

  if (AppData.instance.sessionData == DummySession.data) {
    logoutAction = wrapIconTextButton(
      const Icon(Icons.logout_outlined, color: Colors.orange),
      Text("Exit dummy session", style: GoogleFonts.robotoMono(color: Colors.orange)), 
      () {
        popAll(context);
        exitDummySession();
        goToRootPage();
      }
    );
  }

  Widget privacyPolicyAction = wrapIconTextButton(
    const Icon(Icons.privacy_tip_rounded, color: Colors.blue),
    Text("Privacy Policy", style: GoogleFonts.robotoMono()), 
    () => showDialog(context: context, builder: (BuildContext context) => privacyPolicyWidget(context))
  );

  Widget deleteDataAction = wrapIconTextButton(
    const Icon(Icons.warning_rounded, color: Colors.orangeAccent),
    Text("Delete user data", style: GoogleFonts.robotoMono()), 
    () => showDialog(context: context, builder: (BuildContext context) => deleteUserDataDialog(context))
  );

  Widget deleteAccountAction = wrapIconTextButton(
    const Icon(Icons.warning_rounded, color: Colors.red),
    Text("Delete account", style: GoogleFonts.robotoMono()), 
    () => showDialog(context: context, builder: (BuildContext context) => deleteAccountDialog(context))
  );

  Column footer = Column(
    children: footerWidgets(context)
  );

  Column actionsColumn = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      logoutAction,
      const Gap(8),
      privacyPolicyAction,
      const Gap(8),
      deleteDataAction,
      const Gap(8),
      deleteAccountAction
    ],
  );

  Column column = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      title,
      const Gap(36),
      actionsColumn,
      const Gap(36),
      footer
    ],
  );

  Dialog dialog = Dialog(
      child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: column,
    )
  );

  return dialog;

}