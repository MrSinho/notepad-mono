import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../backend/app_data.dart';



class AppBarView extends StatefulWidget {
  const AppBarView({
      super.key,
      required this.appBar
    }
  );

  final AppBar appBar;

  @override
  State<AppBarView> createState() => AppBarViewState();
}

class AppBarViewInfo {
  
  late GlobalKey<AppBarViewState> key;
  late AppBarView                 widget;

  AppBarViewInfo({required AppBar appBar}) {
    
    key    = GlobalKey<AppBarViewState>();
    widget = AppBarView(key: key, appBar: appBar);

  }

}



class AppBarViewState extends State<AppBarView> {

  AppBar appBar = AppBar();

  @override
  void initState() {
    appBar = widget.appBar;
    super.initState();
  }

  void graphicsSetAppBar(AppBar newAppBar) {
    setState(() {
      appBar = newAppBar;
    });
  }

  @override
  Widget build(BuildContext context) {

    AppBar appBar = AppBar(
      title: Text(AppData.instance.version["name"] ?? "none", style: GoogleFonts.robotoMono(fontSize: 25, fontWeight: FontWeight.bold)),
      actions: [ 
        //IconButton(icon: const Icon(Icons.menu_outlined), onPressed: () => showDialog(context: context, builder: (BuildContext context) => easySettingsDialog(context)))
      ],
    );
        
    return appBar;

  }
}