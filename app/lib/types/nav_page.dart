import 'package:flutter/material.dart';

import '../backend/handle.dart';



class NavPage extends StatefulWidget {
  const NavPage({super.key, required this.handle});

  final Handle handle;


  @override
  State<NavPage> createState() {
    return state_NavPage();
  }
}

class collection_NavPage {
  late GlobalKey<state_NavPage> key;
  late NavPage                  widget;

  collection_NavPage({required Handle handle}) {
    
    key    = GlobalKey<state_NavPage>();
    widget = NavPage(handle: handle, key: key);

  }

}

class state_NavPage extends State<NavPage> {
  late PageController page_controller;
  int page_index = 0;

  @override
  void initState() {
    super.initState();
    page_controller = PageController(initialPage: page_index);
  }

  @override
  void dispose() {
    page_controller.dispose();
    super.dispose();
  }

  void selectPage(int page_idx) {
    page_index = page_idx;
    page_controller.jumpToPage(page_idx);
  }

  int getCurrentPageIndex() {
    return page_index;
  }

  void graphics_selectPage(int page_idx) {
    setState(() => selectPage(page_idx));
  }

  @override
  Widget build(BuildContext context) {

    PageView page_view = PageView(
      controller: page_controller,
      children: [
        const Center(child: Text("First")),
        const Center(child: Text("Second")),
        Center(child: widget.handle.types.collection_profile_view.widget)
      ],
      onPageChanged: (int page_idx) => () {}
    );

    return page_view;
  }
}
