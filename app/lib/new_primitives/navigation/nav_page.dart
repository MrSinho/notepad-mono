import 'package:flutter/material.dart';

import 'handle.dart';



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
  late NavPage                 widget;

  NavPageInfo({required Handle handle}) {
    
    key    = GlobalKey<NavPageState>();
    widget = NavPage(key: key, handle: handle);

  }

}

class NavPageState extends State<NavPage> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void selectPage(int page_idx) {
    pageIndex = page_idx;
    pageController.jumpToPage(page_idx);
  }

  int getCurrentPageIndex() {
    return pageIndex;
  }

  void graphicsSelectPage(int page_idx) {
    setState(() => selectPage(page_idx));
  }

  @override
  Widget build(BuildContext context) {

    PageView pageView = PageView(
      controller: pageController,
      children: [
        const Center(child: Text("First")),
        const Center(child: Text("Second")),
        //Center(child: widget.handle.types.profileViewInfo.widget)
      ],
      onPageChanged: (int pageIdx) => () {}
    );

    return pageView;
  }
}
