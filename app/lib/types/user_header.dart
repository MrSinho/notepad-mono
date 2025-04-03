import 'package:flutter/material.dart';

import '../backend/handle.dart';



class UserHeader extends StatefulWidget {
  UserHeader({super.key, required this.handle});

  final Handle handle;

  @override
  State<UserHeader> createState() {
    return state_UserHeader();
  }

}

class collection_UserHeader {
  late GlobalKey<state_UserHeader> key;
  late UserHeader                  widget;

  collection_UserHeader({required Handle handle}) {
    
    key    = GlobalKey<state_UserHeader>();
    widget = UserHeader(handle: handle, key: key);

  }

}

class state_UserHeader extends State<UserHeader> {


  @override
  Widget build(BuildContext context) {

    DrawerHeader header = DrawerHeader(
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Text(widget.handle.profile.public.username, style: TextStyle(color: Colors.white,   fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Consolas")),
          Text(widget.handle.profile.private.email,    style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: "Consolas")),
          IconButton(icon: Icon(Icons.face, color: Colors.white, size: 50), onPressed: () { widget.handle.types.collection_nav_bar.key.currentState?.graphics_selectPage(2); Navigator.pop(context); }),
          Spacer(),
          Text(widget.handle.profile.public.username, style: TextStyle(color: Colors.white,   fontSize: 18, fontWeight: FontWeight.bold)),
          Text(widget.handle.profile.private.email,    style: TextStyle(color: Colors.white,   fontSize: 18)),
          Spacer(),
        ],
      )
    );
      
    return header;
  }

}


