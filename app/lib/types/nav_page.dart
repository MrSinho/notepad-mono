import 'package:flutter/material.dart';

import '../backend/handle.dart';



class NavPage extends StatefulWidget {
  const NavPage({super.key, required this.handle});

  final Handle handle;


  @override
  State<NavPage> createState() {
    return NavPageState();
  }
}

class NavPageInfo {
  late GlobalKey<NavPageState> key;
  late NavPage                  widget;

  NavPageInfo({required Handle handle}) {
    
    key    = GlobalKey<NavPageState>();
    widget = NavPage(key: key, handle: handle);

  }

}

class NavPageState extends State<NavPage> {
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
        Center(child: widget.handle.types.profileViewInfo.widget)
      ],
      onPageChanged: (int page_idx) => () {}
    );

    return page_view;
  }
}
