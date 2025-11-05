import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:go_router/go_router.dart';

import '../backend/app_data.dart';

import '../backend/utils/ui_utils.dart';



Widget privacyPolicyWidget(BuildContext context) {

  String privacyPolicy = AppData.instance.queriesData.currentVersion["privacy_policy"] ?? "Privacy policy not found for the current app version.";

  MarkdownBody md = MarkdownBody(
    data: privacyPolicy,
    selectable: true,
    softLineBreak: true,
  );

  Widget closeButton = wrapIconTextButton(
    const Icon(Icons.close_rounded),
    Text("Close", style: TextStyle(fontWeight: FontWeight.bold)),
    () => context.pop()
  );

  Padding pad = Padding(
    padding: const EdgeInsets.all(24.0),
    child: SingleChildScrollView(
      child: md
    ),
  );
  
  Column column = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: pad
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: closeButton
      )
    ],
  );

  LayoutBuilder layout = LayoutBuilder(
    builder: (context, constraints) {
      ConstrainedBox box = ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: constraints.maxHeight * 0.9
        ),
        child: column,
      );

      return box;
    },
  );

  Dialog dialog = Dialog(
    child: layout,
  );

  return dialog;
}