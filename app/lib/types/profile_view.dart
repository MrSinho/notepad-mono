import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../backend/handle.dart';
import '../backend/supabase/queries.dart';
import '../static/edit_profile_dialog.dart';



class ProfileView extends StatefulWidget {
  const ProfileView({super.key, required this.handle});

  final Handle handle;

  @override
  State<ProfileView> createState() {
    return state_ProfileView();
  }

}

class collection_ProfileView {
  late GlobalKey<state_ProfileView> key;
  late ProfileView                  widget;

  collection_ProfileView({required Handle handle}) {
    
    key    = GlobalKey<state_ProfileView>();
    widget = ProfileView(handle: handle, key: key);

  }

}

class state_ProfileView extends State<ProfileView> {

  void updateProfile() async {
    await queryProfileInfo(widget.handle);
  }

  int graphics_updateProfile() {
    
    setState(() async => updateProfile());

    return 1;
  }

  @override
  Widget build(BuildContext context) {

    List<TableRow> rows = [
      TableRow(
        children: [ 
          Text("Username:"),
          SelectableText(widget.handle.profile.public.username),
       ]
      ),
      TableRow(
        children: [ 
          Text("Email:"),
          SelectableText(widget.handle.profile.private.email),
       ]
      ),
      TableRow(
        children: [ 
          Text("Joined at:"),
          SelectableText("${widget.handle.profile.public.created_at.toString().split("T")[0]} UTC"),
       ]
      ),
      TableRow(
        children: [ 
            Text("Bio:"),
            MarkdownBody(selectable: true, data: widget.handle.profile.public.bio),
       ]
      ),
      TableRow(
        children: [ 
            Text("Account status:"),
            SelectableText(widget.handle.profile.public.status),
       ]
      ),
      TableRow(
        children: [ 
            Text("Plan:"),
            SelectableText(widget.handle.profile.private.plan),
       ]
      ),
    ];

    Table table = Table(
      children: rows
    );

    Align user_align = Align(
      alignment: Alignment.topCenter,
      child: table,
    );

    Padding user_pad = Padding(
      padding: EdgeInsets.all(16),
      child: user_align,
    );

    Padding welcome_pad = Padding(
      padding: EdgeInsets.all(16),
      child: Text("Hi, ${widget.handle.profile.public.username}!", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
    );

    IconButton edit_button = IconButton(
      icon: Icon(Icons.edit_note_rounded),
      onPressed: () => showDialog(context: context, builder: (BuildContext context) => editProfileDialog(widget.handle, context))
    );

    Column page = Column(
      children: [
        SizedBox(height: 20),
        welcome_pad,
        SizedBox(height: 20),
        Divider(),
        SizedBox(height: 20),
        Row(children: [Spacer(), edit_button]),
        user_pad
      ],
    );


    return page;
  }

}


