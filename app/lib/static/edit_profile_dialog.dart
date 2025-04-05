import 'package:flutter/material.dart';

import '../backend/handle.dart';
import '../backend/supabase/queries.dart';



Dialog editProfileDialog(
  Handle       handle,
  BuildContext context
) {

  TextEditingController username_controller = TextEditingController(text: handle.profile.public.username);
  TextEditingController bio_controller      = TextEditingController(text: handle.profile.public.bio);

  TextField username_field = TextField(
    controller: username_controller,
    decoration: InputDecoration(
      hintText: "Username",
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey,  width: 2.0), borderRadius: BorderRadius.circular(60.0)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(60.0)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0)),
    ),
  );

  TextField bio_field = TextField(
    controller: bio_controller,
    decoration: InputDecoration(
      hintText: "Write something about yourself",
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey,  width: 2.0), borderRadius: BorderRadius.circular(30.0)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(24.0)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(60.0)),
    ),
    maxLines: 5,
  );

  FractionallySizedBox username_fraction = FractionallySizedBox(widthFactor: 0.6, child: username_field,);
  FractionallySizedBox bio_fraction      = FractionallySizedBox(widthFactor: 0.6, child: bio_field,);

  Column dialog_content = Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Edit profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      const SizedBox(height: 40),
      username_fraction,
      const SizedBox(height: 20),
      bio_fraction,
      const SizedBox(height: 20),
      TextButton(
        child: const Text("Save profile"),
        onPressed: () {
          queryUpdatePublicUserProfile(handle, username_controller.text, bio_controller.text);
          Navigator.pop(context);
        } 
      )
    ]
  );

  Dialog dialog = Dialog(
    child: Padding(
      padding: const EdgeInsets.all(48.0),
      child: dialog_content,
    )
  );

  return dialog;
}