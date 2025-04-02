import 'package:flutter/material.dart';

import '../types/handle.dart';

import 'package:simple_icons/simple_icons.dart';

import '../backend/login.dart';
import '../static/utils.dart';

InkWell wrapIconTextButton(Icon icon, Text text, VoidCallback callback) {
  InkWell inkwell = InkWell(onTap: callback, customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), child: wrapIconText(icon, text));

  return inkwell;
}

Widget SignSeparator() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [ Text("―――――――――――――――― or ――――――――――――――――"), ]
  );
}

Widget signInProviderContent(Handle handle) {

  Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      wrapIconTextButton(Icon(SimpleIcons.google), Text("Sign In with Google"), () => googleLogin(handle)), 
      SizedBox(width: 30),
      wrapIconTextButton(Icon(SimpleIcons.github), Text("Sign In with Github"), () => githubLogin(handle)), 
    ]
  );

  return row;
}

Padding wrapIconText(Icon icon, Text text) {
  Padding result = Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          icon,
          Padding(
            padding: EdgeInsets.only(left: 8.0),
          ),
          text
        ],
      )
    );

  return result;
}