import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../backend/supabase/session.dart';

import '../backend/app_data.dart';
import '../backend/utils/color_utils.dart';

import '../static/info_settings_widget.dart';
import '../static/note_dialogs.dart';



AppBar homeAppBarBuilder(BuildContext context) {

  List<Widget> mainAppBarLeftChildren = [
    paletteGradientShaderMask(
      generateRandomColorPalette(2),
      Text(
        AppData.instance.queriesData.currentVersion["name"] ?? "Notepad Mono",
        style: GoogleFonts.robotoMono(
          fontSize: 25, 
          fontWeight: FontWeight.bold,
          color: Colors.white
        )
      )
    ),
    const SizedBox(width: 12.0),
    Column(
      children: [
        Wrap(
          children: [
            Text(
              AppData.instance.queriesData.currentVersion["version"],
              style: GoogleFonts.robotoMono(fontSize: 10),
            ),
          ] 
        ),
        const Gap(4)
      ]
    )
  ];

  /*
  if (
    (
      AppData.instance.noteEditStatusData.status.code == NoteEditStatus.lostConnection.code || 
      AppData.instance.noteEditStatusData.status.code == NoteEditStatus.failedSave.code
    ) &&
    MediaQuery.of(context).size.width > 424
  ) {
    mainAppBarLeftChildren.add(
      Padding(
        padding: const EdgeInsetsGeometry.only(left: 4),
        child: IconButton(
          icon: Icon(
            Icons.sync_rounded,
            color: NoteEditStatus.lostConnection.color,
          ),
          onPressed: () => setNoteEditStatus(NoteEditStatus.dismissedErrors)
        )   
      )
    );
  }
  */

  AppBar appBar = AppBar(
    leading: IconButton(
      icon: const Icon(Icons.add),
      onPressed: () => showDialog(context: context, builder: (BuildContext context) => newNoteDialog(context))
    ),
    title: Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: mainAppBarLeftChildren
    ),
    actions: [
      IconButton(
        icon: getProfilePicture(false),
        onPressed: () => showUserInfoWidget(context)
      ),
      const Gap(8.0)
    ],
  );

  return appBar;
}