import 'package:flutter/material.dart';

import '../backend/supabase/listen.dart';
import '../backend/app_data.dart';

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
    listenToNotes(context);
    listenToVersions(context);
  }
  
  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder builder = ValueListenableBuilder(
      valueListenable: AppData.instance.homePageUpdates,
      builder: (context, value, child) => notesPageViewBuilder(context)
    );

    return builder;
  }
}