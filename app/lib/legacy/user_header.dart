/*
import 'package:flutter/material.dart';



class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() {
    return UserHeaderState();
  }

}

class UserHeaderInfo {
  late GlobalKey<UserHeaderState> key;
  late UserHeader                  widget;

  UserHeaderInfo() {
    
    key    = GlobalKey<UserHeaderState>();
    widget = UserHeader(key: key);

  }

}

class UserHeaderState extends State<UserHeader> {

  @override
  Widget build(BuildContext context) {

    DrawerHeader header = DrawerHeader(
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Text(widget.handle.profile.public.username, style: const TextStyle(color: Colors.white,   fontSize: 24, fontWeight: FontWeight.bold, fontFamily: "Consolas")),
          Text(widget.handle.profile.private.email,    style: const TextStyle(color: Colors.white70, fontSize: 16, fontFamily: "Consolas")),
          IconButton(icon: const Icon(Icons.face, color: Colors.white, size: 50), onPressed: () { /*widget.handle.types.navBarInfo.key.currentState?.graphics_selectPage(2); Navigator.pop(context);*/ }),
          const Spacer(),
          Text(widget.handle.profile.public.username, style: const TextStyle(color: Colors.white,   fontSize: 18, fontWeight: FontWeight.bold)),
          Text(widget.handle.profile.private.email,    style: const TextStyle(color: Colors.white,   fontSize: 18)),
          const Spacer(),
        ],
      )
    );
      
    return header;
  }

}
*/
