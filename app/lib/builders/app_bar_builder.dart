import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';
import '../backend/note_edit/note_edit.dart';
import '../backend/color_palette.dart';

import '../static/info_settings_widget.dart';
import '../static/note_dialogs.dart';
import '../static/shortcuts_map.dart';
import '../static/ui_utils.dart';

import '../themes.dart';



AppBar mainAppBarBuilder(BuildContext context) {

  List<Widget> mainAppBarLeftChildren = [
    paletteGradientShaderMask(
      generateRandomColorPalette(2, isThemeBright(context)),
      Text(
        AppData.instance.queriesData.version["name"] ?? "Notepad Mono",
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
              AppData.instance.queriesData.version["version"] ?? "",
              style: GoogleFonts.robotoMono(fontSize: 10),
            ),
          ] 
        ),
        const Gap(4)
      ]
    )
  ];

  if (
    AppData.instance.noteEditStatusData.status.code == NoteEditStatus.lostConnection.code || 
    AppData.instance.noteEditStatusData.status.code == NoteEditStatus.failedSave.code
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

Widget editAppBarContentBuilder(BuildContext context) {
  appLog("Updating edit app bar content", true);

  String title = AppData.instance.queriesData.selectedNote["title"] ?? "";

  ShaderMask titleGradientMask = paletteGradientShaderMask(
    AppData.instance.editColorPaletteData,
    Text(
      title, 
      style: GoogleFonts.robotoMono(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
      overflow: TextOverflow.ellipsis, // Important for long titles
      maxLines: 1
    )
  );

  TextButton titleButton = TextButton(
    child: titleGradientMask,
    onPressed: () => showDialog(context: context, builder: (BuildContext context) => renameNoteDialog(context)),
  );

  Flexible titleFlexible = Flexible(
    child: titleButton
  );

  List<Widget> leftChildren = [
    Padding(
      padding: const EdgeInsetsGeometry.all(12.0),
      child: Icon(Icons.circle, color: AppData.instance.noteEditStatusData.status.color, size: 14.0,),
    ),
    favoriteButton(AppData.instance.queriesData.selectedNote, context),
    titleFlexible
  ];

  if (
    AppData.instance.noteEditStatusData.status.code == NoteEditStatus.lostConnection.code || 
    AppData.instance.noteEditStatusData.status.code == NoteEditStatus.failedSave.code
  ) {

    leftChildren.add(
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

  Row content = Row(
    children: leftChildren
  );

  return content;
}

AppBar editAppBarBuilder(BuildContext context) {

  AppBar appBar = AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => exitNoteEditPage(context)
    ),
    title: AppData.instance.editAppBarContent,
    actions: [
      //IconButton(
      //  icon: const Icon(Icons.format_indent_increase_rounded),
      //  onPressed: () => indentSelection(AppData.instance.noteEditData.controller),
      //),
      //IconButton(
      //  icon: const Icon(Icons.copy_sharp),
      //  onPressed: () async => await copySelectionToClipboardOrNot()
      //),
      //IconButton(
      //  icon: const Icon(Icons.copy_all_sharp),
      //  onPressed: () async => await copyNoteToClipboardOrNot()
      //),
      //IconButton(
      //  icon: const Icon(Icons.save_outlined),
      //  onPressed: () async => await saveNoteContent()
      //),
      IconButton(
        icon: const Icon(Icons.keyboard_rounded),
        onPressed: () => showShortCutsMap(context),
      ),
      IconButton(
        icon: getProfilePicture(false),
        onPressed: () => showUserInfoWidget(context)
      ),
      const Gap(8.0)
    ],
  );

  return appBar;
}