import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:template/static/utils.dart';

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
          const Text("Username:"),
          SelectableText(widget.handle.profile.public.username),
       ]
      ),
      TableRow(
        children: [ 
          const Text("Email:"),
          SelectableText(widget.handle.profile.private.email),
       ]
      ),
      TableRow(
        children: [ 
          const Text("Joined at:"),
          SelectableText("${widget.handle.profile.public.created_at.toString().split("T")[0]} UTC"),
       ]
      ),
      TableRow(
        children: [ 
            const Text("Bio:"),
            MarkdownBody(selectable: true, data: widget.handle.profile.public.bio),
       ]
      ),
      TableRow(
        children: [ 
            const Text("Account status:"),
            SelectableText(widget.handle.profile.public.status),
       ]
      ),
      TableRow(
        children: [ 
            const Text("Plan:"),
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
      padding: const EdgeInsets.all(16),
      child: user_align,
    );

    Padding welcome_pad = Padding(
      padding: const EdgeInsets.all(16),
      child: Text("Hi, ${widget.handle.profile.public.username}!", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
    );

    IconButton edit_button = IconButton(
      icon: const Icon(Icons.edit_note_rounded),
      onPressed: () => showDialog(context: context, builder: (BuildContext context) => editProfileDialog(widget.handle, context))
    );

    Column page = Column(
      children: [
        const SizedBox(height: 20),
        welcome_pad,
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        Row(children: [const Spacer(), edit_button]),
        user_pad
      ],
    );


    return page;
  }

}


