import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';

import '../builders/home_page_builder.dart';



class HomePage extends StatefulWidget {
  const HomePage({
      super.key
    }
  );

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    appLog("Initialized HomePageState", true);
  }
  
  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder builder = ValueListenableBuilder(
      valueListenable: AppData.instance.rootPageUpdates,
      builder: (context, value, child) => homePageBuilder(context)
    );

    return builder;
  }
}