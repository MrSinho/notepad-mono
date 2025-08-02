import 'package:flutter/material.dart';



class AppDataUIView extends StatefulWidget {
  const AppDataUIView({
      super.key,
      required this.appDataUI
    }
  );

  final Widget appDataUI;

  @override
  State<AppDataUIView> createState() => AppDataUIViewState();
}

class AppDataUIViewInfo {
  
  late GlobalKey<AppDataUIViewState> key;
  late AppDataUIView                 widget;

  AppDataUIViewInfo({required Widget appDataUI}) {
    
    key    = GlobalKey<AppDataUIViewState>();
    widget = AppDataUIView(key: key, appDataUI: appDataUI);

  }

}



class AppDataUIViewState extends State<AppDataUIView> {

  Widget appDataUI = Text("");

  @override
  void initState() {
    appDataUI = widget.appDataUI;
    super.initState();
  }

  void graphicsSetAppDataUI(Widget newAppDataUI) {
    appDataUI = newAppDataUI;
  }

  @override
  Widget build(BuildContext context) {
        
    return appDataUI;

  }
}