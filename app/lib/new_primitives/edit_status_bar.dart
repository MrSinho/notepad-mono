import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';

import '../builders/edit_status_bar_builder.dart';



class EditStatusBar extends StatefulWidget {
  const EditStatusBar({
      super.key,
    }
  );

  @override
  State<EditStatusBar> createState() => EditStatusBarState();
}

class EditStatusBarState extends State<EditStatusBar> {

  @override
  void initState() {
    super.initState();
    appLog("Initialized EditStatusBarState");
  }

  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder<int> builder = ValueListenableBuilder<int>(
      valueListenable: AppData.instance.noteEditBarsUpdates,
      builder: (context, value, child) => editStatusBarBuilder(context)
    );

    return builder;

  }
}