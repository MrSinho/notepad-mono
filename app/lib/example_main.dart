import 'package:flutter/material.dart';

import 'types/swipe_sheet.dart';
import 'backend/handle.dart';


void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    List<Widget> cards = List.generate(10, (index) {
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

    SwipeSheet sheet = SwipeSheet(
      handle: handle,
      children: sheetContent,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Draggable Bottom Sheet',
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: sheet,
      )
    );
  }
}

