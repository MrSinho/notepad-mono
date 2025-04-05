import 'package:flutter/material.dart';

import '../backend/handle.dart';

import '../static/sign_out_dialog.dart';



class Drawer extends StatefulWidget {
  Drawer({super.key, required this.handle});

  final Handle handle;

  @override
  State<Drawer> createState() {
    return state_Drawer();
  }

}

class collection_Drawer {
  late GlobalKey<state_Drawer> key;
  late Drawer                  widget;

  collection_Drawer({required Handle handle}) {
    
    key    = GlobalKey<state_Drawer>();
    widget = Drawer(handle: handle, key: key);

  }

}

class state_Drawer extends State<Drawer> {


  @override
  Widget build(BuildContext context) {

    ListView list_view = ListView(
      children: [
        widget.handle.types.collection_user_header.widget,
        ListTile(title: const Text("Profile"), leading: const Icon(Icons.person), onTap: () { widget.handle.types.collection_nav_bar.key.currentState?.graphics_selectPage(2); Navigator.pop(context); }),
        ListTile(title: const Text("Security"), leading: const Icon(Icons.security), onTap: () {}),
        ListTile(title: const Text("Notifications"), leading: const Icon(Icons.notifications), onTap: () {}),
        const Divider(),
        ListTile(title: const Text("About Sinho Softworks"), leading: const Icon(Icons.code), onTap: () {},),
        //ListTile(title: Text("Report issue"), leading: Icon(Icons.bug_report), onTap: () => showDialog(context: context, builder: (BuildContext context) => softyReportIssueDialog(handle, context))),
        const Divider(),
        ListTile(title: const Text("Build"), subtitle: const Text("pre-release"), leading: const Icon(Icons.build), onTap: () {}),
        const Divider(),
        ListTile(title: const Text("Sign Out"), leading: const Icon(Icons.logout), onTap: () => showDialog(context: context, builder: (BuildContext context) => signOutDialog(widget.handle, context))),
      ],
    );

    return list_view;
  }

}


