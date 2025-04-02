import '../static/login.dart';
import 'handle.dart';

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({super.key, required this.handle});

  Handle handle = Handle(); 

  @override
  State<Login> createState() {
    return state_Login();
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
    
    return loginPage(widget.handle);
  }

}


