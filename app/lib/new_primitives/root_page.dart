import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils/utils.dart';

import '../builders/root_page_builder.dart';



class RootPage extends StatefulWidget {
  const RootPage({
      super.key
    }
  );

  @override
  State<RootPage> createState() => RootPageState();
}

class RootPageState extends State<RootPage> {

  @override
  void initState() {
    super.initState();
    appLog("Initialized RootPageState");
  }
  
  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder builder = ValueListenableBuilder(
      valueListenable: AppData.instance.widgetsNotifier.rootPageUpdates,
      builder: (context, value, child) => rootPageBuilder(context)
    );

    return builder;
  }
}