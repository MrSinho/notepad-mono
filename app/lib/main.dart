import 'package:flutter/material.dart';
import 'package:template/types/swipe_seach_bar.dart';
import 'package:template/types/swipe_sheet.dart';
import 'backend/handle.dart';

import 'types/dynamic_stack.dart';



void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    List<Widget> cards = List.generate(6, (index) {
      return const Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        child: ListTile(),
      );
    });

    List<Widget> sheetContent = [
      const Text("Swipe sheet example")
    ];

    sheetContent.addAll(cards);

    Handle handle = Handle();

    handle.initAll();

    List<Map<String, dynamic>> searchSrc = [
      {
        "title": "hello", 
        "subtitle": "miao"
      },
      {
        "title": "house", 
        "subtitle": "docker"
      }
    ];    

    SwipeSearchBarInfo searchBar = SwipeSearchBarInfo(
      srcData: searchSrc,
      titleProperty: "title",
      subtitleProperty: "subtitle",
    );

    handle.types.swipeSheetInfos.addAll(
      {
        "main": SwipeSheetInfo(children: sheetContent)
      }
    );
    
    List<Widget> stackContent = [ 
      const Center(child: Text("HELLO!")),
      handle.types.swipeSheetInfos["main"]!.widget,
      searchBar.widget,
    ];

    DynamicStackInfo stack = DynamicStackInfo(children: stackContent);

    MaterialApp app = MaterialApp(
      title: 'Draggable Bottom Sheet',
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: stack.widget
      )
    );

    return app; 
  }
}

