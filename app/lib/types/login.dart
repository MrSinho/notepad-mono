import 'package:simple_icons/simple_icons.dart';
import 'package:flutter/material.dart';

import '../backend/supabase/login.dart';
import '../static/utils.dart';

import '../backend/handle.dart';



class Login extends StatefulWidget {
  Login({super.key, required this.handle});

  Handle handle = Handle(); 

  @override
  State<Login> createState() {
    return state_Login();
  }

}

class collection_Login {
  late GlobalKey<state_Login> key;
  late Login                  widget;

  collection_Login({required Handle handle}) {
    
    key    = GlobalKey<state_Login>();
    widget = Login(handle: handle, key: key);

  }

}

class state_Login extends State<Login> {

  void updateHandle(Handle handle) {
    widget.handle = handle;
  } 


  void graphics_updateHandle(Handle handle) {
    setState(() => updateHandle(handle));
  }

  @override
  Widget build(BuildContext context) {
    
    Column column = Column(
      children: [
        const SizedBox(height: 60.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch_rounded),
            Text(" Welcome!", style: TextStyle(fontFamily: "Consolas", fontSize: 36, fontWeight: FontWeight.bold),),
          ]
          
        ),
        const SizedBox(height: 20.0),
        const Text("Find the right infrastructure for developers", style: TextStyle(fontFamily: "Consolas", fontWeight: FontWeight.bold)),
        const SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            wrapIconTextButton(const Icon(SimpleIcons.google), const Text("Sign In with Google"), () => googleLogin(widget.handle)), 
            const SizedBox(width: 30),
            wrapIconTextButton(const Icon(SimpleIcons.github), const Text("Sign In with Github"), () => githubLogin(widget.handle)), 
          ],
        )
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

}


