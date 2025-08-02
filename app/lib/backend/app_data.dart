import 'package:flutter/material.dart';
import 'package:template/new_primitives/note_page_view.dart';
import '../backend/supabase/queries.dart';

import 'package:template/new_primitives/list_tiles_view.dart';
import 'package:template/types/scaffold_view.dart';

import '../types/app_bar_view.dart';
import '../types/text_field_view.dart';

import '../builders/app_bar_builder.dart';
import '../builders/text_field_builder.dart';

//class AppData {
//
//  static List<Map<String, dynamic>> notes = [];
//
//  static final ScaffoldViewInfo scaffoldViewInfo = ScaffoldViewInfo(
//      //appBarViewInfo: appBarViewInfo,
//      body: ListTilesViewInfo(
//      children: []
//    ).widget
//  );
//
//  AppData() {
//
//    print("APP DATA INITIALIZED!!");
//    
//    //ListTilesViewInfo listTilesViewInfo = ListTilesViewInfo(
//    //  children: []
//    //);
//
//    //scaffoldViewInfo = ScaffoldViewInfo(
//    //  //appBarViewInfo: appBarViewInfo,
//    //  body: listTilesViewInfo.widget
//    //);
//
//    print("Scaffold view info check from AppData " + scaffoldViewInfo.key.toString());
//  }

class AppData {
  static final AppData instance = AppData._internal();

  late List<Map<String, dynamic>> notes = [];

  late ScaffoldViewInfo mainScaffoldViewInfo;
  late AppBarViewInfo mainAppBarViewInfo;
  late ListTilesViewInfo notesViewInfo;

  late Map<String, dynamic> selectedNote;

  late NotePageViewInfo notePageViewInfo;
  late TextEditingController noteTextEditingController;


  //This will be called once and only once... 
  //before every widget is built (no BuildContext is available, so you cannot initialize complex responsive widgets)
  AppData._internal() {
    notesViewInfo = ListTilesViewInfo(children: []);
    noteTextEditingController = TextEditingController();
    selectedNote = { "title": "Empty" };

    print("APP DATA INITIALIZED!!");
  }



  FutureBuilder enterDashboard() {

    FutureBuilder builder = FutureBuilder(

      future: pingDatabase(),

      //Here a BuildContext is available, so you initialize some complex and responsive widgets
      builder: (context, futureSnapshot) {

        mainAppBarViewInfo = AppBarViewInfo(appBar: mainAppBarBuilder(context)); 

        //link ListTileViewInfo as body of ScaffoldViewInfo
        //if any of those widgets needs to change, update ONLY the state of ListTilesViewInfo, NEVER replace with a new widget, which carries also a new key and may be outside of the widget tree
        //took me a lot of time to realize my mistakes...
        mainScaffoldViewInfo = ScaffoldViewInfo(
          appBarViewInfo: mainAppBarViewInfo,
          body: notesViewInfo.widget
        );

        notePageViewInfo = NotePageViewInfo(
          appBar: AppBar(),
          textField: textFieldBuilder(noteTextEditingController)
        );

        print("Scaffold view info check from AppData future builder " + mainScaffoldViewInfo.key.toString());

        return mainScaffoldViewInfo.widget;
      }

    );

    return builder;
  }


  
}