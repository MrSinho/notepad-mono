import 'package:flutter/material.dart';

import '../backend/handle.dart';



class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.handle});

  final Handle handle;

  @override
  State<NavBar> createState() {
    return NavBarState();
  }

}

class NavBarInfo {
  late GlobalKey<NavBarState> key;
  late NavBar                  widget;

  NavBarInfo({required Handle handle}) {
    
    key    = GlobalKey<NavBarState>();
    widget = NavBar(key: key, handle: handle);

  }

}

class NavBarState extends State<NavBar> {

  int page_index = 0;

  void selectPage(int page_idx) {
    page_index = page_idx;
  }

  void graphics_selectPage(int page_idx) {
    setState(() => selectPage(page_idx));
    widget.handle.types.navPageInfo.key.currentState?.graphics_selectPage(page_idx);
  }


  @override
  Widget build(BuildContext context) {

    List<BottomNavigationBarItem> navbar_items = [
      const BottomNavigationBarItem(icon: Icon(Icons.local_library),           label: 'Selection'),  
      const BottomNavigationBarItem(icon: Icon(Icons.desktop_windows_rounded), label: 'Workstation'), 
      const BottomNavigationBarItem(icon: Icon(Icons.star),                    label: 'Dashboard')
    ];

    BottomNavigationBar navbar = BottomNavigationBar(
      items: navbar_items,
      currentIndex: page_index,
      onTap: (int page_idx) => graphics_selectPage(page_idx)
    );

    return navbar;
  }

}