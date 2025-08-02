import 'package:flutter/material.dart';



class DrawerView extends StatefulWidget {
  const DrawerView({
      super.key,
      required this.drawer
    }
  );

  final Drawer drawer;

  @override
  State<DrawerView> createState() => DrawerViewState();
}

class DrawerViewInfo {
  
  late GlobalKey<DrawerViewState> key;
  late DrawerView                 widget;

  DrawerViewInfo({required Drawer drawer}) {
    
    key    = GlobalKey<DrawerViewState>();
    widget = DrawerView(key: key, drawer: drawer);

  }

}



class DrawerViewState extends State<DrawerView> {

  Drawer drawer = const Drawer();

  @override
  void initState() {
    drawer = widget.drawer;
    super.initState();
  }

  void graphicsSetDrawer(Drawer newDrawer) {
    drawer = newDrawer;
  }

  @override
  Widget build(BuildContext context) {
        
    return drawer;

  }
}