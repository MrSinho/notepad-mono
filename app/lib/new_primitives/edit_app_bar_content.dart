import 'package:flutter/material.dart';

import '../backend/app_data.dart';

import '../builders/app_bar_builder.dart';



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
  Widget build(BuildContext context) {

    ValueListenableBuilder<int> builder = ValueListenableBuilder<int>(
      valueListenable: AppData.instance.noteEditUpdates,
      builder: (context, value, child) => editAppBarContentBuilder(context)
    );

    return builder;

  }
}