import 'package:flutter/material.dart';

import '../backend/app_data.dart';

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
  Widget build(BuildContext context) {

    ValueListenableBuilder<int> builder = ValueListenableBuilder<int>(
      valueListenable: AppData.instance.noteEditUpdates,
      builder: (context, value, child) => editStatusBarBuilder(context)
    );

    return builder;

  }
}