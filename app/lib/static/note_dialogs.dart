import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

import '../backend/supabase/queries.dart';

import '../backend/app_data.dart';
import '../backend/navigator.dart';
import '../backend/color_palette.dart';
import '../backend/inputs.dart';

import '../themes.dart';



Widget newNoteDialog(BuildContext context) {

  TextEditingController controller = TextEditingController(text: "New note");

  TextField field = TextField(
    controller: controller,
    style: GoogleFonts.robotoMono(),
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0)),
    ),
  );

  ShaderMask doneMask = paletteGradientShaderMask(
    generateRandomColorPalette(2, isThemeBright(context)),
    Text(
      "Done", 
      style: GoogleFonts.robotoMono(
        color: Colors.white
      )
    )
  );

  TextButton confirmButton = TextButton(
    child: doneMask, 
    onPressed: () async {
      NavigatorInfo.getState()?.pop(context);
      await createNewNote(controller.text);
    }
  );

  TextButton noButton = TextButton(
    child: Text(
      "Cancel",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      )
    ), 
    onPressed: () => NavigatorInfo.getState()?.pop(context)
  );

  Column dialogContent = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text("Create note", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold),),
      const Gap(20),
      IntrinsicWidth(child: field),
      const Gap(20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          noButton,
          const Gap(12),
          confirmButton
        ]
      ),
    ]
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialogContent,
    )
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: dialog,
    onKeyEvent: (KeyEvent event) => newNoteInputListener(context, event, controller)
  );

  return listener;
}

Widget renameNoteDialog(BuildContext context) {

  TextEditingController renameController = TextEditingController(text: AppData.instance.queriesData.selectedNote["title"] ?? "");

  TextField renameField = TextField(
    controller: renameController,
    style: GoogleFonts.robotoMono(),
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent, width: 2.0), borderRadius: BorderRadius.circular(0.0)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0)),
    ),
  );

  ShaderMask renameMask = paletteGradientShaderMask(
    generateRandomColorPalette(2, isThemeBright(context)),
    Text(
      "Done",
      style: GoogleFonts.robotoMono(
        color: Colors.white
      )
    )
  );

  TextButton renameButton = TextButton(
    child: renameMask, 
    onPressed: () async {
      NavigatorInfo.getState()?.pop(context);
      await renameNote(renameController.text);
    }
  );

  TextButton noButton = TextButton(
    child: Text(
      "Cancel",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      )
    ), 
    onPressed: () => NavigatorInfo.getState()?.pop(context)
  );

  Column dialogContent = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text("Rename note", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold)),
      const Gap(20),
      IntrinsicWidth(child: renameField),
      const Gap(20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          noButton,
          const Gap(12),
          renameButton
        ]
      )
    ]
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialogContent,
    )
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: dialog,
    onKeyEvent: (KeyEvent event) => renameInputListener(context, event, renameController),
  );

  return listener;
}

Widget deleteNoteDialog(BuildContext context) {

  TextButton yesButton = TextButton(
    child: Text(
      "Yes, delete",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      )
    ), 
    onPressed: () async {
      NavigatorInfo.getState()?.pop(context);
      await deleteSelectedNote();
    }
  );

  ShaderMask noMask = paletteGradientShaderMask(
    generateRandomColorPalette(2, isThemeBright(context)),
    Text(
      "Cancel",
      style: GoogleFonts.robotoMono(
        color: Colors.white
      )
    )
  );

  TextButton noButton = TextButton(
    child: noMask, 
    onPressed: () => NavigatorInfo.getState()?.pop(context)
  );

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Confirm delete ${AppData.instance.queriesData.selectedNote["title"]}", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold),),
      const Gap(20),
      Text("Are you sure you want to delete this note?", style: GoogleFonts.robotoMono(fontSize: 12),),
      const Gap(20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          yesButton,
          const Gap(12),
          noButton
        ]
      )
    ]
  );
  
  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialogContent,
    )
  );

  return dialog;
}

Widget unsavedChangesDialog(BuildContext context) {

  TextButton yesButton = TextButton(
    child: Text(
      "Discard",
      style: GoogleFonts.robotoMono(
        color: getCurrentThemePalette(context).quaternaryForegroundColor
      )
    ), 
    onPressed: () {
      NavigatorInfo.getState()?.pop(context);
      NavigatorInfo.getState()?.pop(context);
    }
  );

  ShaderMask noMask = paletteGradientShaderMask(
    generateRandomColorPalette(2, isThemeBright(context)),
    Text(
      "Cancel",
      style: GoogleFonts.robotoMono(
        color: Colors.white
      )
    )
  );

  TextButton cancelButton = TextButton(
    child: noMask, 
    onPressed: () => NavigatorInfo.getState()?.pop(context)
  );

  ShaderMask saveMask = paletteGradientShaderMask(
    generateRandomColorPalette(2, isThemeBright(context)),
    Text(
      "Save changes",
      style: GoogleFonts.robotoMono(
        color: Colors.white
      )
    )
  );

  TextButton saveButton = TextButton(
    child: saveMask, 
    onPressed: () {
      saveNoteContent();
      NavigatorInfo.getState()?.pop(context);
      NavigatorInfo.getState()?.pop(context);
    }
  );

  Column dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Discard unsaved changes?", style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold),),
      const Gap(20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          cancelButton,
          const Gap(12),
          yesButton,
          const Gap(12),
          saveButton
        ]
      )
    ]
  );
  
  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialogContent,
    )
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: dialog,
    onKeyEvent: (KeyEvent event) => {},
  );

  return listener;
}