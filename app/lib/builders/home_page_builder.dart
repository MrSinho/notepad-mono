import 'package:flutter/material.dart';

import '../backend/app_data.dart';
import '../backend/inputs.dart';

import '../static/swipe_card.dart';

import 'home_app_bar_builder.dart';



Widget homePageBuilder(BuildContext context) {
  
  Stack view = Stack(
    children: [
      AppData.instance.notesView,
      swipeCardsBuilder(context)
    ],
  );

  Scaffold scaffold = Scaffold(
    appBar: homeAppBarBuilder(context),
    body: SafeArea(child: view),
  );

  KeyboardListener listener = KeyboardListener(
    autofocus: true,
    focusNode: FocusNode(),
    child: scaffold,
    onKeyEvent: (KeyEvent event) => homeInputListener(context, event),
  );

  return listener;
}