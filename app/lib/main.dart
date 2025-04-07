import 'package:flutter/material.dart';
import 'backend/handle.dart';

import 'dart:ui'; // For ImageFilter


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


    WidgetsBinding.instance.addPostFrameCallback(
      (Duration duration) {
        handle.types.collection_swipe_sheet.key.currentState?.graphics_setChildren(sheetContent);
      }
    );

    MaterialApp app = MaterialApp(
      title: 'Draggable Bottom Sheet',
      home: Scaffold(
        backgroundColor: Colors.amber,
        body: handle.types.collection_swipe_sheet.widget,
      )
    );

    return app; 
  }
}

