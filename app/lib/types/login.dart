import 'package:simple_icons/simple_icons.dart';
import 'package:flutter/material.dart';

import '../backend/supabase/login.dart';
import '../backend/handle.dart';

import '../static/utils.dart';




class Login extends StatefulWidget {
  Login({super.key, required this.handle});

  final Handle handle; 

  @override
  State<Login> createState() {
    return LoginState();
  }

}

class LoginInfo {
  late GlobalKey<LoginState> key;
  late Login                  widget;

  LoginInfo({required Handle handle}) {
    
    key    = GlobalKey<LoginState>();
    widget = Login(handle: handle, key: key);

  }

}

class LoginState extends State<Login> {

  @override
  void initState() {
    super.initState();
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
      padding: const EdgeInsets.all(16),
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


