import 'package:flutter/material.dart';

import '../backend/handle.dart';
import '../backend/supabase/logout.dart';



Dialog signOutDialog(
  Handle       handle,
  BuildContext context
) {

  Column dialog_content = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Confirm Sign Out", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      SizedBox(height: 20),
      Text(
        "Are you sure you want to Sign Out?", 
        //style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 40),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Confirm"),
            onPressed: () async {
              await logout(handle);
              Navigator.pop(context);
            } 
          )
        ],
      )
      
    ]
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: EdgeInsets.all(48.0),
      child: dialog_content,
    )
  );

  return dialog;
}
