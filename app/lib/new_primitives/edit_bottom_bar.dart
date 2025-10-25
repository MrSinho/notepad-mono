import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';

import '../builders/edit_bottom_bar_builder.dart';



class EditBottomBar extends StatefulWidget {
  const EditBottomBar({
      super.key,
    }
  );

  @override
  State<EditBottomBar> createState() => EditBottomBarState();
}

class EditBottomBarState extends State<EditBottomBar> {

  @override
  void initState() {
    super.initState();
    appLog("Initialized EditBottomBarState");
  }

  @override
  Widget build(BuildContext context) {

    ValueListenableBuilder<int> builder = ValueListenableBuilder<int>(
      valueListenable: AppData.instance.noteEditBarsUpdates,
      builder: (context, value, child) => editBottomBarBuilder(context)
    );

    return builder;

  }
}