import 'package:flutter/material.dart';

import 'handle.dart';

import '../../static/sign_out_dialog.dart';



class Drawer extends StatefulWidget {
  Drawer({super.key, required this.handle});

  final Handle handle;

  @override
  State<Drawer> createState() {
    return DrawerState();
  }

}

class DrawerInfo {
  late GlobalKey<DrawerState> key;
  late Drawer                  widget;

  DrawerInfo({required Handle handle}) {
    
    key    = GlobalKey<DrawerState>();
    widget = Drawer(key: key, handle: handle);

  }

}

class DrawerState extends State<Drawer> {


  @override
  Widget build(BuildContext context) {

    ListView list_view = ListView(
      children: [
        widget.handle.types.userHeaderInfo.widget,
        ListTile(title: const Text("Profile"), leading: const Icon(Icons.person), onTap: () {}/*{ widget.handle.types.navBarInfo.key.currentState?.graphics_selectPage(2); Navigator.pop(context); }*/),
        ListTile(title: const Text("Security"), leading: const Icon(Icons.security), onTap: () {}),
        ListTile(title: const Text("Notifications"), leading: const Icon(Icons.notifications), onTap: () {}),
        const Divider(),
        ListTile(title: const Text("About Sinho Softworks"), leading: const Icon(Icons.code), onTap: () {},),
        //ListTile(title: Text("Report issue"), leading: Icon(Icons.bug_report), onTap: () => showDialog(context: context, builder: (BuildContext context) => softyReportIssueDialog(handle, context))),
        const Divider(),
        ListTile(title: const Text("Build"), subtitle: const Text("pre-release"), leading: const Icon(Icons.build), onTap: () {}),
        const Divider(),
        ListTile(title: const Text("Sign Out"), leading: const Icon(Icons.logout), onTap: () => showDialog(context: context, builder: (BuildContext context) => signOutDialog(context))),
      ],
    );

    return list_view;
  }

}


