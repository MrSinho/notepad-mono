import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../backend/supabase/login.dart';




InkWell wrapIconTextButton(Icon icon, Text text, VoidCallback callback) {

  InkWell inkwell = InkWell(
    onTap: callback,
    customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), child: wrapIconText(icon, text)
  );

  return inkwell;
}

Widget signInProviderContent() {

  Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      wrapIconTextButton(const Icon(SimpleIcons.google), const Text("Sign In with Google"), () => googleLogin()), 
      const SizedBox(width: 30),
      wrapIconTextButton(const Icon(SimpleIcons.github), const Text("Sign In with Github"), () => githubLogin()), 
    ]
  );

  return row;
}

Padding wrapIconText(Icon icon, Text text) {
  Padding result = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
          ),
          text
        ],
      )
    );

  return result;
}

FutureBuilder futureBuilderWidget(
  Future<dynamic> asyncWidget,
) {

  FutureBuilder builder = FutureBuilder(
    future: asyncWidget, 
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator()); // Loading state
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}')); // Error state
      } else {
        return snapshot.data; // Render the dialog once async is done
      }
    }
  );  

  return builder;

}

WidgetBuilder futureBuilder(
  Future<dynamic> asyncWidget,
) {

  return (BuildContext context) { return futureBuilderWidget(asyncWidget); };

}

Text warningText(String msg) {
  return Text(msg, style: const TextStyle(color: Colors.red));
}

Widget userImageInkWell(GestureTapCallback callback) {
  return ClipOval(
    child: Material(
      color: Colors.transparent, // Needed to make Ink splash work
      child: Ink.image(
        image: NetworkImage(
          Supabase.instance.client.auth.currentUser?.userMetadata?["picture"] ?? ""
        ),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
        child: InkWell(
          onTap: callback,
          splashColor: const Color.from(alpha: 0.1, red: 0.0, green: 0.0, blue: 0.0),
          highlightColor: Colors.transparent,
        ),
      ),
    ),
  );
}