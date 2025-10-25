import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/utils.dart';

import '../themes.dart';



Widget editStatusBarBuilder(BuildContext context) {

  appLog("Updating edit status bar");

  Center content = Center(
    child: Card(
      shadowColor: AppData.instance.noteEditStatusData.status.color,
      child: Padding(
        padding: const EdgeInsetsGeometry.all(8.0),
        child: Text(AppData.instance.noteEditStatusData.message, style: TextStyle(color: getCurrentThemePalette().primaryForegroundColor, fontWeight: FontWeight.normal)),
      ),
    )
  );

  return content;
}