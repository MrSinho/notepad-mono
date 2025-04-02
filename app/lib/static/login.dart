import 'package:flutter/material.dart';

import '../types/handle.dart';
import 'utils.dart';

Widget loginPage(
  Handle handle
) {

  Column column = Column(
    children: [
      const SizedBox(height: 60.0),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.rocket_launch_rounded),
          Text(" Welcome to !", style: TextStyle(fontFamily: "Consolas", fontSize: 36, fontWeight: FontWeight.bold),),
        ]
        
      ),
      const SizedBox(height: 20.0),
      const Text("Find the right infrastructure for developers", style: TextStyle(fontFamily: "Consolas", fontWeight: FontWeight.bold)),
      const SizedBox(height: 60.0),
      signInProviderContent(handle)
    ],
  );

  Padding signup_pad = Padding(
    padding: EdgeInsets.all(16),
    child: column,
  ); 
  
  
  FractionallySizedBox signup_box = FractionallySizedBox(
    widthFactor: 0.8,
    heightFactor: 0.8,
    child: Card(child: signup_pad),
  );
  
  Center signup_center = Center(
    child: signup_box,
  );

  Scaffold signup_scaffold = Scaffold(
    body: signup_center, 
  );

  return signup_scaffold;
}