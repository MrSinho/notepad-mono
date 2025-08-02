import 'package:flutter/material.dart';

import 'handle.dart';



class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.handle, required this.navbar});

  final Handle handle;
  final BottomNavigationBar navbar;

  @override
  State<NavBar> createState() {
    return NavBarState();
  }

}

class NavBarInfo {
  late GlobalKey<NavBarState> key;
  late NavBar                 widget;

  NavBarInfo({required Handle handle, required BottomNavigationBar navbar}) {
    
    key    = GlobalKey<NavBarState>();
    widget = NavBar(key: key, handle: handle, navbar: navbar);

  }

}

class NavBarState extends State<NavBar> {

  int pageIndex = 0;

  void selectPage(int pageIdx) {
    pageIndex = pageIdx;
  }

  void graphicsSelectPage(int pageIdx) {
    setState(() => selectPage(pageIdx));
    widget.handle.types.navPageInfo.key.currentState?.graphicsSelectPage(pageIdx);
  }


  @override
  Widget build(BuildContext context) {
    return widget.navbar;
  }

}