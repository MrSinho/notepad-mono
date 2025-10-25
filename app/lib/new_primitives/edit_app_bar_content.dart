import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils/utils.dart';

import '../builders/edit_app_bar_builder.dart';



class EditAppBarContent extends StatefulWidget {
  const EditAppBarContent({
      super.key,
    }
  );

  @override
  State<EditAppBarContent> createState() => EditAppBarContentState();
}

class EditAppBarContentState extends State<EditAppBarContent> {

  @override
  void initState() {
    super.initState();
    appLog("Initialized EditAppBarContentState");
  }

  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder<int> builder = ValueListenableBuilder<int>(
      valueListenable: AppData.instance.widgetsNotifier.noteEditBarsUpdates,
      builder: (context, value, child) => editAppBarContent(context)
    );

    return builder;

  }
}