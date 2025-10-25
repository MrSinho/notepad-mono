import 'package:flutter/material.dart';

import 'utils.dart';



class NavigatorInfo {

  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static NavigatorState? getState() {

    if (key.currentState == null) {
      appLog("Trying to access invalid NavigatorState");
    }

    return key.currentState;
  }

}

BuildContext? getNavigatorContext() {
  return NavigatorInfo.key.currentContext;
}