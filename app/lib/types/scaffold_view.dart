import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/backend/note_edit.dart';
import 'package:template/builders/app_bar_builder.dart';
import 'package:template/static/utils.dart';

import 'app_bar_view.dart';
import 'bottom_navigation_bar_view.dart';
import 'bottom_sheet_view.dart';
import 'drawer_view.dart';
import '../new_primitives/list_tiles_view.dart';

import '../backend/app_data.dart';

import '../static/note_bottom_sheet.dart';



class ScaffoldView extends StatefulWidget {
  const ScaffoldView({
    super.key,
    this.appBarViewInfo,
    this.bottomNavigationBarViewInfo,
    this.body,
    this.drawerViewInfo,
    this.bottomSheetViewInfo,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator
  });

  final AppBarViewInfo? appBarViewInfo;
  final BottomNavigationBarViewInfo? bottomNavigationBarViewInfo;
  final Widget? body;
  final DrawerViewInfo? drawerViewInfo;
  final BottomSheetViewInfo? bottomSheetViewInfo;

  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;


  @override
  State<ScaffoldView> createState() {
    return ScaffoldViewState();
  }

}

class ScaffoldViewInfo {

  late GlobalKey<ScaffoldViewState> key;
  late ScaffoldView                 widget;

  ScaffoldViewInfo({
    AppBarViewInfo? appBarViewInfo,
    BottomNavigationBarViewInfo? bottomNavigationBarViewInfo,
    Widget? body,
    DrawerViewInfo? drawerViewInfo,
    BottomSheetViewInfo? bottomSheetViewInfo,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator
  }) {
    key    = GlobalKey<ScaffoldViewState>();
    widget = ScaffoldView(
      key: key,
      appBarViewInfo: appBarViewInfo,
      bottomNavigationBarViewInfo: bottomNavigationBarViewInfo,
      body: body,
      drawerViewInfo: drawerViewInfo,
      bottomSheetViewInfo: bottomSheetViewInfo,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
    );
  }

}

class ScaffoldViewState extends State<ScaffoldView> {

  AppBarViewInfo? appBarViewInfo;
  BottomNavigationBarViewInfo? bottomNavigationBarViewInfo;
  Widget? body;
  DrawerViewInfo? drawerViewInfo;
  BottomSheetViewInfo? bottomSheetViewInfo;

  Widget? floatingActionButton;
  FloatingActionButtonLocation? floatingActionButtonLocation;
  FloatingActionButtonAnimator? floatingActionButtonAnimator;

  @override
  void initState() {
    appBarViewInfo = widget.appBarViewInfo;
    bottomNavigationBarViewInfo = widget.bottomNavigationBarViewInfo;
    body = widget.body;
    drawerViewInfo = widget.drawerViewInfo;
    bottomSheetViewInfo = widget.bottomSheetViewInfo;
    floatingActionButton = widget.floatingActionButton;
    floatingActionButtonLocation = widget.floatingActionButtonLocation;
    floatingActionButtonAnimator = widget.floatingActionButtonAnimator;
    super.initState();
    listenToNotes(context);
  }

  void graphicsSetAppBarViewInfo(AppBarViewInfo newAppBarViewInfo) {
    setState(() {
      appBarViewInfo = newAppBarViewInfo;
    });
  }

  void graphicsSetBottomNavigationBarViewInfo(BottomNavigationBarViewInfo newbottomNavigationBarViewInfo) {
    setState(() {
      bottomNavigationBarViewInfo = newbottomNavigationBarViewInfo;
    });
  }

  void graphicsSetBody(Widget newBody) {
    setState(() {
      body = newBody;
    });
  }

  void graphicsSetDrawerViewInfo(DrawerViewInfo newDrawerViewInfo) {
    setState(() {
      drawerViewInfo = newDrawerViewInfo;
    });
  }

  void graphicsSetBottomSheetViewInfo(BottomSheetViewInfo newBottomSheetViewInfo) {
    setState(() {
      bottomSheetViewInfo = newBottomSheetViewInfo;
    });
  }

  int listenToNotes(BuildContext context) {

    try {

      SupabaseQueryBuilder table = Supabase.instance.client.from("Notes");

      table.stream(primaryKey: ["id"]).listen(

        (List<Map<String, dynamic>> notes) async {
          

          notes.sort((a, b) {
            final aTime = DateTime.tryParse(a['last_edit'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime = DateTime.tryParse(b['last_edit'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

          AppData.instance.notes = notes;

          List<ListTile> notesUI = [];

          for (Map<String, dynamic> note in notes) {
            notesUI.add(
              ListTile(
                title: Text(note["title"] ?? "", style: GoogleFonts.robotoMono()),
                trailing: Text("Last edit ${formatDateTime(note["last_edit"] ?? "")}", style: GoogleFonts.robotoMono()),
                onTap: () { 

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppData.instance.notePageViewInfo.widget)
                  );

                  selectNote(context, note);//This function includes a postframe callback, so it must be after pushing the new note page

                },
                onLongPress: () {
                  selectNote(context, note);
                  noteBottomSheet(context, note);
                }
              ),
            );
          }

          //Only update the state of the ListTilesView, never replace with a new ListTilesView widget!
          AppData.instance.notesViewInfo.key.currentState?.graphicsSetChildren(notesUI);
          
          //Update selected note
          for (Map<String, dynamic> note in notes) {
            if (note['id'] == AppData.instance.selectedNote['id']) {
              selectNote(context, note);              
            }
          }

          /*
            Don't do this! You are replacing a widget in the tree with a brand new widget with it's own state, wrong.
              graphicsSetBody(
                ListTilesView(children: notesUI)
              );
            Nesting StatefulWidgets is not the problem.
            The real issue was replacing a StatefulWidget instance entirely instead of updating its internal state.
          */

        }

      );

      return 1;

    }
    catch (exception) {
      debugPrint('Failed listening to new notes: $exception');
      return 0;
    }

  }

  @override
  Widget build(BuildContext context) {

    Scaffold scaffold = Scaffold(
      appBar:              appBarViewInfo?.widget.appBar, 
      bottomNavigationBar: bottomNavigationBarViewInfo?.widget.bottomNavigationBar, 
      drawer:              drawerViewInfo?.widget.drawer, 
      body:                body,//If you want to change the state of the body you better save the Stateful widget data in AppData
      bottomSheet:         bottomSheetViewInfo?.widget.bottomSheet, 
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator
    );

    return scaffold;
  }

}

