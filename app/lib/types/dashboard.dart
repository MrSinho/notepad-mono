import 'package:flutter/material.dart';

import '../backend/handle.dart';

import '../static/sign_out_dialog.dart';



class Dashboard extends StatefulWidget {
  Dashboard({super.key, required this.handle});

  final Handle handle;

  @override
  State<Dashboard> createState() {
    return state_Dashboard();
  }

}

class collection_Dashboard {

  late GlobalKey<state_Dashboard> key;
  late Dashboard                  widget;

  collection_Dashboard({required Handle handle}) {
    
    key    = GlobalKey<state_Dashboard>();
    widget = Dashboard(handle: handle, key: key);

  }

}

class state_Dashboard extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {

    AppBar bar = AppBar(
    title: Text("Softy", style: TextStyle(fontFamily: "Consolas", fontSize: 25, fontWeight: FontWeight.bold)),
    actions: [ 
      IconButton(icon: Icon(Icons.face), onPressed: () => widget.handle.types.collection_nav_bar.key.currentState?.graphics_selectPage(2)), 
      IconButton(icon: Icon(Icons.logout), onPressed: () => showDialog(context: context, builder: (BuildContext context) => signOutDialog(widget.handle, context)) ),
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar              : bar, 
    bottomNavigationBar : widget.handle.types.collection_nav_bar.widget,
    //drawer              : widget.handle.types.collection_drawer.widget, 
    body                : widget.handle.types.collection_nav_page.widget
  );

    return scaffold;
  }

}

