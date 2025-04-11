import 'package:flutter/material.dart';

import '../backend/handle.dart';

import '../static/sign_out_dialog.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({super.key, required this.handle});

  final Handle handle;

  @override
  State<Dashboard> createState() {
    return DashboardState();
  }

}

class DashboardInfo {

  late GlobalKey<DashboardState> key;
  late Dashboard                  widget;

  DashboardInfo({required Handle handle}) {
    
    key    = GlobalKey<DashboardState>();
    widget = Dashboard(key: key, handle: handle);

  }

}

class DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {

    AppBar bar = AppBar(
    title: const Text("Softy", style: TextStyle(fontFamily: "Consolas", fontSize: 25, fontWeight: FontWeight.bold)),
    actions: [ 
      IconButton(icon: const Icon(Icons.face), onPressed: () => widget.handle.types.navBarInfo.key.currentState?.graphics_selectPage(2)), 
      IconButton(icon: const Icon(Icons.logout), onPressed: () => showDialog(context: context, builder: (BuildContext context) => signOutDialog(widget.handle, context)) ),
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar              : bar, 
    bottomNavigationBar : widget.handle.types.navBarInfo.widget,
    //drawer              : widget.handle.types.drawerInfo.widget, 
    body                : widget.handle.types.navPageInfo.widget,
    bottomSheet         : widget.handle.types.swipeSheetInfo.widget,
  );

    return scaffold;
  }

}

