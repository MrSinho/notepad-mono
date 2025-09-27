import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

import '../backend/note_edit/custom_intents/cut_lines.dart';
import '../backend/note_edit/custom_intents/duplicate_lines.dart';
import '../backend/note_edit/custom_intents/move_lines.dart';
import '../backend/note_edit/custom_intents/indent_lines.dart';
import '../backend/note_edit/custom_intents/outdent_lines.dart';

import '../backend/app_data.dart';
import '../backend/inputs.dart';

import '../themes.dart';




Widget noteCodeEditorBuilder(BuildContext context, CodeController controller) {

  CodeField codeField = CodeField(
    controller: controller,
    //expands: true,
    //maxLines: null,
    //minLines: null,

    textStyle: GoogleFonts.robotoMono(
      color: getCurrentThemePalette(context).primaryForegroundColor,
    ),

    gutterStyle: const GutterStyle(
      //textStyle: GoogleFonts.robotoMono(
      //  color: getCurrentThemePalette(context).quaternaryForegroundColor,
      //),
      showLineNumbers: true,
      showFoldingHandles: true,
      showErrors: false
    ),

    cursorColor: getCurrentThemePalette(context).primaryForegroundColor,

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Theme.of(context).highlightColor
    ),

    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
    ),

  );


  CodeTheme theme = CodeTheme(
    data: CodeThemeData(styles: monokaiSublimeTheme),
    child: SingleChildScrollView(
      child: codeField
    ),
  );

  Shortcuts shortcuts = Shortcuts(
    shortcuts: const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowRight, control: true, alt: true): ExpandSelectionToLineBreakIntent(forward: true),
      SingleActivator(LogicalKeyboardKey.arrowLeft, control: true, alt: true): ExpandSelectionToLineBreakIntent(forward: false),
      SingleActivator(LogicalKeyboardKey.backspace, control: true, alt: true): DeleteToLineBreakIntent(forward: false),
      SingleActivator(LogicalKeyboardKey.keyK, control: true, alt: true): DeleteToLineBreakIntent(forward: false),
      SingleActivator(LogicalKeyboardKey.keyL, control: true, alt: true): DeleteToLineBreakIntent(forward: true),
      //Custom intents
      SingleActivator(LogicalKeyboardKey.keyX, control: true, alt: true): CutLinesIntent(),
      SingleActivator(LogicalKeyboardKey.keyD, control: true): DuplicateLinesIntent(),
      SingleActivator(LogicalKeyboardKey.keyI, control: true): IndentLinesIntent(),
      SingleActivator(LogicalKeyboardKey.keyO, control: true): OutdentLinesIntent(),
      //SingleActivator(LogicalKeyboardKey.): MoveCursorToStartOfLineIntent(),
      //SingleActivator(LogicalKeyboardKey.): MoveCursorToEndOfLineIntent(),
      SingleActivator(LogicalKeyboardKey.arrowUp, control: true, alt: true): MoveLinesUpIntent(),
      SingleActivator(LogicalKeyboardKey.arrowDown, control: true, alt: true): MoveLinesDownIntent(),
    },
    child: Actions(
      actions: <Type, Action<Intent>>{//Custom intents
        CutLinesIntent: CutLinesAction(),
        DuplicateLinesIntent: DuplicateLinesAction(),
        IndentLinesIntent: IndentLinesAction(),
        OutdentLinesIntent: OutdentLinesAction(),
        MoveLinesUpIntent: MoveLinesUpAction(),
        MoveLinesDownIntent: MoveLinesDownAction(),
      },
      child: theme,
    ),
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: AppData.instance.noteEditData.focusNode,
    onKeyEvent: (KeyEvent event) => editInputListener(context, event),
    child: shortcuts
  );

  return listener;
}

/*
MonacoEditorWidget monacoEditorBuilder(MonacoController controller, BuildContext context) {

  MonacoEditorWidget monaco = MonacoEditorWidget(
    showStatusBar: true,
    controller: controller
  );

  return monaco;
}
*/

/*
MonacoEditor monacoEditorBuilder(MonacoController controller, BuildContext context) {

  MonacoEditor monaco = MonacoEditor(
    showStatusBar: true,
    controller: controller
  );

  return monaco;
}
*/

/*
CodeField noteCodeFieldBuilder(CodeController controller, BuildContext context) {

  CodeField codeField = CodeField(
    controller: controller,
    expands: true,
    maxLines: null,
    minLines: null,
    lineNumbers: true,

    textStyle: GoogleFonts.robotoMono(
      color: getCurrentThemePalette(context).primaryForegroundColor,
    ),

    lineNumberStyle: LineNumberStyle(
      textStyle: GoogleFonts.robotoMono(
      color: getCurrentThemePalette(context).quaternaryForegroundColor,
      ),
    ),

    cursorColor: getCurrentThemePalette(context).primaryForegroundColor,

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Theme.of(context).highlightColor
    ),

    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
    ),

  );

  return codeField;
}

TextField noteTextFieldBuilder(TextEditingController controller) {
  
  TextField textField = TextField(
    style: GoogleFonts.robotoMono(),
    decoration: InputDecoration(
      hintText: "# Write your notes here...",
      hintStyle: GoogleFonts.robotoMono(),
      border: InputBorder.none,
    ),
    expands: true,
    maxLines: null,
    minLines: null,
    controller: controller,
  );

  return textField;
}
*/