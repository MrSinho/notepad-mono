import 'package:flutter/material.dart';

import 'types/swipe_seach_bar.dart';
import 'types/swipe_sheet.dart';

import 'backend/handle.dart';



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

    List<Widget> stackContent = [ 
      const Center(child: Text("HELLO!")),
      searchBar.widget,
    ];

    handle.types.swipeSheetInfos.addAll(
      {
        "main": SwipeSheetInfo(children: sheetContent, pageContents: stackContent)
      }
    );
    
    MaterialApp app = MaterialApp(
      title: 'Draggable Bottom Sheet',
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: assertSwipeSheetInfoMemory(handle.types.swipeSheetInfos["main"]).widget,
      )
    );

    return app; 
  }
}

