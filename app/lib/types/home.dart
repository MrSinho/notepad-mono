import 'package:flutter/material.dart';

class Home extends StatefulWidget {// Configuration class for the state, holds state management
  const Home({super.key, required this.title});// Key is required for flutter to track stateful widgets in the widget tree

  final String title;

  @override
  State<Home> createState() {
    return state_Home();
  }

}


class state_Home extends State<Home> {

  int count = 0;

  void incrementCounter() {
    count++;
  }


  void graphics_incrementCounter() {
    setState(() => incrementCounter()); //When setState() is called, the widgets specified in build() will be rebuilt
  }


  @override
  Widget build(BuildContext context) {//Entry point for rendering widgets, called also every time setState() is called

    Scaffold scaffold = Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.pink,
        title          : Text(widget.title),
        foregroundColor: Colors.white
      ),
      
      body: Center(
        child: Text('You have pushed the button $count times:'),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: graphics_incrementCounter,
        child    : const Icon(Icons.add),
      ),
    );

    return scaffold;
  }


}