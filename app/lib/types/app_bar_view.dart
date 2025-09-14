import 'package:flutter/material.dart';
import '../backend/utils.dart';



class AppBarView extends StatefulWidget {
  const AppBarView({super.key, required this.appBar});

  final AppBar appBar;

  @override
  State<AppBarView> createState() => AppBarViewState();
}

class AppBarViewInfo {
  late GlobalKey<AppBarViewState> key;
  late AppBarView widget;

  AppBarViewInfo({required AppBar appBar}) {
    key = GlobalKey<AppBarViewState>();
    widget = AppBarView(key: key, appBar: appBar);
  }
}

class AppBarViewState extends State<AppBarView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return const Text("HI");
  }
}
